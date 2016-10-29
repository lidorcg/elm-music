module Components.Modals exposing (Model, init, update, view)

import Actions exposing (..)
import Components.NewPlaylistModal as NewPlaylistModal
import Html exposing (..)

-- MODEL

type alias Model =
  {newPlaylistModal : NewPlaylistModal.Model}

init : Model
init =
  Model NewPlaylistModal.init


-- UPDATE

update: Msg -> Model -> (Model, Cmd Msg)
update msg model =
  let
      ( newPlaylistModal, newPlaylistModalCmd ) =
          NewPlaylistModal.update msg model.newPlaylistModal
  in
      ( { model | newPlaylistModal = newPlaylistModal }
      , Cmd.batch [ newPlaylistModalCmd ]
      )

view : Model -> Html Msg
view model =
  NewPlaylistModal.view model.newPlaylistModal
