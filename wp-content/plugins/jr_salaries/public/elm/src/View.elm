module View exposing (view)

import Html exposing (Html, button, div, form, input, label, legend, option, select, text)
import Html.Attributes exposing (checked, class, name, required, type_, value)
import Html.Events exposing (onCheck, onInput, onSubmit)
import Maybe exposing (withDefault)
import String exposing (fromInt, toInt)
import Types exposing (..)


view : Model -> Html Msg
view { formContents, viewType } =
    case viewType of
        "form" ->
            formView formContents

        "list" ->
            listView

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
            withDefault London << Maybe.map Tuple.first << List.head <| List.drop n options
    in
    select
        [ onInput (UpdateFormField << UpdateLocation << elemAt << withDefault 0 << toInt)
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
                    , onInput (UpdateFormField << UpdateSalary << withDefault 0 << toInt)
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


listView : Html Msg
listView =
    div []
        [ text "list here"
        ]
