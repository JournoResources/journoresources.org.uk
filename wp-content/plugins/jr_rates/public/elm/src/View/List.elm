module View.List exposing (view)

import Html exposing (..)
import Html.Attributes exposing (checked, class, id, selected, type_, value)
import Html.Events exposing (onCheck, onInput)
import RemoteData as RD
import String exposing (fromInt, toInt)
import Types exposing (..)
import Utils exposing (formatRate, matchesSearch, prettyPrintLocation, printHttpError)


view : Model -> Html Msg
view { listFilters, ratesRequest, categoriesRequest } =
    case ratesRequest of
        RD.NotAsked ->
            text "Loading..."

        RD.Loading ->
            text "Loading..."

        RD.Failure e ->
            div []
                [ text "There was a problem loading the rates:"
                , pre [] [ text <| printHttpError e ]
                ]

        RD.Success rates ->
            let
                categories =
                    case categoriesRequest of
                        RD.Success categories_ ->
                            categories_

                        _ ->
                            []
            in
            listView rates categories listFilters


type alias LocationDetails =
    { name : String
    , recommendedRate : Int
    , averageRate : Float
    , rates : List Rate
    }


type alias CategoryGrouping =
    { id : Int
    , text : String
    , london : LocationDetails
    , rural : LocationDetails
    , city : LocationDetails
    }


emptyLocationGrouping : Category -> CategoryGrouping
emptyLocationGrouping { id, text, recommendedLondon, recommendedRural, recommendedCity } =
    { id = id
    , text = text
    , london = LocationDetails (prettyPrintLocation London) recommendedLondon 0 []
    , rural = LocationDetails (prettyPrintLocation Rural) recommendedRural 0 []
    , city = LocationDetails (prettyPrintLocation City) recommendedCity 0 []
    }


insertIntoGrouping : Rate -> CategoryGrouping -> CategoryGrouping
insertIntoGrouping rate grouping =
    let
        average rates =
            (toFloat <| List.sum <| List.map .rate rates) / (toFloat <| List.length rates)

        update x details =
            let
                rates_ =
                    x :: details.rates
            in
            { details | averageRate = average rates_, rates = rates_ }
    in
    case rate.location of
        London ->
            { grouping | london = update rate grouping.london }

        Rural ->
            { grouping | rural = update rate grouping.rural }

        City ->
            { grouping | city = update rate grouping.city }


filterGroupingBySearchText : String -> CategoryGrouping -> CategoryGrouping
filterGroupingBySearchText text grouping =
    let
        filter details =
            { details
                | rates =
                    List.filter
                        (\x -> List.any (matchesSearch text) [ x.company_name, x.job_title ])
                        details.rates
            }
    in
    { grouping
        | london = filter grouping.london
        , rural = filter grouping.rural
        , city = filter grouping.city
    }


hideLondonInGrouping : CategoryGrouping -> CategoryGrouping
hideLondonInGrouping grouping =
    let
        details =
            grouping.london
    in
    { grouping | london = { details | rates = [] } }


locationNotEmpty : LocationDetails -> Bool
locationNotEmpty { rates } =
    List.length rates > 0


groupingNotEmpty : CategoryGrouping -> Bool
groupingNotEmpty grouping =
    locationNotEmpty grouping.london
        || locationNotEmpty grouping.rural
        || locationNotEmpty grouping.city


listView : List Rate -> List Category -> Filters -> Html Msg
listView rates categories filters =
    let
        grouped : List ( Category, List Rate )
        grouped =
            List.map
                (\cat -> ( cat, List.filter (.rate_category >> (==) cat.id) rates ))
                categories

        subgrouped : List CategoryGrouping
        subgrouped =
            List.map
                (\( cat, sals ) ->
                    List.foldr insertIntoGrouping (emptyLocationGrouping cat) sals
                )
                grouped

        filteredByCategory : List CategoryGrouping
        filteredByCategory =
            case filters.category of
                Just catId ->
                    List.filter (\{ id } -> id == catId) subgrouped

                Nothing ->
                    subgrouped

        filteredByLocation : List CategoryGrouping
        filteredByLocation =
            if filters.hideLondon then
                List.map hideLondonInGrouping filteredByCategory

            else
                filteredByCategory

        filteredBySearchText : List CategoryGrouping
        filteredBySearchText =
            List.map
                (filterGroupingBySearchText filters.searchText)
                filteredByLocation

        filteredByEmpty : List CategoryGrouping
        filteredByEmpty =
            List.filter groupingNotEmpty filteredBySearchText
    in
    div [ id "jr-rates-list" ] <|
        [ Html.map UpdateFilters <| viewListFilters categories filters
        ]
            ++ (case filteredByEmpty of
                    [] ->
                        [ text "Sorry, no rates found. Try changing your search criteria"
                        ]

                    xs ->
                        List.map viewCategoryGrouping xs
               )


viewListFilters : List Category -> Filters -> Html UpdateFilterMsg
viewListFilters categories { searchText, category, hideLondon } =
    let
        options =
            option [ value "", selected True ] [ text "All categories" ]
                :: List.map (\c -> option [ value <| String.fromInt c.id ] [ text c.text ]) categories
    in
    section []
        [ label []
            [ span [] [ text "Search rates: " ]
            , input
                [ type_ "text"
                , onInput UpdateSearchText
                , value searchText
                ]
                []
            ]
        , label []
            [ span [] [ text "Choose category: " ]
            , select
                [ onInput <| \str -> UpdateCategory (String.toInt str)
                ]
                options
            ]
        , label []
            [ span [] [ text "Hide jobs in London" ]
            , input
                [ type_ "checkbox"
                , onCheck UpdateHideLondon
                , checked hideLondon
                ]
                []
            ]
        ]


viewCategoryGrouping : CategoryGrouping -> Html a
viewCategoryGrouping grouping =
    let
        nonEmptyLocations =
            List.filter locationNotEmpty
                [ grouping.london
                , grouping.rural
                , grouping.city
                ]
    in
    section []
        [ h2 [] [ text grouping.text ]
        , div [] (List.map viewLocationGroup nonEmptyLocations)
        ]


viewLocationGroup : LocationDetails -> Html a
viewLocationGroup { name, recommendedRate, averageRate, rates } =
    div []
        [ h4 [] [ text name ]
        , p [] [ text <| "Average rate: " ++ formatRate (round averageRate) ]
        , p [] [ text <| "We recommend asking for: " ++ formatRate recommendedRate ]
        , table [] <|
            [ tr []
                [ th [] [ text "Job title" ]
                , th [] [ text "Rate" ]
                , th [] [ text "Date recorded" ]
                ]
            ]
                ++ (List.map viewRate <| List.reverse <| List.sortBy .rate rates)
        ]


viewRate : Rate -> Html a
viewRate { job_title, location, part_time, rate, year, company_name, extra_rate_info } =
    tr []
        [ td []
            [ text job_title
            , text " at "
            , text company_name
            ]
        , td [] [ text <| formatRate rate ]
        , td [] [ text year ]
        ]
