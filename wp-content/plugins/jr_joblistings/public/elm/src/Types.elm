module Types exposing (..)

import Date exposing (Date)
import RemoteData as RD


type alias Model =
    { host : Url
    , jobsRequest : RD.WebData (List Job)
    , searchText : String
    , hideLondon : Bool
    , today : Maybe Date
    }


type Msg
    = ReceiveTodaysDate Date
    | JobsLoaded (RD.WebData (List Job))
    | UpdateSearch String
    | ToggleLondon Bool


type alias Url =
    String


type alias Job =
    { title : String
    , employer : String
    , location : String
    , salary : String
    , citation : Maybe Url
    , citation_url : Maybe Url
    , expiry_date : Result String Date
    , listing_url : Url
    , job_page_url : Url

    -- TODO: Possibly better to model this using extensible records
    , paid_promotion : Maybe PaidPromotion
    }


type alias PaidPromotion =
    { description_preview : String
    , company_logo : Url
    }
