port module Main exposing (main)

import Browser
import Decode exposing (decodeCategories, decodeRates)
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


emptyForm : FormContents
emptyForm =
    { name = ""
    , email = ""
    , company_name = ""
    , job_description = ""
    , rate = ""
    , year = ""
    , gRecaptchaResponseToken = ""
    }


init : Flags -> ( Model, Cmd Msg )
init flags =
    ( { host = flags.host
      , viewType = flags.viewType
      , ratesRequest = RD.NotAsked
      , categoriesRequest = RD.NotAsked
      , submitRequest = RD.NotAsked
      , formContents = emptyForm
      , listFilters =
            { searchText = ""
            , category = Nothing
            }
      }
    , Cmd.batch [ loadRates flags.host, loadCategories flags.host ]
    )


apiPath : String
apiPath =
    "/wp-json/jr/v1/"


postForm : Url -> FormContents -> Cmd Msg
postForm host form =
    Http.post
        { url = host ++ apiPath ++ "rates"
        , body = Http.jsonBody (encodeFormContents form)
        , expect = Http.expectWhatever (RD.fromResult >> FormSubmitted)
        }


loadRates : Url -> Cmd Msg
loadRates host =
    Http.get
        { url = host ++ apiPath ++ "rates"
        , expect = Http.expectJson (RD.fromResult >> RatesLoaded) decodeRates
        }


loadCategories : Url -> Cmd Msg
loadCategories host =
    Http.get
        { url = host ++ apiPath ++ "rates/categories"
        , expect = Http.expectJson (RD.fromResult >> CategoriesLoaded) decodeCategories
        }


port recaptchaSubmit : (String -> msg) -> Sub msg


port recaptchaRefresh : () -> Cmd msg



---- UPDATE ----


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SubmitForm ->
            ( { model | submitRequest = RD.Loading }, postForm model.host model.formContents )

        ResetForm ->
            ( { model | submitRequest = RD.NotAsked, formContents = emptyForm }, recaptchaRefresh () )

        FormSubmitted webdata ->
            ( { model | submitRequest = webdata }, Cmd.none )

        RatesLoaded webdata ->
            ( { model | ratesRequest = webdata }, Cmd.none )

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

                        UpdateJobDescription job_description ->
                            { formContents | job_description = job_description }

                        UpdateRate rate ->
                            { formContents | rate = rate }

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
            in
            ( { model | listFilters = filters_ }, Cmd.none )

        RecaptchaSubmit token ->
            let
                formContents =
                    model.formContents
            in
            ( { model | formContents = { formContents | gRecaptchaResponseToken = token } }, Cmd.none )



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
        , subscriptions = \_ -> recaptchaSubmit RecaptchaSubmit
        }
