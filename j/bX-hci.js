var HCI = function (fwt) {

	var offset = 0;
	var mOffset;

	$("section#main #selector").bind("touchstart", function(e)
	{
		mOffset = e.originalEvent.changedTouches[0].pageX - $(this).children("#tiles").position().left;
	});

	$("section#main #selector").bind("touchmove", function(e) {
		e.preventDefault();

		var value = e.originalEvent.changedTouches[0].pageX - mOffset;

		//> Common operations
		var selectMed =  $("section#main #selector").innerWidth() / 2;
		var tileMed = $("section#main .tile").innerHeight() / 2;

		//> Establishing limits
		var limitA = selectMed - 10 - tileMed;
		var limitB = selectMed - $("section#main #tiles").innerWidth() + tileMed + 10;

		if (value > limitA)
		{
			value = limitA;
			mOffset = e.originalEvent.changedTouches[0].pageX - $(this).children("#tiles").position().left;
		}

		if (value < limitB)
		{
			value = limitB;
			mOffset = e.originalEvent.changedTouches[0].pageX - $(this).children("#tiles").position().left;
		}

		$(this).children("#tiles").css("left", value);
		localStorage.fwt3MenuPos = value;
	});

	var wTarget = -1;

	var mousewheel = function (e) {
		if (wTarget == -1)
			wTarget = $("section#main #tiles").position().left

		var factor = ( e.wheelDelta || (e.detail * -1) ) / 120;

		wTarget += factor * (0.30 * $("section#main .tile").innerHeight());

		//> Common operations
		var selectMed =  $("section#main #selector").innerWidth() / 2;
		var tileMed = $("section#main .tile").innerHeight() / 2;

		//> Establishing limits
		var limitA = selectMed - 10 - tileMed;
		var limitB = selectMed - $("section#main #tiles").innerWidth() + tileMed + 10;

		if (wTarget > limitA)
			wTarget = limitA;

		if (wTarget < limitB)
			wTarget = limitB;

		$("section#main #tiles").stop().animate({"left": wTarget}, 100, "linear", function(){
			wTarget = -1;
		});
		localStorage.fwt3MenuPos = wTarget;
		
		e.preventDefault();
	}

	document.getElementById('main').onmousewheel = mousewheel;
	document.getElementById('main').addEventListener('DOMMouseScroll', mousewheel, false);

		//document.onkeydown = function (e) {
		//	if (e.keyCode == 39 || (!event.shiftKey && event.keyCode == 9)) {
		//		menuItem++;
		//		if (menuItem > $('#tiles .tile').length - 1)
		//			menuItem = 0;
		//		adjust();
		//		e.preventDefault();
		//	}
		//	if (e.keyCode == 37 || (event.shiftKey && event.keyCode == 9)) {
		//		menuItem--;
		//		if (menuItem < 0)
		//			menuItem = $('#tiles .tile').length - 1;
		//		adjust();
		//		e.preventDefault();
		//	}
		//	if (e.keyCode == 13) {
		//		if(activeGame == true)
		//			action(menuItem);
		//		else
		//			action(menuItem + 1);
		//		e.preventDefault();
		//	}
		//}





//··································································································································//
//························································ MAIN INTERACTION ························································//

	var showMain = function()
	{
		// Show footer
		$('footer').animate({bottom: -52}, 250);

		// Change
		$('section').fadeOut(250);
		$('#main').delay(250).fadeIn(250);
	}	

	var newGame = function()
	{
		// Hide footer
		$('footer').animate({bottom: -52}, 250);

		// Change
		$('#main').fadeOut(250);
		$('#game').delay(250).fadeIn(250, function() {

			// End any active game
			if (fwt.game)
				fwt.game.endGame();

			// Create new game
			fwt.game = new Game();

		});
	}

	var customizeGame = function()
	{
		// Show footer
		$('footer').animate({bottom: -52}, 250);

		// Change
		$('section').fadeOut(250);
		$('#settings').delay(250).fadeIn(250);
	}

	var showMarks = function()
	{
		// Change
		$('#main').fadeOut(250);
		$('#marks').delay(250).fadeIn(250);
	}	

	var showHelp = function()
	{
		// Change
		$('#main').fadeOut(250);
		$('#help').delay(250).fadeIn(250);
	}	

	$("#tiles #t1").click(newGame);
	$("#tiles #t2").click(customizeGame);
	$("#tiles #t3").click(showMarks);
	$("#tiles #t4").click(showHelp);

	$("section .menu-back").click(showMain);
	
//··································································································································//
//···························································· KEYBOARD ····························································//

	document.onkeyup = function(e)
	{
		kc = e.keyCode;
		/*if (e.keyCode == 40 || e.keyCode == 98)
			limitDelay = normalDelay;*/

		if (fwt.game)
		{
			if (kc == 88)
				fwt.game.rotateC();
			if (kc == 90)
				fwt.game.rotateCC();
			if (kc == 38 || kc == 104) //default
				fwt.game.rotate();
			if (kc == 32 || kc == 96)
				fwt.game.drop();
		}

		if (kc == 78 || kc == 105)
		{
			newGame();
		}

		if (kc == 76)
			fwt.ui.langDialog();
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