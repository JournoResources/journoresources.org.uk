module Types exposing (Category, Filters, FormContents, Location(..), Model, Msg(..), Rate, UpdateFieldMsg(..), UpdateFilterMsg(..), Url, readLocation, showLocation)

import RemoteData as RD


type alias Model =
    { host : Url
    , viewType : String
    , categoriesRequest : RD.WebData (List Category)
    , ratesRequest : RD.WebData (List Rate)
    , submitRequest : RD.WebData ()
    , formContents : FormContents
    , listFilters : Filters
    }


type UpdateFieldMsg
    = UpdateName String
    | UpdateEmail String
    | UpdateCompany String
    | UpdateAnonymise Bool
    | UpdateLocation Location
    | UpdateJobTitle String
    | UpdateRate Int
    | UpdatePartTime Bool
    | UpdateRateInfo String
    | UpdateYear String


type UpdateFilterMsg
    = UpdateSearchText String
    | UpdateCategory (Maybe Int)
    | UpdateHideLondon Bool


type Msg
    = RatesLoaded (RD.WebData (List Rate))
    | CategoriesLoaded (RD.WebData (List Category))
    | UpdateFormField UpdateFieldMsg
    | SubmitForm
    | FormSubmitted (RD.WebData ())
    | ResetForm
    | UpdateFilters UpdateFilterMsg
    | RecaptchaSubmit String


type alias Url =
    String


type Location
    = London
    | Rural
    | City


showLocation : Location -> String
showLocation location =
    case location of
        London ->
            "London"

        Rural ->
            "Rural"

        City ->
            "City"


readLocation : String -> Maybe Location
readLocation location =
    case location of
        "London" ->
            Just London

        "Rural" ->
            Just Rural

        "City" ->
            Just City

        _ ->
            Nothing


type alias FormContents =
    { name : String
    , email : String
    , company_name : String
    , anonymise_company : Bool
    , location : Location
    , job_title : String
    , rate : Int
    , part_time : Bool
    , extra_rate_info : String
    , year : String
    , gRecaptchaResponseToken : String
    }


type alias Rate =
    { anonymise_company : Bool
    , company_name : String
    , extra_rate_info : Maybe String
    , job_title : String
    , location : Location
    , part_time : Bool
    , rate : Int
    , rate_category : Int
    , year : String
    }


type alias Category =
    { id : Int
    , text : String
    , recommendedLondon : Int
    , recommendedRural : Int
    , recommendedCity : Int
    }


type alias Filters =
    { searchText : String
    , category : Maybe Int
    , hideLondon : Bool
    }
