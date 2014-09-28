class Map
	map = undefined

	constructor: (w, h) ->
		#	if entropy == undefined
		r   = (0 for _ in [1...w])
		map = (r for _ in [1...h])

	raw: -> map
	index: (i, j) -> map(j,i)
	material: (i,j) -> map(j,i).material
	width: -> map[0].length
	height: -> map.length

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
#
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

#	// Options
#	var shade, shadeEnabled;
#	var lastLine = 0;
#	var rotation = "cc";
#	var colorTheme = "iced";
#		$('canvas#canvas').attr('data-theme', colorTheme);
#
#	// Graphics
	graphics = {iced: {}, classic: {o: [], t: []}}
	#var loadGameGraphics = function(){
		#ui.loader.needed(2 + colors.length * 2);

		# Iced
	graphics.iced.o = new Image()
	graphics.iced.o.src = "g/material/iced-o.png"
	graphics.iced.o.onload = ->
		#ui.loader.tick();
	graphics.iced.t = new Image()
	graphics.iced.t.src = "g/material/iced-t.png"
	graphics.iced.t.onload = ->
		#ui.loader.tick();

	for n, color of colors
		graphics.classic.o[n] = new Image()
		graphics.classic.o[n].src = "g/material/classic-o-" + color + ".png"
		graphics.classic.o[n].onload = ->
			#ui.loader.tick();
		graphics.classic.t[n] = new Image()
		graphics.classic.t[n].src = "g/material/classic-t-" + color + ".png"
		graphics.classic.t[n].onload = ->
				#ui.loader.tick();

	# Request Animation Frame pollyfill
	window.requestAnimFrame = (->
		window.requestAnimationFrame ||
		window.mozRequestAnimationFrame ||
		window.msRequestAnimationFrame ||
		window.oRequestAnimationFrame ||
		window.webkitRequestAnimationFrame ||
		(callback) -> window.setTimeout(callback, 1000 / 60)
	)()

	window.cancelAnimFrame = (->
		window.cancelAnimationFrame ||
		window.mozCancelAnimationFrame ||
		window.msCancelAnimationFrame ||
		window.oCancelAnimationFrame ||
		window.webkitCancelAnimationFrame ||
		window.clearTimeout
	)()
#
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
#
	init = ->
		#do defaults
		# Dimensions of the board
		o.width  = 24 if typeof o.width  is øs
		o.height = 17 if typeof o.height is øs
		# Set of pieces
		o.set = 'extended' if typeof o.set  is øs
		# Theme
		o.theme = 'iced' if typeof o.theme  is øs
		# Consistent colors
		o.ccolorsOn = true if typeof o.ccolorsOn is øs
		# Shade
		o.shadeOn   = true if typeof o.shadeOn   is øs

		shapes = sets[o.set]

		map = new Map(o.width, o.height)
	#	map = new Map(o.width, o.height, entropy)

		# Set game state to ACTIVE
		state = GSACTIVE

		# Generate FIRST piece and SHADE if enabled
		current => do makeNext
		do makeShade if o.shadeOn

		do repaint

		next = do makeNext

		clock = requestAnimFrame(pulse)
#		fps_clk = setInterval(function() { $('.fpsmetter').html(fps + " FPS"); fps = 0; }, 1000);

		return

	pulse = ->
		clock = requestAnimFrame(pulse)

		if state is GSACTIVE

			if delay > fallDelay
				delay = 0

				if canFall(current)
					current.j++
				else
					#mark(1 + dropBonus, 'pulse');

					# If freeze returns false the game is over
					if freeze(current) == false
						do gameOver
						return

					#dropBonus = 0;

					current = next
					next = do makeNext

					do makeShade if o.shadeOn

				repaint();

			fps++
			delay++

#	var aborted = function() {
#		cancelAnimFrame(clk);
#		clearInterval(fps_clk);
#		$('.fpsmetter').html("0 FPS");
#
#		gameState = S_OVER;
#		repaint();
#	}
#
#	var gameOver = function() {
#		aborted();
#
#		console.log("Juego acabado");
#	}
#
#	var endGame = function() {
#		aborted();
#
#		console.log("Juego abortado");
#	}
#	Game.prototype.endGame = endGame;
#
#
#	Game.prototype.right = function () {
	#		if (gameState == S_OVER)
	#			return;
	#
	#		if (gameState == S_PAUSED)
	#			pauseGame(false);
	#
	#		if (canRight()) {
	#			current.i++;
	#
	#			if (shadeEnabled)
	#				createShade();
	#
	#			repaint();
	#		}
	#	}
	#
#	Game.prototype.left = function () {
	#		if (gameState == S_OVER)
	#			return;
	#
	#		if (gameState == S_PAUSED)
	#			pauseGame(false);
	#
	#		if (canLeft()) {
	#			current.i--;
	#
	#			if (shadeEnabled)
	#				createShade();
	#
	#			repaint();
	#		}
	#	}
#	var canRight = function () {
	#		if (current.i + current.form[0].length + 1 > width)
	#			return false;
	#
	#		for (j = 0; j < current.form.length; j++) {
	#			for (i = current.form[0].length - 1; i > -1; i--) {
	#				if (current.form[j][i] != 0) {
	#
	#					if (current.j + j-1 > -1 && map[current.j + j][current.i + i + 1].mat != 0)
	#						return false;
	#
	#					break;
	#
	#				}
	#			}
	#		}
	#
	#		return true;
	#	}
#	var canLeft = function () {
	#		if (current.i - 1 < 0)
	#			return false;
	#
	#		for (j = 0; j < current.form.length; j++) {
	#			for (i = 0; i < current.form[0].length; i++) {
	#				if (current.form[j][i] != 0) {
	#
	#					if (current.j + j-1 > -1 && map[current.j + j][current.i + i - 1].mat != 0)
	#						return false;
	#
	#					break;
	#
	#				}
	#			}
	#		}
	#
	#		return true;
	#	}
	#
#	var rotateC = function () {
	#		if (gameState == S_OVER)
	#			return;
	#
	#		if (gameState == S_PAUSED)
	#			pauseGame(false);
	#
	#		aux = new Array(current.form[0].length);
	#
	#		for (j = 0; j < aux.length; j++)
	#			aux[j] = new Array(current.form.length);
	#
	#		k = 0;
	#		for (j = current.form.length - 1; j > -1; j--) {
	#			for (i = 0; i < current.form[j].length; i++) {
	#				aux[i][k] = current.form[j][i];
	#			}
	#			k++;
	#		}
	#
	#		if (canRotate(aux)) {
	#			current.form = aux;
	#
	#			if (shadeEnabled)
	#				createShade();
	#
	#			repaint();
	#		}
	#	}
	#	Game.prototype.rotateC = rotateC;
	#
#	var rotateCC = function () {
	#		if (gameState == S_OVER)
	#			return;
	#
	#		if (gameState == S_PAUSED)
	#			pauseGame(false);
	#
	#		aux = new Array(current.form[0].length);
	#
	#		for (j = 0; j < aux.length; j++)
	#			aux[j] = new Array(current.form.length);
	#
	#		k = current.form[0].length - 1;
	#		for (j = 0; j < aux.length; j++) {
	#			for (i = 0; i < aux[0].length; i++) {
	#				aux[j][i] = current.form[i][k];
	#			}
	#			k--;
	#		}
	#
	#		if (canRotate(aux)) {
	#			current.form = aux;
	#
	#			if (shadeEnabled)
	#				createShade();
	#			
	#			repaint();
	#		}
	#	}
	#	Game.prototype.rotateCC = rotateCC;
	#
#	Game.prototype.rotate = function () {
	#		//if (options.rotation == "c")
	#			rotateC();
	#		//else
	#			//rotateCC();
	#	}
	#
#	var canRotate = function (aux) {
	#		for (j = 0; j < aux.length; j++) {
	#			for (i = 0; i < aux[0].length; i++) {
	#
	#				if (aux[j][i] != 0 && (current.j + j > 0)) {
	#					if (typeof map[current.j + j] == 'undefined' || typeof map[current.j + j][current.i + i] == 'undefined' || map[current.j + j][current.i + i].mat != 0)
	#						return false;
	#				}
	#
	#			}
	#		}
	#
	#		return true;
	#	}
#	Game.prototype.drop = function () {
	#		if (gameState == S_OVER)
	#			return;
	#
	#		if (gameState == S_PAUSED)
	#			pauseGame(false);
	#
	#		j1 = current.j;
	#
	#		while (canFall(current))
	#			current.j++;
	#
	#		//mark((current.j - j1) + Math.floor((current.j - j1) / 2) + 1 + dropBonus, 'drop');
	#		if ( !freeze(current) ) {  // false -> game over
	#			gameOver();
	#			return;
	#		}
	#		//dropBonus = 0;
	#
	#		current = next;
	#		next = chooseNext();
	#
	#		if (shadeEnabled)
	#			createShade();
	#		
	#		repaint();
	#
	#		//> Reset pulse
	#		delay = 0;
	#	}

	freeze = (piece) ->
	#	for (j = piece.form.length - 1; j >= 0; j--) {
	#		for (i = 0; i < piece.form[j].length; i++) {
	#			if (piece.form[j][i] != 0) {
#
	#				if (piece.j + j > -1)
	#					map[piece.j + j][piece.i + i].mat = piece.mat;
	#					map[piece.j + j][piece.i + i].col = piece.col;
	#				else
	#					return false
	#			}
	#		}
	#	}

		topLine = Math.min(current.j, topLine)

		#do checkLine

		return true

#	var checkLine = function () {
#		var _lines = 0;
#
#		for (j = current.form.length - 1; j >= 0; j--) {
#
#			var n = 0;
#			for (var i = 0; i < width; i++) {
#				if (map[current.j + j][i].mat == 0)
#					break;
#				else
#					n++;
#			}
#
#			if (n == width) {
#				for (var j_involved = current.j + j; j_involved > lastLine; j_involved--) {
#					for (var i = 0; i < width; i++){
#						map[j_involved][i].mat = map[j_involved - 1][i].mat;  // IT CAN FAIL!
#						map[j_involved][i].col = map[j_involved - 1][i].col;
#					}
#				}
#				for (var i = 0; i < width; i++){
#					map[lastLine][i].mat = 0;
#					map[lastLine][i].col = 0;
#				}
#				lastLine++;
#				j++;
#
#				_lines++;
#			}
#
#		}
#
#		if (_lines > 0) {
#			fsum = [10, 25, 75, 300];
#			//p = fsum[_lines - 1] * (level + 1);
#			//mark(p, "line", _lines);
#		}
#	}

	makeShade = ->
		shade = clone(current)
		do shade.j++ while canFall(shade)
		return

	canFall = (piece) ->
		if (piece.j + piece.shape.s.length) == o.height
			return false

		for i in [0...piece.shape.s[0].length]
			for j in [piece.shape.s.length-1..0] 
				if piece.shape.s[j][i] != 0

					if piece.j+j+1 > -1 && map.material(piece.i+i, piece.j+j + 1) != 0
						return false

		return true

	repaint = ->
		context.clearRect(0, 0, canvas.width, canvas.height);

		size = $(canvas).innerHeight() / o.height;

		# Paint map
		for j in [0...map.height()]
			for i in [0...map[0].width()]
				if map.index(i,j).material != 0
					context.drawImage(chooseImage.mapped(i, j), size * i, size * j, size, size)

		# Paint current
		#if state != GSOVER
		#	for j in [0...current.h]
		#		for i in [0...current.w]
		#			if current.b(i,j) == 1
		#				context.drawImage(chooseImage.current(), (i * size) + (current.i * size), (j * size) + (current.j * size), size, size);

#		// Paint shade
#		if (gameState != S_OVER && shadeEnabled && shade !== undefined && current.j != shade.j)
#			for (j = 0; j < shade.form.length; j++)
#				for (i = 0; i < shade.form[j].length; i++)
#					if (shade.form[j][i] == 1)
#						out.drawImage(chooseImage.shade(), (i * size) + (shade.i * size), (j * size) + (shade.j * size), size, size);
#
#		$('.fpsmetter').addClass('rp');
#		setTimeout(function() { $('.fpsmetter').removeClass('rp'); }, 20);

	`var chooseImage = {
		current: function(){
			if (colorTheme == "sclassic"){
				if (gameState == 2)
					return graphics.classic.o[current.col];
				else
					return graphics.classic.t[current.col];
			} else {
				if (gameState == 2)
					return graphics.iced.o;
				else
					return graphics.iced.t;
			}
		},
		shade: function(){
			if (colorTheme == "classic"){
				return graphics.classic.t[current.col]
			} else {
				return graphics.iced.t;
			}
		},
		next: function(){
			if (colorTheme == "classic"){
				return graphics.classic.o[next.col];
			} else {
				return graphics.iced.o;
			}	
		},
		mapped: function(i, j){
			if (colorTheme == "classic"){
				if (gameState == 2)
					return graphics.classic.o[map[j][i].col];
				else
					return graphics.classic.t[map[j][i].col];
			} else {
				if (gameState == 2)
					return graphics.iced.o;
				else
					return graphics.iced.t;
			}	
		}
	}`

	makeNext = (first, paintOnly) ->
		rndShape = Math.round(Math.random() * (shapes.length - 1))
		# Board.w/2 - Piece.w/2
		iSource = Math.round(o.width / 2) - Math.round(shapes[rndShape].length / 2)
		# Negative Piece.h
		jSource = shapes[rndShape].length * -1

		piece = {
			i: iSource,
			j: jSource,
			w: shapes[rndShape][0].length,
			h: shapes[rndShape].length,
			t: 1,
			shape: shapes[rndShape]
		}

		if o.ccolorsOn && (o.set is 'classic' || o.set is 'extended')
			piece.c = colors[ rndShape ]
		else
			piece.c = colors[ Math.round(Math.random() * (colors.length - 1)) ]


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

	pauseGame = (force) ->
		if force == false

			if state == GSPAUSED
				state = GSACTIVE
				repaint()

		else if force == true

			if state == GSACTIVE
				state = GSPAUSED
				repaint()

		else

			if state == GSPAUSED
				state = GSACTIVE
				repaint()
			else if state == GSACTIVE
				state = GSPAUSED
				repaint()
			
#		//if (gameState == S_PAUSED) {
#		//	$("#big-paused").fadeIn(200);
#		//} else if (gameState == S_ACTIVE) {
#		//	$("#big-paused").fadeOut(200);
#		//}
		return

#
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
#		limitDelay = normalDelay;
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
	clone = (obj) ->
		if null == obj || "object" != typeof obj
			return obj 

		if obj instanceof Date
			copy = new Date()
			copy.setTime(obj.getTime())
			return copy

		if obj instanceof Array
			copy = []
			len = obj.length
			for i in [0...len]
				copy[i] = clone(obj[i])
			return copy
		
		if obj instanceof Object
			copy = {}
			for attr of obj when obj.hasOwnProperty(attr)
				copy[attr] = clone(obj[attr])
			return copy

		throw new Error("Unable to copy obj! Its type isn't supported.");
	
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
#/*	var setEvents = function() {
#		window.onresize = function() {
#			adjust();
#		}
#		adjust();
#
#		document.onkeyup = function(e) {
#			if (e.keyCode == 40 || e.keyCode == 98)
#				limitDelay = normalDelay;
#			if (e.keyCode == 88)
#				rotateC();
#			if (e.keyCode == 90)
#				rotateCC();
#			if (e.keyCode == 38 || e.keyCode == 104) //default
#				rotate();
#			if (e.keyCode == 32 || e.keyCode == 96)
#				drop();
#			if (e.keyCode == 78 || e.keyCode == 105)
#				newGame();
#		}
#
#		document.onkeydown = function(e) {
#			if (e.keyCode == 39 || e.keyCode == 102)
#				right();
#			if (e.keyCode == 37 || e.keyCode == 100)
#				left();
#			if (e.keyCode == 80 || e.keyCode == 103)
#				pause();
#			if (e.keyCode == 40 || e.keyCode == 98) {
#				if (gameStatus < 2)
#					return;
#				if (gameStatus == 2)
#					pause();
#				limitDelay = 1;
#			}
#		}
#
#		window.onbeforeunload = saveToLS;
#
#		setOSDMessages();
#	}*/
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
	@pauseGame = pauseGame
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