module Types exposing (Job, Label, LabelId, Model, Msg(..), PaidPromotion, Url)

import RemoteData as RD
import Time exposing (Posix)


type alias Model =
    { host : Url
    , jobsRequest : RD.WebData (List Job)
    , labelsRequest : RD.WebData (List Label)
    , searchText : String
    , hideLondon : Bool
    , labelFilter : Maybe LabelId
    , today : Maybe Posix
    }


type Msg
    = ReceiveTodaysDate Posix
    | JobsLoaded (RD.WebData (List Job))
    | LabelsLoaded (RD.WebData (List Label))
    | UpdateSearch String
    | ToggleLondon Bool
    | UpdateLabelFilter (Maybe LabelId)


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
    , labels : List LabelId

    -- TODO: Possibly better to model this using extensible records
    , paid_promotion : Maybe PaidPromotion
    }


type alias PaidPromotion =
    { description_preview : String
    , company_logo : Url
    }


type alias LabelId =
    Int


type alias Label =
    { id : LabelId
    , text : String
    , background_colour : String
    , text_colour : String
    }
