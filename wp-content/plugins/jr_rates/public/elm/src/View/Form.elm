module View.Form exposing (view)

import Html exposing (..)
import Html.Attributes exposing (attribute, checked, class, id, name, required, type_, value)
import Html.Events exposing (onCheck, onClick, onInput, onSubmit)
import RemoteData as RD
import String exposing (fromInt, toInt)
import Types exposing (..)
import Utils exposing (printHttpError)


view : Model -> Html Msg
view { formContents, submitRequest } =
    div
        [ id "jr-rates-form" ]
        [ case submitRequest of
            RD.NotAsked ->
                formView formContents

            RD.Loading ->
                p [] [ text "Submitting your answers..." ]

            RD.Failure e ->
                div []
                    [ p [] [ text "There was a problem submitting your answers:" ]
                    , pre [] [ text <| printHttpError e ]
                    ]

            RD.Success _ ->
                div []
                    [ h3 [] [ text "Thank you for submitting!" ]
                    , p []
                        [ text "We'll get this added to the site soon. Refresh the page or "
                        , button [ class "reset-form", onClick ResetForm ] [ text "click here" ]
                        , text " to add another rate."
                        ]
                    ]
        ]


formView : FormContents -> Html Msg
formView formContents =
    form
        [ onSubmit SubmitForm
        ]
        [ label []
            [ span [] [ text "What's your name?" ]
            , input
                [ type_ "text"
                , onInput (UpdateFormField << UpdateName)
                , value formContents.name
                , required True
                ]
                []
            ]
        , label []
            [ span [] [ text "What's your email address?" ]
            , input
                [ type_ "email"
                , onInput (UpdateFormField << UpdateEmail)
                , value formContents.email
                , required True
                ]
                []
            ]
        , label []
            [ span [] [ text "What sort of work did you do?" ]
            , input
                [ type_ "text"
                , onInput (UpdateFormField << UpdateJobDescription)
                , value formContents.job_description
                , required True
                ]
                []
            ]
        , label []
            [ span [] [ text "What is the company's name?" ]
            , input
                [ type_ "text"
                , onInput (UpdateFormField << UpdateCompany)
                , value formContents.company_name
                , required True
                ]
                []
            ]
        , label []
            [ span [] [ text "How much were you paid?" ]
            , input
                [ type_ "text"
                , onInput (UpdateFormField << UpdateRate)
                , value formContents.rate
                , required True
                ]
                []
            ]
        , label []
            [ span [] [ text "When was this (year)?" ]
            , input
                [ type_ "number"
                , onInput (UpdateFormField << UpdateYear)
                , value formContents.year
                , required True
                ]
                []
            ]
        , div [ class "g-recaptcha" ] []
        , button []
            [ text "Submit"
            ]
        ]
