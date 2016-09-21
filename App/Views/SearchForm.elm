module Views.SearchForm exposing (view)

import Maybe exposing (withDefault)
import Html exposing (..)
import Html.Events exposing (..)
import Html.Attributes exposing (class, type', placeholder)
import Actions.Search exposing (..)


-- VIEW


view model =
    let
        isLoading =
            model.loading |> withDefault ""
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
