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


init =
    State "" Nothing [] Nothing



-- UPDATE


type Msg
    = ChangeQuery String
    | SearchTracks
    | FetchSucceed SearchTracksResult
    | FetchFail Http.Error


update : Msg -> State -> ( State, Cmd Msg )
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
