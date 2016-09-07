import Html.App as App
import Html exposing (..)
import Html.Events exposing (..)
import Html.Attributes exposing (type', placeholder)
import Http exposing (send, defaultSettings, fromJson, Body, Error)
import Task exposing (Task, perform)
import Json.Encode as Json
import Json.Decode exposing (Decoder, at, string, list)
import Json.Decode.Pipeline exposing (decode, required, optional)

import TrackList
import Track



main =
  App.program
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }


-- MODEL


type alias Model =
  { query : String
  , tracks : TrackList.Model
  , error : String
  }


init =
  ( Model "" TrackList.init ""
  , Cmd.none
  )



-- UPDATE


type Msg
  = ChangeQuery String
  | SearchTracks
  | FetchSucceed (List Track.Model)
  | FetchFail Http.Error
  | TrackListMsg TrackList.Msg


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    ChangeQuery input ->
      ({model | query=input}, Cmd.none)

    SearchTracks ->
      (model, searchTracks model.query)

    FetchSucceed tracks ->
      ({model | tracks={tracks=tracks}}, Cmd.none)

    FetchFail err ->
      ({model | error=(logError err)}, Cmd.none)

    TrackListMsg _ ->
      (model, Cmd.none)



-- VIEW


view : Model -> Html Msg
view model =
  let
    tracks = viewTracks model.tracks
  in
    div []
    [ form [ onSubmit SearchTracks ]
    [ input [ type' "text", placeholder "Track", onInput ChangeQuery ] []
    , button [] [ text "Search!" ]
    ]
    , tracks
    ]


viewTracks : TrackList.Model -> Html Msg
viewTracks tracks =
  App.map TrackListMsg (TrackList.view tracks)



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none


-- TODO: extract to module
-- HTTP


searchTracks : String -> Cmd Msg
searchTracks query =
  let
    url =
      "http://localhost:5000/graphql?"

    gql =
      "{searchTracks(query: \"" ++ query ++ """\"){
        name
        artists{name}
        youtubeId
      }}"""

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
  at ["data", "searchTracks"] (list trackDecoder)


trackDecoder : Decoder Track.Model
trackDecoder =
  decode Track.Model
    |> required "name" string
    |> required "artists" (list artistDecoder)
    |> optional "youtubeId" string "(No ytID)"


artistDecoder : Decoder Track.Artist
artistDecoder =
  decode Track.Artist
    |> required "name" string


logError : Http.Error -> String
logError err =
  case err of
    Http.Timeout ->
      Debug.log "Timeout" "Timeout"

    Http.NetworkError ->
      Debug.log "NetworkError" "NetworkError"

    Http.UnexpectedPayload str ->
      Debug.log str str

    Http.BadResponse n str ->
      Debug.log str str
