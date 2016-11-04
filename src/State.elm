module State exposing (..)

import Models exposing (..)
import Actions exposing (..)
import Utils exposing (RemoteData(..), WebData)
import GraphQL.Playlists exposing (playlists)
import Task exposing (perform)


-- MODEL


type alias Model =
    { searchForm : SearchForm
    , searchResult : WebData (List Track)
    , playlists : WebData (List Playlist)
    , displayMain : MainDisplay
    , displayForm : DisplayForm
    , newPlaylistForm : NewPlaylistForm
    , renamePlaylistForm : RenamePlaylistForm
    , deletePlaylistForm : DeletePlaylistForm
    , dnd : Dnd
    }


init : ( Model, Cmd Msg )
init =
    ( { searchForm = SearchForm ""
      , searchResult = NotAsked
      , playlists = Loading
      , displayMain = DisplayNone
      , displayForm = DisplayNoForm
      , newPlaylistForm = NewPlaylistForm ""
      , renamePlaylistForm = RenamePlaylistForm "" ""
      , deletePlaylistForm = DeletePlaylistForm ""
      , dnd = Dnd Nothing Nothing Nothing
      }
    , playlists
        |> perform FetchPlaylistsFail FetchPlaylistsSucceed
    )
