module Components.UI.Layout exposing (Model, init, update, view)

import Actions exposing (Msg)
import Html exposing (..)
import Html.Attributes exposing (class)
import Components.UI.Nav as Nav
import Components.UI.Menu as Menu
import Components.UI.Modals as Modals


-- MODEL


type alias Model =
    { nav : Nav.Model
    , menu : Menu.Model
    , modals : Modals.Model
    }


init : Model
init =
    Model Nav.init Menu.init Modals.init



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    let
        ( nav, navCmd ) =
            Nav.update msg model.nav

        ( menu, menuCmd ) =
            Menu.update msg model.menu

        ( modals, modalsCmd ) =
            Modals.update msg model.modals
    in
        ( { model
            | nav = nav
            , menu = menu
            , modals = modals
          }
        , Cmd.batch
            [ navCmd
            , menuCmd
            , modalsCmd
            ]
        )



-- VIEW


view : Model -> Html Msg
view model =
    div
        [ class "columns is-gapless" ]
        [ div
            [ class "column is-2" ]
            [ div
                [ class "container is-fluid is-marginless" ]
                [ Menu.view model.menu ]
            ]
        , div
            [ class "column" ]
            [ div
                [ class "container is-fluid is-marginless" ]
                [ Nav.view model.nav
                  --, Main.view model.main
                ]
            ]
        , Modals.view model.modals
        ]
