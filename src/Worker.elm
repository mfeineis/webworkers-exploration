port module Worker exposing (main, reactor)

import Json.Decode exposing (Value)
import Shared exposing (Model, Msg(..))


port toWorker : (Value -> msg) -> Sub msg


port fromWorker : Value -> Cmd msg


type alias Flags =
    {}


defaultFlags : Flags
defaultFlags =
    {}


main : Program Flags Model Msg
main =
    Platform.programWithFlags
        { init = init
        , subscriptions = subscriptions
        , update = update
        }


reactor : Program Never Model Msg
reactor =
    Platform.program
        { init = init defaultFlags
        , subscriptions = subscriptions
        , update = update
        }


init : Flags -> ( Model, Cmd Msg )
init flags =
    ( {}, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ toWorker Incoming
        ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    Debug.log ("Elm.Worker => " ++ toString msg) <|
        case msg of
            Incoming value ->
                ( model, fromWorker value )

            _ ->
                ( model, Cmd.none )
