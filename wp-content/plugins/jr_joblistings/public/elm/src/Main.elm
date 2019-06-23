port module Main exposing (main)

import Browser
import Decode exposing (decodeJobs, decodeLabels)
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
      , labelsRequest = RD.NotAsked
      , searchText = ""
      , hideLondon = False
      , labelFilter = Nothing
      , today = Nothing
      }
    , getTodaysDate
    )


getTodaysDate : Cmd Msg
getTodaysDate =
    Task.perform ReceiveTodaysDate now


apiPath : String
apiPath =
    "/wp-json/jr/v1/"


loadJobs : Posix -> Url -> Cmd Msg
loadJobs expireAfter host =
    let
        dateString =
            formatDateApi expireAfter
    in
    Http.get
        { url = host ++ apiPath ++ "jobs?expire_after=" ++ dateString
        , expect = Http.expectJson (RD.fromResult >> JobsLoaded) decodeJobs
        }


loadLabels : Url -> Cmd Msg
loadLabels host =
    Http.get
        { url = host ++ apiPath ++ "jobs/labels"
        , expect = Http.expectJson (RD.fromResult >> LabelsLoaded) decodeLabels
        }



---- PORTS ----


port updateFormattedHTML : () -> Cmd a



---- UPDATE ----


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    let
        ( newModel, newMsg ) =
            case msg of
                ReceiveTodaysDate date ->
                    ( { model | today = Just date }
                    , Cmd.batch
                        [ loadJobs date model.host
                        , loadLabels model.host
                        ]
                    )

                JobsLoaded webdata ->
                    ( { model | jobsRequest = webdata }, Cmd.none )

                LabelsLoaded webdata ->
                    ( { model | labelsRequest = webdata }, Cmd.none )

                UpdateSearch text ->
                    ( { model | searchText = text }, Cmd.none )

                ToggleLondon shouldHide ->
                    ( { model | hideLondon = shouldHide }, Cmd.none )

                UpdateLabelFilter maybeId ->
                    ( { model | labelFilter = maybeId }, Cmd.none )
    in
    ( newModel, Cmd.batch [ newMsg, updateFormattedHTML () ] )



---- PROGRAM ----


main : Program Flags Model Msg
main =
    Browser.element
        { view = view
        , init = init
        , update = update
        , subscriptions = always Sub.none
        }
