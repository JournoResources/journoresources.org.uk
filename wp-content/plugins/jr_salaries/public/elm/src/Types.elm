module Types exposing (Category, FormContents, Location(..), Model, Msg(..), Salary, UpdateFieldMsg(..), Url)

import RemoteData as RD


type alias Model =
    { host : Url
    , viewType : String
    , categoriesRequest : RD.WebData (List Category)
    , salariesRequest : RD.WebData (List Salary)
    , submitRequest : RD.WebData ()
    , formContents : FormContents
    }


type UpdateFieldMsg
    = UpdateName String
    | UpdateEmail String
    | UpdateCompany String
    | UpdateAnonymise Bool
    | UpdateLocation Location
    | UpdateJobTitle String
    | UpdateSalary Int
    | UpdatePartTime Bool
    | UpdateSalaryInfo String
    | UpdateYear String


type Msg
    = UpdateFormField UpdateFieldMsg
    | SubmitForm
    | SalariesLoaded (RD.WebData (List Salary))
    | CategoriesLoaded (RD.WebData (List Category))
    | FormSubmitted (RD.WebData ())


type alias Url =
    String


type Location
    = London
    | Rural
    | City


type alias FormContents =
    { name : String
    , email : String
    , company_name : String
    , anonymise_company : Bool
    , location : Location
    , job_title : String
    , salary : Int
    , part_time : Bool
    , extra_salary_info : String
    , year : String
    }


type alias Salary =
    { anonymise_company : Bool
    , company_name : String
    , extra_salary_info : Maybe String
    , job_title : String
    , location : Location
    , part_time : Bool
    , salary : Int
    , salary_category : Int
    , year : String
    }


type alias Category =
    { id : Int
    , text : String
    , recommended : String
    }
