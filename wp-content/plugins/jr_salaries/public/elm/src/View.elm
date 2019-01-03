module View exposing (view)

import Html exposing (Html, div, fieldset, form, input, label, legend, text)
import Html.Attributes exposing (checked, class, name, type_, value)
import Html.Events exposing (onSubmit)
import Types exposing (..)


view : Model -> Html Msg
view { salary } =
    div [ class "wrapper" ]
        [ form
            [-- onSubmit FormSubmit
            ]
            [ label []
                [ text "Name"
                , input [ type_ "text", value salary.name ] []
                ]
            , label []
                [ text "Email"
                , input [ type_ "text", value salary.email ] []
                ]
            , label []
                [ text "Job title"
                , input [ type_ "text", value salary.job_title ] []
                ]
            , label []
                [ text "Company"
                , input [ type_ "text", value salary.company ] []
                ]
            , label []
                [ text "Salary"
                , input [ type_ "text", value salary.salary ] []
                ]
            , fieldset []
                [ legend [] [ text "Anonymise?" ]
                , label []
                    [ text "Yes"
                    , input [ type_ "radio", name "anonymise", checked salary.anonymise ] []
                    ]
                , label []
                    [ text "No"
                    , input [ type_ "radio", name "anonymise", checked <| not salary.anonymise ] []
                    ]
                ]
            , label []
                [ text "Location"
                , input [ type_ "text", value salary.location ] []
                ]
            , label []
                [ text "When was this?"
                , input [ type_ "datetime", value salary.job_date ] []
                ]
            , label []
                [ text "Other information"
                , input [ type_ "text", value salary.other ] []
                ]
            ]
        ]
