module View exposing (view)

import Dict as Dict
import Html exposing (..)
import Html.Attributes exposing (checked, class, name, required, selected, type_, value)
import Html.Events exposing (onCheck, onInput, onSubmit)
import RemoteData as RD
import String exposing (fromInt, toInt)
import Types exposing (..)
import Utils exposing (matchesSearch, printHttpError)


view : Model -> Html Msg
view { viewType, formContents, listFilters, salariesRequest, categoriesRequest } =
    case viewType of
        "form" ->
            formView formContents

        "list" ->
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

        _ ->
            text "Invalid view type"


locationSelect : Html Msg
locationSelect =
    let
        options =
            [ ( London, "London" )
            , ( Rural, "Outside London (rural)" )
            , ( City, "Outside London (other city)" )
            ]

        elemAt n =
            Maybe.withDefault London << Maybe.map Tuple.first << List.head <| List.drop n options
    in
    select
        [ onInput (UpdateFormField << UpdateLocation << elemAt << Maybe.withDefault 0 << toInt)
        ]
        (List.indexedMap
            (\i ( _, s ) ->
                option
                    [ value <| fromInt i ]
                    [ text s ]
            )
            options
        )


formView : FormContents -> Html Msg
formView data =
    div
        [ class "wrapper" ]
        [ form
            [ onSubmit SubmitForm
            ]
            [ label []
                [ text "What's your name?"
                , input
                    [ type_ "text"
                    , onInput (UpdateFormField << UpdateName)
                    , value data.name
                    , required True
                    ]
                    []
                ]
            , label []
                [ text "What's your email address?"
                , input
                    [ type_ "text"
                    , onInput (UpdateFormField << UpdateEmail)
                    , value data.email
                    , required True
                    ]
                    []
                ]
            , label []
                [ text "What is the job title?"
                , input
                    [ type_ "text"
                    , onInput (UpdateFormField << UpdateJobTitle)
                    , value data.job_title
                    , required True
                    ]
                    []
                ]
            , label []
                [ text "What is the company's name?"
                , input
                    [ type_ "text"
                    , onInput (UpdateFormField << UpdateCompany)
                    , value data.company_name
                    , required True
                    ]
                    []
                ]
            , label []
                [ text "Would you like us to anonymise the company?"
                , input
                    [ type_ "checkbox"
                    , onCheck (UpdateFormField << UpdateAnonymise)
                    , checked data.anonymise_company
                    ]
                    []
                ]
            , label []
                [ text "How much were you paid (per annum)?"
                , input
                    [ type_ "number"
                    , onInput (UpdateFormField << UpdateSalary << Maybe.withDefault 0 << toInt)
                    , value <| fromInt data.salary
                    , required True
                    ]
                    []
                ]
            , label []
                [ text "Was the job part-time?"
                , input
                    [ type_ "checkbox"
                    , onCheck (UpdateFormField << UpdatePartTime)
                    , checked data.part_time
                    ]
                    []
                ]
            , label []
                [ text "Where was the job located?"
                , locationSelect
                ]
            , label []
                [ text "When was this (year)?"
                , input
                    [ type_ "text"
                    , onInput (UpdateFormField << UpdateYear)
                    , value data.year
                    , required True
                    ]
                    []
                ]
            , if data.part_time then
                label []
                    [ text "Any further information?"
                    , input
                        [ type_ "text"
                        , onInput (UpdateFormField << UpdateSalaryInfo)
                        , value data.extra_salary_info
                        ]
                        []
                    ]

              else
                text ""
            , button []
                [ text "Submit"
                ]
            ]
        ]


listView : List Salary -> List Category -> Filters -> Html Msg
listView salaries categories filters =
    let
        filterByLocation loc =
            List.filter (.location >> (==) loc)

        filterByCategory =
            List.filter
                (\{ salary_category } ->
                    case filters.category of
                        Just cat ->
                            cat == salary_category

                        Nothing ->
                            True
                )

        filterBySearchText =
            List.filter
                (\x ->
                    List.any (matchesSearch filters.searchText)
                        [ x.company_name, x.job_title ]
                )

        groupByCategory =
            List.foldr
                (\x dict ->
                    Dict.update x.salary_category
                        (\maybeVal ->
                            case maybeVal of
                                Just v ->
                                    Just (x :: v)

                                Nothing ->
                                    Just [ x ]
                        )
                        dict
                )
                Dict.empty

        categoryForId id =
            List.head <| List.filter (.id >> (==) id) categories

        buildCategoryGroup : Location -> List ( Category, List Salary )
        buildCategoryGroup location =
            salaries
                |> filterByLocation location
                |> filterByCategory
                |> filterBySearchText
                |> groupByCategory
                |> Dict.toList
                |> List.map
                    (\( catId, ys ) ->
                        case categoryForId catId of
                            Just cat ->
                                Just ( cat, ys )

                            _ ->
                                Nothing
                    )
                |> List.filterMap identity

        locationsToShow =
            List.concat
                [ if filters.showLondon then
                    [ ( London, buildCategoryGroup London ) ]

                  else
                    []
                , if filters.showElsewhere then
                    [ ( City, buildCategoryGroup City ), ( Rural, buildCategoryGroup Rural ) ]

                  else
                    []
                ]
                |> List.filter (Tuple.second >> List.length >> (<) 0)
    in
    div [] <|
        [ Html.map UpdateFilters <| viewListFilters categories filters
        ]
            ++ (case locationsToShow of
                    [] ->
                        [ text "Sorry, no salaries found. Try changing your search criteria"
                        ]

                    xs ->
                        List.map
                            (\( loc, group ) ->
                                section []
                                    [ h2 [] [ text <| showLocation loc ]
                                    , div [] (List.map viewSalaryGroup group)
                                    ]
                            )
                            xs
               )


viewListFilters : List Category -> Filters -> Html UpdateFilterMsg
viewListFilters categories { searchText, category, showLondon, showElsewhere } =
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
            [ span [] [ text "Show jobs in London" ]
            , input
                [ type_ "checkbox"
                , onCheck UpdateShowLondon
                , checked showLondon
                ]
                []
            ]
        , label []
            [ span [] [ text "Show jobs outside London" ]
            , input
                [ type_ "checkbox"
                , onCheck UpdateShowElsewhere
                , checked showElsewhere
                ]
                []
            ]
        ]


viewSalaryGroup : ( Category, List Salary ) -> Html a
viewSalaryGroup ( category, group ) =
    let
        numSalaries =
            List.length group

        groupAverage =
            (toFloat <| List.sum <| List.map .salary group) / toFloat numSalaries
    in
    div []
        [ h3 [] [ text category.text ]
        , p [] [ text <| "No. recorded: " ++ String.fromInt numSalaries ]
        , p [] [ text <| "Average salary: " ++ formatSalary groupAverage ]
        , p [] [ text <| "We recommend you ask for: " ++ category.recommended ]
        , table [] <|
            [ tr []
                [ th [] [ text "Job title" ]
                , th [] [ text "Salary" ]
                , th [] [ text "Date recorded" ]
                ]
            ]
                ++ List.map viewSalary group
        ]


viewSalary : Salary -> Html a
viewSalary { job_title, location, part_time, salary, year, company_name, extra_salary_info } =
    tr []
        [ td []
            [ text job_title
            , text " at "
            , text company_name
            ]
        , td [] [ text <| formatSalary <| toFloat salary ]
        , td [] [ text year ]
        ]


formatSalary : Float -> String
formatSalary salary =
    "£" ++ String.fromFloat salary
