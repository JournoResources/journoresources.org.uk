module Utils exposing (formatRate, matchesSearch, printHttpError)

import FormatNumber exposing (format)
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


formatRate : Int -> String
formatRate =
    toFloat
        >> format
            { decimals = 0
            , thousandSeparator = ","
            , decimalSeparator = "."
            , negativePrefix = "£"
            , negativeSuffix = "pa"
            , positivePrefix = "£"
            , positiveSuffix = "pa"
            }
