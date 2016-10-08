module State.Search exposing (..)

import Utils.RemoteData exposing (..)
import GraphQL.Music exposing (search, SearchResult)
import Debug exposing (log)
import Http exposing (Error)
import Task exposing (perform)


-- MODEL


type alias Model =
    { query : String
    , result : WebData SearchResult }


init : Model
init =
    Model "" NotAsked



-- UPDATE


type Msg
    = Input String
    | FetchData
    | FetchSucceed SearchResult
    | FetchFail Http.Error


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Input string ->
            ( { model | query = string }
            , Cmd.none
            )

        FetchData ->
            ( { model | result = Loading }
            , search { query = model.query } |> perform FetchFail FetchSucceed
            )

        FetchSucceed result ->
            ( { model | result = Success result }
            , Cmd.none
            )

        FetchFail error ->
            ( { model | result = Failure (log "error" error) }
            , Cmd.none
            )
