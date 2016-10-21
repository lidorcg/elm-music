module Views.Menu exposing (view)

import Reducers.Main as State
import Actions.Main as Actions
import Html exposing (..)
import Html.Attributes exposing (class, href, style)
import Html.Events exposing (onClick)
import Utils.RemoteData exposing (..)
import Reducers.Display as Display
import Views.MenuItems as MenuItems


-- VIEW


view : State.Model -> Html Actions.Msg
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
        , viewMenuList state
        , p
            [ class "menu-label" ]
            [ text "Manage" ]
        , newPlaylistItem
        ]


viewMenuList : State.Model -> Html Actions.Msg
viewMenuList state =
    case state.playlists.allPlaylistsRequest of
        NotAsked ->
            p [] [ text "We haven't asked for your playlists yet" ]

        Loading ->
            p [] [ text "We're fetching your playlists now" ]

        Failure err ->
            p [] [ text "We ran into an error, see the console for more info" ]

        Success playlists ->
            let
                active =
                    isDisplayingPlaylist state.display.main

                model =
                    MenuItems.Model active playlists.allPlaylists
            in
                MenuItems.view model


isDisplayingPlaylist : Display.DisplayMain -> String
isDisplayingPlaylist display =
    case display of
        Display.Playlist id ->
            id

        _ ->
            ""


newPlaylistItem : Html Actions.Msg
newPlaylistItem =
    ul
        [ class "menu-list" ]
        [ li
            []
            [ a
                [ onClick (Actions.DisplayNewPlaylistForm) ]
                [ text "Create New Playlist" ]
            ]
        ]
