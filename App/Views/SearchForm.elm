module Views.SearchForm exposing (view)

import Html exposing (..)
import Html.Events exposing (onSubmit, onInput)
import Html.Attributes exposing (class, type', placeholder)
import Maybe exposing (withDefault)
import State.Search as Search
import Models.RemoteData exposing (..)


-- VIEW


view : Search.State -> Html Search.Msg
view searchState =
    let
        isLoading =
            case searchState.result of
              Loading ->
                "is-loading"

              _ ->
                ""
    in
        form [ onSubmit Search.SearchTracks ]
            [ p [ class "nav-item control has-addons" ]
                [ input
                    [ class "input"
                    , placeholder "Find music"
                    , type' "text"
                    , onInput Search.ChangeQuery
                    ]
                    []
                , button
                    [ class <| "button is-info " ++ isLoading ]
                    [ text "Search" ]
                ]
            ]
