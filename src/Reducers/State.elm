module Reducers.State exposing (..)

import Actions.Main exposing (..)
import Reducers.State.Nav as Nav
import Reducers.State.Menu as Menu
import Reducers.State.Main as Main
import Reducers.State.Modal as Modal


-- MODEL


type alias Model =
    { nav : Nav.Model
    , menu : Menu.Model
    , main : Main.Model
    , modal : Modal.Model
    }


init : Model
init =
    Model
        Nav.init
        Menu.init
        Main.init
        Modal.init



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

        ( modal, modalCmd ) =
            Modal.update msg model.modal
    in
        ( { model
            | nav = nav
            , menu = menu
            , main = main
            , modal = modal
          }
        , Cmd.batch
            [ navCmd
            , menuCmd
            , mainCmd
            , modalCmd
            ]
        )
