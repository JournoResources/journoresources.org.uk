module Main exposing (..)

import Date exposing (Date)
import Date.Format exposing (format)
import Html exposing (Html, text, strong, a, div, ul, li)
import Html.Attributes exposing (class, href, target)
import Http
import Json.Decode as Json
import RemoteData as RD


---- MODEL ----


type alias Model =
    { jobsRequest : RD.WebData (List Job)
    }


type alias Job =
    { title : String
    , employer : String
    , location : String
    , salary : Result String Int
    , expiry_date : Result String Date
    , listing_url : String
    }


init : ( Model, Cmd Msg )
init =
    ( { jobsRequest = RD.NotAsked
      }
    , loadJobs
    )


loadJobs : Cmd Msg
loadJobs =
    Http.get "http://localhost:8000/wp-json/wp/v2/job" decodeJobs
        |> RD.sendRequest
        |> Cmd.map JobsLoaded


decodeJobs : Json.Decoder (List Job)
decodeJobs =
    Json.list decodeJob


decodeJob : Json.Decoder Job
decodeJob =
    Json.map6 Job
        (Json.at [ "title", "rendered" ] Json.string)
        (Json.at [ "acf", "employer" ] Json.string)
        (Json.at [ "acf", "location" ] Json.string)
        (Json.at [ "acf", "salary" ] decodeSalary)
        (Json.at [ "acf", "expiry_date" ] decodeDate)
        (Json.at [ "acf", "listing_url" ] Json.string)


decodeSalary : Json.Decoder (Result String Int)
decodeSalary =
    Json.string
        |> Json.map String.toInt


decodeDate : Json.Decoder (Result String Date)
decodeDate =
    Json.string
        |> Json.map Date.fromString



---- UPDATE ----


type Msg
    = JobsLoaded (RD.WebData (List Job))


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        JobsLoaded webdata ->
            ( { model | jobsRequest = webdata }, Cmd.none )



---- VIEW ----


view : Model -> Html Msg
view model =
    div []
        [ viewJobs model.jobsRequest
        ]


viewJobs : RD.WebData (List Job) -> Html msg
viewJobs webdata =
    case webdata of
        RD.NotAsked ->
            text "Not asked"

        RD.Loading ->
            text "Loading..."

        RD.Failure e ->
            text ("There was a problem loading the jobs: " ++ toString e)

        RD.Success jobs ->
            ul [ class "jobs" ] (List.map viewJob jobs)


viewJob : Job -> Html a
viewJob { title, employer, location, salary, expiry_date, listing_url } =
    let
        withLabel l t =
            div []
                [ strong [] [ text (l ++ ": ") ]
                , text t
                ]

        viewSalary =
            case salary of
                Ok s ->
                    "£" ++ toString s

                Err e ->
                    e

        viewExpiryDate =
            case expiry_date of
                Ok date ->
                    format "%d/%m/%Y" date

                Err e ->
                    e
    in
        li [ class "job" ]
            [ div []
                [ a [ href listing_url, target "_blank", class "title" ] [ text title ]
                , div [] [ text employer ]
                ]
            , div []
                [ withLabel "Location" location
                , withLabel "Salary" viewSalary
                ]
            , div []
                [ withLabel "Expires on" viewExpiryDate
                ]
            ]



---- PROGRAM ----


main : Program Never Model Msg
main =
    Html.program
        { view = view
        , init = init
        , update = update
        , subscriptions = always Sub.none
        }
