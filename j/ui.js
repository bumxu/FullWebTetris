var ui = function () {
	
	var gameInProgress, menuItem, language;

	var _languages = ["english", "spanish", "french", "italian", "german"];

	var run = function() {
		// Any game in progress?
		gameInProgress = false;
		// if(juego guardado...){
		// 	preparar...
		// 	gameInProgress = true;
		// }

		// Menu item selected
		menuItem = 0;
		if(gameInProgress){
			menuItem = 1;
		}

		// Set user language or more appropriate
		language = localStorage.xtr;
		if(!(language > -1 && language < _languages.length))
			language = userLanguage();
		translate();

		setEvents();
	}

	var userLanguage = function () {
		userLang = (navigator.language) ? navigator.language : navigator.userLanguage;
		switch (userLang) {
			case "es":
				return 1;
			case "ca":
				return 1;
			case "fr":
				return 2;
			case "it":
				return 3;
			case "de":
				return 4;
		}
		return 0;
	}
	var translate = function () {
		$('#languages span').removeClass('selected');
		$('.xtr-' + language).addClass('selected');

		$.getJSON('j/xtr/' + _languages[language] + '.json', function (data) {
			$.i18n.setDictionary(data);

			$('.xtr').map(function () {
				$(this).html($.i18n._($(this).attr('data-xtr')));
			});
		});
	}
	var changeLanguage = function(n){
		if (n > -1 && n < _languages.length) {
			language = n;
			localStorage.xtr = language;
			translate();
		}
	}

	var mousewheel = function (e) {
		factor = e.wheelDelta || (e.detail * -1);

		if (factor < 0) {
			menuItem++;
			if (menuItem > $('#tiles .tile').length - 1)
				menuItem = 0;
			adjust();
		}
		if (factor > 0) {
			menuItem--;
			if (menuItem < 0)
				menuItem = $('#tiles .tile').length - 1;
			adjust();
		}
		
		e.preventDefault();
	}
	var setEvents = function () {
		window.onresize = function () {
			adjust();
		}
		adjust();

		document.getElementById('main').onmousewheel = mousewheel;
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
				if(gameInProgress == true)
					action(menuItem);
				else
					action(menuItem + 1);
				e.preventDefault();
			}
		}
	}
	var adjust = function () {
		$(".activity").css('width', $('#layout').innerWidth() - 12);
		$(".activity").css('height', $('#layout').innerHeight() - 12 - 20);

		for (i = 0; i < $('#tiles .tile').length; i++) {
			$($('#tiles .tile')[i]).css({ 'margin-left': -100 + 230 * (i - menuItem) });
			
			if (i == menuItem)
				$($('#tiles .tile')[i]).css({ 'color': 'rgba(0, 0, 0, 0.7)', 'box-shadow': '0 0 6px rgba(0, 0, 0, 0.3)', 'background-color': 'rgba(255, 255, 255, 0.3)' });
			else
				$($('#tiles .tile')[i]).css({ 'color': 'rgba(255, 255, 255, 0.2)', 'box-shadow': 'none', 'background-color': 'rgba(255, 255, 255, 0.1)' });
		}

		$('#tiles .tile').fadeIn(100);
	}

	var action = function(id){
		switch(id){
			case 0:
				if(!gameInProgress)
					break;
				$fwt.setEvents();
				$('.activity#game').show().animate({ 'margin-left': 0 }, 500);
				$('.activity#main').animate({ 'margin-left': '-110%' }, 500, function () {
					$(this).hide();
					$fwt.pause(0);
				});
			break;
			case 1:
				$fwt.setEvents();
				$('.activity#game').show().animate({ 'margin-left': 0 }, 500);
				$('.activity#main').animate({ 'margin-left': '-110%' }, 500, function () {
					$(this).hide();
					gameInProgress = true;
					$fwt.newGame();
				});
			break;
			/*case 2:
				$fwt.setEvents();
				$('.activity#game').show().animate({ 'margin-left': 0 }, 500);
				$('.activity#main').animate({ 'margin-left': '-110%' }, 500, function () {
					$(this).hide();
					gameInProgress = true;
					$fwt.newGame();
				});
			break;*/
		}
	}



	// Public methods
	this.action = action;
	this.changeLanguage = changeLanguage;

	run();
}

var $ui = new ui();