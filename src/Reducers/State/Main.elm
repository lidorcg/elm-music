module Reducers.State.Main exposing (..)

import Actions.Main exposing (..)
import GraphQL.Discover exposing (SearchResult)
import GraphQL.Playlists exposing (AllPlaylistsResult)
import Http exposing (Error)
import List exposing (map)
import Maybe exposing (withDefault)
import String exposing (toInt)


-- MODEL


type alias Model =
    { display : Display
    , searchResult : List Track
    , playlists : List Playlist
    }


type Display
    = SearchResult
    | ShowPlaylist String
    | None


type alias Track =
    { name : String
    , artists : String
    , duration : String
    , youtubeId : Maybe String
    }


type alias Playlist =
    { id : String
    , tracks : List Track
    }


init : Model
init =
    Model None [] []



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SearchFormSubmit ->
            ( { model | display = SearchResult }
            , Cmd.none
            )

        SearchResponse result ->
            let
                tracks =
                    processTracks result
            in
                ( { model | display = SearchResult, searchResult = tracks }
                , Cmd.none
                )

        GetPlaylistsResponse result ->
            let
                playlists =
                    processPlaylists result
            in
                ( { model | playlists = playlists }
                , Cmd.none
                )

        DisplayPlaylist id ->
            ( { model | display = ShowPlaylist id }
            , Cmd.none
            )

        _ ->
            ( model, Cmd.none )



-- UTILS


processPlaylists : Result Error AllPlaylistsResult -> List Playlist
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


processTracks : Result Http.Error SearchResult -> List Track
processTracks result =
    case result of
        Err error ->
            []

        Ok result ->
            map processTrack result.searchTracks


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
