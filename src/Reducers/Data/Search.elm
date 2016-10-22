module Reducers.Data.Search exposing (..)

import Actions.Main exposing (..)
import Utils.RemoteData exposing (..)
import Utils.SendMsg exposing (sendMsg)
import GraphQL.Discover exposing (SearchResult, search)
import Task exposing (perform, Task)
import Debug exposing (log)


-- MODEL


type alias Model =
    RemoteData SearchResult


init : Model
init =
    NotAsked



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SearchRequest query ->
            ( Loading
            , search { query = query }
                |> perform SearchRequestError SearchRequestOk
            )

        SearchRequestError error ->
            ( Failure (log "error" error)
            , sendMsg (SearchResponse (Err error))
            )

        SearchRequestOk result ->
            ( Success result
            , sendMsg (SearchResponse (Ok result))
            )

        _ ->
            ( model, Cmd.none )
