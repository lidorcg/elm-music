module Views.NewPlaylistForm exposing (newPlaylistForm)

import Actions.Main as Actions
import Html exposing (..)
import Html.Attributes exposing (class, placeholder, type', style)
import Html.Events exposing (onSubmit, onInput, onClick)


newPlaylistForm : Html Actions.Msg
newPlaylistForm =
    div
        [ class "modal is-active" ]
        [ div
            [ class "modal-background"
            , onClick Actions.CloseNewPlaylistModal
            , style [ ( "background-color", "rgba(17, 17, 17, 0.16)" ) ]
            ]
            []
        , div
            [ class "modal-content" ]
            [ div
                [ class "box" ]
                [ form
                    [ onSubmit Actions.NewPlaylistFormSubmit ]
                    [ label
                        [ class "label" ]
                        [ text "Name" ]
                    , p
                        [ class "control" ]
                        [ input
                            [ class "input"
                            , placeholder "Playlist Name"
                            , type' "text"
                            , onInput Actions.NewPlaylistFormInputName
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
            [ class "modal-close", onClick Actions.CloseNewPlaylistModal ]
            []
        ]
