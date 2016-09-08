module Main exposing (..)

import Debug exposing (log)
import Html.App as App
import Html exposing (..)
import Html.Events exposing (..)
import Html.Attributes exposing (type', placeholder)
import Http exposing (Error)
import Task exposing (perform)
import TrackList
import GraphQL.Music exposing (searchTracks, SearchTracksResult)


main =
    App.program
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }



-- MODEL
-- TODO: add loading state


type alias Model =
    { query : String
    , result : TrackList.Model
    , error : Maybe Http.Error
    }


init =
    ( Model "" TrackList.init Nothing
    , Cmd.none
    )



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
            ( { model | query = input }, Cmd.none )

        SearchTracks ->
            ( model, searchTracks { query = model.query } |> perform FetchFail FetchSucceed )

        FetchSucceed result ->
            ( { model | result = result.searchTracks }, Cmd.none )

        FetchFail error ->
            ( { model | error = Maybe.Just (log "error" error) }, Cmd.none )

        TrackListMsg _ ->
            ( model, Cmd.none )



-- VIEW


view : Model -> Html Msg
view model =
    let
        tracks =
            viewTracks model.result
    in
        div []
            [ form [ onSubmit SearchTracks ]
                [ input [ type' "text", placeholder "Search for Music...", onInput ChangeQuery ] []
                , button [] [ text "Search!" ]
                ]
            , tracks
            ]


viewTracks : TrackList.Model -> Html Msg
viewTracks tracks =
    App.map TrackListMsg (TrackList.view tracks)
