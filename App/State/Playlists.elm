module State.Playlists exposing (..)

import Utils.RemoteData exposing (..)
import GraphQL.Music exposing (playlists, PlaylistsResult)
import Task exposing (perform, Task)
import Http exposing (Error)
import Debug exposing (log)


-- MODEL


type alias Model =
    WebData PlaylistsResult


init : ( Model, Cmd Msg )
init =
  let
    (model, cmd) =
      update FetchData NotAsked
  in
    ( model, cmd )



-- UPDATE


type Msg
    = FetchData
    | FetchFail Http.Error
    | FetchSucceed PlaylistsResult



update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        FetchData ->
          ( Loading
          , playlists |> perform FetchFail FetchSucceed
          )

        FetchSucceed result ->
            ( Success result
            , Cmd.none
            )

        FetchFail error ->
            ( Failure (log "error" error)
            , Cmd.none
            )
