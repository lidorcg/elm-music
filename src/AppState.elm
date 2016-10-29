module Main exposing (..)

import Actions exposing (..)
import Utils.RemoteData exposing (..)
import Models exposing (..)
import GraphQL.Playlists exposing (playLists, PlayListsResult)
import GraphQL.Discover exposing (search, SearchResult)
import Task exposing (perform, Task)
import Debug exposing (log)
import List exposing (map)
import Maybe exposing (withDefault)
import String exposing (toInt)


-- MODEL


type alias Model =
    { searchResult : RemoteData (List Track)
    , playlists : RemoteData (List Playlist)
    , mainDisplay : MainDisplay
    }


type MainDisplay
    = MainNone
    | DisplaySearchResult
    | DisplayPlaylist String


init : ( Model, Cmd Action )
init =
    ( Model NotAsked Loading MainNone
    , playLists
        |> perform PlaylistsRequestError PlaylistsRequestOk
    )



-- UPDATE


update : Action -> Model -> ( Model, Cmd Action )
update msg model =
    case msg of
        PlaylistsRequestError error ->
            ( { model | playlists = Failure (log "error" error) }
            , Cmd.none
            )

        PlaylistsRequestOk result ->
            ( { model | playlists = Success <| processPlaylists result }
            , Cmd.none
            )

        Search query ->
            ( { model
                | searchResult = Loading
                , mainDisplay = DisplaySearchResult
              }
            , search { query = query }
                |> perform SearchRequestError SearchRequestOk
            )

        SearchRequestError error ->
            ( { model | searchResult = Failure (log "error" error) }
            , Cmd.none
            )

        SearchRequestOk result ->
            ( { model
                | searchResult = Success <| processSearchResult result
                , mainDisplay = DisplaySearchResult
              }
            , Cmd.none
            )

        _ ->
            ( model, Cmd.none )


processPlaylists : PlayListsResult -> List Playlist
processPlaylists result =
    map processPlaylist result.playlists


processPlaylist : RemotePlaylist -> Playlist
processPlaylist playlist =
    let
        id =
            playlist.id

        name =
            playlist.name |> withDefault "UNKNOWN"

        tracks =
            map processPlaylistTrack playlist.tracks
    in
        Playlist playlist.id name tracks


processPlaylistTrack : RemotePlaylistTrack -> Track
processPlaylistTrack track =
    let
        id =
            Just track.id

        name =
            track.name |> withDefault "UNKNOWN"

        artist =
            track.artists |> withDefault "UNKNOWN"

        duration =
            track.duration |> processDuration
    in
        Track id name artist duration track.youtubeId


processSearchResult : SearchResult -> List Track
processSearchResult result =
    map processTrack result.searchTracks


processTrack : RemoteTrack -> Track
processTrack track =
    let
        id =
            Nothing

        name =
            track.name |> withDefault "UNKNOWN"

        artist =
            track.artists |> withDefault "UNKNOWN"

        duration =
            track.duration |> processDuration
    in
        Track id name artist duration track.youtubeId


processDuration : Maybe String -> String
processDuration t =
    case t of
        Nothing ->
            "UNKNOWN"

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
