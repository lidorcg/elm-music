import Track
import Html exposing (..)
import Html.App as App
import Html.Events exposing (..)
import Html.Attributes exposing (type', placeholder)
import Http exposing (send, defaultSettings, fromJson, Body, Error)
import Task exposing (Task, perform)
import Json.Encode as Json
import Json.Decode exposing (Decoder, at, string, list)
import Json.Decode.Pipeline exposing (decode, required, optional)


main =
  App.program
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }



-- MODEL


type alias Model =
  { track_id : String
  , tracks : List Track.Model
  }


init : (Model, Cmd Msg)
init =
  ( Model "" []
  , Cmd.none
  )



-- UPDATE


type Msg
  = ChangeTrackId String
  | FetchTrack
  | FetchSucceed (List Track.Model)
  | FetchFail Http.Error
  | TrackMsg Track.Msg


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    ChangeTrackId input ->
      ({model | track_id = input}, Cmd.none)

    FetchTrack ->
      (model, getTrack model.track_id)

    FetchSucceed tracks ->
      ( {model
      | tracks = tracks}
      , Cmd.none)

    FetchFail _ ->
      (model, Cmd.none)

    TrackMsg _ ->
      (model, Cmd.none)



-- VIEW


view : Model -> Html Msg
view model =
  let
    tracks = List.map viewTrack model.tracks
  in
    div []
    [ input [ type' "text", placeholder "Track", onInput ChangeTrackId ] []
    , button [ onClick FetchTrack ] [ text "Get Song!" ]
    , h1 [] [ text "Tracks:" ]
    , tracksTable tracks
    ]


tracksTable tracks =
  table []
  ([ tr []
    [ th [] [ text "Name" ]
    , th [] [ text "Duration" ]
    , th [] [ text "ytID" ]
    ]
  ] ++ tracks)

viewTrack : Track.Model -> Html Msg
viewTrack track =
  App.map TrackMsg (Track.view track)


-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none



-- HTTP


getTrack : String -> Cmd Msg
getTrack query =
  let
    url =
      "http://localhost:5000/graphql?"

    gql =
      "{searchTracks(query: \"" ++ query ++ "\"){name duration youtubeId}}"

    jsonObject =
      Json.object
      [ ("operationName", Json.null)
      , ("query", Json.string gql)
      , ("variables", Json.null)
      ]
  in
    perform FetchFail FetchSucceed (postJson decodeJson url (Http.string (Json.encode 0 jsonObject)))


postJson : Decoder value -> String -> Body -> Task Error value
postJson decoder url body =
  let request =
        { verb = "POST"
        , headers = [
        ("Content-Type", "application/json"),
        ("Accept", "application/json")
        ]
        , url = url
        , body = body
        }
  in
    fromJson decoder (send defaultSettings request)


decodeJson : Decoder (List Track.Model)
decodeJson =
  at ["data", "searchTracks"] trackListDecoder


trackListDecoder : Decoder (List Track.Model)
trackListDecoder =
  list trackDecoder


trackDecoder : Decoder Track.Model
trackDecoder =
  decode Track.Model
    |> required "name" string
    |> required "duration" string
    |> optional "youtubeId" string "(No ytID)"
