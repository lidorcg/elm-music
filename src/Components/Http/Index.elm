module Components.Http.Index exposing (Model, init, update)

import Actions exposing (Msg)
import Components.Http.Search as Search
import Components.Http.GetPlaylists as GetPlaylists
import Components.Http.CreateNewPlaylist as CreatePlaylist


-- MODEL


type alias Model =
    { search : Search.Model
    , getPlaylists : GetPlaylists.Model
    , createPlaylist : CreatePlaylist.Model
    }


init : Model
init =
    Model Search.init GetPlaylists.init CreatePlaylist.init



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    let
        ( search, searchCmd ) =
            Search.update msg model.search

        ( getPlaylists, getPlaylistsCmd ) =
            GetPlaylists.update msg model.getPlaylists

        ( createPlaylist, createPlaylistCmd ) =
            CreatePlaylist.update msg model.createPlaylist
    in
        ( { model
            | search = search
            , getPlaylists = getPlaylists
            , createPlaylist = createPlaylist
          }
        , Cmd.batch
            [ searchCmd
            , getPlaylistsCmd
            , createPlaylistCmd
            ]
        )
