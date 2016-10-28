module Components.Http.GetPlaylists exposing (Model, init, update)

import Actions exposing (..)
import Utils.RemoteData exposing (..)
import Utils.SendMsg exposing (sendMsg)
import GraphQL.Playlists exposing (AllPlaylistsResult, allPlaylists)
import Task exposing (perform, Task)
import Debug exposing (log)


-- MODEL


type alias Model =
    RemoteData AllPlaylistsResult


init : Model
init =
    NotAsked



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GetPlaylistsRequest ->
            ( Loading
            , allPlaylists
                |> perform GetPlaylistsRequestError GetPlaylistsRequestOk
            )

        GetPlaylistsRequestError error ->
            ( Failure (log "error" error)
            , sendMsg (GetPlaylistsResponse (Err error))
            )

        GetPlaylistsRequestOk result ->
            ( Success result
            , sendMsg (GetPlaylistsResponse (Ok result))
            )

        _ ->
            ( model, Cmd.none )
