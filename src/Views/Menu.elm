module Views.Menu exposing (view)

import State exposing (..)
import Actions exposing (..)
import Models exposing (..)
import Utils exposing (RemoteData(..))
import Html exposing (..)
import Html.Attributes exposing (id, class, href, style, placeholder, type', value, autofocus)
import Html.Events exposing (onClick, onSubmit, onInput, onBlur)


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
        , playlistOps state
        ]


viewPlaylists : Model -> Html Msg
viewPlaylists state =
    case state.playlists of
        NotAsked ->
            p [] [ text "We haven't asked for your playlists yet" ]

        Loading ->
            p [] [ text "We're fetching your playlists now" ]

        Failure err ->
            p [] [ text "We ran into an error, see the console for more info" ]

        Success res ->
            let
                active =
                    isDisplayingPlaylist state.displayMain
            in
                ul
                    [ class "menu-list" ]
                    ((List.map (viewPlaylist active state) res)
                    ++ (viewNewPlaylistForm state))


isDisplayingPlaylist : MainDisplay -> String
isDisplayingPlaylist displayMain =
    case displayMain of
        DisplayPlaylist playlist ->
            playlist.id

        _ ->
            ""


viewPlaylist : String -> Model -> Playlist -> Html Msg
viewPlaylist active state playlist =
    if active == playlist.id then
        viewActivePlaylist state playlist
    else
        li
            []
            [ a
                [ onClick (ShowPlaylist playlist) ]
                [ text playlist.name ]
            ]


viewActivePlaylist : Model -> Playlist -> Html Msg
viewActivePlaylist { displayForm, renamePlaylistForm } playlist =
    case displayForm of
        DisplayRenamePlaylistForm ->
            li [] [ viewRenameForm renamePlaylistForm ]

        _ ->
            li
                []
                [ a
                    [ class "is-active", onClick ShowRenamePlaylistForm ]
                    [ text playlist.name ]
                ]


viewRenameForm : RenamePlaylistForm -> Html Msg
viewRenameForm renamePlaylistForm =
    form
        [ onSubmit RenamePlaylist ]
        [ p
            [ class "control" ]
            [ input
                [ id "rename-playlist-form"
                , class "input"
                , placeholder "Rename Playlist"
                , type' "text"
                , value renamePlaylistForm.name
                , autofocus True
                , onInput RenamePlaylistFormInput
                , onBlur HideForm
                ]
                []
            ]
        ]


viewNewPlaylistForm : Model -> List (Html Msg)
viewNewPlaylistForm { displayForm } =
    case displayForm of
        DisplayNewPlaylistForm ->
            [ li []
                [ form
                    [ onSubmit CreateNewPlaylist ]
                    [ input
                        [ id "new-playlist-form"
                        , class "input"
                        , placeholder "New Playlist Name"
                        , type' "text"
                        , autofocus True
                        , onInput NewPlaylistFormInputName
                        , onBlur HideForm
                        ]
                        []
                    ]
                ]
            ]

        _ ->
          []


playlistOps : Model -> Html Msg
playlistOps { displayMain } =
    let
        operations =
            case displayMain of
                DisplayPlaylist playlist ->
                    [ li
                        []
                        [ a
                            [ onClick ShowDeletePlaylistForm ]
                            [ text "Delete Playlist" ]
                        ]
                    ]

                _ ->
                    []
    in
        ul
            [ class "menu-list" ]
            ([ li
                []
                [ a
                    [ onClick ShowNewPlaylistForm ]
                    [ text "Create New Playlist" ]
                ]
             ]
                ++ operations
            )
