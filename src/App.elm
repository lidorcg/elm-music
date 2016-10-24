module App exposing (..)

import Html.App as App
import Views.Layout as View
import Reducers.Main as State


main : Program Never
main =
    App.program
        { init = State.init
        , view = View.view
        , update = State.update
        , subscriptions = (always Sub.none)
        }
