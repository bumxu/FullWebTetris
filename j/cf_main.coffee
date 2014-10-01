@fwt = {}
ui = {}

game = activity = undefined

activityAmount = $('section').length

preload = ->
   # Load necessary resources and go to MAIN

   do setEvents

   setTimeout ->
      changeActivity 'game'
      newGame()
   , 600

changeActivity = (act) ->
   active = $('section.active')
   other  = $('section#' + act)

   activeIndex = $('section').index( active )
   otherIndex  = $('section').index( other )

   if activeIndex == otherIndex     or
      otherIndex  >= activityAmount or
      otherIndex  <  0
   then return false

   active.removeClass 'active'
   other.addClass     'active'

   if activeIndex < otherIndex
      active.animate { 'left': '-100%' }, 400
      other.css      { 'left': '100%' }
      other.animate  { 'left': '0' }, 400
   else
      active.animate { 'left': '100%' }, 400
      other.css      { 'left': '-100%' }
      other.animate  { 'left': '0' }, 400

   activity = act

   return true


setEvents = ->

   document.onkeyup = (e) ->
      if e.keyCode is 40 or e.keyCode is 98
         do game.normalSpeed if activity is 'game'

      if e.keyCode is 88
         do game.rotateC if activity is 'game'

      if e.keyCode is 90
         do game.rotateCC if activity is 'game'

      if e.keyCode is 38 or e.keyCode is 104 #default
         do game.rotate if activity is 'game'

      if e.keyCode is 78 or e.keyCode is 105
         do newGame if activity is 'game'

   document.onkeydown = (e) ->
      if e.keyCode is 39 or e.keyCode is 102
         do game.right if activity is 'game'

      if e.keyCode is 37 or e.keyCode is 100
         do game.left if activity is 'game'

      if e.keyCode is 32 or e.keyCode is 96
         do game.drop if activity is 'game'

      if e.keyCode is 80 or e.keyCode is 103
         do game.pauseGame if activity is 'game'

      if e.keyCode is 40 or e.keyCode is 98
         do game.fastSpeed if activity is 'game'

   return

   #/*   var setEvents = function() {
#     window.onresize = function() {
#        adjust();
#     }
#     adjust();
#

#     window.onbeforeunload = saveToLS;
#
#     setOSDMessages();
#  }*/

newGame = () ->
   changeActivity 'game'

   do game.endGame if typeof game isnt 'undefined'

   game = new Game({});

fwt.changeActivity = changeActivity
fwt.newGame = newGame
fwt.game = -> game

preload()

$('.fondo').addClass('v');