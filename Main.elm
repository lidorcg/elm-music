module Main exposing (..)

import Debug exposing (log)
import Maybe exposing (withDefault)
import Html.App as App
import Html exposing (..)
import Html.Events exposing (..)
import Html.Attributes exposing (class, type', placeholder)
import Http exposing (Error)
import CDN exposing (bulma, fontAwesome)
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
    , loading : Maybe String
    , result : TrackList.Model
    , error : Maybe Http.Error
    }


init =
    ( Model "" Nothing TrackList.init Nothing
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
            ( { model | query = input }
            , Cmd.none )

        SearchTracks ->
            ( { model | loading = Just "is-loading" }
            , searchTracks { query = model.query } |> perform FetchFail FetchSucceed )

        FetchSucceed result ->
            ( { model | loading = Nothing, result = result.searchTracks }
            , Cmd.none )

        FetchFail error ->
            ( { model | loading = Nothing, error = Maybe.Just (log "error" error) }
            , Cmd.none )

        TrackListMsg _ ->
            ( model
            , Cmd.none )



-- VIEW


view : Model -> Html Msg
view model =
    let
        tracks =
            viewTracks model.result
    in
        div []
            [ bulma.css
            , fontAwesome.css
            , viewSearchForm model
            , tracks
            ]


viewSearchForm : Model -> Html Msg
viewSearchForm model =
  let
    isLoading =
      model.loading |> withDefault ""
  in
    form [ onSubmit SearchTracks ]
        [ p [ class "control has-addons" ]
            [ input
                [ class "input", placeholder "Find music", type' "text", onInput ChangeQuery ]
                []
            , button [ class <| "button is-info " ++ isLoading ]
                [ text "Search" ]
            ]
        ]


viewTracks : TrackList.Model -> Html Msg
viewTracks tracks =
    App.map TrackListMsg (TrackList.view tracks)
