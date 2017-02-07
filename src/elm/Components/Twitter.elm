port module Components.Twitter exposing (..)

port auth : String -> Cmd msg

type alias TokenBundle = (String, String)
port getToken : TokenBundle -> Cmd msg
