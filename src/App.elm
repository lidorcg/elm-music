module App exposing (..)

import Html.App as App
import Components.Layout as Main


main : Program Never
main =
    App.program
        { init = Main.init
        , update = Main.update
        , view = Main.view
        , subscriptions = (always Sub.none)
        }
