(function() {
  var activity, activityAmount, changeActivity, game, newGame, preload, setEvents, ui;

  this.fwt = {};

  ui = {};

  game = activity = void 0;

  activityAmount = $('section').length;

  preload = function() {
    setEvents();
    return setTimeout(function() {
      changeActivity('game');
      return newGame();
    }, 600);
  };

  changeActivity = function(act) {
    var active, activeIndex, other, otherIndex;
    active = $('section.active');
    other = $('section#' + act);
    activeIndex = $('section').index(active);
    otherIndex = $('section').index(other);
    if (activeIndex === otherIndex || otherIndex >= activityAmount || otherIndex < 0) {
      return false;
    }
    active.removeClass('active');
    other.addClass('active');
    if (activeIndex < otherIndex) {
      active.animate({
        'left': '-100%'
      }, 400);
      other.css({
        'left': '100%'
      });
      other.animate({
        'left': '0'
      }, 400);
    } else {
      active.animate({
        'left': '100%'
      }, 400);
      other.css({
        'left': '-100%'
      });
      other.animate({
        'left': '0'
      }, 400);
    }
    activity = act;
    return true;
  };

  setEvents = function() {
    document.onkeyup = function(e) {
      if (e.keyCode === 40 || e.keyCode === 98) {
        if (activity === 'game') {
          game.normalSpeed();
        }
      }
      if (e.keyCode === 88) {
        if (activity === 'game') {
          game.rotateC();
        }
      }
      if (e.keyCode === 90) {
        if (activity === 'game') {
          game.rotateCC();
        }
      }
      if (e.keyCode === 38 || e.keyCode === 104) {
        if (activity === 'game') {
          game.rotate();
        }
      }
      if (e.keyCode === 78 || e.keyCode === 105) {
        if (activity === 'game') {
          return newGame();
        }
      }
    };
    document.onkeydown = function(e) {
      if (e.keyCode === 39 || e.keyCode === 102) {
        if (activity === 'game') {
          game.right();
        }
      }
      if (e.keyCode === 37 || e.keyCode === 100) {
        if (activity === 'game') {
          game.left();
        }
      }
      if (e.keyCode === 32 || e.keyCode === 96) {
        if (activity === 'game') {
          game.drop();
        }
      }
      if (e.keyCode === 80 || e.keyCode === 103) {
        if (activity === 'game') {
          game.pauseGame();
        }
      }
      if (e.keyCode === 40 || e.keyCode === 98) {
        if (activity === 'game') {
          return game.fastSpeed();
        }
      }
    };
  };

  newGame = function() {
    changeActivity('game');
    if (typeof game !== 'undefined') {
      game.endGame();
    }
    return game = new Game({});
  };

  fwt.changeActivity = changeActivity;

  fwt.newGame = newGame;

  fwt.game = function() {
    return game;
  };

  preload();

  $('.fondo').addClass('v');

}).call(this);
