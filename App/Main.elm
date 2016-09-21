module Main exposing (..)

import Html.App as App
import Views.Main as View
import Models.Main as State
import Actions.Main as Actions


main : Program Never
main =
    App.program
        { init = State.init
        , view = View.view
        , update = Actions.update
        , subscriptions = \_ -> Sub.none
        }
