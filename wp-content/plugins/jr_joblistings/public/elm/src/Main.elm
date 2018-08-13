module Main exposing (..)

import Date exposing (Date)
import Date.Format exposing (format)
import Html exposing (Html, a, div, img, li, strong, text, ul)
import Html.Attributes exposing (class, href, src, target)
import Html.Attributes.Extra exposing (innerHtml)
import Http
import Json.Decode as Json
import RemoteData as RD


---- MODEL ----


type alias Flags =
    { host : Url
    }


type alias Model =
    { jobsRequest : RD.WebData (List Job)
    }


type alias Url =
    String


type alias Job =
    { title : String
    , employer : String
    , location : String
    , salary : Result String Int
    , expiry_date : Result String Date
    , listing_url : Url
    , paid_promotion : Maybe PaidPromotion
    }


type alias PaidPromotion =
    { description : String
    , company_logo : Url
    }


init : Flags -> ( Model, Cmd Msg )
init flags =
    ( { jobsRequest = RD.NotAsked
      }
    , loadJobs flags.host
    )


loadJobs : Url -> Cmd Msg
loadJobs host =
    Http.get (host ++ "/wp-json/wp/v2/job") decodeJobs
        |> RD.sendRequest
        |> Cmd.map JobsLoaded


decodeJobs : Json.Decoder (List Job)
decodeJobs =
    Json.list decodeJob


inAcf : String -> Json.Decoder a -> Json.Decoder a
inAcf field =
    Json.at [ "acf", field ]


decodeJob : Json.Decoder Job
decodeJob =
    Json.map7 Job
        (Json.at [ "title", "rendered" ] Json.string)
        (inAcf "employer" Json.string)
        (inAcf "location" Json.string)
        (inAcf "salary" decodeSalary)
        (inAcf "expiry_date" decodeDate)
        (inAcf "listing_url" Json.string)
        (inAcf "paid_promotion" Json.bool |> Json.andThen decodePaidPromotion)


decodeSalary : Json.Decoder (Result String Int)
decodeSalary =
    Json.string
        |> Json.map String.toInt


decodeDate : Json.Decoder (Result String Date)
decodeDate =
    Json.string
        |> Json.map Date.fromString


decodePaidPromotion : Bool -> Json.Decoder (Maybe PaidPromotion)
decodePaidPromotion isPaid =
    if isPaid then
        Json.map2 PaidPromotion
            (inAcf "job_description" Json.string)
            (inAcf "company_logo" Json.string)
            |> Json.map Just
    else
        Json.succeed Nothing



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
viewJob { title, employer, location, salary, expiry_date, listing_url, paid_promotion } =
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

        viewPaidPromotion : List (Html a)
        viewPaidPromotion =
            case paid_promotion of
                Just { description, company_logo } ->
                    [ div [ innerHtml description ]
                        []
                    , img [ src company_logo ]
                        []
                    ]

                Nothing ->
                    []
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
            , div [] viewPaidPromotion
            ]



---- PROGRAM ----


main : Program Flags Model Msg
main =
    Html.programWithFlags
        { view = view
        , init = init
        , update = update
        , subscriptions = always Sub.none
        }
