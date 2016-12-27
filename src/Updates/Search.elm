module Updates.Search exposing (update)

import State exposing (Model)
import Actions exposing (..)
import Models
    exposing
        ( SearchForm
        , MainDisplay(DisplaySearchResult)
        , remoteSearchTrackToTrack
        , Track
        )
import Utils exposing (RemoteData(..))
import GraphQL.Discover exposing (search, Search)
import Task exposing (perform)
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
                |> perform SearchFail SearchSucceed
            )

        SearchFail error ->
            ( { model
                | searchResult = Failure (log "error" error)
              }
            , Cmd.none
            )

        SearchSucceed result ->
            ( { model
                | searchResult =
                    Success <|
                        processSearchResult result
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
