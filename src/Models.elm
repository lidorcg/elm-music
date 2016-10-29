module Models exposing (..)


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


type alias RemoteTrack =
    { name : Maybe String
    , artists : Maybe String
    , duration : Maybe String
    , youtubeId : Maybe String
    }


type alias RemotePlaylistTrack =
    { id : String
    , name : Maybe String
    , duration : Maybe String
    , artists : Maybe String
    , youtubeId : Maybe String
    }


type alias RemotePlaylist =
    { id : String
    , name : Maybe String
    , tracks : List RemotePlaylistTrack
    }
