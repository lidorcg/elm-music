module Components.Menu exposing (Model, init, update, view)

import Actions exposing (..)
import Utils.RemoteData exposing (..)
import GraphQL.Playlists exposing (PlaylistsResult)
import List exposing (map)
import Maybe exposing (withDefault)
import Html exposing (..)
import Html.Attributes exposing (class, href, style)
import Html.Events exposing (onClick)
import Components.DragAndDrop exposing (dropablePlaylist)


-- MODEL


type alias Model =
    { playlists : RemoteData (List Playlist)
    , active : String
    }


type alias Playlist =
    { id : String
    , name : String
    }


init : Model
init =
    Model NotAsked ""



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Search ->
            ( { model | active = "" }
            , Cmd.none
            )

        SearchResponseError _ ->
            ( { model | active = "" }
            , Cmd.none
            )

        SearchResponseOk _ ->
            ( { model | active = "" }
            , Cmd.none
            )

        DisplayPlaylist id ->
            ( { model | active = id }
            , Cmd.none
            )

        FetchPlaylistsResponseOk result ->
            let
                playlists =
                    processPlaylists result
            in
                ( { model | playlists = Success playlists }
                , Cmd.none
                )

        _ ->
            ( model, Cmd.none )


processPlaylists : PlaylistsResult -> List Playlist
processPlaylists result =
    map processPlaylist result.playlists


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
    case model.playlists of
        Success playlists ->
            ul
                [ class "menu-list" ]
                (map (viewPlaylist model.active) playlists)

        Loading ->
            p [] [ text "Loading your music now" ]

        _ ->
            p [] [ text "Opps, we couldn't fetch your music :(" ]


viewPlaylist : String -> Playlist -> Html Msg
viewPlaylist active playlist =
    let
        isActive =
            if active == playlist.id then
                "is-active"
            else
                ""
    in
        dropablePlaylist playlist.id <|
            li
                []
                [ a
                    [ class isActive, onClick (DisplayPlaylist playlist.id) ]
                    [ text playlist.name ]
                ]


newPlaylistItem : Html Msg
newPlaylistItem =
    ul
        [ class "menu-list" ]
        [ li
            []
            [ a
                [ onClick ShowNewPlaylistModal ]
                [ text "Create New Playlist" ]
            ]
        ]
