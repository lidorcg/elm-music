module Views.Dnd exposing (view)

import State exposing (..)
import Actions exposing (..)
import Html exposing (..)
import Html.Attributes exposing (class, style)

-- VIEW


(=>) : a -> b -> ( a, b )
(=>) =
    (,)


view : Model -> Html Msg
view model =
    case model.dnd.pos of
        Nothing ->
            div [] []

        Just pos ->
            span
                [ class "icon is-large"
                , style
                    [ "position" => "absolute"
                    , "left" => px (pos.x-28)
                    , "top" => px (pos.y-28)
                    , "cursor" => "move"
                    , "pointer-events" => "none"
                    ]
                ]
                [ i [ class "fa fa-music" ] [] ]


px : Int -> String
px number =
    toString number ++ "px"
