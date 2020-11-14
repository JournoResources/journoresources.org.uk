module View.List exposing (view)

import Html exposing (..)
import Html.Attributes exposing (checked, class, id, selected, type_, value)
import Html.Events exposing (onCheck, onInput)
import RemoteData as RD
import String exposing (fromInt, toInt)
import Types exposing (..)
import Utils exposing (formatSalary, matchesSearch, prettyPrintLocation, printHttpError)


view : Model -> Html Msg
view { listFilters, salariesRequest, categoriesRequest } =
    case salariesRequest of
        RD.NotAsked ->
            text "Loading..."

        RD.Loading ->
            text "Loading..."

        RD.Failure e ->
            div []
                [ text "There was a problem loading the salaries:"
                , pre [] [ text <| printHttpError e ]
                ]

        RD.Success salaries ->
            let
                categories =
                    case categoriesRequest of
                        RD.Success categories_ ->
                            categories_

                        _ ->
                            []
            in
            listView salaries categories listFilters


type alias LocationDetails =
    { name : String
    , recommendedSalary : Int
    , averageSalary : Float
    , salaries : List Salary
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


insertIntoGrouping : Salary -> CategoryGrouping -> CategoryGrouping
insertIntoGrouping salary grouping =
    let
        average salaries =
            (toFloat <| List.sum <| List.map .salary salaries) / (toFloat <| List.length salaries)

        update x details =
            let
                salaries_ =
                    x :: details.salaries
            in
            { details | averageSalary = average salaries_, salaries = salaries_ }
    in
    case salary.location of
        London ->
            { grouping | london = update salary grouping.london }

        Rural ->
            { grouping | rural = update salary grouping.rural }

        City ->
            { grouping | city = update salary grouping.city }


filterGroupingBySearchText : String -> CategoryGrouping -> CategoryGrouping
filterGroupingBySearchText text grouping =
    let
        filter details =
            { details
                | salaries =
                    List.filter
                        (\x -> List.any (matchesSearch text) [ x.company_name, x.job_title ])
                        details.salaries
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
    { grouping | london = { details | salaries = [] } }


locationNotEmpty : LocationDetails -> Bool
locationNotEmpty { salaries } =
    List.length salaries > 0


groupingNotEmpty : CategoryGrouping -> Bool
groupingNotEmpty grouping =
    locationNotEmpty grouping.london
        || locationNotEmpty grouping.rural
        || locationNotEmpty grouping.city


listView : List Salary -> List Category -> Filters -> Html Msg
listView salaries categories filters =
    let
        grouped : List ( Category, List Salary )
        grouped =
            List.map
                (\cat -> ( cat, List.filter (.salary_category >> (==) cat.id) salaries ))
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
    div [ id "jr-salaries-list" ] <|
        [ Html.map UpdateFilters <| viewListFilters categories filters
        ]
            ++ (case filteredByEmpty of
                    [] ->
                        [ text "Sorry, no salaries found. Try changing your search criteria"
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
            [ span [] [ text "Search salaries: " ]
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
viewLocationGroup { name, recommendedSalary, averageSalary, salaries } =
    div []
        [ h4 [] [ text name ]
        , p [] [ text <| "Average salary: " ++ formatSalary (round averageSalary) ]
        , p [] [ text <| "We recommend asking for: " ++ formatSalary recommendedSalary ]
        , div [ class "table-wrapper" ]
            [ table [] <|
                [ tr []
                    [ th [] [ text "Job title" ]
                    , th [] [ text "Salary" ]
                    , th [] [ text "Date recorded" ]
                    ]
                ]
                    ++ (List.map viewSalary <| List.reverse <| List.sortBy .salary salaries)
            ]
        ]


viewSalary : Salary -> Html a
viewSalary { job_title, location, part_time, salary, year, company_name, extra_salary_info } =
    tr []
        [ td []
            [ text job_title
            , text " at "
            , text company_name
            ]
        , td [] [ text <| formatSalary salary ]
        , td [] [ text year ]
        ]
