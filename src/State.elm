module State exposing (..)

import Models exposing (..)
import Actions exposing (..)
import GraphQL.Playlists exposing (playlists)
import Task exposing (perform)


-- MODEL


type alias Model =
    { searchQuery : String
    , searchResult : RemoteData (List Track)
    , playlists : RemoteData (List Playlist)
    , displayMain : DisplayMain
    , displayModal : DisplayModal
    , newPlaylistName : String
    }


init : ( Model, Cmd Msg )
init =
    ( { searchQuery = ""
      , searchResult = NotAsked
      , playlists = Loading
      , displayMain = DisplayNone
      , displayModal = Hide
      , newPlaylistName = ""
      }
    , playlists
        |> perform FetchPlaylistsFail FetchPlaylistsSucceed
    )
