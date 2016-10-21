module Reducers.Search exposing (..)

import Actions.Main exposing (..)
import Utils.RemoteData exposing (..)
import GraphQL.Discover exposing (search, SearchResult)
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
        SearchFormInputQuery string ->
            ( { model | query = string }
            , Cmd.none
            )

        SearchFormSubmit ->
            ( { model | result = Loading }
            , search { query = model.query }
                |> perform FetchSearchResultFail FetchSearchResultSucceed
            )

        FetchSearchResultFail error ->
            ( { model | result = Failure (log "error" error) }
            , Cmd.none
            )

        FetchSearchResultSucceed result ->
            ( { model | result = Success result }
            , Cmd.none
            )

        _ ->
            ( model, Cmd.none )
