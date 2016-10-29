module Components.DOM.Search exposing (Model, init, update, view)

import Actions exposing (..)
import Html exposing (..)
import Html.Events exposing (onSubmit, onInput)
import Html.Attributes exposing (class, type', placeholder)


-- MODEL


type alias Model =
    { query : String
    , isLoading : Bool
    }


init : Model
init =
    Model "" False



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SearchFormOnInput string ->
            ( { model | query = string }
            , Cmd.none
            )

        SearchFormOnSubmit ->
            ( { model | isLoading = True }
            , Cmd.none
            )

        SearchResponse _ ->
            ( { model | isLoading = False }
            , Cmd.none
            )

        _ ->
            ( model, Cmd.none )



-- VIEW


view : Model -> Html Msg
view model =
    let
        isLoading =
            if model.isLoading then
                "is-loading"
            else
                ""
    in
        form [ onSubmit SearchFormOnSubmit ]
            [ p [ class "nav-item control has-addons" ]
                [ input
                    [ class "input"
                    , placeholder "Find music"
                    , type' "text"
                    , onInput SearchFormOnInput
                    ]
                    []
                , button
                    [ class <| "button is-info " ++ isLoading ]
                    [ text "Search" ]
                ]
            ]
