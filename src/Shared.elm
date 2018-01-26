module Shared exposing (Model, Msg(..))

import Json.Decode exposing (Value)


type alias Model =
    {}


type Msg
    = Incoming Value
    | WorkerSetupCompleted
    | Unknown
