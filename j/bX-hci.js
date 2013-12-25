var HCI = function (fwt) {

	// Resizes the elements to fit screen
	//var adjust = function () {
		/*$("section").css('width', $('#layout').innerWidth() - 12);
		$("section").css('height', $('#layout').innerHeight() - 12 - 20);

		for (i = 0; i < $('#tiles .tile').length; i++) {
			$($('#tiles .tile')[i]).css({ 'margin-left': -100 + 230 * (i - menuItem) });
			
			if (i == menuItem)
				$($('#tiles .tile')[i]).css({ 'color': 'rgba(0, 0, 0, 0.7)', 'box-shadow': '0 0 6px rgba(0, 0, 0, 0.3)', 'background-color': 'rgba(255, 255, 255, 0.3)' });
			else
				$($('#tiles .tile')[i]).css({ 'color': 'rgba(255, 255, 255, 0.2)', 'box-shadow': 'none', 'background-color': 'rgba(255, 255, 255, 0.1)' });
		}

		$('#tiles .tile').fadeIn(100);*/

		
	//}

	//window.onresize = function () {
	//	adjust();
	//}
	//adjust();


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