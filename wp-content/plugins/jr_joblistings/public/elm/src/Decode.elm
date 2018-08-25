module Decode exposing (decodeJobs)

import Date exposing (Date)
import Json.Decode as Json
import Types exposing (..)


decodeJobs : Json.Decoder (List Job)
decodeJobs =
    Json.list decodeJob


decodeJob : Json.Decoder Job
decodeJob =
    Json.map8 Job
        (Json.field "title" Json.string)
        (Json.field "employer" Json.string)
        (Json.field "location" Json.string)
        (Json.field "salary" Json.string)
        (Json.field "expiry_date" decodeDate)
        (Json.field "listing_url" Json.string)
        (Json.field "link" Json.string)
        (Json.field "paid_promotion" Json.bool |> Json.andThen decodePaidPromotion)


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
