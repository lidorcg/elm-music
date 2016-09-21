module Models.Search exposing (State, init)

import Http exposing (Error)
import Models.Track as Track


-- MODEL


type alias State =
    { query : String
    , isLoading : Maybe String
    , results : List Track.Model
    , error : Maybe Http.Error
    }


init =
    State "" Nothing [] Nothing
