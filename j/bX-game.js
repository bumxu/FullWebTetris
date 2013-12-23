var game = function (fwt) {

	// Timing functions
	window.requestAnimFrame = (function () {
		return window.requestAnimationFrame ||
			window.mozRequestAnimationFrame ||
			window.msRequestAnimationFrame ||
			window.oRequestAnimationFrame ||
			window.webkitRequestAnimationFrame ||
			function (callback) {
				window.setTimeout(callback, 1000 / 60);
			};
	})();

	window.cancelAnimFrame = (function () {
		return window.cancelAnimationFrame ||
			window.mozCancelAnimationFrame ||
			window.msCancelAnimationFrame ||
			window.oCancelAnimationFrame ||
			window.webkitCancelAnimationFrame ||
			window.clearTimeout;
	})();


	// Get canvas and context
	var canvas  = $('section#game canvas')[0];
	var context = canvas.getContext('2d');


}