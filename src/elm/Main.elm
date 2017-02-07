module Main exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing ( onClick )
import Components.Twitter exposing (auth, getToken)
import QueryString exposing (parse, one, string)

-- APP
main : Program Flags Model Msg
main =
  Html.programWithFlags { init = init, view = view, update = update, subscriptions = subscriptions }

-- MODEL
init : Flags -> (Model, Cmd Msg)
init flags =
    let
        params = parse flags.query
        authPair = (one string "oauth_token" params, one string "oauth_verifier" params)
    in
        case authPair of
            (Just token, Just verifier) ->
                (Model (Just token) (Just verifier), getToken (token, verifier))
            _ -> (Model Nothing Nothing, Cmd.none)

type alias Flags = { query : String
}

type alias Model = { token : Maybe String
                   , verifier : Maybe String
                   }

-- UPDATE
type Msg = Auth

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Auth -> (model, auth "123")

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
