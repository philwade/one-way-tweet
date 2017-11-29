port module Components.Twitter exposing (..)

port auth : String -> Cmd msg

type alias TokenBundle = (String, String)
port getToken : TokenBundle -> Cmd msg
port postTweet : String -> Cmd msg
port gotUser : (TwitterUser -> msg) -> Sub msg

-- A simplified version of the twitter use object
type alias TwitterUser = { name: String
                         , user_name: String
                         , profile_image: String
                         }

trySendTweet : Maybe String -> Cmd msg
trySendTweet tweet =
    case tweet of
        Nothing ->
            Cmd.none
        Just value ->
            postTweet value
