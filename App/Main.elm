module Main exposing (..)

import Html.App as App
import Views.Main as View
import Stores.Main as State


main : Program Never
main =
    App.program
        { init = State.init
        , view = View.view
        , update = State.update
        , subscriptions = (always Sub.none)
        }
