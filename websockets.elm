import Html exposing (..)
import Html.App as App
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import WebSocket

main : Program Never
main =
  App.program
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }

echoServer : String
echoServer =
  "wss://echo.websocket.org"

type alias Model =
  { input : String
  , messages : List String
  }

init : (Model, Cmd Msg)
init =
  (Model "" [], Cmd.none)

type Msg
  = Input String
  | Send
  | NewMessage String

update : Msg -> Model -> (Model, Cmd Msg)
update msg {input, messages} =
  case msg of
    Input newInput ->
      (Model newInput messages, Cmd.none)

    Send ->
      (Model "" messages, WebSocket.send echoServer input)

    NewMessage str ->
      (Model input (str :: messages), Cmd.none)

subscriptions : Model -> Sub Msg
subscriptions model =
  WebSocket.listen echoServer NewMessage

view : Model -> Html Msg
view model =
  div []
    [ div [] (List.map viewMessage (List.reverse model.messages))
    , input [onInput Input, value model.input] []
    , button [onClick Send] [text "Send"]
    ]

viewMessage : String -> Html Msg
viewMessage msg =
  div [] [ text msg ]
