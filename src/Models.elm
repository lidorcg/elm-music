module Models exposing (..)

import List exposing (map, filter, head)
import Maybe exposing (withDefault)
import Mouse exposing (Position)


type alias Dnd =
    { track : Maybe Track
    , playlistId : Maybe String
    , pos : Maybe Position
    }


type DisplayForm
    = DisplayNewPlaylistForm
    | DisplayRenamePlaylistForm
    | DisplayDeleteForm
    | DisplayNoForm


type MainDisplay
    = DisplayPlaylist Playlist
    | DisplaySearchResult
    | DisplayNone


type alias SearchForm =
    { query : String
    }


type alias NewPlaylistForm =
    { name : String
    }


type alias RenamePlaylistForm =
    { id : String
    , name : String
    }


type alias DeletePlaylistForm =
    { id : String
    }


type alias Track =
    { id : Maybe String
    , name : String
    , artists : String
    , duration : String
    , youtubeId : Maybe String
    }


type alias Playlist =
    { id : String
    , name : String
    , tracks : List Track
    }


type alias RemoteSearchTrack =
    { name : Maybe String
    , artists : Maybe String
    , duration : Maybe String
    , youtubeId : Maybe String
    }


type alias RemotePlaylistTrack =
    { id : String
    , name : Maybe String
    , artists : Maybe String
    , duration : Maybe String
    , youtubeId : Maybe String
    }


type alias RemotePlaylist =
    { id : String
    , name : Maybe String
    , tracks : List RemotePlaylistTrack
    }



-- Funcitons


remotePlaylistToPlaylist : RemotePlaylist -> Playlist
remotePlaylistToPlaylist playlist =
    let
        tracks =
            map remotePlaylistTrackToTrack playlist.tracks

        name =
            playlist.name |> withDefault "NULL"
    in
        Playlist playlist.id name tracks


remotePlaylistTrackToTrack : RemotePlaylistTrack -> Track
remotePlaylistTrackToTrack track =
    let
        id =
            Just track.id

        name =
            track.name |> withDefault "NULL"

        artist =
            track.artists |> withDefault "NULL"

        duration =
            track.duration |> processDuration
    in
        Track id name artist duration track.youtubeId


remoteSearchTrackToTrack : RemoteSearchTrack -> Track
remoteSearchTrackToTrack track =
    let
        id =
            Nothing

        name =
            track.name |> withDefault "NULL"

        artist =
            track.artists |> withDefault "NULL"

        duration =
            track.duration |> processDuration
    in
        Track Nothing name artist duration track.youtubeId


processDuration : Maybe String -> String
processDuration t =
    case t of
        Nothing ->
            "0"

        Just time ->
            time
