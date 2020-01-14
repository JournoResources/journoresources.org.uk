module View exposing (view)

import Html exposing (Html, button, div, form, input, label, legend, option, select, text)
import Html.Attributes exposing (checked, class, name, required, type_, value)
import Html.Events exposing (onCheck, onInput, onSubmit)
import Maybe exposing (withDefault)
import String exposing (fromInt, toInt)
import Types exposing (..)


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


view : Model -> Html Msg
view { salary } =
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
                    , value salary.name
                    , required True
                    ]
                    []
                ]
            , label []
                [ text "What's your email address?"
                , input
                    [ type_ "text"
                    , onInput (UpdateFormField << UpdateEmail)
                    , value salary.email
                    , required True
                    ]
                    []
                ]
            , label []
                [ text "What is the job title?"
                , input
                    [ type_ "text"
                    , onInput (UpdateFormField << UpdateJobTitle)
                    , value salary.job_title
                    , required True
                    ]
                    []
                ]
            , label []
                [ text "What is the company's name?"
                , input
                    [ type_ "text"
                    , onInput (UpdateFormField << UpdateCompany)
                    , value salary.company_name
                    , required True
                    ]
                    []
                ]
            , label []
                [ text "Would you like us to anonymise the company?"
                , input
                    [ type_ "checkbox"
                    , onCheck (UpdateFormField << UpdateAnonymise)
                    , checked salary.anonymise_company
                    ]
                    []
                ]
            , label []
                [ text "How much were you paid (per annum)?"
                , input
                    [ type_ "number"
                    , onInput (UpdateFormField << UpdateSalary << withDefault 0 << toInt)
                    , value <| fromInt salary.salary
                    , required True
                    ]
                    []
                ]
            , label []
                [ text "Was the job part-time?"
                , input
                    [ type_ "checkbox"
                    , onCheck (UpdateFormField << UpdatePartTime)
                    , checked salary.part_time
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
                    , value salary.year
                    , required True
                    ]
                    []
                ]
            , if salary.part_time then
                label []
                    [ text "Any further information?"
                    , input
                        [ type_ "text"
                        , onInput (UpdateFormField << UpdateSalaryInfo)
                        , value salary.extra_salary_info
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
