module Views.MenuItems exposing (view, Model)

import Actions.Main as Actions
import Html exposing (..)
import Html.Attributes exposing (class, href)
import Html.Events exposing (onClick)
import List exposing (map)
import Maybe exposing (withDefault)


-- MODEL


type alias Model =
    { active : String
    , playlists : List Playlist
    }


type alias Playlist =
    { id : String
    , name : Maybe String
    , tracks :
        List
            { name : Maybe String
            , artists : Maybe String
            , duration : Maybe String
            , youtubeId : Maybe String
            }
    }



-- VIEW


view : Model -> Html Actions.Msg
view model =
    ul
        [ class "menu-list" ]
        (viewItems model)


viewItems : Model -> List (Html Actions.Msg)
viewItems model =
    map (viewItem model.active) model.playlists


viewItem : String -> Playlist -> Html Actions.Msg
viewItem active playlist =
    let
        isActive =
            isPlaylistActive active playlist.id

        name =
            playlist.name |> withDefault "Unknown Playlist"
    in
        li
            []
            [ a
                [ class isActive, onClick (Actions.ShowPlaylist playlist.id) ]
                [ text name ]
            ]


isPlaylistActive : String -> String -> String
isPlaylistActive active id =
    if active == id then
        "is-active"
    else
        ""
