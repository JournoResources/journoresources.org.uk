module Types exposing (Category, Filters, FormContents, Model, Msg(..), Rate, UpdateFieldMsg(..), UpdateFilterMsg(..), Url)

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
    | UpdateJobDescription String
    | UpdateRate String
    | UpdateYear String


type UpdateFilterMsg
    = UpdateSearchText String
    | UpdateCategory (Maybe Int)


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


type alias FormContents =
    { name : String
    , email : String
    , company_name : String
    , job_description : String
    , rate : String
    , year : String
    , gRecaptchaResponseToken : String
    }


type alias Rate =
    { company_name : String
    , job_description : String
    , rate : String
    , rate_category : Int
    , year : String
    }


type alias Category =
    { id : Int
    , text : String
    }


type alias Filters =
    { searchText : String
    , category : Maybe Int
    }
