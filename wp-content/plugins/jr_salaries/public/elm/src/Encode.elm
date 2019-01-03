module Encode exposing (encodeSalary)

import Json.Encode as Json
import Types exposing (..)


encodeSalary : Salary -> Json.Value
encodeSalary { name, email, job_title, company, salary, anonymise, location, job_date, other } =
    Json.object
        [ ( "name", Json.string name )
        , ( "email", Json.string email )
        , ( "job_title", Json.string job_title )
        , ( "company", Json.string company )
        , ( "salary", Json.string salary )
        , ( "anonymise", Json.bool anonymise )
        , ( "location", Json.string location )
        , ( "job_date", Json.string job_date )
        , ( "other", Json.string other )
        ]
