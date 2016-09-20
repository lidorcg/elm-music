module Layout exposing (Model, init, Msg, update, view)

import Html.App as App
import Html exposing (..)
import Html.Events exposing (..)
import Html.Attributes exposing (class)
import CDN exposing (bulma, fontAwesome)
import Search


-- MODEL


type alias Model =
    { searchState : Search.Model }


init =
    ( Model Search.init
    , Cmd.none
    )



-- UPDATE


type Msg
    = SearchMsg Search.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SearchMsg searchMsg ->
            let
                ( updatedSearchModel, searchCmd ) =
                    Search.update searchMsg model.searchState
            in
                ( { model | searchState = updatedSearchModel }
                , Cmd.map SearchMsg searchCmd
                )



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ bulma.css
        , fontAwesome.css
        , viewSearch model.searchState
        ]


viewSearch : Search.Model -> Html Msg
viewSearch searchModel =
    App.map SearchMsg <| Search.view searchModel
