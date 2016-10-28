module Components.Data.Playlists exposing (..)

import Actions exposing (Msg(GetPlaylistsResponse))
import GraphQL.Playlists exposing (AllPlaylistsResult)
import Utils.SendMsg exposing (sendMsg)
import Http exposing (Error)
import List exposing (map)
import Maybe exposing (withDefault)
import String exposing (toInt)


-- MODEL


type alias Model =
    List Playlist

type alias Playlist =
    { id : String
    , tracks : List Track
    }

type alias Track =
    { name : String
    , artists : String
    , duration : String
    , youtubeId : Maybe String
    }


init : Model
init =
    []



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GetPlaylistsResponse result ->
            let
                playlists =
                    processPlaylists result
            in
                ( playlists
                , Cmd.none
                )

        _ ->
            ( model, Cmd.none )


processPlaylists : Result Http.Error AllPlaylistsResult -> List Playlist
processPlaylists result =
    case result of
        Err error ->
            []

        Ok result ->
            map processPlaylist result.allPlaylists


processPlaylist : { b | id : String, tracks : List { a | artists : Maybe String, duration : Maybe String, name : Maybe String, youtubeId : Maybe String } } -> Playlist
processPlaylist playlist =
    let
        tracks =
            map processTrack playlist.tracks
    in
        Playlist playlist.id tracks


processTrack : { a | artists : Maybe String, duration : Maybe String, name : Maybe String, youtubeId : Maybe String } -> Track
processTrack track =
    let
        name =
            track.name |> withDefault "Unknown Name"

        artist =
            track.artists |> withDefault "Unknown Artist"

        duration =
            track.duration |> processDuration
    in
        Track name artist duration track.youtubeId


processDuration : Maybe String -> String
processDuration t =
    case t of
        Nothing ->
            "Unknown Duration"

        Just time ->
            let
                ms =
                    Result.withDefault 0 (toInt time)

                minutes =
                    ms // 1000 // 60

                seconds =
                    ms // 1000 `rem` 60

                zeroPadding =
                    if seconds < 10 then
                        "0"
                    else
                        ""
            in
                toString minutes ++ ":" ++ zeroPadding ++ toString seconds
