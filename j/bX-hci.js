var HCI = function (fwt) {

	var offset = 0;
	var mOffset;

	$("section#main #selector").bind("touchstart", function(e)
	{
		mOffset = e.originalEvent.changedTouches[0].pageX - $(this).children("#tiles").position().left - 3;
	});

	$("section#main #selector").bind("touchmove", function(e) {
		e.preventDefault();
		$(this).children("#tiles").css("left", e.originalEvent.changedTouches[0].pageX - mOffset);
	});


	document.onkeyup = function(e) {
		kc = e.keyCode;
		/*if (e.keyCode == 40 || e.keyCode == 98)
			limitDelay = normalDelay;*/

		if (fwt.game) {
			if (kc == 88)
				fwt.game.rotateC();
			if (kc == 90)
				fwt.game.rotateCC();
			if (kc == 38 || kc == 104) //default
				fwt.game.rotate();
			if (kc == 32 || kc == 96)
				fwt.game.drop();
		}

		if (kc == 78 || kc == 105) {
			if (fwt.game)
				fwt.game.endGame();

			$("#big-paused, #big-over").fadeOut(200);

			fwt.game = new Game();
		}

	}

	document.onkeydown = function(e) {
		kc = e.keyCode;

		if (fwt.game) {
			if (kc == 39 || kc == 102)
				fwt.game.right();
			if (kc == 37 || kc == 100)
				fwt.game.left();
			if (kc == 80 || kc == 103)
				fwt.game.pauseGame();
		}

		/*if (e.keyCode == 40 || e.keyCode == 98) {
			if (gameStatus < 2)
				return;
			if (gameStatus == 2)
				pause();
			limitDelay = 1;
		}*/
	}


	/*document.getElementById('main').onmousewheel = mousewheel;
	document.getElementById('main').addEventListener('DOMMouseScroll', mousewheel, false);

	document.onkeydown = function (e) {
		if (e.keyCode == 39 || (!event.shiftKey && event.keyCode == 9)) {
			menuItem++;
			if (menuItem > $('#tiles .tile').length - 1)
				menuItem = 0;
			adjust();
			e.preventDefault();
		}
		if (e.keyCode == 37 || (event.shiftKey && event.keyCode == 9)) {
			menuItem--;
			if (menuItem < 0)
				menuItem = $('#tiles .tile').length - 1;
			adjust();
			e.preventDefault();
		}
		if (e.keyCode == 13) {
			if(activeGame == true)
				action(menuItem);
			else
				action(menuItem + 1);
			e.preventDefault();
		}
	}*/

}