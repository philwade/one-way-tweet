var $ = jQuery = require( '../../node_modules/jquery/dist/jquery.js' );           // <--- remove if jQuery not needed

var auth = function () {
	$.get('/api/request-token', {}, function(res) {
		window.location.href = res;
	});
}

if ( typeof define === "function" && define.amd ) {
	define( "auth", [], function() {
		return auth;
	} );
}
