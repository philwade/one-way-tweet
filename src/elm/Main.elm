module Main exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing ( onClick, onInput )
import Components.Twitter exposing (TwitterUser, auth, getToken, trySendTweet, gotUser, invalidTweet, tweetSendResult)
import QueryString exposing (parse, one, string)
import Components.Message exposing (Msg(..))
import Time exposing (every, second)

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
                (Model (Just token) (Just verifier) False Nothing Nothing Nothing, getToken (token, verifier))
            _ -> (Model Nothing Nothing False Nothing Nothing Nothing, Cmd.none)

type alias Flags = { query : String
}

type alias Model = { token : Maybe String
                   , verifier : Maybe String
                   , loading : Bool
                   , user : Maybe TwitterUser
                   , tweetBody : Maybe String
                   , actionMessage : Maybe String
                   }

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    TryAuth -> ({ model | loading = True }, auth "")
    AuthSuccess -> (model, Cmd.none)
    SendTweet -> ({ model | loading = True }, trySendTweet model.tweetBody)
    GotUser user -> ({ model | user = Just user}, Cmd.none)
    TweetValue value -> ({model | tweetBody = Just value}, Cmd.none)
    TweetSendStatus Nothing -> ({model | actionMessage = Just "Tweet sent", tweetBody = Nothing, loading = False}, Cmd.none)
    TweetSendStatus (Just err) -> ({model | actionMessage = Just err, loading = False}, Cmd.none)
    ClearMessage _ -> ({ model | actionMessage = Nothing}, Cmd.none)

subscriptions : Model -> Sub Msg
subscriptions model =
    case model.actionMessage of
        Nothing ->
            Sub.batch [ gotUser GotUser
                      , tweetSendResult TweetSendStatus
                      ]
        Just _ ->
            Sub.batch [ gotUser GotUser
                      , tweetSendResult TweetSendStatus
                      , every (second * 5) ClearMessage
                      ]

pickDisplay : Model -> Html Msg
pickDisplay model =
    case model.user of
        Just user -> writeTweet model.tweetBody model.loading
        Nothing -> signIn

signIn : Html Msg
signIn =
      button [ class "mui-btn mui-btn--primary", onClick TryAuth ] [
        span[ class "glyphicon glyphicon-star" ][]
        , span[][ text "Sign into twitter" ]
      ]

writeTweet : Maybe String -> Bool -> Html Msg
writeTweet tweetBody loading =
    div [ class "mui-form" ] [
        div [ class "mui-textfield" ] [
            textarea [ placeholder "Write a tweet"
                     , onInput TweetValue
                     , disabled loading
                     , value (Maybe.withDefault "" tweetBody)
                     ] []
        ]
        , span [ classList [ ("mui--pull-right", True)
                           , ("mui--text-danger", (invalidTweet tweetBody))
                           ] ]
                           [ text (Maybe.withDefault "" tweetBody |> String.length |> toString) ]
        , button [ class "mui-btn mui-btn--primary"
                 , onClick SendTweet
                 , disabled ((invalidTweet tweetBody) || loading)
                 ]
                 [ text "Send tweet" ]
    ]

userDisplay : Model -> Html Msg
userDisplay model =
    case model.user of
        Just user -> img [ src user.profile_image ] []
        Nothing -> text ""

appBar : Model -> Html Msg
appBar model =
        div [ class "mui-appbar navbar" ] [
            div [ class "mui-container" ][
                table [] [
                    tr [ class "mui--appbar-height" ] [
                        td [ class "mui--text-title" ] [
                            text "One Way Tweet"
                        ]
                        , td [ class "mui--text-right" ] [
                            userDisplay model
                        ]
                    ]
                ]
            ]
        ]

-- VIEW
-- Html is defined as: elem [ attribs ][ children ]
-- CSS can be applied via class names or inline style attrib
view : Model -> Html Msg
view model =
    let
        ui = pickDisplay model
    in
      div [] [
        appBar model
        , div [ classList [("progress", True), ("mui--hide", not model.loading)] ] [
            div [ class "indeterminate" ] [ ]
        ]
        , div [ class "mui-container" ][
            div [ class "col-xs-12" ][
                ui
            ]
        ]
        , div [ id "toast", classList [("show", not <| model.actionMessage == Nothing)]  ]
            [ div [ id "desc" ] [ text <| Maybe.withDefault "" model.actionMessage ]
            ]
      ]
