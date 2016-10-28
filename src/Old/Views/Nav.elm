module Views.Nav exposing (view)

import Reducers.State.Nav exposing (Model)
import Actions.Main as Actions
import Html exposing (..)
import Html.Events exposing (onSubmit, onInput)
import Html.Attributes exposing (class, type', placeholder)


-- VIEW


view : Model -> Html Actions.Msg
view model =
    nav [ class "nav" ]
        [ div [ class "nav-left" ]
            [ viewSearchForm model ]
        ]

viewSearchForm : Model -> Html Actions.Msg
viewSearchForm model =
    form [ onSubmit Actions.SearchFormSubmit ]
        [ p [ class "nav-item control has-addons" ]
            [ input
                [ class "input"
                , placeholder "Find music"
                , type' "text"
                , onInput Actions.SearchFormInputQuery
                ]
                []
            , button
                [ class <| "button is-info " ++ model.status ]
                [ text "Search" ]
            ]
        ]
