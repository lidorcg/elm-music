module Views.Modals exposing (view)

import State exposing (..)
import Actions exposing (..)
import Models exposing (..)
import Html exposing (..)
import Html.Attributes exposing (class, placeholder, type_, style, value)
import Html.Events exposing (onSubmit, onInput, onClick)


view : Model -> Html Msg
view state =
    div []
        [ deletePlaylistModal state
        ]


deletePlaylistModal : Model -> Html Msg
deletePlaylistModal { displayForm } =
    let
        isActive =
            case displayForm of
                DisplayDeleteForm ->
                    "is-active"

                _ ->
                    ""
    in
        div
            [ class ("modal " ++ isActive) ]
            [ div
                [ class "modal-background"
                , onClick HideForm
                , style [ ( "background-color", "rgba(17, 17, 17, 0.5)" ) ]
                ]
                []
            , div
                [ class "modal-content" ]
                [ div
                    [ class "box has-text-centered" ]
                    [ h1
                        [ class "title is-1" ]
                        [ text "Are You Sure?" ]
                    , div
                        [ class "level" ]
                        [ p
                            [ class "level-item has-text-centered" ]
                            [ a
                                [ class "button is-large is-danger is-outlined"
                                , onClick DeletePlaylist
                                ]
                                [ text "Yes, Delete Playlist" ]
                            ]
                        , p
                            [ class "level-item has-text-centered" ]
                            [ a
                                [ class "button is-large is-primary is-outlined"
                                , onClick HideForm
                                ]
                                [ text "No, Take Me Back" ]
                            ]
                        ]
                    ]
                ]
            , button
                [ class "modal-close", onClick HideForm ]
                []
            ]
