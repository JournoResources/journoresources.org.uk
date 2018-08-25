module View exposing (view)

import Date exposing (Date)
import Date.Format exposing (format)
import Html exposing (Html, a, div, h3, img, input, label, li, span, strong, text, ul)
import Html.Attributes exposing (class, classList, for, href, name, placeholder, src, target, type_)
import Html.Attributes.Extra exposing (innerHtml)
import Html.Events exposing (onCheck, onInput)
import RemoteData as RD
import Types exposing (..)


view : Model -> Html Msg
view model =
    div [ class "wrapper" ]
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
            [ label [ for fieldName ] [ text "Show me jobs outside of London" ]
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
        newsletterUrl =
            "https://journoresources.us14.list-manage.com/subscribe?u=9037ace2517242ddbf0100fad&id=867663be55"
    in
        div []
            [ text "We couldn't find any jobs matching this search right now, but you can sign up to our A* newsletter "
            , a [ href newsletterUrl ] [ text "here" ]
            , text ", which might have what you're looking for. You can also try widening your search 😊"
            ]



---- Individual jobs ----


viewTitleEmployer : String -> String -> Url -> Html a
viewTitleEmployer title employer linkUrl =
    let
        renderedTitle =
            span [ innerHtml title ] []
    in
        div [ class "titleEmployer" ]
            [ h3 []
                [ a [ href linkUrl, target "_blank" ]
                    [ renderedTitle
                    , text <| ", " ++ employer
                    ]
                ]
            ]


viewLocationSalary : String -> String -> Html a
viewLocationSalary location salary =
    div [ class "locationSalary" ]
        [ text <| location ++ " - " ++ salary
        ]


viewExpiryDate : Result String Date -> Html a
viewExpiryDate expiry_date =
    div [ class "expiryDate" ]
        [ text <|
            "Closes "
                ++ case expiry_date of
                    Ok date ->
                        format "%d/%m/%Y" date

                    Err e ->
                        e
        ]


viewPaidPromotion : PaidPromotion -> Html a
viewPaidPromotion { description_preview, company_logo } =
    div [ class "promotionDetails" ]
        [ div [ class "description", innerHtml description_preview ]
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
        li [ classList [ ( "job", True ), ( "promotion", isPaid ) ] ]
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
