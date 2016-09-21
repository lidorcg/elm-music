module Views.SearchResult exposing (view)

import Views.TrackList as TrackList


-- VIEW


view searchModel =
    TrackList.view searchModel.result
