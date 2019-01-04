module Main exposing (main)

import Browser
import Encode exposing (encodeSalary)
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
      , submitRequest = RD.NotAsked
      , salary =
            { name = ""
            , email = ""
            , job_title = ""
            , company = ""
            , salary = ""
            , anonymise = False
            , location = ""
            , job_date = ""
            , other = ""
            }
      }
    , Cmd.none
    )


postForm : Url -> Salary -> Cmd Msg
postForm host salary =
    Http.post
        { url = host ++ "/wp-json/jr/v1/salaries"
        , body = Http.jsonBody (encodeSalary salary)
        , expect = Http.expectWhatever (RD.fromResult >> FormSubmitted)
        }



---- UPDATE ----


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SubmitForm ->
            ( model, postForm model.host model.salary )

        FormSubmitted webdata ->
            ( { model | submitRequest = webdata }, Cmd.none )

        UpdateFormField updateMsg ->
            let
                salary =
                    model.salary

                newSalary =
                    case updateMsg of
                        UpdateName name ->
                            { salary | name = name }

                        UpdateEmail email ->
                            { salary | email = email }

                        UpdateJobTitle job_title ->
                            { salary | job_title = job_title }

                        UpdateCompany company ->
                            { salary | company = company }

                        UpdateSalary salary_ ->
                            { salary | salary = salary_ }

                        UpdateAnonymise anonymise ->
                            { salary | anonymise = anonymise }

                        UpdateLocation location ->
                            { salary | location = location }

                        UpdateJobDate job_date ->
                            { salary | job_date = job_date }

                        UpdateOther other ->
                            { salary | other = other }
            in
            ( { model | salary = newSalary }, Cmd.none )



---- PROGRAM ----


main : Program Flags Model Msg
main =
    Browser.element
        { view = view
        , init = init
        , update = update
        , subscriptions = always Sub.none
        }
