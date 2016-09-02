module Track exposing ( Model, view, Msg )

import Html exposing (..)
import Html.Events exposing (..)



-- MODEL


type alias Model =
  { name : String
  , duration : String
  , youtubeId : String
  }



-- UPDATE


type Msg
  = None


update : Msg -> Model -> Model
update msg model =
  case msg of
    None ->
      model



-- VIEW


view : Model -> Html Msg
view model =
  tr []
    [ td [] [text model.name]
    , td [] [text model.duration]
    , td [] [text model.youtubeId]
    ]
