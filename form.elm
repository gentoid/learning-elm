import Html exposing (..)
import Html.App as Html
import Html.Attributes exposing (..)
import Html.Events exposing (onInput, onClick)
import String
import Regex exposing (contains, regex)

main: Program Never
main =
  Html.beginnerProgram { model = model, view = view, update = update }

type alias Model =
  { name: String
  , password: String
  , passwordAgain: String
  , age: String
  , check: Bool
  }

model: Model
model =
  Model "" "" "" "" False

type Msg
  = Name String
  | Password String
  | PasswordAgain String
  | Age String
  | Submit

update: Msg -> Model -> Model
update msg model =
  let model = { model | check = False }
  in
  case msg of
    Name name ->
      { model | name = name }

    Password password ->
      { model | password = password }

    PasswordAgain password ->
      { model | passwordAgain = password }

    Age age ->
      { model | age = age }

    Submit ->
      { model | check = True }

view: Model -> Html Msg
view model =
  div []
    [ input [ type' "text", placeholder "Name", onInput Name ] []
    , input [ type' "password", placeholder "Password", onInput Password ] []
    , input [ type' "password", placeholder "Re-enter password", onInput PasswordAgain ] []
    , input [ type' "text", placeholder "Age", onInput Age ] []
    , viewValidation model
    , button [ onClick Submit ] [ text "Submit" ]
    ]

viewValidation: Model -> Html Msg
viewValidation model =
  let
    longEnough = String.length model.password >= 8
    allChars =
          contains (regex "\\d+")  model.password
      &&  contains (regex "[a-z]") model.password
      &&  contains (regex "[A-Z]") model.password
    integerAge = contains (regex "^\\d+$")  model.age
    (color, message) =
      if not model.check then
        ("green", "Just click 'Submit' once you're ready")
      else
      if not integerAge then
        ("red", "Age nust be an integer")
      else
      if not allChars then
        ("red", "Password must contain digits, upper and lower case chars")
      else
      if not longEnough then
        ("red", "Password's too short!")
      else
      if model.password == model.passwordAgain then
        ("green", "OK")
      else
        ("red", "Passwords do not match!")
  in
    div [ style [("color", color)] ] [ text message ]
