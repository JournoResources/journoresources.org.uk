module View exposing (view)

import Html exposing (Html, button, div, form, input, label, legend, text)
import Html.Attributes exposing (checked, class, name, required, type_, value)
import Html.Events exposing (onCheck, onInput, onSubmit)
import Types exposing (..)


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
                [ text "What is the company?"
                , input
                    [ type_ "text"
                    , onInput (UpdateFormField << UpdateCompany)
                    , value salary.company
                    , required True
                    ]
                    []
                ]
            , label []
                [ text "How much were you paid?"
                , input
                    [ type_ "text"
                    , onInput (UpdateFormField << UpdateSalary)
                    , value salary.salary
                    , required True
                    ]
                    []
                ]
            , label []
                [ text "Would you like us to anonymise the company?"
                , input
                    [ type_ "checkbox"
                    , onCheck (UpdateFormField << UpdateAnonymise)
                    , checked salary.anonymise
                    ]
                    []
                ]
            , label []
                [ text "Where was the job located?"
                , input
                    [ type_ "text"
                    , onInput (UpdateFormField << UpdateLocation)
                    , value salary.location
                    , required True
                    ]
                    []
                ]
            , label []
                [ text "When was this?"
                , input
                    [ type_ "date"
                    , onInput (UpdateFormField << UpdateJobDate)
                    , value salary.job_date
                    , required True
                    ]
                    []
                ]
            , label []
                [ text "Anything else?"
                , input
                    [ type_ "text"
                    , onInput (UpdateFormField << UpdateOther)
                    , value salary.other
                    ]
                    []
                ]
            , button []
                [ text "Submit"
                ]
            ]
        ]
