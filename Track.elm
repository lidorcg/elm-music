module Track exposing (..)

import Html exposing (..)
import Html.Events exposing (..)
import String



-- MODEL


type alias Model =
  { name : String
  , artists : List Artist
  , youtubeId : String
  }


type alias Artist =
  { name : String }



-- TODO: get rid of the update section
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
    , td [] [text (String.join ", " (List.map .name model.artists))]
    , td [] [text model.youtubeId]
    ]
