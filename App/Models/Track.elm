module Models.Track exposing (Model)

-- MODEL


type alias Model =
    { name : Maybe String
    , youtubeId : Maybe String
    , artists :
        List
            { name : Maybe String
            }
    }
