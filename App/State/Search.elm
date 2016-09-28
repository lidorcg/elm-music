module State.Search exposing (..)

import Models.Track as Track
import Debug exposing (log)
import Http exposing (Error)
import Task exposing (perform)
import GraphQL.Music exposing (searchTracks, SearchTracksResult)


-- MODEL


type alias State =
    { query : String
    , isLoading : Maybe String
    , results : List Track.Model
    , error : Maybe Http.Error
    }


init : State
init =
    State "" Nothing [] Nothing



-- UPDATE


type Msg
    = ChangeQuery String
    | SearchTracks
    | FetchSucceed SearchTracksResult
    | FetchFail Http.Error


update : Msg -> State -> ( State, Cmd Msg )
update msg state =
    case msg of
        ChangeQuery input ->
            ( { state | query = input }
            , Cmd.none
            )

        SearchTracks ->
            ( { state | isLoading = Just "is-loading" }
            , searchTracks { query = state.query } |> perform FetchFail FetchSucceed
            )

        FetchSucceed result ->
            ( { state | isLoading = Nothing, results = result.searchTracks }
            , Cmd.none
            )

        FetchFail error ->
            ( { state | isLoading = Nothing, error = Maybe.Just (log "error" error) }
            , Cmd.none
            )
