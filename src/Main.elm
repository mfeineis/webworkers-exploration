port module Main exposing (main, reactor)

import Html exposing (Html)
import Json.Decode as Decode exposing (Decoder, Value)
import Shared exposing (Model, Msg(..))


port toElm : (Value -> msg) -> Sub msg


port fromElm : Value -> Cmd msg


type alias Flags =
    {}


defaultFlags : Flags
defaultFlags =
    {}


main : Program Flags Model Msg
main =
    Html.programWithFlags
        { init = init
        , subscriptions = subscriptions
        , update = update
        , view = view
        }


reactor : Program Never Model Msg
reactor =
    Html.program
        { init = init defaultFlags
        , subscriptions = subscriptions
        , update = update
        , view = view
        }


init : Flags -> ( Model, Cmd Msg )
init flags =
    ( {}, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ toElm Incoming
        ]


decodeIncoming : Decoder Msg
decodeIncoming =
    let
        decode type_ =
            case type_ of
                "WORKER_SETUP_COMPLETED" ->
                    Decode.succeed WorkerSetupCompleted

                _ ->
                    Decode.succeed Unknown
    in
    Decode.field "type" Decode.string
        |> Decode.andThen decode


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    Debug.log ("Elm.Main => " ++ toString msg) <|
        case msg of
            Incoming value ->
                case Decode.decodeValue decodeIncoming value of
                    Ok decodedMsg ->
                        Debug.log ("decoded " ++ toString decodedMsg)
                            (update decodedMsg model)

                    Err reason ->
                        Debug.log ("error" ++ reason)
                            ( model, Cmd.none )

            Unknown ->
                Debug.log (toString msg)
                    ( model, Cmd.none )

            WorkerSetupCompleted ->
                Debug.log (toString msg)
                    ( model, Cmd.none )


view : Model -> Html Msg
view model =
    Html.text "Hello World!"
