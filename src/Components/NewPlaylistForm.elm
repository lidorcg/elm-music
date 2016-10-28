module Components.NewPlaylistForm exposing (Model, init, update, view)

import Actions.Main exposing (..)
import Utils.SendMsg exposing (sendMsg)
import Html exposing (..)
import Html.Attributes exposing (class, placeholder, type')
import Html.Events exposing (onSubmit, onInput)


-- MODEL


type alias Model =
    { name : String }


init : Model
init =
    Model ""



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NewPlaylistFormInputName name ->
            ( { model | name = name }
            , Cmd.none
            )

        NewPlaylistFormSubmit ->
            ( model
            , sendMsg (CreateNewPlaylistRequest model.name)
            )

        _ ->
            ( model, Cmd.none )



-- VIEW


view : Model -> Html Msg
view model =
    div
        [ class "box" ]
        [ form
            [ onSubmit NewPlaylistFormSubmit ]
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
