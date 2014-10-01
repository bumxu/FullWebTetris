Game = (o) ->
	# Math
	π  = Math.PI
	ø  =  undefined
	øs = 'undefined'

	# Canvas
	canvas  = $('canvas#board').get(0)
	context = canvas.getContext('2d')

	map     = ø
	topLine = 0

	# Timing variables
	clock = fps_clock = ø
	fps = 0

	# Game
	state    = ø
	GSOVER   = 0
	GSPAUSED = 1
	GSACTIVE = 2
#	var level, lines, score, dropBonus;
#	//var rnd0, rnd1, rnd2, rnd3, rnd4;
#
	# Speed variables
	delay = 0
	fallDelay = normalDelay = 15

	# Sets and shapes
	sets = {}
	sets.classic   = [[[1,1,0],[0,1,1]],[[0,1,1],[1,1,0]],[[1,1],[1,1]],[[1,1,1,1]],[[0,1,0],[1,1,1]],[[1,0,0],[1,1,1]],[[0,0,1],[1,1,1]]]
	sets.extended  = sets.classic.concat [[[1,0],[1,1]],[[0,1],[1,1]],[[1]],[[0,0],[1,1]]]
	sets.challenge = sets.extended.concat [[[0,1,0],[1,1,1],[0,1,0]],[[0,1,1],[0,1,1],[1,1,0]],[[1,1,0],[1,1,0],[0,1,1]],[[0,1,1],[0,1,1],[1,1,1]],[[1,1,0],[1,1,0],[1,1,1]],[[1,1,1],[1,1,0]],[[1,1,0],[1,1,1]],[[1,0,1],[1,1,1]],[[1,1,1]],[[0,0,1],[1,1,1],[1,0,0]],[[1,0,0],[1,1,1],[0,0,1]],[[1,0,0],[1,1,0],[1,1,1]],[[0,0,1],[0,1,1],[1,1,1]],[[0,1,0],[1,1,1],[1,1,0]],[[0,1,0],[1,1,1],[0,1,1]]]
	sets.lethal    = sets.challenge.concat [[[1,1,1],[1,1,0],[0,1,1]],[[1,1,1],[0,1,1],[1,1,0]],[[1,1,0],[0,1,1],[1,1,0]],[[1,1,0],[1,1,1],[0,1,1]],[[1,1,1,1,1,1,1,1]],[[0,0,1],[0,1,0],[1,0,0]],[[1,0,1],[0,1,0],[1,0,1]],[[0,0,1],[0,1,0],[1,0,1]],[[0,1,1],[1,1,0],[1,0,0]],[[0,1],[1,0]],[[0,1],[1,1],[1,1],[0,1],[0,1]],[[1,0],[1,1],[1,1],[1,0],[1,0]],[[0,1],[1,1],[1,1],[0,1],[1,1]],[[1,1],[1,0],[1,1],[1,0],[1,1]],[[1,1],[1,0],[0,1],[1,0],[0,1]],[[1,0],[1,1],[1,1],[1,0],[1,1]],[[1,1],[0,1],[1,0],[0,1],[1,0]],[[1,1,1],[1,0,1],[1,1,1]],[[1,1,1],[0,0,1],[1,1,1]],[[1,1,0],[1,0,1],[1,0,1]],[[1,1,0],[1,1,1],[1,0,1]],[[0,1,1],[1,0,1],[1,0,1]],[[0,1,1],[1,1,1],[1,0,1]],[[0,1,0],[1,1,1],[1,0,1]],[[1,1,1],[0,1,0],[1,1,1]]]

	# Colors
	colors = ["red","green","blue","cyan","purple","orange","yellow","brown","emerald","pink","white"]

	# Pieces var declaration
	shapes = current = next = shade = ø



#	//-> Get preferences from localStorage if any
#	/*try{
#		prefs = $.evalJSON(localStorage.fwtPreferences);
#		
#		width = prefs.width || width;
#		height = prefs.height || height;
#		set = prefs.set || set;
#			forms = formSets[set];
#		colorTheme = prefs.theme || colorTheme;
#			$('canvas#canvas').attr('data-theme', colorTheme);
#		shadeEnabled = prefs.shades || shadeEnabled;
#		rotation = prefs.rotation || rotation;
#	} catch(e){
#		//-> No action
#	}*/
#
#	/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */


	# EXPERIMENTAL
	hellShape = ->
		rx = Math.round(Math.random() * 511).toString(2) #remember: only for positive numbers
		rx = ('000000000' + rx).slice(-9)
		z  = 0

		_r = -> 
			_row = []
			for _ in [0...3] by 1
				_row.push( Number( rx[z] ) )
				z++
			return _row

		adfg = (do _r for _ in [0...3] by 1)
		
		return adfg





	#		//if (gameStatus < 2)
	#		//	return;
	#
	#		/*if(!paintOnly) {
	#			rndForm = Math.round(Math.random() * (shapes.length - 1));
	#			rndColor = Math.round(Math.random() * (colors.length - 1));;
	#			iSource = Math.round(width / 2) - Math.round(shapes[rndForm][0].length / 2);
	#			jSource = shapes[rndForm].length * -1;
	#
	#			next = { i: iSource, j: jSource, mat: 1, col: rndColor, form: shapes[rndForm] }
	#		}*/
	#
	#		// --- //
	#
	#		/*if (first !== true) {
	#			$('section#game #next .oldNext').remove();
	#			$('section#game #next .newNext').addClass('oldNext').removeClass('newNext').animate({ 'left': 120, 'opacity': 0 }, 260, function () {
	#				$(this).remove();
	#			});
	#
	#			newCanvasNext = $('<canvas width="120" height="120">').addClass('newNext').appendTo('#next')[0];
	#			newOutNext = newCanvasNext.getContext('2d');
	#
	#			centerX = (120 - next.form[0].length * 25) / 2;
	#			centerY = (120 - next.form.length * 25) / 2;
	#
	#			for (j = 0; j < next.form.length; j++)
	#				for (i = 0; i < next.form[j].length; i++)
	#					if (next.form[j][i] == 1)
	#						newOutNext.drawImage(chooseImage.next(), 25 * i + centerX, 25 * j + centerY, 25, 25);
	#
	#			$(newCanvasNext).animate({ 'left': 0, 'opacity': 1 }, 260);
	#		}*/
	#	}



#	/*var prepare = function (saved) {
#		map = saved.map;
#		current = saved.current;
#		next = saved.next;
#
#		window.cancelAnimFrame(clock);
#
#		lastLine = saved.lastLine;
#		gameStatus = 3;
#		setNextPiece(false, true); // -> This requires gameStatus > 1
#
#		score = saved.score;
#		$('section#game #next #score').html(score);
#		
#		calcLevel();
#
#		dropBonus = saved.dropBonus;
#
#		clock = window.requestAnimFrame(pulse);
#		pause(1);
#	}
#
#*/
#
#	var mark = function (plus, type, about) {
#		// score //
#		score += plus;
#		$('section#game #next #score').html(score);
#
#		// level //
#		calcLevel();
#
#		// osd //
#		waitExtra = 0;
#		classExtra = '';
#
#		osdY = current.j * size - 25;
#		if (osdY < 100)
#			osdY = 100;
#		osdX = (current.i * size) + (current.form[0].length * 25 / 2) - 250;
#
#		msg = '';
#
#		if (plus == 1)
#			msg = rnd0[Math.round(Math.random() * 4)];
#
#		if (plus > 1 && type == 'pulse') {
#			max = height + Math.floor(height / 2) + 1;
#
#			if (plus <= max / 2)
#				msg = rnd1[Math.round(Math.random() * 4)];
#			else
#				msg = rnd2[Math.round(Math.random() * 4)];
#		}
#
#		if (lastLine < 5 && Math.random() * 5 > 2)
#			msg = "Date prisa";
#
#		if (type == 'drop')
#			msg = rnd3[Math.round(Math.random() * 4)];
#
#		if (plus >= 40 && type == "line") {
#			msg = rnd4[about - 1];
#			waitExtra = 400;
#			classExtra = 'line';
#		}
#
#		$('<div>').html('¡' + msg + '! <strong>+ ' + plus + '</strong>').addClass(classExtra).css({ 'top': osdY, 'left': osdX, 'opacity': 0 }).appendTo('#osd').delay(waitExtra).animate({ 'top': osdY - 60, 'opacity': 1 }, 800, 'linear').animate({ 'top': osdY - 60 - 30, 'opacity': 0 }, 600, 'linear', function () {
#			$(this).remove();
#		});
#	}
#
#	var calcLevel = function() {
#		level = Math.floor(score / 3000);
#		normalDelay = 40 - level;
#		fallDelay = normalDelay;
#		$('section#game #next #level').html('<span class="xtr" data-xtr="level-lab">' + $.i18n._('level-lab') + '</span> ' + level);
#	}
#
#
#
#
#
#
#
#
#
#
#	var setNextPiece = function(first, paintOnly) {
#		if (gameStatus < 2)
#			return;
#
#		if(!paintOnly) {
#			rndForm = Math.round(Math.random() * (forms.length - 1));
#			rndColor = Math.round(Math.random() * (colors.length - 1));;
#			iSource = Math.round(width / 2) - Math.round(forms[rndForm][0].length / 2);
#			jSource = forms[rndForm].length * -1;
#
#			next = { i: iSource, j: jSource, mat: 1, col: rndColor, form: forms[rndForm] }
#		}
#
#		// --- //
#
#		/*if (first !== true) {
#			$('section#game #next .oldNext').remove();
#			$('section#game #next .newNext').addClass('oldNext').removeClass('newNext').animate({ 'left': 120, 'opacity': 0 }, 260, function () {
#				$(this).remove();
#			});
#
#			newCanvasNext = $('<canvas width="120" height="120">').addClass('newNext').appendTo('#next')[0];
#			newOutNext = newCanvasNext.getContext('2d');
#
#			centerX = (120 - next.form[0].length * 25) / 2;
#			centerY = (120 - next.form.length * 25) / 2;
#
#			for (j = 0; j < next.form.length; j++)
#				for (i = 0; i < next.form[j].length; i++)
#					if (next.form[j][i] == 1)
#						newOutNext.drawImage(chooseImage.next(), 25 * i + centerX, 25 * j + centerY, 25, 25);
#
#			$(newCanvasNext).animate({ 'left': 0, 'opacity': 1 }, 260);
#		}*/
#	}
#
#	var clearNext = function() {
#		next = {};
#		$('section#game #next canvas').animate({ 'left': 120, 'opacity': 0 }, 260, function () {
#			$(this).remove();
#		});
#	}
#

	
#	var adjust = function() {
#		$("section").css('width', $('#layout').innerWidth() - 12);
#		$("section").css('height', $('#layout').innerHeight() - 12 - 20);
#
#		wPxB = $("section#game").innerWidth() - 125;
#		hPxB = $("section#game").innerHeight();
#
#		size = Math.floor(hPxB / height);
#		wPxC = width * size;
#		hPxC = height * size;
#
#		if (wPxC > wPxB) {
#			size = Math.floor(wPxB / width);
#			wPxC = width * size
#			hPxC = height * size;
#		}
#
#		$(canvas).attr("width", wPxC);
#		$(canvas).attr("height", hPxC);
#		$("section#game #osd").css("width", wPxC);
#		$("section#game #osd").css("height", hPxC);
#
#		fieldDistance = ($("section#game").innerWidth() - 125 - wPxC) / 2;
#
#		$(canvas).css("top", ($("section#game").innerHeight() - hPxC) / 2);
#		$(canvas).css("left", ($("section#game").innerWidth() - 125 - wPxC) / 2 + 125);
#		$("section#game #osd").css("top", ($("section#game").innerHeight() - hPxC) / 2);
#		$("section#game #osd").css("left", ($("section#game").innerWidth() - 125 - wPxC) / 2 + 125);
#
#		repaint();
#	}
#
#	var switchTheme = function(theme){
#		switch(theme){
#			case "classic":
#			 colorTheme = "classic";
#			 break;
#			default:
#			 colorTheme = "iced";
#		}
#		$('canvas#canvas').attr('data-theme', colorTheme);
#		savePrefs();
#	}
#
#	var switchShades = function(bool){
#		shadeEnabled = bool;
#		if (gameStatus > 1) {
#			createShade();
#			repaint();
#		}
#		savePrefs();
#	}
#

#
#	var saveToLS = function(){
#		save = {};		
#		save.map = map;
#		save.current = current;
#		save.next = next;
#		save.lastLine = lastLine;
#		save.score = score;
#		save.dropBonus = dropBonus;
#		localStorage.fwtActiveGame = $.toJSON(save);
#	}
#
#	var savePrefs = function() {
#		localStorage.fwtPreferences = $.toJSON({
#			'shades': shadeEnabled,
#			'theme': colorTheme,
#			'width': width,
#			'height': height,
#			'set': set,
#			'rotation': rotation
#		});
#	}
#
#	var setOSDMessages = function(){
#		// OSD messages
#		rnd0 = [$.i18n._('well'), $.i18n._('slow'), $.i18n._('candobetter'), $.i18n._('onemore'), $.i18n._('point')]
#		rnd1 = [$.i18n._('notbad'), $.i18n._('alright'), $.i18n._('genial'), $.i18n._('keepitup'), $.i18n._('nottoobad')];
#		rnd2 = [$.i18n._('magnificent'), $.i18n._('veryfast'), $.i18n._('fast'), $.i18n._('shooting'), $.i18n._('fast2')];
#		rnd3 = [$.i18n._('instant'), $.i18n._('most'), $.i18n._('welldone'), $.i18n._('stellar'), $.i18n._('awesome')];
#		rnd4 = [$.i18n._('singleline'), $.i18n._('doubleline'), $.i18n._('tripleline'), $.i18n._('ttetris')];
#	}	
#
#
#
#	var getWidth = function() {
#		return width;
#	}
#	var setWidth = function(p) {
#		width = p*1;
#		newGame();
#		savePrefs();
#	}
#	var setHeight = function(p) {
#		height = p*1;
#		newGame();
#		savePrefs();
#	}
#	var getHeight = function() {
#		return height;
#	}
#
#	var getGameState = function () {
#		return gameState;
#	}
#
#	var getShadeEnabled = function() {
#		return shadeEnabled;
#	}
#	var getColorTheme = function() {
#		return colorTheme;
#	}	
#	var getPiecesSet = function() {
#		return set;
#	}
#	var getRotation = function() {
#		return rotation;
#	}
#	var switchRotation = function(direction) {
#		if (direction == "cc" || direction == "c") {
#			rotation = direction;
#			savePrefs();
#		}
#	}
#	var switchSet = function(opt) {
#		if (opt == "classic" || opt == "full" || opt == "challenge" || opt == "lethal") {
#			set = opt;
#			forms = formSets[set];
#			newGame();
#			savePrefs();
#		}
#	}
#
#	// Public methods
#	//this.newGame = newGame;
	#@repaint = repaint
#	//this.setEvents = setEvents;

#	//this.prepare = prepare;
#	//this.loadGameGraphics = loadGameGraphics;
#	//this.repaintNextPiece = function() { setNextPiece(false, true); }
#
#	 // Prefs
#	 this.getWidth 			= getWidth;
#	  this.setWidth 		= setWidth;
#	 this.getHeight 		= getHeight;
#	  this.setHeight 		= setHeight;
#	 this.getShadeEnabled 	= getShadeEnabled;
#	  this.switchShades 	= switchShades;
#	 this.getColorTheme 	= getColorTheme;
#	  this.switchTheme 		= switchTheme;
#	 this.getPiecesSet 		= getPiecesSet;
#	  this.switchSet 		= switchSet;
#	 this.getRotation 		= getRotation;
#	  this.switchRotation 	= switchRotation;
#
	do init