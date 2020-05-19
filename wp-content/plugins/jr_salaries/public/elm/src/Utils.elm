module Utils exposing (formatSalary, matchesSearch, prettyPrintLocation, printHttpError)

import FormatNumber exposing (format)
import Http exposing (Error(..))
import Types exposing (Location(..))


matchesSearch : String -> String -> Bool
matchesSearch needle haystack =
    let
        clean =
            String.trim << String.toLower
    in
    String.contains (clean needle) (clean haystack)


prettyPrintLocation : Location -> String
prettyPrintLocation location =
    case location of
        London ->
            "London"

        Rural ->
            "Outside London (rural)"

        City ->
            "Outside London (other city)"


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


formatSalary : Int -> String
formatSalary =
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
