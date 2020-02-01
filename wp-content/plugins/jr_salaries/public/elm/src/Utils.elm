module Utils exposing (printHttpError)

import Http exposing (Error(..))
import String exposing (fromInt)


printHttpError : Error -> String
printHttpError error =
    case error of
        BadUrl url ->
            "Bad URL: " ++ url

        Timeout ->
            "Timeout"

        NetworkError ->
            "Network error"

        BadStatus status ->
            "Bad status: " ++ fromInt status

        BadBody b ->
            "Bad body: " ++ b
