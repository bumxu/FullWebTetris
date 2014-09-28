var Game, Map;

Map = (function() {
  var map;

  map = void 0;

  function Map(w, h) {
    var r, _;
    r = (function() {
      var _i, _results;
      _results = [];
      for (_ = _i = 1; 1 <= w ? _i < w : _i > w; _ = 1 <= w ? ++_i : --_i) {
        _results.push(0);
      }
      return _results;
    })();
    map = (function() {
      var _i, _results;
      _results = [];
      for (_ = _i = 1; 1 <= h ? _i < h : _i > h; _ = 1 <= h ? ++_i : --_i) {
        _results.push(r);
      }
      return _results;
    })();
  }

  Map.prototype.raw = function() {
    return map;
  };

  Map.prototype.index = function(i, j) {
    return map(j, i);
  };

  Map.prototype.material = function(i, j) {
    return map(j, i).material;
  };

  Map.prototype.width = function() {
    return map[0].length;
  };

  Map.prototype.height = function() {
    return map.length;
  };

  return Map;

})();

Game = function(o) {
  var GSACTIVE, GSOVER, GSPAUSED, canFall, canvas, clock, clone, color, colors, context, current, delay, fallDelay, fps, fps_clock, freeze, graphics, init, makeNext, makeShade, map, n, next, normalDelay, pauseGame, pulse, repaint, sets, shade, shapes, state, topLine, ø, øs, π;
  π = Math.PI;
  ø = void 0;
  øs = 'undefined';
  canvas = $('canvas#board').get(0);
  context = canvas.getContext('2d');
  map = ø;
  topLine = 0;
  clock = fps_clock = ø;
  fps = 0;
  state = ø;
  GSOVER = 0;
  GSPAUSED = 1;
  GSACTIVE = 2;
  delay = 0;
  fallDelay = normalDelay = 15;
  sets = {};
  sets.classic = [[[1, 1, 0], [0, 1, 1]], [[0, 1, 1], [1, 1, 0]], [[1, 1], [1, 1]], [[1, 1, 1, 1]], [[0, 1, 0], [1, 1, 1]], [[1, 0, 0], [1, 1, 1]], [[0, 0, 1], [1, 1, 1]]];
  sets.extended = sets.classic.concat([[[1, 0], [1, 1]], [[0, 1], [1, 1]], [[1]], [[0, 0], [1, 1]]]);
  sets.challenge = sets.extended.concat([[[0, 1, 0], [1, 1, 1], [0, 1, 0]], [[0, 1, 1], [0, 1, 1], [1, 1, 0]], [[1, 1, 0], [1, 1, 0], [0, 1, 1]], [[0, 1, 1], [0, 1, 1], [1, 1, 1]], [[1, 1, 0], [1, 1, 0], [1, 1, 1]], [[1, 1, 1], [1, 1, 0]], [[1, 1, 0], [1, 1, 1]], [[1, 0, 1], [1, 1, 1]], [[1, 1, 1]], [[0, 0, 1], [1, 1, 1], [1, 0, 0]], [[1, 0, 0], [1, 1, 1], [0, 0, 1]], [[1, 0, 0], [1, 1, 0], [1, 1, 1]], [[0, 0, 1], [0, 1, 1], [1, 1, 1]], [[0, 1, 0], [1, 1, 1], [1, 1, 0]], [[0, 1, 0], [1, 1, 1], [0, 1, 1]]]);
  sets.lethal = sets.challenge.concat([[[1, 1, 1], [1, 1, 0], [0, 1, 1]], [[1, 1, 1], [0, 1, 1], [1, 1, 0]], [[1, 1, 0], [0, 1, 1], [1, 1, 0]], [[1, 1, 0], [1, 1, 1], [0, 1, 1]], [[1, 1, 1, 1, 1, 1, 1, 1]], [[0, 0, 1], [0, 1, 0], [1, 0, 0]], [[1, 0, 1], [0, 1, 0], [1, 0, 1]], [[0, 0, 1], [0, 1, 0], [1, 0, 1]], [[0, 1, 1], [1, 1, 0], [1, 0, 0]], [[0, 1], [1, 0]], [[0, 1], [1, 1], [1, 1], [0, 1], [0, 1]], [[1, 0], [1, 1], [1, 1], [1, 0], [1, 0]], [[0, 1], [1, 1], [1, 1], [0, 1], [1, 1]], [[1, 1], [1, 0], [1, 1], [1, 0], [1, 1]], [[1, 1], [1, 0], [0, 1], [1, 0], [0, 1]], [[1, 0], [1, 1], [1, 1], [1, 0], [1, 1]], [[1, 1], [0, 1], [1, 0], [0, 1], [1, 0]], [[1, 1, 1], [1, 0, 1], [1, 1, 1]], [[1, 1, 1], [0, 0, 1], [1, 1, 1]], [[1, 1, 0], [1, 0, 1], [1, 0, 1]], [[1, 1, 0], [1, 1, 1], [1, 0, 1]], [[0, 1, 1], [1, 0, 1], [1, 0, 1]], [[0, 1, 1], [1, 1, 1], [1, 0, 1]], [[0, 1, 0], [1, 1, 1], [1, 0, 1]], [[1, 1, 1], [0, 1, 0], [1, 1, 1]]]);
  colors = ["red", "green", "blue", "cyan", "purple", "orange", "yellow", "brown", "emerald", "pink", "white"];
  shapes = current = next = shade = ø;
  graphics = {
    iced: {},
    classic: {
      o: [],
      t: []
    }
  };
  graphics.iced.o = new Image();
  graphics.iced.o.src = "g/material/iced-o.png";
  graphics.iced.o.onload = function() {};
  graphics.iced.t = new Image();
  graphics.iced.t.src = "g/material/iced-t.png";
  graphics.iced.t.onload = function() {};
  for (n in colors) {
    color = colors[n];
    graphics.classic.o[n] = new Image();
    graphics.classic.o[n].src = "g/material/classic-o-" + color + ".png";
    graphics.classic.o[n].onload = function() {};
    graphics.classic.t[n] = new Image();
    graphics.classic.t[n].src = "g/material/classic-t-" + color + ".png";
    graphics.classic.t[n].onload = function() {};
  }
  window.requestAnimFrame = (function() {
    return window.requestAnimationFrame || window.mozRequestAnimationFrame || window.msRequestAnimationFrame || window.oRequestAnimationFrame || window.webkitRequestAnimationFrame || function(callback) {
      return window.setTimeout(callback, 1000 / 60);
    };
  })();
  window.cancelAnimFrame = (function() {
    return window.cancelAnimationFrame || window.mozCancelAnimationFrame || window.msCancelAnimationFrame || window.oCancelAnimationFrame || window.webkitCancelAnimationFrame || window.clearTimeout;
  })();
  init = function() {
    if (typeof o.width === øs) {
      o.width = 24;
    }
    if (typeof o.height === øs) {
      o.height = 17;
    }
    if (typeof o.set === øs) {
      o.set = 'extended';
    }
    if (typeof o.theme === øs) {
      o.theme = 'iced';
    }
    if (typeof o.ccolorsOn === øs) {
      o.ccolorsOn = true;
    }
    if (typeof o.shadeOn === øs) {
      o.shadeOn = true;
    }
    shapes = sets[o.set];
    map = new Map(o.width, o.height);
    state = GSACTIVE;
    current((function(_this) {
      return function() {
        return makeNext();
      };
    })(this));
    if (o.shadeOn) {
      makeShade();
    }
    repaint();
    next = makeNext();
    clock = requestAnimFrame(pulse);
  };
  pulse = function() {
    clock = requestAnimFrame(pulse);
    if (state === GSACTIVE) {
      if (delay > fallDelay) {
        delay = 0;
        if (canFall(current)) {
          current.j++;
        } else {
          if (freeze(current) === false) {
            gameOver();
            return;
          }
          current = next;
          next = makeNext();
          if (o.shadeOn) {
            makeShade();
          }
        }
        repaint();
      }
      fps++;
      return delay++;
    }
  };
  freeze = function(piece) {
    topLine = Math.min(current.j, topLine);
    return true;
  };
  makeShade = function() {
    shade = clone(current);
    while (canFall(shade)) {
      (shade.j++)();
    }
  };
  canFall = function(piece) {
    var i, j, _i, _j, _ref, _ref1;
    if ((piece.j + piece.shape.s.length) === o.height) {
      return false;
    }
    for (i = _i = 0, _ref = piece.shape.s[0].length; 0 <= _ref ? _i < _ref : _i > _ref; i = 0 <= _ref ? ++_i : --_i) {
      for (j = _j = _ref1 = piece.shape.s.length - 1; _ref1 <= 0 ? _j <= 0 : _j >= 0; j = _ref1 <= 0 ? ++_j : --_j) {
        if (piece.shape.s[j][i] !== 0) {
          if (piece.j + j + 1 > -1 && map.material(piece.i + i, piece.j + j + 1) !== 0) {
            return false;
          }
        }
      }
    }
    return true;
  };
  repaint = function() {
    var i, j, size, _i, _ref, _results;
    context.clearRect(0, 0, canvas.width, canvas.height);
    size = $(canvas).innerHeight() / o.height;
    _results = [];
    for (j = _i = 0, _ref = map.height(); 0 <= _ref ? _i < _ref : _i > _ref; j = 0 <= _ref ? ++_i : --_i) {
      _results.push((function() {
        var _j, _ref1, _results1;
        _results1 = [];
        for (i = _j = 0, _ref1 = map[0].width(); 0 <= _ref1 ? _j < _ref1 : _j > _ref1; i = 0 <= _ref1 ? ++_j : --_j) {
          if (map.index(i, j).material !== 0) {
            _results1.push(context.drawImage(chooseImage.mapped(i, j), size * i, size * j, size, size));
          } else {
            _results1.push(void 0);
          }
        }
        return _results1;
      })());
    }
    return _results;
  };
  var chooseImage = {
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
	};
  makeNext = function(first, paintOnly) {
    var iSource, jSource, piece, rndShape;
    rndShape = Math.round(Math.random() * (shapes.length - 1));
    iSource = Math.round(o.width / 2) - Math.round(shapes[rndShape].length / 2);
    jSource = shapes[rndShape].length * -1;
    piece = {
      i: iSource,
      j: jSource,
      w: shapes[rndShape][0].length,
      h: shapes[rndShape].length,
      t: 1,
      shape: shapes[rndShape]
    };
    if (o.ccolorsOn && (o.set === 'classic' || o.set === 'extended')) {
      return piece.c = colors[rndShape];
    } else {
      return piece.c = colors[Math.round(Math.random() * (colors.length - 1))];
    }
  };
  pauseGame = function(force) {
    if (force === false) {
      if (state === GSPAUSED) {
        state = GSACTIVE;
        repaint();
      }
    } else if (force === true) {
      if (state === GSACTIVE) {
        state = GSPAUSED;
        repaint();
      }
    } else {
      if (state === GSPAUSED) {
        state = GSACTIVE;
        repaint();
      } else if (state === GSACTIVE) {
        state = GSPAUSED;
        repaint();
      }
    }
  };
  clone = function(obj) {
    var attr, copy, i, len, _i;
    if (null === obj || "object" !== typeof obj) {
      return obj;
    }
    if (obj instanceof Date) {
      copy = new Date();
      copy.setTime(obj.getTime());
      return copy;
    }
    if (obj instanceof Array) {
      copy = [];
      len = obj.length;
      for (i = _i = 0; 0 <= len ? _i < len : _i > len; i = 0 <= len ? ++_i : --_i) {
        copy[i] = clone(obj[i]);
      }
      return copy;
    }
    if (obj instanceof Object) {
      copy = {};
      for (attr in obj) {
        if (obj.hasOwnProperty(attr)) {
          copy[attr] = clone(obj[attr]);
        }
      }
      return copy;
    }
    throw new Error("Unable to copy obj! Its type isn't supported.");
  };
  this.pauseGame = pauseGame;
  return init();
};
