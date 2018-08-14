module Main exposing (..)

import Decode exposing (decodeJobs)
import Html
import Http
import Types exposing (..)
import RemoteData as RD
import View exposing (view)


---- MODEL ----


init : Flags -> ( Model, Cmd Msg )
init flags =
    ( { jobsRequest = RD.NotAsked
      , searchText = ""
      }
    , loadJobs flags.host
    )


type alias Flags =
    { host : Url
    }


loadJobs : Url -> Cmd Msg
loadJobs host =
    Http.get (host ++ "/wp-json/wp/v2/job") decodeJobs
        |> RD.sendRequest
        |> Cmd.map JobsLoaded



---- UPDATE ----


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        JobsLoaded webdata ->
            ( { model | jobsRequest = webdata }, Cmd.none )

        UpdateSearch text ->
            ( { model | searchText = text }, Cmd.none )



---- PROGRAM ----


main : Program Flags Model Msg
main =
    Html.programWithFlags
        { view = view
        , init = init
        , update = update
        , subscriptions = always Sub.none
        }
