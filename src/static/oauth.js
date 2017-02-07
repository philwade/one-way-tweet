var $ = jQuery = require( '../../node_modules/jquery/dist/jquery.js' );           // <--- remove if jQuery not needed

var initialAuth = function () {
	$.get('/api/request-auth', {}, function(res) {
		window.location.href = res;
	});
}

var getToken = function (authPair) {
	var [ token, verifier ] = authPair;
	$.get('/api/request-token', {
		oauth_token: token,
		oauth_verifier: verifier
	}, function(res) {
		console.log(res);
	});
}

if ( typeof define === "function" && define.amd ) {
	define( "oauth", [], function() {
		return {
			initialAuth,
			getToken
		}
	} );
}
