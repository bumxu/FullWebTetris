
console.log "\nFull Web Tetris 3"
console.log " By Juande Martos\n Copyright © 2013 Bumxu\n Licensed under the GPLv3 license\n"

class Piece
	types = {
		classic: [[[1, 1, 0], [0, 1, 1]], [[0, 1, 1], [1, 1, 0]], [[1, 1], [1, 1]], [[1, 1, 1, 1]], [[0, 1, 0], [1, 1, 1]], [[1, 0, 0], [1, 1, 1]], [[0, 0, 1], [1, 1, 1]]],
		full: [[[1, 1, 0], [0, 1, 1]], [[0, 1, 1], [1, 1, 0]], [[1, 1], [1, 1]], [[1]], [[1, 1, 1, 1]], [[0, 1, 0], [1, 1, 1]], [[1, 0, 0], [1, 1, 1]], [[0, 0, 1], [1, 1, 1]], [[1, 0], [1, 1]], [[0, 1], [1, 1]]],
		challenge: [[[1, 1, 0], [0, 1, 1]], [[0, 1, 0], [1, 1, 1], [0, 1, 0]], [[0, 1, 1], [0, 1, 1], [1, 1, 0]], [[0, 1, 1], [0, 1, 1], [1, 1, 1]], [[1, 1, 1], [1, 1, 0], [0, 1, 1]], [[1, 1, 0], [0, 1, 1], [1, 1, 0]], [[0, 1, 1], [1, 1, 0]], [[1, 1], [1, 1]], [[1]], [[1, 1]], [[1, 1, 1]], [[1, 1, 1], [1, 0, 1]], [[1, 1, 1, 1]], [[0, 1, 0], [1, 1, 1]], [[1, 0, 0], [1, 1, 1]], [[0, 0, 1], [1, 1, 1]], [[1, 0], [1, 1]], [[0, 1], [1, 1]]],
		lethal: [[[1, 1, 0], [0, 1, 1]], [[0, 1, 0], [1, 1, 1], [0, 1, 0]], [[0, 1, 1], [0, 1, 1], [1, 1, 0]], [[0, 1, 1], [0, 1, 1], [1, 1, 1]], [[1, 1, 1], [1, 1, 0], [0, 1, 1]], [[1, 1, 0], [0, 1, 1], [1, 1, 0]], [[0, 1, 1], [1, 1, 0]], [[1, 1], [1, 1]], [[1]], [[1, 1]], [[1, 1, 1]], [[1, 1, 1, 1, 1, 1, 1, 1]], [[1, 1, 1],[1, 0, 1]], [[1, 1, 1, 1]], [[0, 1, 0], [1, 1, 1]], [[1, 0, 0], [1, 1, 1]], [[0, 0, 1], [1, 1, 1]], [[1, 0], [1, 1]], [[0, 1], [1, 1]], [[0, 0, 1], [0, 1, 0], [1, 0, 0]], [[1, 0, 1], [0, 1, 0], [1, 0, 1]], [[0, 0, 1], [0, 1, 0], [1, 0, 1]], [[0, 1, 1], [1, 1, 0], [1, 0, 0]], [[0, 0, 1], [0, 1, 1], [1, 1, 0]], [[0, 1], [1, 0]], [[0, 1], [1, 1], [1, 1], [0, 1], [0, 1]], [[1, 0], [1, 1], [1, 1], [1, 0], [1, 0]], [[0, 1], [1, 1], [1, 1], [0, 1], [1, 1]], [[1, 1], [1, 0], [1, 1], [1, 0], [1, 1]], [[1, 1], [1, 0], [0, 1], [1, 0], [0, 1]], [[1, 1, 1], [1, 0, 1], [1, 1, 1]], [[1, 1, 1], [0, 0, 1], [1, 1, 1]], [[1, 1, 0], [1, 0, 1], [1, 0, 1]], [[1, 1, 0], [1, 1, 1], [1, 0, 1]], [[0, 1, 0], [1, 1, 1], [1, 0, 1]], [[0, 1, 1], [1, 0, 1], [1, 0, 1]], [[1, 1, 1], [0, 1, 0], [1, 1, 1]]]
	}

	constructor: () ->

class Game
	width = 16
	height = 24
	map = []

	constructor: () ->
		# Create map of request size
		map = new Array(height);

		for j in [0 .. map.length-1]
			map[j] = new Array(width)

			for i in [0 .. map[j].length-1]
				map[j][i] = { mat: 0, col: 0 }


		clock = window.requestAnimationFrame(pulse)

	hciRight: () ->

	pulse = ->
		console.log "hola"

		repaint()

		clock = window.requestAnimationFrame(pulse)
		return




	window.requestAnimationFrame ||= 
		window.webkitRequestAnimationFrame	|| 
		window.mozRequestAnimationFrame		|| 
		window.oRequestAnimationFrame		||
		window.msRequestAnimationFrame		|| 
		(callback, element) ->
			window.setTimeout( ->
				callback(+new Date())
			, 1000 / 60)

	window.cancelAnimationFrame ||= 
		window.webkitCancelAnimationFrame	|| 
		window.mozCancelAnimationFrame		|| 
		window.oCancelAnimationFrame		||
		window.msCancelAnimationFrame		|| 
		window.clearTimeout			


gameCore = new Game
console.log gameCore