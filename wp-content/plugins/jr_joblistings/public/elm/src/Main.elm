module Main exposing (..)

import Html exposing (Html, text,strong, a,div, ul, li)
import Html.Attributes exposing (class, href)
import Http
import RemoteData as RD
import Json.Decode as Json


---- MODEL ----


type alias Model =
    { jobsRequest : RD.WebData (List Job)
    }


type alias Job =
    { title : String
    , employer : String
    , location : String
    , salary : Int
    , expiry_date : String
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
    Http.get "/jobs.json" decodeJobs
        |> RD.sendRequest
        |> Cmd.map JobsLoaded


decodeJobs : Json.Decoder (List Job)
decodeJobs =
    Json.field "jobs" <| Json.list decodeJob


decodeJob : Json.Decoder Job
decodeJob =
    Json.map6 Job
        (Json.field "title" Json.string)
        (Json.field "employer" Json.string)
        (Json.field "location" Json.string)
        (Json.field "salary" Json.int)
        (Json.field "expiry_date" Json.string)
        (Json.field "listing_url" Json.string)



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
            ul [class "jobs"] (List.map viewJob jobs)


viewJob : Job -> Html a
viewJob { title, employer, location, salary, expiry_date, listing_url } =
    let withLabel l t =
        div []
            [ strong [] [text (l ++ ": ")]
            , text t
            ]
    in 

    li [ class "job" ]
        [ div []
            [ a [href listing_url, class "title"] [text title]
            , div [] [text employer]
            ]
        , div []
            [ withLabel "Location" location
            , withLabel "Salary" (toString salary)
            ]
        , div []
            [ withLabel "Expires on" location
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
