module Main exposing (..)

import Html.App
import Layout
import State
import Actions


main : Program Never
main =
    Html.App.program
        { init = State.init
        , view = Layout.view
        , update = Actions.update
        , subscriptions = \_ -> Sub.none
        }
