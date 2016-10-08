module Views.MenuItems exposing (view, Model)

import Html exposing (..)
import Html.Attributes exposing (class, href)
import Html.Events exposing (onClick)
import List exposing (map)
import Maybe exposing (withDefault)
import State.Display as Display


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


view : Model -> Html Display.Msg
view model =
    ul
        [ class "menu-list" ]
        (viewItems model)


viewItems : Model -> List (Html Display.Msg)
viewItems model =
    map (viewItem model.active) model.playlists


viewItem : String -> Playlist -> Html Display.Msg
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
                [ class isActive, onClick (Display.ShowList playlist.id) ]
                [ text name ]
            ]


isPlaylistActive : String -> String -> String
isPlaylistActive active id =
    if active == id then
        "is-active"
    else
        ""
