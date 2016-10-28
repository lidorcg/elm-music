module Views.Menu exposing (view)

import Reducers.State.Menu exposing (Model)
import Reducers.State.DragAndDrop exposing (dropablePlaylist)
import Actions.Main as Actions
import Html exposing (..)
import Html.Attributes exposing (class, href, style)
import Html.Events exposing (onClick)
import List exposing (map)


-- VIEW


view : Model -> Html Actions.Msg
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


viewPlaylists : Model -> Html Actions.Msg
viewPlaylists model =
    ul
        [ class "menu-list" ]
        (map (viewPlaylist model.active) model.playlists)


viewPlaylist : String -> { a | id : String, name : String } -> Html Actions.Msg
viewPlaylist active playlist =
  dropablePlaylist (playlistItem active playlist) playlist.id


playlistItem : String -> { a | id : String, name : String } -> Html Actions.Msg
playlistItem active playlist =
  let
      isActive =
          isPlaylistActive active playlist.id
  in
      li
          []
          [ a
              [ class isActive, onClick (Actions.DisplayPlaylist playlist.id) ]
              [ text playlist.name ]
          ]


isPlaylistActive : String -> String -> String
isPlaylistActive active id =
    if active == id then
        "is-active"
    else
        ""


newPlaylistItem : Html Actions.Msg
newPlaylistItem =
    ul
        [ class "menu-list" ]
        [ li
            []
            [ a
                [ onClick (Actions.DisplayNewPlaylistModal) ]
                [ text "Create New Playlist" ]
            ]
        ]
