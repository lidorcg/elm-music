module Views.Menu exposing (view)

import Reducers.Main as State
import Actions.Main as Actions
import Html exposing (..)
import Html.Attributes exposing (class, href, style)
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
                [ text "Music" ]
            ]
        , hr [ style [ ( "margin", "10px" ) ] ] []
        , viewMenuList state
        ]


viewMenuList : State.Model -> Html Actions.Msg
viewMenuList state =
    case state.playlists of
        NotAsked ->
            p [] [ text "We haven't asked for your playlists yet" ]

        Loading ->
            p [] [ text "We're fetching your playlists now" ]

        Failure err ->
            p [] [ text "We ran into an error, see the console for more info" ]

        Success playlists ->
            let
                active =
                    isDisplayingPlaylist state.display

                model =
                    MenuItems.Model active playlists.allPlaylists
            in
                MenuItems.view model


isDisplayingPlaylist : Display.Display -> String
isDisplayingPlaylist display =
    case display of
        Display.Playlist id ->
            id

        _ ->
            ""
