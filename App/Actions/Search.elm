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


update : Msg -> Search.State -> ( Search.State, Cmd Msg )
update msg model =
    case msg of
        ChangeQuery input ->
            ( { model | query = input }
            , Cmd.none
            )

        SearchTracks ->
            ( { model | isLoading = Just "is-loading" }
            , searchTracks { query = model.query } |> perform FetchFail FetchSucceed
            )

        FetchSucceed result ->
            ( { model | isLoading = Nothing, results = result.searchTracks }
            , Cmd.none
            )

        FetchFail error ->
            ( { model | isLoading = Nothing, error = Maybe.Just (log "error" error) }
            , Cmd.none
            )
