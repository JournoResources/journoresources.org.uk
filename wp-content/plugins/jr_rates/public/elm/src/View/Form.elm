module View.Form exposing (view)

import Html exposing (..)
import Html.Attributes exposing (attribute, checked, class, id, name, required, type_, value)
import Html.Events exposing (onCheck, onClick, onInput, onSubmit)
import RemoteData as RD
import String exposing (fromInt, toInt)
import Types exposing (..)
import Utils exposing (prettyPrintLocation, printHttpError)


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
            [ span [] [ text "What is the job title?" ]
            , input
                [ type_ "text"
                , onInput (UpdateFormField << UpdateJobTitle)
                , value formContents.job_title
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
            [ span [] [ text "Would you like us to anonymise the company?" ]
            , input
                [ type_ "checkbox"
                , onCheck (UpdateFormField << UpdateAnonymise)
                , checked formContents.anonymise_company
                ]
                []
            ]
        , label []
            [ span [] [ text "How much were you paid (£ per annum)?" ]
            , input
                [ type_ "number"
                , onInput (UpdateFormField << UpdateRate << Maybe.withDefault 0 << toInt)
                , value <| fromInt formContents.rate
                , required True
                ]
                []
            ]
        , label []
            [ span [] [ text "Was the job part-time?" ]
            , input
                [ type_ "checkbox"
                , onCheck (UpdateFormField << UpdatePartTime)
                , checked formContents.part_time
                ]
                []
            ]
        , label []
            [ span [] [ text "Where was the job located?" ]
            , locationSelect
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
        , if formContents.part_time then
            label []
                [ span [] [ text "Any further information?" ]
                , input
                    [ type_ "text"
                    , onInput (UpdateFormField << UpdateRateInfo)
                    , value formContents.extra_rate_info
                    ]
                    []
                ]

          else
            text ""
        , div [ class "g-recaptcha" ] []
        , button []
            [ text "Submit"
            ]
        ]


locationSelect : Html Msg
locationSelect =
    let
        options =
            [ ( London, prettyPrintLocation London )
            , ( Rural, prettyPrintLocation Rural )
            , ( City, prettyPrintLocation City )
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
