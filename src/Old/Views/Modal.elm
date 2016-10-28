module Views.Modal exposing (view)

import Reducers.State.Modal exposing (..)
import Actions.Main as Actions
import Html exposing (..)
import Html.Attributes exposing (class)
import Views.NewPlaylistForm exposing (newPlaylistForm)


view : Model -> Html Actions.Msg
view model =
  case model.display of
    NewPlaylistForm ->
      newPlaylistForm

    None ->
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
