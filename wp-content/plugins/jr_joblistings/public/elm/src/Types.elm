module Types exposing (..)

import Date exposing (Date)
import RemoteData as RD


type alias Model =
    { jobsRequest : RD.WebData (List Job)
    , searchText : String
    , hideLondon : Bool
    }


type Msg
    = JobsLoaded (RD.WebData (List Job))
    | UpdateSearch String
    | ToggleLondon Bool


type alias Url =
    String


type alias Job =
    { title : String
    , employer : String
    , location : String
    , salary : String
    , expiry_date : Result String Date
    , listing_url : Url
    , job_page_url : Url
    -- TODO: Possibly better to model this using extensible records
    , paid_promotion : Maybe PaidPromotion
    }


type alias PaidPromotion =
    { description : String
    , company_logo : Url
    }
