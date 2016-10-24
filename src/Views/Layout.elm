module Views.Layout exposing (view)

import Reducers.Main as Main
import Reducers.State exposing (Model)
import Actions.Main exposing (Msg)
import Html exposing (..)
import Html.Attributes exposing (..)
import CDN exposing (bulma, fontAwesome)
import Views.Menu as Menu
import Views.Nav as Nav
import Views.Main as Main
import Views.Modal as Modal


-- VIEW


view : Main.Model -> Html Msg
view model =
    div []
        [ bulma.css
        , fontAwesome.css
        , layout model.state
        ]



layout : Model -> Html Msg
layout model =
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
          , Modal.view model.modal
          ]
