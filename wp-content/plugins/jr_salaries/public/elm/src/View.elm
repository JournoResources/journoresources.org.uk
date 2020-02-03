module View exposing (view)

import Dict as Dict
import Html exposing (Html, button, div, form, h1, h2, h3, h4, input, label, legend, li, option, p, pre, section, select, strong, text, ul)
import Html.Attributes exposing (checked, class, name, required, type_, value)
import Html.Events exposing (onCheck, onInput, onSubmit)
import RemoteData as RD
import String exposing (fromInt, toInt)
import Types exposing (..)
import Utils exposing (printHttpError)


view : Model -> Html Msg
view { viewType, formContents, salariesRequest, categoriesRequest } =
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
                    listView salaries categories

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
                    [ type_ "date"
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


listView : List Salary -> List Category -> Html Msg
listView salaries categories =
    let
        filterByLocation loc =
            List.filter (.location >> (==) loc)

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
            filterByLocation location salaries
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
    in
    div []
        [ section []
            [ h2 [] [ text <| showLocation London ]
            , div [] (List.map viewSalaryGroup <| buildCategoryGroup London)
            ]
        , section []
            [ h2 [] [ text <| showLocation City ]
            , div [] (List.map viewSalaryGroup <| buildCategoryGroup City)
            ]
        , section []
            [ h2 [] [ text <| showLocation Rural ]
            , div [] (List.map viewSalaryGroup <| buildCategoryGroup Rural)
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
        , ul [] <| List.map viewSalary group
        ]


viewSalary : Salary -> Html a
viewSalary { job_title, location, part_time, salary, year, company_name, extra_salary_info } =
    li [ class "salary" ]
        [ h4 [] [ text job_title ]
        , p []
            [ text company_name
            , text ", "
            , text <| showLocation location
            ]
        , p []
            [ strong [] [ text <| formatSalary <| toFloat salary ]
            , text <|
                case extra_salary_info of
                    Just info ->
                        " (" ++ info ++ ")"

                    Nothing ->
                        ""
            ]
        , p [] [ text year ]
        ]


formatSalary : Float -> String
formatSalary salary =
    "£" ++ String.fromFloat salary
