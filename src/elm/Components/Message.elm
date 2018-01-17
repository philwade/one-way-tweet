module Components.Message exposing (..)
import Components.Twitter exposing(TwitterUser)
import Time exposing (Time)

type Msg = TryAuth
         | AuthSuccess
         | SendTweet
         | GotUser TwitterUser
         | TweetValue String
         | TweetSendStatus (Maybe String)
         | ClearMessage Time
         | ToggleAbout
