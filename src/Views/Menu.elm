module Views.Menu exposing (view)

import State exposing (..)
import Actions exposing (..)
import Models exposing (..)
import Html exposing (..)
import Html.Attributes exposing (class, href, style)
import Html.Events exposing (onClick)


-- VIEW


view : Model -> Html Msg
view state =
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
        , viewPlaylists state
        , p
            [ class "menu-label" ]
            [ text "Manage" ]
        , newPlaylistItem
        ]


viewPlaylists : Model -> Html Msg
viewPlaylists { playlists, displayMain } =
    case playlists of
        NotAsked ->
            p [] [ text "We haven't asked for your playlists yet" ]

        Loading ->
            p [] [ text "We're fetching your playlists now" ]

        Failure err ->
            p [] [ text "We ran into an error, see the console for more info" ]

        Success res ->
            let
                active =
                    isDisplayingPlaylist displayMain
            in
                ul
                    [ class "menu-list" ]
                    (List.map (viewPlaylist active) res)


isDisplayingPlaylist : DisplayMain -> String
isDisplayingPlaylist display =
    case display of
        DisplayPlaylist id ->
            id

        _ ->
            ""


viewPlaylist : String -> Playlist -> Html Msg
viewPlaylist active playlist =
    let
        isActive =
            if active == playlist.id then
                "is-active"
            else
                ""
    in
        li
            []
            [ a
                [ class isActive, onClick (ShowPlaylist playlist.id) ]
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
                [ onClick ShowNewPlaylistModal ]
                [ text "Create New Playlist" ]
            ]
        ]
