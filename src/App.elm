module App exposing (..)

import Html.App as App
import Components.Index as Index


main : Program Never
main =
    App.program
        { init = Index.init
        , update = Index.update
        , view = Index.view
        , subscriptions = Index.subscriptions
        }
