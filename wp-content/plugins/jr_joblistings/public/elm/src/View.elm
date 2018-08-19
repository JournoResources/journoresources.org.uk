module View exposing (view)

import Date exposing (Date)
import Date.Format exposing (format)
import Html exposing (Html, a, div, h3, img, input, label, li, strong, text, ul)
import Html.Attributes exposing (class, classList, for, href, name, placeholder, src, target, type_)
import Html.Attributes.Extra exposing (innerHtml)
import Html.Events exposing (onCheck, onInput)
import RemoteData as RD
import Types exposing (..)


view : Model -> Html Msg
view model =
    div []
        [ div [ class "filterOptions" ]
            [ searchField
            , londonVisibilityToggle
            ]
        , viewJobs model.searchText model.hideLondon model.jobsRequest
        ]


---- Search ----


searchField : Html Msg
searchField =
    div [ class "filterOption search" ]
        [ input [ type_ "text", placeholder "Search jobs...", onInput UpdateSearch ] []
        ]


---- "Hide London" toggle ----


londonVisibilityToggle : Html Msg
londonVisibilityToggle =
    let
        fieldName =
            "hideLondon"
    in
        div [ class "filterOption londonVisibility" ]
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


---- Individual jobs ----


viewTitleEmployer : String -> String -> Url -> Html a
viewTitleEmployer title employer linkUrl =
    div [ class "titleEmployer" ]
        [ h3 []
            [ a [ href linkUrl, target "_blank" ]
                [ text <| title ++ ", " ++ employer
                ]
            ]
        ]


viewLocationSalary : String -> Result String Int -> Html a
viewLocationSalary location salary =
    let
        salaryText =
            case salary of
                Ok s ->
                    "£" ++ toString s

                Err e ->
                    e
    in
        div [ class "locationSalary" ]
            [ text <| location ++ " - " ++ salaryText
            ]


viewExpiryDate : Result String Date -> Html a
viewExpiryDate expiry_date =
    div [ class "expiryDate" ]
        [ text <| "Closes " ++ case expiry_date of
            Ok date ->
                format "%d/%m/%Y" date

            Err e ->
                e
        ]


viewPaidPromotion : PaidPromotion -> Html a
viewPaidPromotion { description, company_logo } =
    div [ class "promotionDetails" ]
        [ div [ class "description", innerHtml description ]
            []
        , div [ class "logo" ]
            [ img [ src company_logo ]
                []
            ]
        ]


viewJob : Job -> Html a
viewJob { title, employer, location, salary, expiry_date, listing_url, job_page_url, paid_promotion } =
    let
        isPaid =
            case paid_promotion of
                Just _ ->
                    True
                
                Nothing ->
                    False

        linkUrl =
            if isPaid then
                job_page_url
            else
                listing_url
    in
        li [ classList [("job", True), ("promotion", isPaid)] ]
            [ div []
                [ viewTitleEmployer title employer linkUrl
                , viewLocationSalary location salary
                ]
            , div []
                [ viewExpiryDate expiry_date
                ]
            , case paid_promotion of
                Just data ->
                    viewPaidPromotion data

                Nothing ->
                    text ""
            ]
