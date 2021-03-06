module Utils exposing (compareDates, formatDateApi, formatDateView, isPaidPromotion, isToday, locationMatches, lookupLabels, printHttpError, toHex)

import DateFormat as DF
import Http exposing (Error(..))
import String exposing (fromInt)
import Time exposing (Posix, posixToMillis, toDay, toMonth, toYear, utc)
import Types exposing (..)


isPaidPromotion : Job -> Bool
isPaidPromotion { paid_promotion } =
    case paid_promotion of
        Just _ ->
            True

        Nothing ->
            False


locationMatches : String -> String -> Bool
locationMatches searchText location =
    let
        clean =
            String.trim << String.toLower
    in
    String.contains (clean searchText) (clean location)


formatDateView : Posix -> String
formatDateView =
    DF.format
        [ DF.dayOfMonthFixed
        , DF.text "/"
        , DF.monthFixed
        , DF.text "/"
        , DF.yearNumber
        ]
        utc


formatDateApi : Posix -> String
formatDateApi =
    DF.format
        [ DF.yearNumber
        , DF.monthFixed
        , DF.dayOfMonthFixed
        ]
        utc


isToday : Posix -> Posix -> Bool
isToday today date =
    (toYear utc today == toYear utc date)
        && (toMonth utc today == toMonth utc date)
        && (toDay utc today == toDay utc date)


compareDates : Posix -> Posix -> Order
compareDates d1 d2 =
    compare (posixToMillis d1) (posixToMillis d2)


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


lookupLabels : List Label -> List LabelId -> List Label
lookupLabels labels ids =
    List.filter (\{ id } -> List.member id ids) labels


toHex : String -> String
toHex str =
    "#" ++ String.filter ((/=) '#') str
