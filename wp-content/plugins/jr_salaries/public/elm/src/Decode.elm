module Decode exposing (decodeCategories, decodeSalaries)

import Json.Decode as Json
import Json.Decode.Pipeline exposing (custom, optional, required)
import Time exposing (Posix, millisToPosix)
import Types exposing (..)


decodeSalaries : Json.Decoder (List Salary)
decodeSalaries =
    Json.list decodeSalary


decodeSalary : Json.Decoder Salary
decodeSalary =
    Json.succeed Salary
        |> required "anonymise_company" Json.bool
        |> required "company_name" Json.string
        |> required "extra_salary_info" (Json.nullable Json.string)
        |> required "job_title" Json.string
        |> required "location" (Json.string |> Json.andThen decodeLocation)
        |> required "part_time" Json.bool
        |> required "salary" Json.int
        |> required "salary_category" Json.int
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
        |> required "recommended" Json.string
