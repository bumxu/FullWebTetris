@fwt = {}
ui = {}

game = undefined

activityAmount = $('section').length

preload = ->
   # Load necessary resources and go to MAIN
   setTimeout ->
      changeActivity 'game'
      newGame()
   , 600

changeActivity = (activity) ->
   active = $('section.active')
   other  = $('section#' + activity)

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

   return true

newGame = () ->
   changeActivity 'game'

   game = new Game({});

fwt.changeActivity = changeActivity
fwt.newGame = newGame

preload()

$('.fondo').addClass('v');