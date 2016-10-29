module Components.Layout exposing (Model, init, update, view)

import Actions exposing (..)
import Html exposing (..)
import Html.Attributes exposing (class)
import Components.Nav as Nav
import Components.Menu as Menu
import Components.Main as Main
import Components.Modals as Modals


-- MODEL


type alias Model =
    { nav : Nav.Model
    , menu : Menu.Model
    , main : Main.Model
    , modals : Modals.Model
    }


init : Model
init =
    Model Nav.init Menu.init Main.init Modals.init



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    let
        ( nav, navCmd ) =
            Nav.update msg model.nav

        ( menu, menuCmd ) =
            Menu.update msg model.menu

        ( main, mainCmd ) =
            Main.update msg model.main

        ( modals, modalsCmd ) =
            Modals.update msg model.modals
    in
        ( { model
            | nav = nav
            , menu = menu
            , main = main
            , modals = modals
          }
        , Cmd.batch [ navCmd, menuCmd, mainCmd, modalsCmd ]
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
                , Main.view model.main
                ]
            ]
        , Modals.view model.modals
        ]
