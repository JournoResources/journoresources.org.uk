module Utils exposing (..)

import Date exposing (Date)
import Date.Extra as DE
import Types exposing (..)


isPaidPromotion : Job -> Bool
isPaidPromotion { paid_promotion } =
    case paid_promotion of
        Just _ ->
            True

        Nothing ->
            False


formatDate : Date -> String
formatDate date =
    DE.toFormattedString "dd/MM/yyyy" date


orderDateResults : Result String Date -> Result String Date -> Order
orderDateResults dr1 dr2 =
    case dr1 of
        Ok d1 ->
            case dr2 of
                Ok d2 ->
                    DE.compare d2 d1

                Err _ ->
                    GT

        Err _ ->
            case dr2 of
                Ok _ ->
                    LT

                Err _ ->
                    EQ
