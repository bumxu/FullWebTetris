var ui = function () {
	
	var gameInProgress, menuItem, language, saved, theBeginLoad = 0;

	var _languages = ["english", "spanish", "french", "italian", "german", "portuguese"];

	// The begin!!
	var begin = function(){
		theBeginLoad++;
		if(theBeginLoad == 2){
			$.backstretch("g/wall.jpg", {'speed': 100});
			run();
		}
	}
	_w = new Image(); _w.src = "g/wall.jpg";   _w.onload = begin;
	_l = new Image(); _l.src = "g/loader.png"; _l.onload = begin;

	var run = function() {
		// Any game in progress?
		try{
			saved = $.evalJSON(localStorage.savedGame);

			gameInProgress = true;
		} catch(e) {
			gameInProgress = false;
		}

		// Menu item selected
		menuItem = 0;
		if(gameInProgress)
			$('#tiles').prepend('<div onclick="ui.action(7)" id="t0" class="tile"><span class="xtr" data-xtr="savedgame-mnu">' + $.i18n._('savedgame-mnu') + '</span></div>');

		// Set user language or more appropriate
		setLanguage();

		// Initialice events
		setEvents();

		// Preload graphics
		loader.ui();
		fwt.loadGameGraphics();
	}


	var translate = function () {
		$('#languages span').removeClass('selected');
		$($('#languages span')[language]).addClass('selected');

		$.getJSON('j/xtr/' + _languages[language] + '.json', function (data) {
			$(".tile span").fadeOut(200, function(){

				$.i18n.setDictionary(data);

				$('.xtr').map(function () {
					$(this).html($.i18n._($(this).attr('data-xtr')));
				});

				$(".tile span").fadeIn(200);
			});
		});
	}
	var setLanguage = function(n){
		if(typeof n === "undefined" || isNaN(n)){
			if(localStorage.xtr && !isNaN(localStorage.xtr) && localStorage.xtr > -1 && localStorage.xtr < _languages.length)
				n = localStorage.xtr;
			else
				n = browserLanguage();
		}

		language = n;
		localStorage.xtr = language;
		translate();
	}
	var browserLanguage = function () {
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
			case "pt":
				return 4;
		}
		return 0;
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

		//window.onbeforeunload = null;
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
				fwt.setEvents();
				$('.activity#game').show().animate({ 'margin-left': 0 }, 500);
				$('.activity#main').animate({ 'margin-left': '-110%' }, 500, function () {
					$(this).hide();
					fwt.pause(0);
				});
			break;
			case 1:
				fwt.setEvents();
				$('.activity#game').show().animate({ 'margin-left': 0 }, 500);
				$('.activity#main').animate({ 'margin-left': '-110%' }, 500, function () {
					$(this).hide();
					gameInProgress = true;
					fwt.newGame();
				});
			break;
			case 3:
				fwt.pause(1);
				setEvents();

				$('.activity:not(#settings)').animate({ 'margin-left': '-110%' }, 500, function() { $(this).hide(); });
				$('.activity#settings').show().animate({ 'margin-left': 0 }, 500);
			break;
			case 5:
				fwt.pause(1);
				setEvents();

				$('.activity:not(#help)').animate({ 'margin-left': '-110%' }, 500, function() { $(this).hide(); });
				$('.activity#help').show().animate({ 'margin-left': 0 }, 500);
			break;
			case 6:
				fwt.pause(1);
				setEvents();

				if (gameInProgress) {
					if ($('#tiles #t0').length < 1)
						$('#tiles').prepend('<div onclick="ui.action(0)" id="t0" class="tile"><span class="xtr" data-xtr="resumegame-mnu">' + $.i18n._('resumegame-mnu') + '</span></div>');
					if ($('#tiles #t0').length > 0) {
						$('#tiles #t0 span').attr('data-xtr', 'resumegame-mnu').html($.i18n._('resumegame-mnu'));
						menuItem = 0;
					}
					adjust();
				}

				$('.activity:not(#main)').animate({ 'margin-left': '110%' }, 500, function() { $(this).hide(); });
				$('.activity#main').show().animate({ 'margin-left': 0 }, 500);
			break;

			case 7: // SPECIAL CASE - SAVED GAME
				if(!gameInProgress || !saved)
					break;

				fwt.prepare(saved);
				ui.action(0);
			break;
		}
	}

	var loader = {
		total: 0,
		loaded: 0,

		tick: function(){
			this.loaded++;
			$('#loader-chispa').css('opacity', (this.loaded / this.total));
		
			if(this.loaded == this.total){
				$('#firsttag-chispa, #loader-chispa').fadeOut(500, function(){
					if ($("#title-chispa:animated").length === 0){
						$('#title-chispa').fadeIn(600).delay(400).fadeOut(300, function(){
							ui.action(6);
						});
					}
				})
			}
		},
		needed: function(n){
			this.total += n;
		},
		ui: function(){
			gf = ['tile-customize.png', 'tile-help.png', 'tile-newGame.png', 'tile-rankings.png', 'tile-savedGame.png', 'title.png'];
			ga = [];
			for(i = 0; i < gf.length; i++){
				ui.loader.needed(1);
				ga[i] = new Image();
				ga[i].src = "g/" + gf[i];
				ga[i].onload = function(){
					ui.loader.tick();
				}
			}
		}

	}

	// Public methods
	this.action = action;
	this.setLanguage = setLanguage;
	this.loader = loader;
	
}

var ui = new ui();