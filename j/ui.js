var ui = function () {
	
	var gameInProgress;
	// SAVED GAME ...
	gameInProgress == false;
	
    var menuItem = 0;
	if(gameInProgress == true)
		menuItem = 1;
	
	

    var language = 0;
    var languages = ["english", "spanish", "french", "italian", "german"];

    


	var action = function(cmd){
		switch(cmd){
			case 0:
				if(!gameInProgress)
					break;
				$fwt.setEvents();
				$('#game-board').show().animate({ 'margin-left': 0 }, 500);
				$('#game-title').animate({ 'margin-left': '-110%' }, 500, function () {
					$(this).hide();
					$fwt.pause(0);
				});
			break;
			case 1:
				$fwt.setEvents();
				$('#game-board').show().animate({ 'margin-left': 0 }, 500);
				$('#game-title').animate({ 'margin-left': '-110%' }, 500, function () {
					$(this).hide();
					gameInProgress = true;
					$fwt.newGame();
				});
			break;
			/*case 2:
				$fwt.setEvents();
				$('#game-board').show().animate({ 'margin-left': 0 }, 500);
				$('#game-title').animate({ 'margin-left': '-110%' }, 500, function () {
					$(this).hide();
					gameInProgress = true;
					$fwt.newGame();
				});
			break;*/
		}
	}


    /*var goGame = function () {
        $fwt.setEvents();
        $('#game-board').animate({ 'margin-left': 0 }, 500);
        $('#game-title').animate({ 'margin-left': '-110%' }, 500, function () {
            gameInProgress = true;
            $fwt.newGame();
        });
    }*/

    /*var help = function () {
        $('#game-help').animate({ 'margin-left': 0 }, 500);
        $('#game-title').animate({ 'margin-left': '-110%' }, 500);
    }*/

    /*var goBack = function () {
        setEvents();
        $fwt.pause(1);
        $('#game-title').animate({ 'margin-left': 0 }, 500);
        $('#game-help').animate({ 'margin-left': '110%' }, 500);
        $('#game-board').animate({ 'margin-left': '110%' }, 500);

        if (gameInProgress == true) {
            if ($('#ui-tiles #t0').length < 1)
                $('#ui-tiles').prepend('<div onclick="$ui.action(0)" id="t0" class="ui-tile xtr" data-xtr="resumegame-mnu">' + $.i18n._('resumegame-mnu') + '</a>');
            if ($('#ui-tiles #t0').length > 0) {
                menuItem = 0;
                adjust();
            }
        }
    }*/

    var adjust = function () {
        $(".board").css('width', $('#layout').innerWidth() - 12);
        $(".board").css('height', $('#layout').innerHeight() - 12 - 20);

        for (i = 0; i < $('.ui-tile').length; i++) {
            $($('.ui-tile')[i]).css({ 'margin-left': -100 + 230 * (i - menuItem) });
			
            if (i == menuItem)
                $($('.ui-tile')[i]).css({ 'color': 'rgba(0, 0, 0, 0.7)', 'box-shadow': '0 0 6px rgba(0, 0, 0, 0.3)', 'background-color': 'rgba(255, 255, 255, 0.3)' });
			else
                $($('.ui-tile')[i]).css({ 'color': 'rgba(255, 255, 255, 0.2)', 'box-shadow': 'none', 'background-color': 'rgba(255, 255, 255, 0.1)' });
        }

        $('.ui-tile').fadeIn(100);
    }

    var mousewheel = function (e) {
        factor = e.wheelDelta || (e.detail * -1);

        if (factor < 0) {
            menuItem++;
            if (menuItem > $('.ui-tile').length - 1)
                menuItem = 0;
            adjust();
        }
        if (factor > 0) {
            menuItem--;
            if (menuItem < 0)
                menuItem = $('.ui-tile').length - 1;
            adjust();
        }
		
		e.preventDefault();
    }

    var launcher = function () {
        //document.getElementById('audio').volume = 0;

        // Language
        language = localStorage.xtr;
        if(!(language > -1 && language < 5))
            language = detectLanguage();
        translate();
    }

    var detectLanguage = function () {
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
        $('#lang span').removeClass('selected');
        $('.xtr-' + language).addClass('selected');

        $.getJSON('j/xtr/' + languages[language] + '.json', function (data) {
            $.i18n.setDictionary(data);

            $('.xtr').map(function () {
                $(this).html($.i18n._($(this).attr('data-xtr')));
            });
        });
    }
    var changeLanguage = function(n){
        if (n > -1 && n < 5) {
            language = n;
            translate();
            localStorage.xtr = language;
        }
    }

    var setEvents = function () {
        window.onresize = function () {
            adjust();
        }
        adjust();

        document.getElementById('game-title').onmousewheel = mousewheel;
        document.getElementById('game-title').addEventListener('DOMMouseScroll', mousewheel, false);

        document.onkeydown = function (e) {
            if (e.keyCode == 39 || (!event.shiftKey && event.keyCode == 9)) {
                menuItem++;
                if (menuItem > $('.ui-tile').length - 1)
                    menuItem = 0;
                adjust();
				e.preventDefault();
            }
            if (e.keyCode == 37 || (event.shiftKey && event.keyCode == 9)) {
                menuItem--;
                if (menuItem < 0)
                    menuItem = $('.ui-tile').length - 1;
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

    // Public methods
    this.action = action;

    this.changeLanguage = changeLanguage;

    // Autorun
    launcher();
    setEvents();
}
var $ui = new ui();