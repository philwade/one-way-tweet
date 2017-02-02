module Main exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing ( onClick )
import Components.Twitter exposing (auth)

-- APP
main : Program Never Int Msg
main =
  Html.program { init = init, view = view, update = update, subscriptions = subscriptions }

-- MODEL
init : (Model, Cmd Msg)
init = (0, Cmd.none)

type alias Model = Int

-- UPDATE
type Msg = Auth | Increment

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Auth -> (model, auth "123")
    Increment -> (model + 1, Cmd.none)

subscriptions : Model -> Sub Msg
subscriptions model = Sub.none


-- VIEW
-- Html is defined as: elem [ attribs ][ children ]
-- CSS can be applied via class names or inline style attrib
view : Model -> Html Msg
view model =
  div [ class "container", style [("margin-top", "30px"), ( "text-align", "center" )] ][    -- inline CSS (literal)
    div [ class "row" ][
      div [ class "col-xs-12" ][
          button [ class "btn btn-primary btn-lg", onClick Auth ] [                  -- click handler
            span[ class "glyphicon glyphicon-star" ][]                                      -- glyphicon
            , span[][ text "Sign into your twitter!" ]
          ]
      ]
    ]
  ]

-- CSS STYLES
styles : { img : List ( String, String ) }
styles =
  {
    img =
      [ ( "width", "33%" )
      , ( "border", "4px solid #337AB7")
      ]
  }
