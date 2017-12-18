// pull in desired CSS/SASS files
require( './styles/main.scss' );
var oauth = require('./oauth.js');

// inject bundled Elm app into div#main
var Elm = require( '../elm/Main' );
var app = Elm.Main.embed( document.getElementById( 'main' ), { query: window.location.search } );
console.log(app.ports);
app.ports.auth.subscribe(oauth.initialAuth);
app.ports.getToken.subscribe(function(authPair) {
	oauth.getToken(authPair, function(u) { console.log(u); app.ports.gotUser.send(u); });
});
app.ports.postTweet.subscribe(function(tweet) {
	oauth.postTweet(tweet, function(res) {
		app.ports.tweetSendResult.send(res);
	});
});
oauth.haveUser(function(user) {
	app.ports.gotUser.send(user);
});
