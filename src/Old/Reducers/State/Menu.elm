module Reducers.State.Menu exposing (..)

import Actions.Main exposing (..)
import GraphQL.Playlists exposing (AllPlaylistsResult)
import List exposing (map)
import Maybe exposing (withDefault)
import Http exposing (Error)


type alias Model =
    { playlists : List Playlist
    , active : String
    }


type alias Playlist =
    { id : String
    , name : String
    }


init : Model
init =
    Model [] ""



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SearchFormSubmit ->
            ( { model | active = "" }
            , Cmd.none
            )

        SearchResponse _ ->
            ( { model | active = "" }
            , Cmd.none
            )

        DisplayPlaylist id ->
            ( { model | active = id }
            , Cmd.none
            )

        GetPlaylistsResponse result ->
            let
                playlists =
                    processAllPlaylists result
            in
                ( { model | playlists = playlists }
                , Cmd.none
                )

        _ ->
            ( model, Cmd.none )


processAllPlaylists : Result Http.Error AllPlaylistsResult -> List Playlist
processAllPlaylists result =
    case result of
        Err error ->
            []

        Ok result ->
            map processPlaylist result.allPlaylists


processPlaylist : { a | id : String, name : Maybe String } -> Playlist
processPlaylist playlist =
    let
        name =
            withDefault "UNKNOWN" playlist.name
    in
        Playlist playlist.id name
