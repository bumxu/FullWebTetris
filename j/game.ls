class Game
	# Math
	o  = void
	π  = Math.PI
	ø  =  undefined
	øs = 'undefined'

	# Canvas
	canvas  = $('#board canvas').get(0)
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
	sets.testing   = [[[1 1 1 1] [1 1 1 1] [1 1 1 1] [1 1 1 1]]]
	sets.classic   = [[[1,1,0],[0,1,1]],[[0,1,1],[1,1,0]],[[1,1],[1,1]],[[1,1,1,1]],[[0,1,0],[1,1,1],[0,0,0]],[[1,0,0],[1,1,1],[0,0,0]],[[0,0,1],[1,1,1],[0,0,0]]]
	sets.extended  = sets.classic ++ [[[1,0],[1,1]],[[0,1],[1,1]],[[1]],[[1,1]]]
	sets.challenge = sets.extended ++ [[[0,1,0],[1,1,1],[0,1,0]],[[0,1,1],[0,1,1],[1,1,0]],[[1,1,0],[1,1,0],[0,1,1]],[[0,1,1],[0,1,1],[1,1,1]],[[1,1,0],[1,1,0],[1,1,1]],[[1,1,1],[1,1,0]],[[1,1,0],[1,1,1]],[[1,0,1],[1,1,1]],[[1,1,1]],[[0,0,1],[1,1,1],[1,0,0]],[[1,0,0],[1,1,1],[0,0,1]],[[1,0,0],[1,1,0],[1,1,1]],[[0,0,1],[0,1,1],[1,1,1]],[[0,1,0],[1,1,1],[1,1,0]],[[0,1,0],[1,1,1],[0,1,1]]]
	sets.lethal    = sets.challenge ++ [[[1,1,1],[1,1,0],[0,1,1]],[[1,1,1],[0,1,1],[1,1,0]],[[1,1,0],[0,1,1],[1,1,0]],[[1,1,0],[1,1,1],[0,1,1]],[[1,1,1,1,1,1,1,1]],[[0,0,1],[0,1,0],[1,0,0]],[[1,0,1],[0,1,0],[1,0,1]],[[0,0,1],[0,1,0],[1,0,1]],[[0,1,1],[1,1,0],[1,0,0]],[[0,1],[1,0]],[[0,1],[1,1],[1,1],[0,1],[0,1]],[[1,0],[1,1],[1,1],[1,0],[1,0]],[[0,1],[1,1],[1,1],[0,1],[1,1]],[[1,1],[1,0],[1,1],[1,0],[1,1]],[[1,1],[1,0],[0,1],[1,0],[0,1]],[[1,0],[1,1],[1,1],[1,0],[1,1]],[[1,1],[0,1],[1,0],[0,1],[1,0]],[[1,1,1],[1,0,1],[1,1,1]],[[1,1,1],[0,0,1],[1,1,1]],[[1,1,0],[1,0,1],[1,0,1]],[[1,1,0],[1,1,1],[1,0,1]],[[0,1,1],[1,0,1],[1,0,1]],[[0,1,1],[1,1,1],[1,0,1]],[[0,1,0],[1,1,1],[1,0,1]],[[1,1,1],[0,1,0],[1,1,1]]]

	# Colors
	colors = ['red' 'green' 'blue' 'cyan' 'purple' 'orange' 'yellow' 'brown' 'emerald' 'pink' 'white']

	# Pieces var declaration
	shapes = current = next = shade = void

############################ TEMPORAL ############################
	defImg = new Image()
	defImg.src = "g/material/iced-o.png"
	defImg.width = 124
	defImg.height = 124
#	var colorTheme = "iced";
#		$('canvas#canvas').attr('data-theme', colorTheme);
#
#	# Graphics
#	graphics = {iced: {}, classic: {o: [], t: []}}
#	#var loadGameGraphics = function(){
#		#ui.loader.needed(2 + colors.length * 2);
#
#		# Iced
#	graphics.iced.o = new Image()
#	graphics.iced.o.src = "g/material/iced-o.png"
#	graphics.iced.o.onload = ->
#		#ui.loader.tick();
#	graphics.iced.t = new Image()
#	graphics.iced.t.src = "g/material/iced-t.png"
#	graphics.iced.t.onload = ->
#		#ui.loader.tick();
#
#	for n, color of colors
#		graphics.classic.o[n] = new Image()
#		graphics.classic.o[n].src = "g/material/classic-o-" + color + ".png"
#		graphics.classic.o[n].onload = ->
#			#ui.loader.tick();
#		graphics.classic.t[n] = new Image()
#		graphics.classic.t[n].src = "g/material/classic-t-" + color + ".png"
#		graphics.classic.t[n].onload = ->
#				#ui.loader.tick();
############################ TEMPORAL ############################

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

##################################################################

	(options) ->
		o := options
		do odefault

		shapes := sets[o.set]

		{map, topLine} := makeMap(o.mapPad)

		# Set game state to ACTIVE
		state := GSACTIVE

		# Generate FIRST piece and SHADE if enabled
		current := makeNext!
		if o.shadeOn then makeShade!

		repaint!

		next := makeNext!

		clock := requestAnimFrame(pulse)
		#fps_clk := setInterval(function() { $('.fpsmetter').html(fps + " FPS"); fps = 0; }, 1000);

	odefault = !->
		# Dimensions of the board
		o.width  = 16 if udf o.width
		o.height = 24 if udf o.height
		o.mapPad = 0  if udf o.mapPad

		# Set of pieces
		o.set = 'extended' if udf o.set

		# Rotate direction
		o.rotate = 'cc' if udf o.rotate

		# Theme
		o.theme = 'iced' if udf o.theme

		# Consistent colors
		o.ccolorsOn = true if udf o.ccolorsOn

		# Shade
		o.shadeOn = false if udf o.shadeOn

		# Zero gravity
		o.zerogOn = false if udf o.zerogOn

	loadResources = (callback) ->


	hellShape = ->
		rx = Math.round(Math.random() * 510 + 1).toString(2)
		rx = ('000000000' + rx).slice(-9)
		z  = 0

		row = -> for til 3 then Number( rx[z++] )

		for til 3 then row!

	pulse = !->
		clock := requestAnimFrame(pulse)

		if state is GSACTIVE

			if delay > fallDelay
				delay := 0

				if canFall(current)
					current.j++
				else
					#mark(1 + dropBonus, 'pulse');

					# If freeze returns false the game is over
					if freeze(current) is no
						gameOver!
						return

					#dropBonus = 0;

					current := next
					next    := makeNext!

					do makeShade if o.shadeOn

				repaint!

			fps++
			delay++

	aborted = ->
		cancelAnimFrame(clock)
		#clearInterval(fps_clk);
		#$('.fpsmetter').html("0 FPS");

		state := GSOVER
		repaint!

		return true

	gameOver = ->
		console.log "Game over"
		aborted!

	endGame = ->
		console.log "Game interrupted"
		aborted!

	right = ->
		if state is GSOVER 	then return false
		if state is GSPAUSED then pauseGame(off)

		if canRight!
			current.i++

			do makeShade if o.shadeOn
			do repaint

			return true

		return false

	left = ->
		if state is GSOVER 	then return false
		if state is GSPAUSED then pauseGame(off)

		if do canLeft
			current.i--

			do makeShade if o.shadeOn
			do repaint

			return true

		return false

	canRight = ->
		# Right wall collision // Not used with new shape matrix
		#if current.i + current.w + 1 > o.width then return false

		# Other collision
		for j from 0 til current.h
			for i from current.w-1 to 0 by -1 when current._(i,j) is not 0

				mi = current.i + i + 1
				mj = current.j + j

				if mi >= o.width or (current.j + j-1 > -1) and (map[mj][mi] is not null and map[mj][mi].t is 1)
					return false

				break

		# No collision
		return true

	canLeft = ->
		# Left wall collision // Not used with new shape matrix
		#if current.i - 1 < 0 then return false

		# Other collision
		for j from 0 til current.h
			for i from 0 til current.w when current._(i,j) is not 0

				mi = current.i + i - 1
				mj = current.j + j

				if mi <= -1 or (current.j + j-1 > -1) and (map[mj][mi] is not null and map[mj][mi].t is 1)
					return false

				break

		# No collision
		return true

	#rotateC = ->
	#	if state is GSOVER 	then return false
	#	if state is GSPAUSED then pauseGame(false)
#
	#	aux = new Array(current.w)
#
	#	for (j = 0; j < aux.length; j++)
	#		aux[j] = []#new Array(current.form.length);
#
	#	k = 0;
	#	for (j = current.form.length - 1; j > -1; j--) {
	#		for (i = 0; i < current.form[j].length; i++) {
	#			aux[i][k] = current.form[j][i];
	#		}
	#		k++;
	#	}
#
	#	if canRotate(aux)
	#		current.form = aux  #!
#
	#		if (shadeEnabled)
	#			createShade();
#
	#		repaint();
	#	}
	#}
	#Game.prototype.rotateC = rotateC;

	# ONLY FOR TESTING PURPOSES
	rotateCC = ->
		if state is GSOVER 	then return false
		if state is GSPAUSED then pauseGame(off)

		aux = new Array(current.w)

		for j til aux.length
			aux[j] = new Array(current.h)

		k = current.w - 1;
		for j til aux.length
			for i til aux[0].length
				aux[j][i] = current._(k,i)
			k--

		#if canRotate(aux)
		current.s = aux
		_ = current.w
		current.w = current.h
		current.h = _

		do makeShade if o.shadeOn
		do repaint

		return true

		return false

	rotate = ->
		if o.rotate is 'c'
			rotateC!
		else
			rotateCC!

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

	fastSpeed = ->
		if state is GSOVER 	then return false
		if state is GSPAUSED then pauseGame(off)

		fallDelay := 1
		return true

	normalSpeed = ->
		fallDelay := normalDelay
		return true

	drop = ->
		if state is GSOVER 	then return false
		if state is GSPAUSED then pauseGame(off)

		#j1 = current.j

		while canFall(current) then current.j++

		#mark((current.j - j1) + Math.floor((current.j - j1) / 2) + 1 + dropBonus, 'drop');
		if freeze(current) is false
			return gameOver!

		#dropBonus = 0;

		current := next
		next    := makeNext!

		do makeShade if o.shadeOn
		do repaint

		delay := 0   # Reset pulse

		return true

	freeze = (piece) ->
		for j from piece.h-1 to 0 by -1
			for i from 0 til piece.w when piece._(i,j) is not 0

				if piece.j + j > -1
					map[piece.j + j][piece.i + i] = { t: piece.t, c: piece.c }
				else
					return false

		topLine := current.j <? topLine   # Minimum

		checkLine!

		return true

	checkLine = !->
		lines = []

		# Search for lines in every row of current piece, upward.
		for row from (current.j + current.h-1) to current.j by -1
			# Out of map
			continue if row >= 24

			# Number of tiles per line must be
			# equal to the width of the map.
			nTiles = 0
			for col til o.width
				if map[row][col] is null
				then break
				else nTiles++

			if nTiles == o.width
				lines.push(row)

		lines.push(topLine-1)

		if lines.length is 1 then return false


		for itv from 0 til lines.length
			# Remove lines
			for col til o.width
				try map[(lines[itv])][col] = null

			# Prepare for animation
			for row from lines[itv]-1 til lines[itv+1] by -1
				console.log('Fila ' + row + ' deberá bajar ' + (itv+1))
				for col til o.width
					if map[row][col] is not null
						map[row][col].t$ = itv+1
						map[row][col].o$ = 0

		# Animate
		cancelAnimFrame(clock)

		mods = 1
		anim = !->

			if mods > 0
				requestAnimFrame(anim)
			else
				clock := requestAnimFrame(pulse)
				return

			mods := 0

			for row from lines[0]-1 to topLine by -1
				for col til o.width
					if map[row][col] is not null and map[row][col].t$ is not 0
						if map[row][col].o$ < map[row][col].t$
							map[row][col].o$ = Math.floor((map[row][col].o$ + 0.25)*100)/100
							mods++
						# now:
						if map[row][col].o$ is map[row][col].t$
							t$ = map[row][col].t$
							map[row][col].t$ = 0
							map[row][col].o$ = 0
							map[row+t$][col] = clone(map[row][col])
							map[row][col] = null

			repaint!
		anim!

	# Deprecated
	checkLineOld = ->
		nLines = 0

		for cRow from current.h-1 to 0 by -1

			nTiles = 0
			for mCol til o.width
				if map[current.j + cRow][mCol] is null
					break
				else
					nTiles++

			if nTiles == o.width
				for jInvolved from current.j+cRow til topLine by -1
					for i from 0 til o.width
						map[jInvolved][i] = clone(map[jInvolved - 1][i])

				for i from 0 til o.width
					map[topLine][i] = null

				topLine++
				cRow++

				nLines++

		if nLines > 0
			fsum = [10 25 75 300]
			#p = fsum[nLines - 1] * (level + 1);
			#mark(p, "line", nLines);
			return true

		return false

	makeShade = ->
		shade := clone(current)
		while canFall(shade)
			shade.j++
		return

	makeMap = (pad) ->
		if typeof pad is \undefined
			pad = 0

		_row0 = -> for til o.width then null

		_rowX = ->
			for til o.width
				if Math.round(Math.random()) is 1
					{t: 1, c: 'black'}
				else
					null

		m0 = for til o.height - pad then _row0!
		mX = for til pad then _rowX!

		return {map: m0 ++ mX, topLine: o.height-1}

	canFall = (piece) ->
		# Floor collision
		#if piece.j + piece.h == o.height then return false

		# Other collision
		for i from 0 til piece.w
			for j from piece.h-1 to 0 by -1
				if piece._(i,j) is not 0 and piece.j+j+1 > -1
					mi = piece.i+i
					mj = piece.j+j + 1

					if mj >= o.height or (map[mj][mi] is not null and map[mj][mi].t) is 1
						return false

		# No collision
		return true

	repaint = !->
		context.clearRect(0, 0, canvas.width, canvas.height)

		size = canvas.height / o.height;

		# Paint map
		for j from 0 til o.height
			for i from 0 til o.width when map[j][i] is not null
				x = size * i
				y = size * if o.zerogOn then (o.height-1 - j) else j
				o$ = if typeof map[j][i].o$ is not 'undefined' then (size * map[j][i].o$) else 0

				#chooseImage.mapped(i, j)
				context.drawImage(defImg, x, y + o$, size, size)

		# Paint current
		if state is not GSOVER
			for j from 0 til current.h
				for i from 0 til current.w when current._(i,j) is 1
					x = 	(i * size) + (current.i * size)
					y =  	size * (if o.zerogOn then (current.h-1 - j) else j) +
							size * (if o.zerogOn then (o.height-1 - current.j) else current.j)

					context.drawImage(defImg, x, y, size, size)

#		# Paint shade
#		#if (gameState != S_OVER && shadeEnabled && shade !== undefined && current.j != shade.j)
#		#	for (j = 0; j < shade.form.length; j++)
#		#		for (i = 0; i < shade.form[j].length; i++)
#		#			if (shade.form[j][i] == 1)
#		#				out.drawImage(chooseImage.shade(), (i * size) + (shade.i * size), (j * size) + (shade.j * size), size, size);
#
#		# <ui>
#		#$('.fpsmetter').addClass('rp');
#		#setTimeout(function() { $('.fpsmetter').removeClass('rp'); }, 20);
#
#		return
#
#	`var chooseImage = {
#		current: function(){
#			if (colorTheme == "sclassic"){
#				if (gameState == 2)
#					return graphics.classic.o[current.col];
#				else
#					return graphics.classic.t[current.col];
#			} else {
#				if (gameState == 2)
#					return graphics.iced.o;
#				else
#					return graphics.iced.t;
#			}
#		},
#		shade: function(){
#			if (colorTheme == "classic"){
#				return graphics.classic.t[current.col]
#			} else {
#				return graphics.iced.t;
#			}
#		},
#		next: function(){
#			if (colorTheme == "classic"){
#				return graphics.classic.o[next.col];
#			} else {
#				return graphics.iced.o;
#			}
#		},
#		mapped: function(i, j){
#			if (colorTheme == "classic"){
#				if (gameState == 2)
#					return graphics.classic.o[map[j][i].col];
#				else
#					return graphics.classic.t[map[j][i].col];
#			} else {
#				if (gameState == 2)
#					return graphics.iced.o;
#				else
#					return graphics.iced.t;
#			}
#		}
#	}`
#
	makeNext = (first, paintOnly) ->
		rndShape = Math.round(Math.random() * (shapes.length - 1))
		shape = shapes[rndShape] /*hellShape! #*/
		# Axis i origin = Board.w/2 - Piece.w/2
		iSource = Math.round(o.width / 2) - Math.round(shape.length / 2)
		# Axis j origin = Negative Piece.h
		jSource = shape.length * -1

		piece = {
			i: iSource
			j: jSource
			w: shape[0].length
			h: shape.length
			t: 1
			s: shape
			_: (a,b) -> @s[b][a]
		}

		if o.ccolorsOn and (o.set is 'classic' or o.set is 'extended')
			piece.c = colors[ rndShape ]
		else
			piece.c = colors[ Math.round(Math.random() * (colors.length - 1)) ]

		return piece

	pauseGame = (force) !->
		if force is false

			if state is GSPAUSED
				state := GSACTIVE
				repaint!

		else if force is true

			if state is GSACTIVE
				state := GSPAUSED
				repaint!

		else

			if state is GSPAUSED
				state := GSACTIVE
				repaint!
			else if state is GSACTIVE
				state := GSPAUSED
				repaint!

		# <ui>
		#if state is GSPAUSED
		#	$("#big-paused").fadeIn(200)
		#else if state is GSACTIVE
		#	$("#big-paused").fadeOut(200)

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
			for i from 0 til len
				copy[i] = clone(obj[i])
			return copy

		if obj instanceof Object
			copy = {}
			for attr of obj when obj.hasOwnProperty(attr)
				copy[attr] = clone(obj[attr])
			return copy

		throw new Error("Unable to copy obj! Its type isn't supported.");

	udf = (a) -> typeof a is 'undefined'

############################# PUBLIC #############################
	pauseGame : pauseGame
	endGame : endGame

	left : left
	right : right
	rotate : rotate

	fastSpeed : fastSpeed
	normalSpeed : normalSpeed
	drop : drop
