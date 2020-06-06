module Decode exposing (decodeCategories, decodeRates)

import Json.Decode as Json
import Json.Decode.Pipeline exposing (custom, optional, required)
import Time exposing (Posix, millisToPosix)
import Types exposing (..)


decodeRates : Json.Decoder (List Rate)
decodeRates =
    Json.list decodeRate


decodeRate : Json.Decoder Rate
decodeRate =
    Json.succeed Rate
        |> required "company_name" Json.string
        |> required "job_description" Json.string
        |> required "rate" Json.string
        |> required "rate_category" Json.int
        |> required "year" Json.string


decodeCategories : Json.Decoder (List Category)
decodeCategories =
    Json.list decodeCategory


decodeCategory : Json.Decoder Category
decodeCategory =
    Json.succeed Category
        |> required "id" Json.int
        |> required "text" Json.string
