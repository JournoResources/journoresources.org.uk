module Types exposing (Location(..), Model, Msg(..), Salary, UpdateFieldMsg(..), Url)

import RemoteData as RD


type alias Model =
    { host : Url
    , submitRequest : RD.WebData ()
    , salary : Salary
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
    | FormSubmitted (RD.WebData ())


type alias Url =
    String


type Location
    = London
    | Rural
    | City


type alias Salary =
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
