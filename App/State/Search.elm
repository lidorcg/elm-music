module State.Search exposing (..)

import Debug exposing (log)
import Http exposing (Error)
import Task exposing (perform)
import GraphQL.Music exposing (search, SearchResult)
import Models.RemoteData exposing (..)

-- MODEL


type alias State =
    { query : String
    , result : WebData SearchResult
    }


init : State
init =
    State "" NotAsked



-- UPDATE


type Msg
    = ChangeQuery String
    | SearchTracks
    | FetchSucceed SearchResult
    | FetchFail Http.Error


update : Msg -> State -> ( State, Cmd Msg )
update msg state =
    case msg of
        ChangeQuery input ->
            ( { state | query = input }
            , Cmd.none
            )

        SearchTracks ->
            ( { state | result = Loading }
            , search { query = state.query } |> perform FetchFail FetchSucceed
            )

        FetchSucceed result ->
            ( { state | result = Success result }
            , Cmd.none
            )

        FetchFail error ->
            ( { state | result = Failure (log "error" error) }
            , Cmd.none
            )
