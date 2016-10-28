module Components.UI.Index exposing (Model, init, update, view)

import Actions exposing (..)
import Html exposing (..)
import CDN exposing (bulma, fontAwesome)
import Components.UI.Layout as Layout


-- MODEL


type alias Model =
    { layout : Layout.Model
    }


init : ( Model, Cmd Msg )
init =
    ( Model Layout.init, Cmd.none )



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
