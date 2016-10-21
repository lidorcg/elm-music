module Views.Modal exposing (view)

import Reducers.Main as State
import Actions.Main as Actions
import Reducers.Display as Display
import Views.NewPlaylistForm exposing (newPlaylistForm)
import Html exposing (..)
import Html.Attributes exposing (class)

view : State.Model -> Html Actions.Msg
view state =
  case state.display.modal of
    Display.NewPlaylistForm ->
      newPlaylistForm state.playlists

    Display.None ->
      div
        [ class "modal" ]
        [ div
          [ class "modal-background" ]
          []
        , div
          [ class "modal-content" ]
          []
        , button
          [ class "modal-close" ]
          []
        ]
