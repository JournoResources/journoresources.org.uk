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
            , company_name = ""
            , anonymise_company = False
            , location = London
            , job_title = ""
            , salary = 0
            , part_time = False
            , extra_salary_info = ""
            , year = ""
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

                        UpdateCompany company_name ->
                            { salary | company_name = company_name }

                        UpdateAnonymise anonymise_company ->
                            { salary | anonymise_company = anonymise_company }

                        UpdateLocation location ->
                            { salary | location = location }

                        UpdateJobTitle job_title ->
                            { salary | job_title = job_title }

                        UpdateSalary salary_ ->
                            { salary | salary = salary_ }

                        UpdatePartTime part_time ->
                            { salary | part_time = part_time }

                        UpdateSalaryInfo info ->
                            { salary | extra_salary_info = info }

                        UpdateYear year ->
                            { salary | year = year }
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
