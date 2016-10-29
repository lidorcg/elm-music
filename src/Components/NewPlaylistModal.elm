module Components.NewPlaylistModal exposing (Model, init, update, view)

import Actions exposing (..)
import GraphQL.Playlists exposing (CreatePlaylistResult, createPlaylist)
import Task exposing (perform)
import Html exposing (..)
import Html.Attributes exposing (class, placeholder, type', style)
import Html.Events exposing (onSubmit, onInput, onClick)


-- MODEL


type alias Model =
    { display : Display
    , name : String
    }


type Display
    = Show
    | Hide


init : Model
init =
    Model Hide ""



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ShowNewPlaylistModal ->
            ( { model | display = Show }
            , Cmd.none
            )

        HideNewPlaylistModal ->
            ( { model | display = Hide }
            , Cmd.none
            )

        NewPlaylistFormInputName name ->
            ( { model | name = name }
            , Cmd.none
            )

        CreateNewPlaylist ->
            ( { model | display = Hide }
            , createPlaylist { name = model.name }
                |> perform CreateNewPlaylistResponseError CreateNewPlaylistResponseOk
            )

        _ ->
            ( model, Cmd.none )


view : Model -> Html Msg
view model =
    let
        isActive =
            case model.display of
                Show ->
                    "is-active"

                Hide ->
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
