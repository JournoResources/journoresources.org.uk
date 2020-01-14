module Encode exposing (encodeSalary)

import Json.Encode as Json
import Types exposing (..)


encodeSalary : Salary -> Json.Value
encodeSalary { name, email, company_name, anonymise_company, location, job_title, salary, part_time, extra_salary_info, year } =
    Json.object
        [ ( "name", Json.string name )
        , ( "email", Json.string email )
        , ( "company_name", Json.string company_name )
        , ( "anonymise_company", Json.bool anonymise_company )
        , ( "location", encodeLocation location )
        , ( "job_title", Json.string job_title )
        , ( "salary", Json.int salary )
        , ( "part_time", Json.bool part_time )
        , ( "extra_salary_info", Json.string extra_salary_info )
        , ( "year", Json.string year )
        ]


encodeLocation : Location -> Json.Value
encodeLocation location =
    case location of
        London ->
            Json.string "London"

        Rural ->
            Json.string "Rural"

        City ->
            Json.string "City"
