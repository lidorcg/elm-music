module Components.Menu exposing (Model, init, update, view)

import Actions.Main exposing (..)
import GraphQL.Playlists exposing (AllPlaylistsResult)
import List exposing (map)
import Maybe exposing (withDefault)
import Http
import Html exposing (..)
import Html.Attributes exposing (class, href, style)
import Html.Events exposing (onClick)



-- MODEL


type alias Model =
    { playlists : List Playlist
    , active : String
    }


type alias Playlist =
    { id : String
    , name : String
    }


init : Model
init =
    Model [] ""



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SearchFormSubmit ->
            ( { model | active = "" }
            , Cmd.none
            )

        SearchResponse _ ->
            ( { model | active = "" }
            , Cmd.none
            )

        DisplayPlaylist id ->
            ( { model | active = id }
            , Cmd.none
            )

        GetPlaylistsResponse result ->
            let
                playlists =
                    processAllPlaylists result
            in
                ( { model | playlists = playlists }
                , Cmd.none
                )

        _ ->
            ( model, Cmd.none )


processAllPlaylists : Result Http.Error AllPlaylistsResult -> List Playlist
processAllPlaylists result =
    case result of
        Err error ->
            []

        Ok result ->
            map processPlaylist result.allPlaylists


processPlaylist : { a | id : String, name : Maybe String } -> Playlist
processPlaylist playlist =
    let
        name =
            withDefault "UNKNOWN" playlist.name
    in
        Playlist playlist.id name



-- VIEW


view : Model -> Html Msg
view model =
    aside
        [ class "menu" ]
        [ a
            [ class "nav-item is-brand", href "#" ]
            [ h1
                [ class "title is-2 has-text-centered" ]
                [ text "My Music" ]
            ]
        , hr [ style [ ( "margin", "10px" ) ] ] []
        , p
            [ class "menu-label" ]
            [ text "My Playlists" ]
        , viewPlaylists model
        , p
            [ class "menu-label" ]
            [ text "Manage" ]
        , newPlaylistItem
        ]


viewPlaylists : Model -> Html Msg
viewPlaylists model =
    ul
        [ class "menu-list" ]
        (map (viewPlaylist model.active) model.playlists)


viewPlaylist : String -> Playlist -> Html Msg
viewPlaylist active playlist =
    playlistItem active playlist


playlistItem : String -> Playlist -> Html Msg
playlistItem active playlist =
    let
        isActive =
            isPlaylistActive active playlist.id
    in
        li
            []
            [ a
                [ class isActive, onClick (DisplayPlaylist playlist.id) ]
                [ text playlist.name ]
            ]


isPlaylistActive : String -> String -> String
isPlaylistActive active id =
    if active == id then
        "is-active"
    else
        ""


newPlaylistItem : Html Msg
newPlaylistItem =
    ul
        [ class "menu-list" ]
        [ li
            []
            [ a
                [ onClick OpenNewPlaylistModal ]
                [ text "Create New Playlist" ]
            ]
        ]
