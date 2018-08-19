module Decode exposing (decodeJobs)

import Date exposing (Date)
import Json.Decode as Json
import Types exposing (..)


decodeJobs : Json.Decoder (List Job)
decodeJobs =
    Json.list decodeJob


inAcf : String -> Json.Decoder a -> Json.Decoder a
inAcf field =
    Json.at [ "acf", field ]


decodeJob : Json.Decoder Job
decodeJob =
    Json.map8 Job
        (Json.at [ "title", "rendered" ] Json.string)
        (inAcf "employer" Json.string)
        (inAcf "location" Json.string)
        (inAcf "salary" Json.string)
        (inAcf "expiry_date" decodeDate)
        (inAcf "listing_url" Json.string)
        (Json.field "link" Json.string)
        (inAcf "paid_promotion" Json.bool |> Json.andThen decodePaidPromotion)


decodeDate : Json.Decoder (Result String Date)
decodeDate =
    Json.string
        |> Json.map Date.fromString


decodePaidPromotion : Bool -> Json.Decoder (Maybe PaidPromotion)
decodePaidPromotion isPaid =
    if isPaid then
        Json.map2 PaidPromotion
            (inAcf "job_description" Json.string)
            (inAcf "company_logo" Json.string)
            |> Json.map Just
    else
        Json.succeed Nothing
