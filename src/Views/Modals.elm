module Views.Modals exposing (view)

import State exposing (..)
import Actions exposing (..)
import Models exposing (..)
import Html exposing (..)
import Html.Attributes exposing (class, placeholder, type', style)
import Html.Events exposing (onSubmit, onInput, onClick)


view : Model -> Html Msg
view state =
    newPlaylistModalView state


newPlaylistModalView : Model -> Html Msg
newPlaylistModalView { displayModal } =
    let
        isActive =
            case displayModal of
                ShowNewPlaylist ->
                    "is-active"

                _ ->
                    ""
    in
        div
            [ class ("modal " ++ isActive) ]
            [ div
                [ class "modal-background"
                , onClick HideNewPlaylistModal
                , style [ ( "background-color", "rgba(17, 17, 17, 0.16)" ) ]
                ]
                []
            , div
                [ class "modal-content" ]
                [ div
                    [ class "box" ]
                    [ form
                        [ onSubmit CreateNewPlaylist ]
                        [ label
                            [ class "label" ]
                            [ text "Name" ]
                        , p
                            [ class "control" ]
                            [ input
                                [ class "input"
                                , placeholder "Playlist Name"
                                , type' "text"
                                , onInput NewPlaylistFormInputName
                                ]
                                []
                            ]
                        , p
                            [ class "control" ]
                            [ button
                                [ class "button is-primary" ]
                                [ text "Submit" ]
                            ]
                        ]
                    ]
                ]
            , button
                [ class "modal-close", onClick HideNewPlaylistModal ]
                []
            ]
