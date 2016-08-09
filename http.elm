import Html exposing (..)
import Html.App as App
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Task
import Json.Decode as Json

main : Program Never
main =
  App.program
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }


type alias Model =
  { topic : String
  , gifUrl : String
  , errorMessage : String
  }

init : (Model, Cmd Msg)
init =
  (Model "cats" "waiting.gif" "", Cmd.none)

type Msg
  = MorePlease
  | FetchSuccess String
  | FetchFail Http.Error

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    MorePlease ->
      (model, getRandomGif model.topic)

    FetchSuccess newUrl ->
      ({ model | gifUrl = newUrl, errorMessage = "" }, Cmd.none)

    FetchFail Http.Timeout ->
      ({ model | errorMessage = "Timeout" }, Cmd.none)

    FetchFail Http.NetworkError ->
      ({ model | errorMessage = "NetworkError" }, Cmd.none)

    FetchFail (Http.UnexpectedPayload message) ->
      ({ model | errorMessage = message }, Cmd.none)

    FetchFail (Http.BadResponse code message) ->
      ({ model | errorMessage = (toString code) ++ message }, Cmd.none)


view : Model -> Html Msg
view model =
  div []
    [ h2 [] [ text model.topic ]
    , img [src model.gifUrl] []
    , button [ onClick MorePlease ] [ text "More please!" ]
    , span [] [ text model.errorMessage ]
    ]

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none

getRandomGif : String -> Cmd Msg
getRandomGif topic =
  let
    url = "https://api.giphy.com/v1/gifs/random?api_key=dc6zaTOxFJmzC&tag=" ++ topic
  in
    Task.perform FetchFail FetchSuccess (Http.get decodeGifUrl url)

decodeGifUrl : Json.Decoder String
decodeGifUrl =
  Json.at ["data", "image_url"] Json.string
