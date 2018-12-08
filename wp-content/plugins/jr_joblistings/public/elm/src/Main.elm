module Main exposing (Flags, getTodaysDate, init, loadJobs, main, update)

import Date exposing (Date, now)
import Date.Extra exposing (toFormattedString)
import Decode exposing (decodeJobs)
import Html
import Http
import RemoteData as RD
import Task
import Types exposing (..)
import View exposing (view)



---- MODEL ----


type alias Flags =
    { host : Url
    }


init : Flags -> ( Model, Cmd Msg )
init flags =
    ( { host = flags.host
      , jobsRequest = RD.NotAsked
      , searchText = ""
      , hideLondon = False
      , today = Nothing
      }
    , getTodaysDate
    )


getTodaysDate : Cmd Msg
getTodaysDate =
    Task.perform ReceiveTodaysDate now


loadJobs : Date -> Url -> Cmd Msg
loadJobs expireAfter host =
    let
        dateString =
            toFormattedString "yyyyMMdd" expireAfter
    in
    Http.get (host ++ "/wp-json/jr/v1/jobs?expire_after=" ++ dateString) decodeJobs
        |> RD.sendRequest
        |> Cmd.map JobsLoaded



---- UPDATE ----


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ReceiveTodaysDate date ->
            ( { model | today = Just date }, loadJobs date model.host )

        JobsLoaded webdata ->
            ( { model | jobsRequest = webdata }, Cmd.none )

        UpdateSearch text ->
            ( { model | searchText = text }, Cmd.none )

        ToggleLondon shouldHide ->
            ( { model | hideLondon = shouldHide }, Cmd.none )



---- PROGRAM ----


main : Program Flags Model Msg
main =
    Html.programWithFlags
        { view = view
        , init = init
        , update = update
        , subscriptions = always Sub.none
        }
