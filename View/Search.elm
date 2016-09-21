module View.Search exposing (view)

import Maybe exposing (withDefault)
import Html.App as App
import Html exposing (..)
import Html.Events exposing (..)
import Html.Attributes exposing (class, type', placeholder)
import TrackList
import Logic.Search exposing (..)


-- VIEW


view : Model -> Html Msg
view model =
    let
        tracks =
            viewTracks model.result
    in
        div []
            [ viewSearchForm model
            , tracks
            ]


viewSearchForm : Model -> Html Msg
viewSearchForm model =
    let
        isLoading =
            model.loading |> withDefault ""
    in
        form [ onSubmit SearchTracks ]
            [ p [ class "control has-addons" ]
                [ input
                    [ class "input", placeholder "Find music", type' "text", onInput ChangeQuery ]
                    []
                , button
                    [ class <| "button is-info " ++ isLoading ]
                    [ text "Search" ]
                ]
            ]


viewTracks : TrackList.Model -> Html Msg
viewTracks tracks =
    App.map TrackListMsg <| TrackList.view tracks
