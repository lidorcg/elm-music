module Components.Main exposing (Model, init, update, view)

import Actions exposing (..)
import Utils.Models exposing (..)
import Utils.RemoteData exposing (..)
import GraphQL.Discover exposing (SearchResult)
import GraphQL.Playlists exposing (PlaylistsResult)
import List exposing (map, filter, head)
import Maybe exposing (withDefault)
import Debug exposing (log)
import Html exposing (..)
import Components.TrackTable as TrackTable


-- MODEL


type alias Model =
    { display : Display
    , searchResult : RemoteData (List Track)
    , playlists : RemoteData (List Playlist)
    }


type Display
    = SearchResult
    | ShowPlaylist String
    | None


init : Model
init =
    Model None NotAsked NotAsked



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Search ->
            ( { model | display = SearchResult, searchResult = Loading }
            , Cmd.none
            )

        SearchResponseError error ->
            ( { model | searchResult = Failure <| log "error" error }
            , Cmd.none
            )

        SearchResponseOk result ->
            ( { model | searchResult = Success <| processSearchResult result }
            , Cmd.none
            )

        FetchPlaylistsResponseOk result ->
            ( { model | playlists = Success <| processPlaylists result }
            , Cmd.none
            )

        DisplayPlaylist id ->
            ( { model | display = ShowPlaylist id }
            , Cmd.none
            )

        _ ->
            ( model, Cmd.none )



-- UTILS


addTrackToPlaylist track id playlist =
    if playlist.id == id then
        { playlist | tracks = (track :: playlist.tracks) }
    else
        playlist


processPlaylists : PlaylistsResult -> List Playlist
processPlaylists result =
    map remotePlaylistToPlaylist result.playlists


processSearchResult : SearchResult -> List Track
processSearchResult result =
    map remoteSearchTrackToTrack result.searchTracks



-- VIEW


view : Model -> Html Actions.Msg
view model =
    case model.display of
        ShowPlaylist id ->
            viewPlaylist id model.playlists

        SearchResult ->
            viewSearchResult model.searchResult

        None ->
            div [] []


viewPlaylist : String -> RemoteData (List Playlist) -> Html Msg
viewPlaylist id playlists =
    case playlists of
        Loading ->
            p [] [ text "We're loading your music right now..." ]

        Success playlists ->
            let
                playlist =
                    filter (\p -> p.id == id) playlists |> head
            in
                case playlist of
                    Nothing ->
                        p [] [ text "There's no playlist here, we should probably check the DB" ]

                    Just p ->
                        TrackTable.view p.tracks

        _ ->
            p [] [ text "We ran into a problem, see the log" ]


viewSearchResult : RemoteData (List Track) -> Html Msg
viewSearchResult searchResult =
    case searchResult of
        Loading ->
            p [] [ text "We're searching right now..." ]

        Success result ->
            TrackTable.view result

        _ ->
            p [] [ text "We ran into a problem, see the log" ]
