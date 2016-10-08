module Views.Menu exposing (view)

import Html.App as App
import Html exposing (..)
import Html.Attributes exposing (class, href)
import Views.MenuItems as MenuItems
import State.Display as Display
import Utils.RemoteData exposing (..)
import State.Main as State


-- VIEW


view : State.Model -> Html State.Msg
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


viewMenuList : State.Model -> Html State.Msg
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
                App.map State.DisplayMsg <| MenuItems.view model


isDisplayingPlaylist : Display.Display -> String
isDisplayingPlaylist display =
    case display of
        Display.List id ->
            id

        _ ->
            ""
