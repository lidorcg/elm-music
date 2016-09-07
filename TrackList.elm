module TrackList exposing (..)

import Html.App as App
import Html exposing (..)
import Html.Events exposing (..)

import Track



-- MODEL


type alias Model =
  { tracks : List Track.Model }


init =
  Model []


-- UPDATE


type Msg
  = TrackMsg Track.Msg


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    TrackMsg _ ->
      (model, Cmd.none)



-- VIEW


view : Model -> Html Msg
view model =
  let
    tracks = List.map viewTrack model.tracks
  in
    div []
    [ h1 [] [ text "Tracks:" ]
    , tracksTable tracks
    ]


tracksTable tracks =
  table []
  ([ tr []
    [ th [] [ text "Name" ]
    , th [] [ text "Artist" ]
    , th [] [ text "ytID" ]
    ]
  ] ++ tracks)

viewTrack : Track.Model -> Html Msg
viewTrack track =
  App.map TrackMsg (Track.view track)
