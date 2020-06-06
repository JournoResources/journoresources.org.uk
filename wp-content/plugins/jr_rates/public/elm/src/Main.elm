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
    , anonymise_company = False
    , location = London
    , job_title = ""
    , rate = 0
    , part_time = False
    , extra_rate_info = ""
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
            , hideLondon = False
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

                        UpdateAnonymise anonymise_company ->
                            { formContents | anonymise_company = anonymise_company }

                        UpdateLocation location ->
                            { formContents | location = location }

                        UpdateJobTitle job_title ->
                            { formContents | job_title = job_title }

                        UpdateRate rate ->
                            { formContents | rate = rate }

                        UpdatePartTime part_time ->
                            { formContents | part_time = part_time }

                        UpdateRateInfo info ->
                            { formContents | extra_rate_info = info }

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
