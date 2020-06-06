module Encode exposing (encodeFormContents)

import Json.Encode as Json
import Types exposing (..)


encodeFormContents : FormContents -> Json.Value
encodeFormContents { name, email, company_name, job_description, rate, year, gRecaptchaResponseToken } =
    Json.object
        [ ( "name", Json.string name )
        , ( "email", Json.string email )
        , ( "company_name", Json.string company_name )
        , ( "job_description", Json.string job_description )
        , ( "rate", Json.string rate )
        , ( "year", Json.string year )
        , ( "g-recaptcha-response", Json.string gRecaptchaResponseToken )
        ]
