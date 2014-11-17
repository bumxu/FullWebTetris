@fwt = {}
ui = {}

game = storage = activity = void

activityAmount = $('section').length

preload = ->
   storage := new Storage()

   window.onresize = adjust
   adjust!

   lcanvas = $('#loader canvas').attr({
      'width': $(window).width!
      'height': $(window).height!
   }).get(0)
   lctx = lcanvas.getContext('2d')
   radp = 0
   lctx.fillStyle = "#234750"
   lctx.rect(0,0,lcanvas.width,lcanvas.height)
   lctx.fill()
   loopo = ->
      radp += 2

      lcanvas.width = lcanvas.width
      lctx.globalCompositeOperation = "source-over"
      lctx.fillStyle = "#234750"
      lctx.rect(0,0,lcanvas.width,lcanvas.height)
      lctx.fill()
      lctx.globalCompositeOperation = "xor"
      lctx.beginPath()
      lctx.arc(lcanvas.width*70/100,lcanvas.height*30/100,lcanvas.width*radp/100,0,Math.PI*2,true)
      lctx.fill()
      if radp<100
         requestAnimationFrame(loopo)
      else
         $('#loader').hide!
         changeActivity('game')

   #setTimeout ->
   loopo!
   #, 2000

   do setEvents

  #setTimeout ->
  #   $('.fondo, #layout').addClass('v')
  #   #changeActivity 'game'
  #   #newGame()
  #, 1000

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

   activity := act

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

adjust = ->

   optimal = (availableWidth, availableHeight) ->
      boardWidth = availableWidth
      boardHeight = boardWidth * storage.get('game-height') / storage.get('game-width')
      if boardHeight > availableHeight
         boardHeight = availableHeight
         boardWidth = boardHeight * storage.get('game-width') / storage.get('game-height')
      return {
         w: boardWidth
         h: boardHeight
      }

   gutter = Math.max( Math.min($('#game').width(), $('#game').height()) / 100 * 0.5, 2)

   $('#game > div').css({'top': gutter,'left': gutter,'right': gutter,'bottom': gutter})

   screen = {
      w: $('#game > div').width()
      h: $('#game > div').height()
   }

   # Case VErtical
   availableVE = {
      w: screen.w / 100 * (100 - 12) /* -> the (100 - [aside.width])% */ - gutter
      h: screen.h
   }
   optimalVE = optimal(availableVE.w, availableVE.h)

   # Case HOrizonal
   availableHO = {
      w: screen.w
      h: screen.h - (Math.max(0.09 * screen.h, 52)) - gutter
   }
   optimalHO = optimal(availableHO.w, availableHO.h)

   /*if optimalVE.w > optimalHO.w
      $('#game aside').attr('class', 'vertical')

      # Accommodate vertical layout
      asideWidth = $('#game aside').width()
      totalWidth = asideWidth + optimalVE.w + gutter

      $('#game aside').css({height: optimalVE.h, width: '12%', left: (screen.w - totalWidth) / 2})

      $('#game #board').css({height: optimalVE.h, width: optimalVE.w, top: 0, left: ((screen.w - totalWidth) / 2) + asideWidth + gutter })

   else*/
   $('#game aside').attr('class', 'horizontal')

   # Accommodate horizontal layout
   asideHeight = $('#game aside').height()  ##could include exception for very narrow sizes ||
   totalHeight = asideHeight + optimalHO.h + gutter

   left = (screen.w - optimalHO.w) / 2

   $('#game aside').css({width: optimalHO.w, top: ((screen.h - totalHeight) / 2), left: left})

   $('#game #board').css({height: optimalHO.h, width: optimalHO.w, top: ((screen.h - totalHeight) / 2) + asideHeight + gutter, left: left})

   $('#game canvas').attr({width: $('#game #board').width(), height: $('#game #board').height()})







#     adjust();
#

#     window.onbeforeunload = saveToLS;
#
#     setOSDMessages();
#  }*/

newGame = ->
   changeActivity 'game'

   do game.endGame if typeof game isnt 'undefined'

   game := new Game({});

fwt.changeActivity = changeActivity
fwt.newGame = newGame
fwt.game = -> game

$ !->
   preload!