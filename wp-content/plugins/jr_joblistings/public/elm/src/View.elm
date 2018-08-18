module View exposing (view)

import Date.Format exposing (format)
import Html exposing (Html, a, div, img, input, label, li, strong, text, ul)
import Html.Attributes exposing (class, for, href, name, placeholder, src, target, type_)
import Html.Attributes.Extra exposing (innerHtml)
import Html.Events exposing (onCheck, onInput)
import RemoteData as RD
import Types exposing (..)


view : Model -> Html Msg
view model =
    div []
        [ div []
            [ searchField
            , londonVisibilityToggle
            ]
        , viewJobs model.searchText model.hideLondon model.jobsRequest
        ]


---- Search ----


searchField : Html Msg
searchField =
    div []
        [ input [ type_ "text", placeholder "Search jobs...", onInput UpdateSearch ] []
        ]


---- "Hide London" toggle ----


londonVisibilityToggle : Html Msg
londonVisibilityToggle =
    let
        fieldName =
            "hideLondon"
    in
        div []
            [ label [ for fieldName ] [ text "Hide London jobs" ]
            , input [ type_ "checkbox", name fieldName, onCheck ToggleLondon ] []
            ]


---- Jobs list ----


viewJobs : String -> Bool -> RD.WebData (List Job) -> Html msg
viewJobs searchText hideLondon webdata =
    case webdata of
        RD.NotAsked ->
            text "Not asked"

        RD.Loading ->
            text "Loading..."

        RD.Failure e ->
            text ("There was a problem loading the jobs: " ++ toString e)

        RD.Success jobs ->
            viewFilteredJobs searchText hideLondon jobs


jobMatchesCriteria : String -> Bool -> Job -> Bool
jobMatchesCriteria searchText hideLondon { title, employer, location } =
    let
        -- @TODO filter for only alpha(numeric?) characters
        clean =
            String.trim << String.toLower

        within =
            String.contains <| clean searchText

        matchesSearch =
            List.foldr ((||) << within << clean) False [ title, employer, location ]

        shouldHide =
            hideLondon && clean location == "london"

    in
        matchesSearch && not shouldHide


viewFilteredJobs : String -> Bool -> List Job -> Html a
viewFilteredJobs searchText hideLondon jobs =
    let
        filteredJobs =
            List.filter (jobMatchesCriteria searchText hideLondon) jobs
    in
        if List.isEmpty filteredJobs then
            viewEmptyResults hideLondon
        else
            ul [ class "jobs" ] (List.map viewJob filteredJobs)


viewEmptyResults : Bool -> Html a
viewEmptyResults londonHidden =
    let
        copy =
            if londonHidden then
                """
                Sorry, we couldn't find any jobs matching your criteria. Try searching for
                something else, or unticking the checkbox to show jobs in London.
                """
            else
                """
                Sorry, we couldn't find any jobs matching your search.
                """
    in
        div [] [ text copy ]


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
