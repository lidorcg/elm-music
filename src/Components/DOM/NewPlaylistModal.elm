module Components.DOM.NewPlaylistModal exposing (Model, init, update, view)

import Actions exposing (..)
import Reusables.Modal as Modal
import Utils.SendMsg exposing (sendMsg)
import Html exposing (..)
import Html.Attributes exposing (class, placeholder, type')
import Html.Events exposing (onSubmit, onInput)


-- MODEL


type alias Model =
    { name : String
    , modal : Modal.Model
    }


init : Model
init =
    Model "" Modal.init



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NewPlaylistModalOnInput string ->
            ( { model | name = string }
            , Cmd.none
            )

        NewPlaylistModalOnSubmit ->
            ( model
            , sendMsg (CreateNewPlaylistRequest model.name)
            )

        ModalMsg modalMsg ->
            let
                modal =
                    Modal.update modalMsg model.modal
            in
                ( { model | modal = modal }
                , Cmd.none
                )

        OpenNewPlaylistModal ->
            let
                modal =
                    Modal.update Modal.open model.modal
            in
                ( { model | modal = modal }
                , Cmd.none
                )

        _ ->
            ( model, Cmd.none )


view : Model -> Html Msg
view model =
    Modal.view model.modal ModalMsg formView


formView : Html Msg
formView =
    div
        [ class "box" ]
        [ form
            [ onSubmit NewPlaylistModalOnSubmit ]
            [ label
                [ class "label" ]
                [ text "Name" ]
            , p
                [ class "control" ]
                [ input
                    [ class "input"
                    , placeholder "Playlist Name"
                    , type' "text"
                    , onInput NewPlaylistModalOnInput
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
