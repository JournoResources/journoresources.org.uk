module Main exposing (main)

import Browser
import Decode exposing (decodeJobs)
import Http
import RemoteData as RD
import Task
import Time exposing (Posix, now)
import Types exposing (..)
import Utils exposing (formatDateApi)
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


loadJobs : Posix -> Url -> Cmd Msg
loadJobs expireAfter host =
    let
        dateString =
            formatDateApi expireAfter
    in
    Http.get
        { url = host ++ "/wp-json/jr/v1/jobs?expire_after=" ++ dateString
        , expect = Http.expectJson (RD.fromResult >> JobsLoaded) decodeJobs
        }



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
    Browser.element
        { view = view
        , init = init
        , update = update
        , subscriptions = always Sub.none
        }
