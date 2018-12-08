module Decode exposing (decodeJobs)

import Date exposing (Date)
import Json.Decode as Json
import Json.Decode.Pipeline exposing (custom, decode, optional, required)
import Types exposing (..)


decodeJobs : Json.Decoder (List Job)
decodeJobs =
    Json.list decodeJob


decodeJob : Json.Decoder Job
decodeJob =
    decode Job
        |> required "title" Json.string
        |> required "employer" Json.string
        |> required "location" Json.string
        |> required "salary" Json.string
        |> optional "citation" (Json.maybe Json.string) Nothing
        |> optional "citation_url" (Json.maybe Json.string) Nothing
        |> required "expiry_date" decodeDate
        |> required "listing_url" Json.string
        |> required "link" Json.string
        |> custom (Json.field "paid_promotion" Json.bool
                    |> Json.andThen decodePaidPromotion)


decodeDate : Json.Decoder (Result String Date)
decodeDate =
    Json.string
        |> Json.map Date.fromString


decodePaidPromotion : Bool -> Json.Decoder (Maybe PaidPromotion)
decodePaidPromotion isPaid =
    if isPaid then
        Json.map2 PaidPromotion
            (Json.field "job_description_preview" Json.string)
            (Json.field "company_logo" Json.string)
            |> Json.map Just
    else
        Json.succeed Nothing
