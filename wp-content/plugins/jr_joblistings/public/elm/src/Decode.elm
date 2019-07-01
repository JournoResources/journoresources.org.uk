module Decode exposing (decodeJobs, decodeLabels)

import Json.Decode as Json
import Json.Decode.Pipeline exposing (custom, optional, required)
import Time exposing (Posix, millisToPosix)
import Types exposing (..)


decodeJobs : Json.Decoder (List Job)
decodeJobs =
    Json.list decodeJob


decodeJob : Json.Decoder Job
decodeJob =
    Json.succeed Job
        |> required "title" Json.string
        |> required "employer" Json.string
        |> required "location" Json.string
        |> required "salary" Json.string
        |> optional "citation" (Json.maybe Json.string) Nothing
        |> optional "citation_url" (Json.maybe Json.string) Nothing
        |> required "expiry_date" decodeDate
        |> required "listing_url" Json.string
        |> required "link" Json.string
        |> required "job_labels" (Json.list Json.int)
        |> custom
            (Json.field "paid_promotion" Json.bool
                |> Json.andThen decodePaidPromotion
            )


decodeDate : Json.Decoder Posix
decodeDate =
    Json.int |> Json.map millisToPosix


decodePaidPromotion : Bool -> Json.Decoder (Maybe PaidPromotion)
decodePaidPromotion isPaid =
    if isPaid then
        Json.map2 PaidPromotion
            (Json.field "job_description_preview" Json.string)
            (Json.field "company_logo" Json.string)
            |> Json.map Just

    else
        Json.succeed Nothing


decodeLabels : Json.Decoder (List Label)
decodeLabels =
    Json.list decodeLabel


decodeLabel : Json.Decoder Label
decodeLabel =
    Json.succeed Label
        |> required "id" Json.int
        |> required "text" Json.string
        |> required "background_colour" Json.string
        |> required "text_colour" Json.string
