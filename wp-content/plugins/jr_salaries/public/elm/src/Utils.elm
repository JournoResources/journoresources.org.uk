module Utils exposing (matchesSearch, printHttpError)

import Http exposing (Error(..))


matchesSearch : String -> String -> Bool
matchesSearch needle haystack =
    let
        clean =
            String.trim << String.toLower
    in
    String.contains (clean needle) (clean haystack)


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
            "Bad status: " ++ String.fromInt status

        BadBody b ->
            "Bad body: " ++ b
