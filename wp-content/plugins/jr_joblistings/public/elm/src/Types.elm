module Types exposing (..)

import Date exposing (Date)
import RemoteData as RD


type alias Model =
    { jobsRequest : RD.WebData (List Job)
    }


type Msg
    = JobsLoaded (RD.WebData (List Job))


type alias Url =
    String


type alias Job =
    { title : String
    , employer : String
    , location : String
    , salary : Result String Int
    , expiry_date : Result String Date
    , listing_url : Url
    , job_page_url : Url
    , paid_promotion : Maybe PaidPromotion
    }


type alias PaidPromotion =
    { description : String
    , company_logo : Url
    }
