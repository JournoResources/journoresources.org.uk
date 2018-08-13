module View exposing (view)

import Date.Format exposing (format)
import Html exposing (Html, a, div, img, li, strong, text, ul)
import Html.Attributes exposing (class, href, src, target)
import Html.Attributes.Extra exposing (innerHtml)
import RemoteData as RD
import Types exposing (..)


view : Model -> Html Msg
view model =
    div []
        [ viewJobs model.jobsRequest
        ]


viewJobs : RD.WebData (List Job) -> Html msg
viewJobs webdata =
    case webdata of
        RD.NotAsked ->
            text "Not asked"

        RD.Loading ->
            text "Loading..."

        RD.Failure e ->
            text ("There was a problem loading the jobs: " ++ toString e)

        RD.Success jobs ->
            ul [ class "jobs" ] (List.map viewJob jobs)


viewJob : Job -> Html a
viewJob { title, employer, location, salary, expiry_date, listing_url, job_page_url, paid_promotion } =
    let
        withLabel l t =
            div []
                [ strong [] [ text (l ++ ": ") ]
                , text t
                ]

        viewSalary =
            case salary of
                Ok s ->
                    "£" ++ toString s

                Err e ->
                    e

        viewExpiryDate =
            case expiry_date of
                Ok date ->
                    format "%d/%m/%Y" date

                Err e ->
                    e

        viewPaidPromotion : List (Html a)
        viewPaidPromotion =
            case paid_promotion of
                Just { description, company_logo } ->
                    [ div [ innerHtml description ]
                        []
                    , img [ src company_logo ]
                        []
                    ]

                Nothing ->
                    []

        linkUrl =
            case paid_promotion of
                Just _ ->
                    job_page_url

                Nothing ->
                    listing_url
    in
        li [ class "job" ]
            [ div []
                [ a [ href linkUrl, target "_blank", class "title" ] [ text title ]
                , div [] [ text employer ]
                ]
            , div []
                [ withLabel "Location" location
                , withLabel "Salary" viewSalary
                ]
            , div []
                [ withLabel "Expires on" viewExpiryDate
                ]
            , div [] viewPaidPromotion
            ]
