module TrackList exposing (Model, init, Msg, update, view)

import List exposing (map)
import Html.App as App
import Html exposing (..)
import Html.Events exposing (..)
import Html.Attributes exposing (class)
import Track


-- MODEL


type alias Model =
    List Track.Model


init : Model
init =
    []



-- UPDATE


type Msg
    = TrackMsg Track.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        TrackMsg _ ->
            ( model, Cmd.none )



-- VIEW


view : Model -> Html Msg
view model =
    let
        tracks =
            map viewTrack model
    in
        div []
            [ h3 [ class "title is-3" ] [ text "Tracks:" ]
            , tracks |> trackTable
            ]


trackTable : List (Html Msg) -> Html Msg
trackTable tracks =
    table [ class "table" ]
        [ thead []
            [ tr []
                [ th [] [ text "Name" ]
                , th [] [ text "Artist" ]
                , th [] [ text "ytID" ]
                ]
            ]
        , tbody [] tracks
        ]


viewTrack : Track.Model -> Html Msg
viewTrack track =
    track |> Track.view |> App.map TrackMsg
