module Views.SearchForm exposing (view)

import Html.App as App
import Html exposing (..)
import Html.Events exposing (onSubmit, onInput)
import Html.Attributes exposing (class, type', placeholder)
import State.Search as Search
import State.Main as State
import Utils.RemoteData exposing (..)


-- VIEW


view : Search.Model -> Html State.Msg
view searchState =
    let
        isLoading =
            isResultLoading searchState.result
    in
        form [ onSubmit State.Search ]
            [ p [ class "nav-item control has-addons" ]
                [ App.map State.SearchMsg <| viewInput
                , button
                    [ class <| "button is-info " ++ isLoading ]
                    [ text "Search" ]
                ]
            ]


viewInput : Html Search.Msg
viewInput =
    input
        [ class "input"
        , placeholder "Find music"
        , type' "text"
        , onInput Search.Input
        ]
        []


isResultLoading : RemoteData a b -> String
isResultLoading result =
    case result of
        Loading ->
            "is-loading"

        _ ->
            ""
