module View exposing (view)

import Date.Format exposing (format)
import Html exposing (Html, a, div, img, input, li, strong, text, ul)
import Html.Attributes exposing (class, href, placeholder, src, target, type_)
import Html.Attributes.Extra exposing (innerHtml)
import Html.Events exposing (onInput)
import RemoteData as RD
import Types exposing (..)


view : Model -> Html Msg
view model =
    div []
        [ searchField
        , viewJobs model.searchText model.jobsRequest
        ]



-- Search


searchField : Html Msg
searchField =
    div []
        [ input [ type_ "text", placeholder "Search jobs...", onInput UpdateSearch ] []
        ]



-- Jobs list


viewJobs : String -> RD.WebData (List Job) -> Html msg
viewJobs searchText webdata =
    case webdata of
        RD.NotAsked ->
            text "Not asked"

        RD.Loading ->
            text "Loading..."

        RD.Failure e ->
            text ("There was a problem loading the jobs: " ++ toString e)

        RD.Success jobs ->
            viewFilteredJobs searchText jobs


jobMatchesSearch : String -> Job -> Bool
jobMatchesSearch searchText { title, employer, location } =
    let
        -- @TODO filter for only alpha(numeric?) characters
        clean =
            String.trim << String.toLower

        within =
            String.contains <| clean searchText
    in
        List.foldr ((||) << within << clean) False [ title, employer, location ]


viewFilteredJobs : String -> List Job -> Html a
viewFilteredJobs searchText jobs =
    let
        filteredJobs =
            List.filter (jobMatchesSearch searchText) jobs
    in
        if List.isEmpty filteredJobs then
            div []
                [ text "Sorry, we couldn't find any jobs for your search text"
                ]
        else
            ul [ class "jobs" ] (List.map viewJob filteredJobs)


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
