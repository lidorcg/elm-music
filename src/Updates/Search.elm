module Updates.Search exposing (update)

import State exposing (Model)
import Actions exposing (..)
import Models exposing (..)
import Utils exposing (..)
import GraphQL.Discover exposing (search, Search)
import Task exposing (attempt)
import Debug exposing (log)
import List exposing (map)


-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SearchFormInputQuery string ->
            ( { model
                | searchForm = SearchForm string
              }
            , Cmd.none
            )

        Search ->
            ( { model
                | searchResult = Loading
                , displayMain = DisplaySearchResult
              }
            , search model.searchForm
                |> attempt SearchResponse
            )

        SearchResponse result ->
            let
                searchResult =
                    case result of
                        Ok res ->
                            Success (processSearchResult res)

                        Err err ->
                            Failure (log "error" err)
            in
                ( { model
                    | searchResult = searchResult
                    , displayMain = DisplaySearchResult
                  }
                , Cmd.none
                )

        ShowSearchResult ->
            ( { model
                | displayMain = DisplaySearchResult
              }
            , Cmd.none
            )

        _ ->
            ( model, Cmd.none )


processSearchResult : Search -> List Track
processSearchResult result =
    map remoteSearchTrackToTrack result.searchTracks
