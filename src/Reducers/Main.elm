module Reducers.Main exposing (..)

import Actions.Main exposing (..)
import Reducers.Playlists as Playlists
import Reducers.Search as Search
import Reducers.Display as Display


-- MODEL


type alias Model =
    { playlists : Playlists.Model
    , search : Search.Model
    , display : Display.Model
    }


init : ( Model, Cmd Msg )
init =
    let
        ( playlists, cmd ) =
            Playlists.init
    in
        ( Model playlists Search.init Display.init
        , cmd
        )



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    let
        ( playlists, playlistsCmd ) =
            Playlists.update msg model.playlists

        ( search, searchCmd ) =
            Search.update msg model.search

        display =
            Display.update msg model.display
    in
        ( { model
            | playlists = playlists
            , search = search
            , display = display
          }
        , Cmd.batch [ playlistsCmd, searchCmd ]
        )
