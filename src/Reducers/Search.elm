module Reducers.Search exposing (..)

import Actions.Main exposing (..)
import Utils.RemoteData exposing (..)
import GraphQL.Music exposing (search, SearchResult)
import Debug exposing (log)
import Task exposing (perform)


-- MODEL


type alias Model =
    { query : String
    , result : RemoteData SearchResult
    }


init : Model
init =
    Model "" NotAsked



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ChangeQuery string ->
            ( { model | query = string }
            , Cmd.none
            )

        Search ->
            ( { model | result = Loading }
            , search { query = model.query } |> perform FetchSearchFail FetchSearchSucceed
            )

        FetchSearchFail error ->
            ( { model | result = Failure (log "error" error) }
            , Cmd.none
            )

        FetchSearchSucceed result ->
            ( { model | result = Success result }
            , Cmd.none
            )

        _ ->
            ( model, Cmd.none )
