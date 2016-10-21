module Views.SearchForm exposing (view)

import Reducers.Search as Search
import Actions.Main as Actions
import Html exposing (..)
import Html.Events exposing (onSubmit, onInput)
import Html.Attributes exposing (class, type', placeholder)
import Utils.RemoteData exposing (..)


-- VIEW


view : Search.Model -> Html Actions.Msg
view searchState =
    let
        isLoading =
            isResultLoading searchState.result
    in
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
                    [ class <| "button is-info " ++ isLoading ]
                    [ text "Search" ]
                ]
            ]


isResultLoading : RemoteData a -> String
isResultLoading result =
    case result of
        Loading ->
            "is-loading"

        _ ->
            ""
