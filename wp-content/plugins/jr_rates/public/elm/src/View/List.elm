module View.List exposing (view)

import Html exposing (..)
import Html.Attributes exposing (checked, class, id, selected, type_, value)
import Html.Events exposing (onCheck, onInput)
import RemoteData as RD
import String exposing (fromInt, toInt)
import Types exposing (..)
import Utils exposing (formatRate, matchesSearch, printHttpError)


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


type alias CategoryGrouping =
    { id : Int
    , text : String
    , rates : List Rate
    }


emptyLocationGrouping : Category -> CategoryGrouping
emptyLocationGrouping { id, text } =
    { id = id
    , text = text
    , rates = []
    }


insertIntoGrouping : Rate -> CategoryGrouping -> CategoryGrouping
insertIntoGrouping rate grouping =
    { grouping | rates = rate :: grouping.rates }


filterGroupingBySearchText : String -> CategoryGrouping -> CategoryGrouping
filterGroupingBySearchText text grouping =
    { grouping
        | rates =
            List.filter
                (\x -> List.any (matchesSearch text) [ x.company_name, x.job_description ])
                grouping.rates
    }


groupingNotEmpty : CategoryGrouping -> Bool
groupingNotEmpty grouping =
    List.length grouping.rates > 0


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

        orderedByCompany : List CategoryGrouping
        orderedByCompany =
            List.map
                (\group -> { group | rates = List.sortBy .company_name group.rates })
                subgrouped

        filteredByCategory : List CategoryGrouping
        filteredByCategory =
            case filters.category of
                Just catId ->
                    List.filter (\{ id } -> id == catId) orderedByCompany

                Nothing ->
                    orderedByCompany

        filteredBySearchText : List CategoryGrouping
        filteredBySearchText =
            List.map
                (filterGroupingBySearchText filters.searchText)
                filteredByCategory

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
viewListFilters categories { searchText, category } =
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
        ]


viewCategoryGrouping : CategoryGrouping -> Html a
viewCategoryGrouping grouping =
    section []
        [ h2 [] [ text grouping.text ]
        , div [ class "table-wrapper" ]
            [ table [] <|
                [ tr []
                    [ th [] [ text "Outlet" ]
                    , th [] [ text "Type of work" ]
                    , th [] [ text "Rate" ]
                    , th [] [ text "Date recorded" ]
                    ]
                ]
                    ++ List.map viewRate grouping.rates
            ]
        ]


viewRate : Rate -> Html a
viewRate { job_description, rate, year, company_name } =
    tr []
        [ td [] [ text company_name ]
        , td [] [ text job_description ]
        , td [] [ text rate ]
        , td [] [ text year ]
        ]
