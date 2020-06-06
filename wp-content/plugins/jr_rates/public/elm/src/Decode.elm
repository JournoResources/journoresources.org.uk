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
        |> required "anonymise_company" Json.bool
        |> required "company_name" Json.string
        |> required "extra_rate_info" (Json.nullable Json.string)
        |> required "job_title" Json.string
        |> required "location" (Json.string |> Json.andThen decodeLocation)
        |> required "part_time" Json.bool
        |> required "rate" Json.int
        |> required "rate_category" Json.int
        |> required "year" Json.string


decodeLocation : String -> Json.Decoder Location
decodeLocation location =
    case readLocation location of
        Just loc ->
            Json.succeed loc

        Nothing ->
            Json.fail <| "Invalid location: " ++ location


decodeCategories : Json.Decoder (List Category)
decodeCategories =
    Json.list decodeCategory


decodeCategory : Json.Decoder Category
decodeCategory =
    Json.succeed Category
        |> required "id" Json.int
        |> required "text" Json.string
        |> required "recommended_london" (Json.string |> Json.andThen decodeStringToInt)
        |> required "recommended_rural" (Json.string |> Json.andThen decodeStringToInt)
        |> required "recommended_city" (Json.string |> Json.andThen decodeStringToInt)


decodeStringToInt : String -> Json.Decoder Int
decodeStringToInt str =
    case String.toInt str of
        Just int ->
            Json.succeed int

        Nothing ->
            Json.fail "Failed to parse JSON string to int"
