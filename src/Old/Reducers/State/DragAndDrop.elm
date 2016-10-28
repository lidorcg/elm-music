module Reducers.State.DragAndDrop exposing (..)

import Actions.Main exposing (..)
import Html exposing (..)
import Html.Events exposing (onMouseDown, onMouseUp, onMouseEnter, onMouseLeave)
import Utils.SendMsg exposing (sendMsg)

-- MODEL


type alias Model =
    { track : Maybe Track
    , playlist : Maybe String
    }


type alias Track =
    { name : String
    , artists : String
    , duration : String
    , youtubeId : Maybe String
    }


init : Model
init =
    Model Nothing Nothing



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Drag track ->
            ( { model | track = Just track }
            , Cmd.none
            )

        Drop ->
          case model.playlist of
            Nothing ->
              ( { model | track = Nothing }
              , Cmd.none
              )

            Just id ->
              case model.track of
                Nothing ->
                  ( { model | playlist = Nothing }
                  , Cmd.none
                  )

                Just track ->
                  ( { model | track= Nothing, playlist = Nothing }
                  , sendMsg (DragTrackToPlaylist track id)
                  )

        Enter playlist ->
            ( { model | playlist = Just playlist }
            , Cmd.none
            )

        Leave ->
          ( { model | playlist = Nothing }
          , Cmd.none
          )

        _ ->
            ( model, Cmd.none )

-- VIEW


dragableTrack : Html Msg -> Track -> Html Msg
dragableTrack view track =
    div [ onMouseDown (Drag track) ]
        [ view ]


dropablePlaylist : Html Msg -> String -> Html Msg
dropablePlaylist view playlist =
    div [ onMouseEnter (Enter playlist), onMouseLeave Leave, onMouseUp Drop ]
        [ view ]
