module Main exposing (..)

import Date exposing (Date, now)
import Decode exposing (decodeJobs)
import Html
import Http
import RemoteData as RD
import Task
import Types exposing (..)
import View exposing (view)


---- MODEL ----


init : Flags -> ( Model, Cmd Msg )
init flags =
    ( { jobsRequest = RD.NotAsked
      , searchText = ""
      , hideLondon = False
      , today = Nothing
      }
    , Cmd.batch
        [ loadJobs flags.host
        , getTodaysDate
        ]
    )


type alias Flags =
    { host : Url
    }


loadJobs : Url -> Cmd Msg
loadJobs host =
    Http.get (host ++ "/wp-json/jr/v1/jobs") decodeJobs
        |> RD.sendRequest
        |> Cmd.map JobsLoaded


getTodaysDate : Cmd Msg
getTodaysDate =
    Task.perform ReceiveTodaysDate now



---- UPDATE ----


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        JobsLoaded webdata ->
            ( { model | jobsRequest = webdata }, Cmd.none )

        UpdateSearch text ->
            ( { model | searchText = text }, Cmd.none )

        ToggleLondon shouldHide ->
            ( { model | hideLondon = shouldHide }, Cmd.none )

        ReceiveTodaysDate date ->
            ( { model | today = Just date }, Cmd.none )



---- PROGRAM ----


main : Program Flags Model Msg
main =
    Html.programWithFlags
        { view = view
        , init = init
        , update = update
        , subscriptions = always Sub.none
        }
