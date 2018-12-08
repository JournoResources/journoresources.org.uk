module Utils exposing (formatDate, isPaidPromotion, isToday, locationMatches, orderDateResults)

import Date exposing (Date)
import Date.Extra exposing (Interval(..), equalBy, toFormattedString)
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


formatDate : Date -> String
formatDate date =
    toFormattedString "dd/MM/yyyy" date


isToday : Date -> Date -> Bool
isToday today date =
    let
        intervals =
            [ Year, Month, Day ]
    in
    List.foldr (\interval acc -> acc && equalBy interval today date) True intervals


orderDateResults : Result String Date -> Result String Date -> Order
orderDateResults dr1 dr2 =
    case dr1 of
        Ok d1 ->
            case dr2 of
                Ok d2 ->
                    Date.Extra.compare d1 d2

                Err _ ->
                    GT

        Err _ ->
            case dr2 of
                Ok _ ->
                    LT

                Err _ ->
                    EQ
