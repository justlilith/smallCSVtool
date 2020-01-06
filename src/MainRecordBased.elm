{-
   Okay so, this is going to allow us to drop in a group of files, and
   automagically parse a CSV string for InDesign's data merge.
-}


module MainRecordBased exposing (main)

import Browser
import File.Download as Download
import Html exposing (Attribute, Html, br, button, div, input, text)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)
import Html.Events.Extra.Drag as Drag



-- MAIN


main =
    Browser.document
        { init = init
        , subscriptions = subscriptions
        , update = update
        , view = view
        }



-- MODEL


init : () -> ( Model, Cmd Msg )
init none =
    ( { content = ""
      , outputCSV = []
      }
    , Cmd.none
    )


type alias Model =
    { content : String
    , outputCSV : List StyleRecord
    }


type alias StyleRecord =
    { fileURI : String
    , styleName : String
    , colorway : String
    , extension : String
    }


type alias Document msg =
    { title : String
    , body : List (Html msg)
    }



-- UPDATE


type Msg
    = Change String
    | Download String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Change newContent ->
            ( { model | content = newContent }
            , Cmd.none
            )

        Download aFile ->
            ( model
            , styleRecordListToCSV ("@Path, Style, Color," ++ "\n" ++ downloadCSV model.content)
            )



-- VIEW
{-
   stringToStyleRecord : String -> List StyleRecord
   stringToStyleRecord enteredContent =
       let
           tempList : List String
           tempList =
               String.split "\n" enteredContent
       in
       { fileURI = tempList
       , styleName = tempList
       , colorway = tempList
       , extension = tempList
       }
-}
{--
  (List.map2 (++)
    ((String.split "\n" enteredContent) -- List String
    ) -- List (String)
    ((String.split "\n" enteredContent)
      |> List.map (String.split "/") -- List (List String)
      |> List.map (List.reverse) -- List (List String)
      |> List.map (List.take 1) -- List (List String)
      |> List.concat -- List String
      )
  ) -- List String
--}


stringToRecord : String -> StyleRecord
stringToRecord aString =
    let
        newList : List String
        newList =
            String.split "/" aString
    in
    { fileURI = aString
    , styleName =
        List.map
            (fileUnwrap "styleName")
            (List.take 1
                (List.reverse newList)
            )
            |> String.concat
    , colorway =
        List.map
            (fileUnwrap "colorway")
            (List.take 1
                (List.reverse newList)
            )
            |> String.concat
    , extension =
        List.map
            (fileUnwrap "extension")
            (List.take 1
                (List.reverse newList)
            )
            |> String.concat
    }


fileUnwrap : String -> String -> String
fileUnwrap signal astring =
    let
        temp =
            String.split "." astring
    in
    case signal of
        "styleName" ->
            case temp of
                x :: xs ->
                    String.split " " x
                        |> List.take 1
                        |> String.concat

                _ ->
                    ""

        "colorway" ->
            case temp of
                x :: xs ->
                    String.split " " x
                        |> List.drop 1
                        |> List.intersperse " "
                        |> String.concat

                _ ->
                    ""

        "extension" ->
            case temp of
                x :: xs ->
                    String.concat xs

                _ ->
                    ""

        _ ->
            ""


viewCSV : String -> List (Html Msg)
viewCSV enteredContent =
    let
        listContent : List String
        listContent =
            String.split "\n" enteredContent
    in
    List.map stringToRecord listContent
        -- List StyleRecord
        |> List.map styleRecordListToHtml
        |> List.intersperse (br [] [])


downloadCSV : String -> String
downloadCSV enteredContent =
    let
        listContent : List String
        listContent =
            String.split "\n" enteredContent
    in
    List.map stringToRecord listContent
        |> List.map downloadThis
        |> String.concat


downloadThis : StyleRecord -> String
downloadThis arecord =
    arecord.fileURI
        ++ ", "
        ++ arecord.styleName
        ++ ", "
        ++ arecord.colorway
        ++ ",\n"


styleRecordListToHtml : StyleRecord -> Html msg
styleRecordListToHtml arecord =
    text
        (arecord.fileURI
            ++ ", "
            ++ arecord.styleName
            ++ ", "
            ++ arecord.colorway
            ++ ", "
        )


styleRecordListToCSV : String -> Cmd msg
styleRecordListToCSV csvList =
    Download.string "StyleCSV.csv" "text/csv" csvList


view : Model -> Document Msg
view model =
    { title = "CSVTools"
    , body =
        [ div []
            [ Html.textarea
                [ placeholder "Filename with style"
                , value model.content
                , onInput Change
                , style "width" "800px"
                , style "height" "100px"
                ]
                []

            --, div [] [ text (String.reverse model.content) ]
            , div [ style "color" "grey" ] [ text "Original input: " ]
            , div [ style "color" "black" ] [ text model.content ]
            , div [ style "color" "grey" ] [ text "Resulting CSV list: " ]
            , div [ style "color" "black" ]
                {--viewCSV --}
                (viewCSV model.content)
            , button [ onClick (Download (downloadCSV model.content)) ] [ text "Download CSV" ]
            ]
        ]
    }


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none
