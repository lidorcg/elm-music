module Reducers.Display exposing (..)

import Actions.Main exposing (..)


-- MODEL


type DisplayMain
    = Playlist String
    | SearchResult


type DisplayModal
    = NewPlaylistForm
    | None


type alias Model =
    { main : DisplayMain
    , modal : DisplayModal
    }


init : Model
init =
    Model SearchResult None



-- UPDATE


update : Msg -> Model -> Model
update msg model =
    case msg of
        SearchFormSubmit ->
            { model | main = SearchResult }

        DisplayPlaylist id ->
            { model | main = Playlist id }

        DisplayNewPlaylistForm ->
            { model | modal = NewPlaylistForm }

        CloseNewPlaylistForm ->
            { model | modal = None }

        NewPlaylistFormSubmit ->
            { model | modal = None }
            
        _ ->
            model
