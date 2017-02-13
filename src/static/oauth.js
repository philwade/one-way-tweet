var $ = jQuery = require( '../../node_modules/jquery/dist/jquery.js' );           // <--- remove if jQuery not needed

var initialAuth = function () {
	$.get('/api/request-auth', {}, function(res) {
		window.location.href = res;
	});
}

var getToken = function (authPair, returnUser) {
	var [ token, verifier ] = authPair;
	$.get('/api/request-token', {
		oauth_token: token,
		oauth_verifier: verifier
	}, function(res) {
    	if(res && res.name && res.screen_name && res.profile_image_url) {
			returnUser({
				name: res.name,
				user_name: res.screen_name,
				profile_image: res.profile_image_url
			});
		}
		console.log(res);
	});
}

var postTweet = function(status) {
	$.get('/api/post-status', {
		status
	}, function(res) {
		console.log(res);
	});
}

if ( typeof define === "function" && define.amd ) {
	define( "oauth", [], function() {
		return {
			initialAuth,
			getToken,
			postTweet
		}
	} );
}
