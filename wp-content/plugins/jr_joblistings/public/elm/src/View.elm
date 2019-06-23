module View exposing (view)

import Html exposing (Html, a, div, h3, img, input, label, li, pre, span, strong, text, ul)
import Html.Attributes exposing (attribute, class, classList, for, href, name, placeholder, src, style, target, type_)
import Html.Events exposing (onCheck, onInput)
import RemoteData as RD
import Time exposing (Posix)
import Types exposing (..)
import Utils exposing (compareDates, formatDateView, isPaidPromotion, isToday, locationMatches, lookupLabels, printHttpError, toHex)


dataHtml : String -> List (Html.Attribute a)
dataHtml s =
    [ attribute "data-jr_joblisting_html" s ]


view : Model -> Html Msg
view model =
    div [ class "wrapper" ]
        [ div [ class "filterOptions" ]
            [ searchField
            , londonVisibilityToggle
            ]
        , viewJobs model.searchText model.hideLondon model.today model.jobsRequest model.labelsRequest
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


viewJobs : String -> Bool -> Maybe Posix -> RD.WebData (List Job) -> RD.WebData (List Label) -> Html msg
viewJobs searchText hideLondon today jobs_webdata labels_webdata =
    case jobs_webdata of
        RD.NotAsked ->
            text "Not asked"

        RD.Loading ->
            text "Loading..."

        RD.Failure e ->
            div []
                [ text "There was a problem loading the jobs:"
                , pre [] [ text <| printHttpError e ]
                ]

        RD.Success jobs ->
            let
                labels =
                    case labels_webdata of
                        RD.Success labels_ ->
                            labels_

                        _ ->
                            []
            in
            viewFilteredJobs searchText hideLondon today jobs labels


jobMatchesCriteria : String -> Bool -> Job -> Bool
jobMatchesCriteria searchText hideLondon { title, employer, location } =
    let
        matchesSearch =
            List.foldr ((||) << locationMatches searchText) False [ title, employer, location ]

        shouldHide =
            hideLondon && locationMatches "london" location
    in
    matchesSearch && not shouldHide


orderJobs : List Job -> List Job
orderJobs jobs =
    let
        ( promotedJobs, regularJobs ) =
            List.partition isPaidPromotion jobs

        sort =
            List.sortWith (\job1 job2 -> compareDates job1.expiry_date job2.expiry_date)
    in
    sort promotedJobs ++ sort regularJobs


viewFilteredJobs : String -> Bool -> Maybe Posix -> List Job -> List Label -> Html a
viewFilteredJobs searchText hideLondon today jobs labels =
    let
        filteredJobs =
            List.filter (jobMatchesCriteria searchText hideLondon) (orderJobs jobs)
    in
    if List.isEmpty filteredJobs then
        viewEmptyResults hideLondon

    else
        ul [ class "jobs" ] (List.map (viewJob today labels) filteredJobs)


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


viewTitleEmployer : String -> String -> Url -> List Label -> Html a
viewTitleEmployer title employer linkUrl labels =
    let
        renderedTitle =
            span (dataHtml title) []
    in
    div [ class "titleEmployer" ]
        [ h3 []
            [ a [ href linkUrl, target "_blank" ]
                [ renderedTitle
                , text <| ", " ++ employer
                ]
            , ul [ class "labels" ]
                (List.map viewLabel labels)
            ]
        ]


viewLabel : Label -> Html a
viewLabel label =
    li
        [ class "label"
        , style "backgroundColor" <| toHex label.background_colour
        , style "color" <| toHex label.text_colour
        ]
        [ text label.text
        ]


viewLocationSalary : String -> String -> Html a
viewLocationSalary location salary =
    div [ class "locationSalary" ]
        [ text <| location ++ " - " ++ salary
        ]


viewCitation : Maybe String -> Maybe Url -> Html a
viewCitation maybeCitation maybeCitationUrl =
    let
        renderedCitation =
            case ( maybeCitation, maybeCitationUrl ) of
                ( Just citation, Just url ) ->
                    a [ href url, target "_blank" ]
                        [ text citation ]

                ( Just citation, Nothing ) ->
                    text citation

                ( _, _ ) ->
                    text ""
    in
    div [ class "citation" ]
        [ renderedCitation
        ]


viewExpiryDate : Maybe Posix -> Posix -> Html a
viewExpiryDate maybeToday expiryDate =
    let
        renderedDate =
            case maybeToday of
                Just today ->
                    if isToday today expiryDate then
                        strong [] [ text "Closes today" ]

                    else
                        text <| "Closes " ++ formatDateView expiryDate

                Nothing ->
                    text <| "Closes " ++ formatDateView expiryDate
    in
    div [ class "expiryDate" ]
        [ renderedDate
        ]


viewPaidPromotion : PaidPromotion -> Html a
viewPaidPromotion { description_preview, company_logo } =
    div [ class "promotionDetails" ]
        [ div [ class "logo" ]
            [ img [ src company_logo ]
                []
            ]
        , div ([ class "description" ] ++ dataHtml description_preview)
            []
        ]


viewJob : Maybe Posix -> List Label -> Job -> Html a
viewJob today labels ({ title, employer, location, salary, citation, citation_url, expiry_date, listing_url, job_page_url, paid_promotion } as job) =
    let
        linkUrl =
            if isPaidPromotion job then
                job_page_url

            else
                listing_url

        labels_ =
            lookupLabels labels job.labels
    in
    li [ classList [ ( "job", True ), ( "promotion", isPaidPromotion job ) ] ]
        [ div []
            [ viewTitleEmployer title employer linkUrl labels_
            , viewLocationSalary location salary
            , viewCitation citation citation_url
            ]
        , div []
            [ viewExpiryDate today expiry_date
            ]
        , case paid_promotion of
            Just data ->
                viewPaidPromotion data

            Nothing ->
                text ""
        ]
