// pull in desired CSS/SASS files
require( './styles/main.scss' );
var oauth = require('./oauth.js');

// inject bundled Elm app into div#main
var Elm = require( '../elm/Main' );
var app = Elm.Main.embed( document.getElementById( 'main' ), { query: window.location.search } );

app.ports.auth.subscribe(oauth.initialAuth);
app.ports.getToken.subscribe(function(authPair) {
	var user = oauth.getToken(authPair);
	app.ports.gotUser(user);
});
app.ports.postTweet.subscribe(oauth.postTweet);
