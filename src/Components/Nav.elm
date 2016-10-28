module Components.Nav exposing (Model, init, update, view)

import Actions.Main exposing (..)
import Html exposing (..)
import Html.Attributes exposing (class)
import Components.Search as Search


-- MODEL


type alias Model =
    { search : Search.Model
    }


init : Model
init =
    Model Search.init



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    let
        ( search, searchCmd ) =
            Search.update msg model.search
    in
        ( { model | search = search }
        , Cmd.batch [ searchCmd ]
        )



-- VIEW


view : Model -> Html Msg
view model =
    nav [ class "nav" ]
        [ div [ class "nav-left" ]
            [ Search.view model.search ]
        ]
