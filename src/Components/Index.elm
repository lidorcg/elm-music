module Components.Index exposing (Model, init, update, subscriptions, view)

import Actions exposing (..)
import GraphQL.Playlists exposing (playlists)
import Task exposing (perform)
import CDN exposing (bulma, fontAwesome)
import Html exposing (..)
import Components.Layout as Layout
import Components.DragAndDrop as Dnd


-- MODEL


type alias Model =
    { layout : Layout.Model
    , dnd : Dnd.Model
    }


init : ( Model, Cmd Msg )
init =
    ( Model Layout.init Dnd.init
    , playlists |> perform FetchPlaylistsResponseError FetchPlaylistsResponseOk
    )



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    let
        ( layout, layoutCmd ) =
            Layout.update msg model.layout

        ( dnd, dndCmd ) =
            Dnd.update msg model.dnd
    in
        ( { model | layout = layout, dnd = dnd }
        , Cmd.batch [ layoutCmd, dndCmd ]
        )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Dnd.subscriptions model.dnd



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ bulma.css
        , fontAwesome.css
        , Layout.view model.layout
        , Dnd.view model.dnd
        ]
