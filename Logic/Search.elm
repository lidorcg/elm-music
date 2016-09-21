module Logic.Search exposing (..)

import Debug exposing (log)
import Http exposing (Error)
import Task exposing (perform)
import TrackList
import GraphQL.Music exposing (searchTracks, SearchTracksResult)


-- MODEL


type alias Model =
    { query : String
    , loading : Maybe String
    , result : TrackList.Model
    , error : Maybe Http.Error
    }


init =
    Model "" Nothing TrackList.init Nothing


-- UPDATE


type Msg
    = ChangeQuery String
    | SearchTracks
    | FetchSucceed SearchTracksResult
    | FetchFail Http.Error
    | TrackListMsg TrackList.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
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

        TrackListMsg _ ->
            ( model
            , Cmd.none
            )
