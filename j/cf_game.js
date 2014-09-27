var Game;

Game = function(o) {
  var GS, canFall, canvas, clone, context, createMap, current, init, makeNext, makeShade, map, next, pauseGame, shade, state;
  canvas = $('canvas#board').get(0);
  context = canvas.getContext('2d');
  map = void 0;
  state = void 0;
  GS = {
    OVER: 0,
    PAUSED: 1,
    ACTIVE: 2
  };
  current = next = shade = void 0;
  window.requestAnimFrame = (function() {
    return window.requestAnimationFrame || window.mozRequestAnimationFrame || window.msRequestAnimationFrame || window.oRequestAnimationFrame || window.webkitRequestAnimationFrame || function(callback) {
      return window.setTimeout(callback, 1000 / 60);
    };
  })();
  window.cancelAnimFrame = (function() {
    return window.cancelAnimationFrame || window.mozCancelAnimationFrame || window.msCancelAnimationFrame || window.oCancelAnimationFrame || window.webkitCancelAnimationFrame || window.clearTimeout;
  })();
  init = function() {
    o.width = o.width || 24;
    o.height = o.height || 17;
    o.shadeOn = (o.shadeOn === true) || true;
    map = createMap();
    state = GS.ACTIVE;
    current = makeNext();
    if (o.shadeOn) {
      makeShade();
    }
    next = chooseNext();
  };
  makeShade = function() {
    shade = clone(current);
    while (canFall(shade)) {
      (shade.j++)();
    }
  };
  canFall = function(piece) {
    var i, j, _i, _j, _ref, _ref1;
    if ((piece.j + piece.form.length) === o.height) {
      return false;
    }
    for (i = _i = 0, _ref = piece.form[0].length; 0 <= _ref ? _i < _ref : _i > _ref; i = 0 <= _ref ? ++_i : --_i) {
      for (j = _j = _ref1 = piece.form.length - 1; _ref1 <= 0 ? _j <= 0 : _j >= 0; j = _ref1 <= 0 ? ++_j : --_j) {
        if (piece.form[j][i] !== 0) {
          if (piece.j + j + 1 > -1 && map[piece.j + j + 1][piece.i + i].mat !== 0) {
            return false;
          } else {
            break;
          }
        }
      }
    }
    return true;
  };
  makeNext = function(first, paintOnly) {};
  createMap = function(entropy) {
    var m, r, _;
    r = (function() {
      var _i, _ref, _results;
      _results = [];
      for (_ = _i = 1, _ref = o.width; 1 <= _ref ? _i < _ref : _i > _ref; _ = 1 <= _ref ? ++_i : --_i) {
        _results.push(0);
      }
      return _results;
    })();
    return m = (function() {
      var _i, _ref, _results;
      _results = [];
      for (_ = _i = 1, _ref = o.height; 1 <= _ref ? _i < _ref : _i > _ref; _ = 1 <= _ref ? ++_i : --_i) {
        _results.push(r);
      }
      return _results;
    })();
  };
  pauseGame = function(force) {
    if (force === false) {
      if (state === GS.PAUSED) {
        state = GS.ACTIVE;
        repaint();
      }
    } else if (force === true) {
      if (state === GS.ACTIVE) {
        state = GS.PAUSED;
        repaint();
      }
    } else {
      if (state === GS.PAUSED) {
        state = GS.ACTIVE;
        repaint();
      } else if (state === GS.ACTIVE) {
        state = GS.PAUSED;
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
