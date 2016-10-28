module Components.NewPlaylistModal exposing (Model, init, update, view)

import Actions.Main exposing (..)
import Reusables.Modal as Modal
import Components.NewPlaylistForm as Form
import Html exposing (..)
import Html.App exposing (map)


-- MODEL


type alias Model =
    Modal.Model Form.Model


init : Model
init =
    Modal.init Form.init



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NewPlaylistModalMsg modalMsg ->
            let
                ( model, cmd ) =
                    Modal.update Form.update modalMsg model
            in
                ( model, Cmd.map NewPlaylistModalMsg cmd )

        _ ->
            ( model, Cmd.none )


view : Model -> Html Msg
view model =
    map NewPlaylistModalMsg (Modal.view Form.view model)
