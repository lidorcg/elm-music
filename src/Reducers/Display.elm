module Reducers.Display exposing (..)

import Actions.Main exposing (..)


-- MODEL


type Display
    = Playlist String
    | SearchResult
    | Nothing


type alias Model =
    Display


init : Model
init =
    Nothing



-- UPDATE


update : Msg -> Model -> Model
update msg model =
    case msg of
        ShowPlaylist id ->
            Playlist id

        Search ->
            SearchResult

        _ ->
            model
