module Track exposing (..)

import String exposing (join)
import Maybe exposing (withDefault)
import List exposing (map)
import Html exposing (..)
import Html.Events exposing (..)


-- MODEL


type alias Model =
    { name : Maybe String
    , youtubeId : Maybe String
    , artists :
        List
            { name : Maybe String
            }
    }



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
    let
        name =
            model.name |> withDefault "Unknown"

        artistsNames =
             map (.name >> withDefault "Unknown") model.artists |> join ", "
             -- TODO: figure out map and |> operator

        youtubeId =
            model.youtubeId |> withDefault "No Youtube ID"
    in
        tr []
            [ td [] [ name |> text ]
            , td [] [ artistsNames |> text ]
            , td [] [ youtubeId |> text ]
            ]
