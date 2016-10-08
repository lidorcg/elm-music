module Views.Menu exposing (view)

import Stores.Main as State
import Actions.Main as Actions
import Html exposing (..)
import Html.Attributes exposing (class, href)
import Utils.RemoteData exposing (..)
import Stores.Display as Display
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
        , viewMenuList state
        ]


viewMenuList : State.Model -> Html Actions.Msg
viewMenuList state =
    case state.playlists of
        NotAsked ->
            p [] [ text "We couldn't even send the request to the server" ]

        Loading ->
            p [] [ text "We're fetching your playlists now" ]

        Failure err ->
            p [] [ text "There's seems to be a problem" ]

        Success playlists ->
            let
                active =
                    isDisplayingPlaylist state.display

                model =
                    MenuItems.Model active playlists.playlists
            in
                MenuItems.view model


isDisplayingPlaylist : Display.Display -> String
isDisplayingPlaylist display =
    case display of
        Display.List id ->
            id

        _ ->
            ""
