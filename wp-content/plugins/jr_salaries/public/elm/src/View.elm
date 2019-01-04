module View exposing (view)

import Html exposing (Html, button, div, fieldset, form, input, label, legend, text)
import Html.Attributes exposing (checked, class, name, type_, value)
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
                [ text "Name"
                , input
                    [ type_ "text"
                    , onInput (UpdateFormField << UpdateName)
                    , value salary.name
                    ]
                    []
                ]
            , label []
                [ text "Email"
                , input
                    [ type_ "text"
                    , onInput (UpdateFormField << UpdateEmail)
                    , value salary.email
                    ]
                    []
                ]
            , label []
                [ text "Job title"
                , input
                    [ type_ "text"
                    , onInput (UpdateFormField << UpdateJobTitle)
                    , value salary.job_title
                    ]
                    []
                ]
            , label []
                [ text "Company"
                , input
                    [ type_ "text"
                    , onInput (UpdateFormField << UpdateCompany)
                    , value salary.company
                    ]
                    []
                ]
            , label []
                [ text "Salary"
                , input
                    [ type_ "text"
                    , onInput (UpdateFormField << UpdateSalary)
                    , value salary.salary
                    ]
                    []
                ]
            , label []
                [ text "Anonymise?"
                , input
                    [ type_ "checkbox"
                    , onCheck (UpdateFormField << UpdateAnonymise)
                    , checked salary.anonymise
                    ]
                    []
                ]
            , label []
                [ text "Location"
                , input
                    [ type_ "text"
                    , onInput (UpdateFormField << UpdateLocation)
                    , value salary.location
                    ]
                    []
                ]
            , label []
                [ text "When was this?"
                , input
                    [ type_ "date"
                    , onInput (UpdateFormField << UpdateJobDate)
                    , value salary.job_date
                    ]
                    []
                ]
            , label []
                [ text "Other information"
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
