module Types exposing (Model, Msg(..), Salary, UpdateFieldMsg(..), Url)

import RemoteData as RD


type alias Model =
    { host : Url
    , submitRequest : RD.WebData ()
    , salary : Salary
    }


type UpdateFieldMsg
    = UpdateName String
    | UpdateEmail String
    | UpdateJobTitle String
    | UpdateCompany String
    | UpdateSalary String
    | UpdateAnonymise Bool
    | UpdateLocation String
    | UpdateJobDate String
    | UpdateOther String


type Msg
    = UpdateFormField UpdateFieldMsg
    | SubmitForm
    | FormSubmitted (RD.WebData ())


type alias Url =
    String


type alias Salary =
    { name : String
    , email : String
    , job_title : String
    , company : String
    , salary : String
    , anonymise : Bool
    , location : String
    , job_date : String
    , other : String
    }
