var ui = function () {
	
	
	var menuItem;


	console.log("Full Web Tetris 2.2.0");
	console.log(" By Juande Martos\n Copyright © 2012 Bumxu\n Licensed under the GPLv3 license\n");

//	<Preloader> preloads graphics to the <Loader>
	var preLoaderDone = 0;
	var preLoaderToDo = 2;

	var preLoader = function(){
		preLoaderDone++;
		if(preLoaderDone == preLoaderToDo){
			$.backstretch("g/wall.jpg", {'speed': 100});
			init();
		}
	}

	_iv0 = new Image(); _iv0.src = "g/wall.jpg";   _iv0.onload = preLoader;
	_iv1 = new Image(); _iv1.src = "g/loader.png"; _iv1.onload = preLoader;
//

//	<Init> prepares user interface
	var savedGameImage = null;
	var activeGame = false;

	var init = function(){
		//-> Set more apropiate language
		setLanguage();

		//-> Set user interface events
		setEvents();


		//-> Preload game graphics & user interface
		console.log(" - Preparing graphics...");
		fwt.loadGameGraphics();
		    loader.ui();
		console.log("   Ready");

		//-> Get saved game from localStorage if any
		try{
			savedGameImage = $.evalJSON(localStorage.fwtActiveGame);
			activeGame = true;
			console.log(" - Active game found");
		} catch(e){
			activeGame = false;
			console.log(" - No active game found");
		}

		menuItem = 0;
		if(activeGame)
			$('#tiles').prepend('<div onclick="ui.action(7)" id="t0" class="tile"><span class="xtr" data-xtr="savedgame-mnu">' + $.i18n._('savedgame-mnu') + '</span></div>');
	}
//

//	<Set language><Browser languge><Translate> detect and define the more adecuated language
	var language;
	var languageList = ["english", "spanish", "french", "italian", "german", "portuguese"];

	var setLanguage = function(n){
		if(typeof n === "undefined" || isNaN(n)){
			if(localStorage.fwtLanguage && !isNaN(localStorage.fwtLanguage) && localStorage.fwtLanguage > -1 && localStorage.fwtLanguage < languageList.length)
				n = localStorage.fwtLanguage;
			else
				n = browserLanguage();
		}

		language = n;
		localStorage.fwtLanguage = language;
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

	var translate = function () {
		$('#languages span').removeClass('selected');
		$($('#languages span')[language]).addClass('selected');

		console.log(languageList[language]);

		$.getJSON('j/xtr/' + languageList[language] + '.json', function (data) {
			$(".tile span").fadeOut(200, function(){
				$.i18n.setDictionary(data);

				$('.xtr').map(function () {
					$(this).html($.i18n._($(this).attr('data-xtr')));
				});

				$(".tile span").fadeIn(200);
			});
		});
	}
//

//	<Set events><Mousewheel>
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
				if(activeGame == true)
					action(menuItem);
				else
					action(menuItem + 1);
				e.preventDefault();
			}
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
//

//	<Loader> preloads all the game & interface graphics, and SHOW MAIN MENU when ready
	var loader = {
		total: 0,
		loaded: 0,

		tick: function(){
			this.loaded++;
			$('#loader-chispa').css('opacity', (this.loaded / this.total));
		
			if(this.loaded == this.total){
				$('#firsttag-chispa, #loader-chispa').fadeOut(500, function(){
					if ($("#title-chispa:animated").length === 0){
						$('#title-chispa').fadeIn(400).delay(200).fadeOut(300, function(){
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
			gf = ['tile-customize.png', 'tile-help.png', 'tile-newGame.png', 'tile-rankings.png', 'tile-savedGame.png', 'title.png', 'arrow.png'];
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
//

//	<Adjust> resize the elements to fit screen
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
				if(!activeGame)
					break;
				fwt.setEvents();
				$('.activity#game').show().animate({ 'margin-left': 0 }, 500);
				$('.activity#main').animate({ 'margin-left': '-110%' }, 500, function () {
					$(this).hide();
					fwt.pause(0);
				});
			break;
			case 1: // -> New game
				fwt.setEvents();
				$('.activity#game').show().animate({ 'margin-left': 0 }, 500);
				$('.activity#main').animate({ 'margin-left': '-110%' }, 500, function () {
					$(this).hide();
					activeGame = true;
					savedGameImage = null;
					fwt.newGame();
				});
			break;
			case 2: // -> Customize
				fwt.pause(1);
				setEvents();

				cmd.loadPrefs();

				$('.activity:not(#settings)').animate({ 'margin-left': '-110%' }, 500, function() { $(this).hide(); });
				$('.activity#settings').show().animate({ 'margin-left': 0 }, 500);
			break;
			case 3: // -> Marks
				$('.activity:not(#marks)').animate({ 'margin-left': '-110%' }, 500, function() { $(this).hide(); });
				$('.activity#marks').show().animate({ 'margin-left': 0 }, 500);
			break;
			case 4: // -> Assistance
				fwt.pause(1);
				setEvents();

				$('.activity:not(#help)').animate({ 'margin-left': '-110%' }, 500, function() { $(this).hide(); });
				$('.activity#help').show().animate({ 'margin-left': 0 }, 500);
			break;
			case 6: // -> Back to main menu
				fwt.pause(1);
				setEvents();

				if (activeGame && savedGameImage == null) {
					$('#tiles #t0').remove();
					$('#tiles').prepend('<div onclick="ui.action(0)" id="t0" class="tile"><span class="xtr" data-xtr="resumegame-mnu">' + $.i18n._('resumegame-mnu') + '</span></div>');

					menuItem = 0;
					adjust();
				}

				$('.activity:not(#main)').animate({ 'margin-left': '110%' }, 500, function() { $(this).hide(); });
				$('.activity#main').show().animate({ 'margin-left': 0 }, 500);
			break;
			case 7: // -> Start saved game
				if(!activeGame || savedGameImage == null)
					break;

				fwt.prepare(savedGameImage);
				savedGameImage = null;
				ui.action(0);
			break;
		}
	}

	var stopGame = function() {
		activeGame = false;
		savedGameImage = null;

		$('#tiles #t0').remove();
		
		menuItem = 0;
		adjust();
	}


	// Public methods
	this.action = action;
	this.setLanguage = setLanguage;
	this.loader = loader;
	this.stopGame = stopGame;
	
}

var ui = new ui();