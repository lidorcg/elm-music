module Reducers.Data exposing (..)

import Actions.Main exposing (..)
import Reducers.Data.Search as Search
import Reducers.Data.GetPlaylists as GetPlaylists
import Reducers.Data.CreateNewPlaylist as CreateNewPlaylist


-- MODEL


type alias Model =
    { search : Search.Model
    , getPlaylists : GetPlaylists.Model
    , createNewPlaylist : CreateNewPlaylist.Model
    }


init : Model
init =
    Model
        Search.init
        GetPlaylists.init
        CreateNewPlaylist.init



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    let
        ( search, searchCmd ) =
            Search.update msg model.search

        ( getPlaylists, getPlaylistsCmd ) =
            GetPlaylists.update msg model.getPlaylists

        ( createNewPlaylist, createNewPlaylistCmd ) =
            CreateNewPlaylist.update msg model.createNewPlaylist
    in
        ( { model
            | search = search
            , getPlaylists = getPlaylists
            , createNewPlaylist = createNewPlaylist
          }
        , Cmd.batch
            [ searchCmd
            , getPlaylistsCmd
            , createNewPlaylistCmd
            ]
        )
