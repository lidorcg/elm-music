module Components.Index exposing (Model, init, update, view)

import Actions exposing (..)
import Components.Layout as Layout
import GraphQL.Playlists exposing (playlists)
import Task exposing (perform)
import CDN exposing (bulma, fontAwesome)
import Html exposing (..)


-- MODEL


type alias Model =
    { layout : Layout.Model
    }


init : ( Model, Cmd Msg )
init =
    ( Model Layout.init
    , playlists |> perform FetchPlaylistsResponseError FetchPlaylistsResponseOk
    )



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    let
        ( layout, layoutCmd ) =
            Layout.update msg model.layout
    in
        ( { model | layout = layout }
        , Cmd.batch [ layoutCmd ]
        )



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ bulma.css
        , fontAwesome.css
        , Layout.view model.layout
        ]
