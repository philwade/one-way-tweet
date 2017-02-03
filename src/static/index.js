// pull in desired CSS/SASS files
require( './styles/main.scss' );
var auth = require('./oauth.js');

// inject bundled Elm app into div#main
var Elm = require( '../elm/Main' );
var app = Elm.Main.embed( document.getElementById( 'main' ), { query: window.location.search } );

app.ports.auth.subscribe(auth);
