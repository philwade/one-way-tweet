module Components.Message exposing (..)
import Components.Twitter exposing(TwitterUser)

type Msg = TryAuth
         | AuthSuccess
         | SendTweet
         | GotUser TwitterUser
         | TweetValue String
         | TweetSendStatus (Maybe String)
