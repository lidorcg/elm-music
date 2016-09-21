module Actions.Search exposing (..)

import Debug exposing (log)
import Http exposing (Error)
import Task exposing (perform)
import GraphQL.Music exposing (searchTracks, SearchTracksResult)
import Models.Search as Search

-- UPDATE


type Msg
    = ChangeQuery String
    | SearchTracks
    | FetchSucceed SearchTracksResult
    | FetchFail Http.Error


update : Msg -> Search.Model -> ( Search.Model, Cmd Msg )
update msg model =
    case msg of
        ChangeQuery input ->
            ( { model | query = input }
            , Cmd.none
            )

        SearchTracks ->
            ( { model | loading = Just "is-loading" }
            , searchTracks { query = model.query } |> perform FetchFail FetchSucceed
            )

        FetchSucceed result ->
            ( { model | loading = Nothing, result = result.searchTracks }
            , Cmd.none
            )

        FetchFail error ->
            ( { model | loading = Nothing, error = Maybe.Just (log "error" error) }
            , Cmd.none
            )
