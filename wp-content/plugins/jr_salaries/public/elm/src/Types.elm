module Types exposing (Model, Msg(..), Salary, Url)

-- import RemoteData as RD


type alias Model =
    { host : Url
    , salary : Salary
    }


type Msg
    = UpdateName String
    | UpdateEmail String
    | UpdateJobTitle String
    | UpdateCompany String
    | UpdateSalary String
    | UpdateAnonymise Bool
    | UpdateLocation String
    | UpdateJobDate String
    | UpdateOther String


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
