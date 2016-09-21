module Models.Search exposing (Model, init)

import Http exposing (Error)
import Models.Track as Track


-- MODEL


type alias Model =
    { query : String
    , loading : Maybe String
    , result : List Track.Model
    , error : Maybe Http.Error
    }


init =
    Model "" Nothing [] Nothing
