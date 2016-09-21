module Views.SearchForm exposing (view)


import Html exposing (..)
import Html.Events exposing (onSubmit, onInput)
import Html.Attributes exposing (class, type', placeholder)
import Maybe exposing (withDefault)
import Actions.Search exposing (..)


-- VIEW


view searchState =
    let
        isLoading =
            searchState.isLoading |> withDefault ""
    in
        form [ onSubmit SearchTracks ]
            [ p [ class "nav-item control has-addons" ]
                [ input
                    [ class "input", placeholder "Find music", type' "text", onInput ChangeQuery ]
                    []
                , button
                    [ class <| "button is-info " ++ isLoading ]
                    [ text "Search" ]
                ]
            ]
