module State.Main exposing (..)

import State.Playlists as Playlists
import State.Search as Search
import State.Display as Display


-- MODEL


type alias Model =
    { playlists : Playlists.Model
    , search : Search.Model
    , display : Display.Model
    }


init : ( Model, Cmd Msg )
init =
    let
        ( playlists, pcmd ) =
            Playlists.init
    in
        ( Model playlists Search.init Display.init
        , Cmd.map PlaylistMsg pcmd
        )



-- UPDATE


type Msg
    = PlaylistMsg Playlists.Msg
    | SearchMsg Search.Msg
    | DisplayMsg Display.Msg
    | Search


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        PlaylistMsg pmsg ->
            let
                ( playlists, cmd ) =
                    Playlists.update pmsg model.playlists
            in
                ( { model | playlists = playlists }, Cmd.map PlaylistMsg cmd )

        SearchMsg smsg ->
            let
                ( search, cmd ) =
                    Search.update smsg model.search
            in
                ( { model | search = search }, Cmd.map SearchMsg cmd )

        DisplayMsg dmsg ->
            let
                display =
                    Display.update dmsg model.display
            in
                ( { model | display = display }, Cmd.none )

        Search ->
            let
                ( search, scmd ) =
                    Search.update Search.FetchData model.search

                display =
                   Display.update Display.ShowSearch model.display

            in
                ( { model | search = search, display = display }
                , Cmd.map SearchMsg scmd
                )
