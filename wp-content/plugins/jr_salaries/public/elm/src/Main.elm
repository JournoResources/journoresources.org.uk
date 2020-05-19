module Main exposing (main)

import Browser
import Decode exposing (decodeCategories, decodeSalaries)
import Encode exposing (encodeFormContents)
import Html exposing (text)
import Http
import RemoteData as RD
import Task
import Types exposing (..)
import View.Form as Form
import View.List as List



---- MODEL ----


type alias Flags =
    { host : Url
    , viewType : String
    }


init : Flags -> ( Model, Cmd Msg )
init flags =
    ( { host = flags.host
      , viewType = flags.viewType
      , salariesRequest = RD.NotAsked
      , categoriesRequest = RD.NotAsked
      , submitRequest = RD.NotAsked
      , formContents =
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
      , listFilters =
            { searchText = ""
            , category = Nothing
            , hideLondon = False
            }
      }
    , Cmd.batch [ loadSalaries flags.host, loadCategories flags.host ]
    )


apiPath : String
apiPath =
    "/wp-json/jr/v1/"


postForm : Url -> FormContents -> Cmd Msg
postForm host form =
    Http.post
        { url = host ++ apiPath ++ "salaries"
        , body = Http.jsonBody (encodeFormContents form)
        , expect = Http.expectWhatever (RD.fromResult >> FormSubmitted)
        }


loadSalaries : Url -> Cmd Msg
loadSalaries host =
    Http.get
        { url = host ++ apiPath ++ "salaries"
        , expect = Http.expectJson (RD.fromResult >> SalariesLoaded) decodeSalaries
        }


loadCategories : Url -> Cmd Msg
loadCategories host =
    Http.get
        { url = host ++ apiPath ++ "salaries/categories"
        , expect = Http.expectJson (RD.fromResult >> CategoriesLoaded) decodeCategories
        }



---- UPDATE ----


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SubmitForm ->
            ( model, postForm model.host model.formContents )

        FormSubmitted webdata ->
            ( { model | submitRequest = webdata }, Cmd.none )

        SalariesLoaded webdata ->
            ( { model | salariesRequest = webdata }, Cmd.none )

        CategoriesLoaded webdata ->
            ( { model | categoriesRequest = webdata }, Cmd.none )

        UpdateFormField updateMsg ->
            let
                formContents =
                    model.formContents

                formContents_ =
                    case updateMsg of
                        UpdateName name ->
                            { formContents | name = name }

                        UpdateEmail email ->
                            { formContents | email = email }

                        UpdateCompany company_name ->
                            { formContents | company_name = company_name }

                        UpdateAnonymise anonymise_company ->
                            { formContents | anonymise_company = anonymise_company }

                        UpdateLocation location ->
                            { formContents | location = location }

                        UpdateJobTitle job_title ->
                            { formContents | job_title = job_title }

                        UpdateSalary salary ->
                            { formContents | salary = salary }

                        UpdatePartTime part_time ->
                            { formContents | part_time = part_time }

                        UpdateSalaryInfo info ->
                            { formContents | extra_salary_info = info }

                        UpdateYear year ->
                            { formContents | year = year }
            in
            ( { model | formContents = formContents_ }, Cmd.none )

        UpdateFilters filterMsg ->
            let
                filters =
                    model.listFilters

                filters_ =
                    case filterMsg of
                        UpdateSearchText searchText ->
                            { filters | searchText = searchText }

                        UpdateCategory category ->
                            { filters | category = category }

                        UpdateHideLondon hideLondon ->
                            { filters | hideLondon = hideLondon }
            in
            ( { model | listFilters = filters_ }, Cmd.none )



---- PROGRAM ----


main : Program Flags Model Msg
main =
    Browser.element
        { view =
            \model ->
                case model.viewType of
                    "form" ->
                        Form.view model

                    "list" ->
                        List.view model

                    _ ->
                        text "Invalid view type"
        , init = init
        , update = update
        , subscriptions = always Sub.none
        }
