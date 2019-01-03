module Types exposing (Job, Model, Msg(..), PaidPromotion, Url)

import RemoteData as RD
import Time exposing (Posix)


type alias Model =
    { host : Url
    , jobsRequest : RD.WebData (List Job)
    , searchText : String
    , hideLondon : Bool
    , today : Maybe Posix
    }


type Msg
    = ReceiveTodaysDate Posix
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
    , expiry_date : Posix
    , listing_url : Url
    , job_page_url : Url

    -- TODO: Possibly better to model this using extensible records
    , paid_promotion : Maybe PaidPromotion
    }


type alias PaidPromotion =
    { description_preview : String
    , company_logo : Url
    }
