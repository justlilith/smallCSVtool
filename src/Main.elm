{-
Okay so, this is going to allow us to drop in a group of files, and
automagically parse a CSV string for InDesign's data merge.
-}

module Main exposing (main)

import Browser
import Html exposing (Html, Attribute, div, input, text)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)



-- MAIN


main =
  Browser.sandbox { init = init, update = update, view = view }



-- MODEL


init : Model
init =
  {content = ""}

type alias Model =
  { content : String
  }


-- UPDATE


type Msg
  = Change String


update : Msg -> Model -> Model
update msg model =
  case msg of
    Change newContent ->
      { model | content = newContent }



-- VIEW


transform : String -> List (Html Msg)
transform thiscontent =
  (List.map2 (++)
    ((String.split "\n" thiscontent) -- List String
    ) -- List (String)
    ((String.split "\n" thiscontent)
      |> List.map (String.split "/") -- List (List String)
      |> List.map (List.reverse) -- List (List String)
      |> List.map (List.take 1) -- List (List String)
      |> List.concat -- List String
      )
  ) -- List String
  |> List.map text -- List (Html Msg)
  |> List.intersperse (Html.br[][])


view : Model -> Html Msg
view model =
  div []
    [
    Html.textarea
      [ placeholder "Filename with style"
      , value model.content
      , onInput Change
      , style "width" "800px"
      , style "height" "100px"]
      []
    --, div [] [ text (String.reverse model.content) ]
      ,div [style "color" "grey"] [text("Original input: ")]
      ,div [style "color" "black"] [text (model.content)]
      ,div [style "color" "grey"] [text ("Resulting CSV list: ")]
      ,div [style "color" "black"]
        (transform model.content)
    ]
