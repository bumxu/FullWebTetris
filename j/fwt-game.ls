fwt3g = do !->
   # Constants
   sets   = {}  # Stores available piece shapes by name when ready
   colors = []  # Stores available colors ordered list when ready

   states =  # Game states
      loading: -1
      over:     0
      paused:   1
      active:   2

   shapes = bag = void
   highest-line = 0

   deploy = !->
      # Sets
      sets.testing   := aux.u-shape('MTExMS8xMTExLzExMTEvMTExMQ==')
      sets.classic   := aux.u-shape('MTEwLzAxMSAwMTEvMTEwIDExLzExIDExMTEgMDEwLzExMSAxMDAvMTExIDAwMS8xMTE=')
      sets.extended  := sets.classic ++ aux.u-shape('MTAvMTEgMDEvMTEgMSAxMQ==')
      sets.challenge := sets.extended ++ aux.u-shape('MDEwLzExMS8wMTAgMDExLzAxMS8xMTAgMTEwLzExMC8wMTEgMDExLzAxMS8xMTEgMTEwLzExMC8xMTEgMTExLzExMCAxMTAvMTExIDEwMS8xMTEgMTExIDAwMS8xMTEvMTAwIDEwMC8xMTEvMDAxIDEwMC8xMTAvMTExIDAwMS8wMTEvMTExIDAxMC8xMTEvMTEwIDAxMC8xMTEvMDEx')
      sets.lethal    := sets.challenge ++ aux.u-shape('MTExLzExMC8wMTEgMTExLzAxMS8xMTAgMTEwLzAxMS8xMTAgMTEwLzExMS8wMTEgMTExMTExMTEgMDAxLzAxMC8xMDAgMTAxLzAxMC8xMDEgMDAxLzAxMC8xMDEgMDExLzExMC8xMDAgMDEvMTAgMDEvMTEvMTEvMDEvMDEgMTAvMTEvMTEvMTAvMTAgMDEvMTEvMTEvMDEvMTEgMTEvMTAvMTEvMTAvMTEgMTEvMTAvMDEvMTAvMDEgMTAvMTEvMTEvMTAvMTEgMTEvMDEvMTAvMDEvMTAgMTExLzEwMS8xMTEgMTExLzAwMS8xMTEgMTEwLzEwMS8xMDEgMTEwLzExMS8xMDEgMDExLzEwMS8xMDEgMDExLzExMS8xMDEgMDEwLzExMS8xMDEgMTExLzAxMC8xMTE=')

      # Colors
      colors := atob('cmVkMWVtZXJhbGQxeWVsbG93MWN5YW4xcHVycGxlMWJsdWUxb3JhbmdlMWJyb3duMWdyZWVuMXBpbmsxd2hpdGU=') / \1

   # Generates a 2D matrix map for a new game, establishing <map> and the <hightest-line>.
   # Also accepts a number of lines that will be filled with random tiles (<pad>).
   make-map = (pad = 0) !->
      # Generates empty rows
      row-empty = -> for til game.width then null
      # Generates random filled rows
      row-stuff = ->
         row = []        ## Contents of the row
         all-one = true  ## If all terms until (<width> - 1) are solid

         for i til game.width
            # In the last term, if all (<width> - 1) terms are solid put last to empty
            if i is (game.width - 1) and all-one
               row.push null
               break

            # In the other terms set solid or empty randomly
            if Math.round(Math.random!) is 1
               row.push { t: 1, c: random-color! }
            else
               # Also, when a term is setted to empty set <all-one> to FALSE
               all-one = false
               row.push null

         return row

      # Attend demand
      m0 = for til (game.height - pad) then row-empty!
      mX = for til pad then row-stuff!

      # Concat filled with empty and set
      map := m0 ++ mX
      highest-line := game.height - 1

   random-color = -> Math.round(Math.random! * (colors.length - 1))

   # Chooses and generates the next piece
   # RETURN the piece object
   make-piece = ->
      # Choose a shape for next piece
      if game.set is 'hell'
         shape = hell-shape!
      else         
         # Fortune 1 OR 2 -> Use a "bag" of shapes
         if game.fortune is 1 or game.fortune is 2
            # Rebuild if empty and shuffle
            if bag.length is 0
               # Bag size: fortune 1 -> size 2, fortune 2 -> size 1
               bag-size = 3 - game.fortune 
               for i til shapes.length * bag-size then bag.push(i % shapes.length)
               bag := bag.shuffle!

            pick = bag.shift!
         else
            # (fortune = 0) -> Use a random shape
            pick = Math.round(Math.random! * (shapes.length - 1))

         shape  = shapes[pick]

      # Piece structure
      piece = {
         # Initial <i> position -> board center
         i: Math.round(game.width / 2) - Math.round(shape.length / 2)
         # Initial <j> position -> minus shape height
         j: shape.length * -1
         # Shape dimensions
         w: shape[0].length
         h: shape.length
         # Type of material, for now only: 0 -> empty, 1 -> normal
         t: 1
         # A pointer to the shape of this piece
         s: shape
         # Shorthand for get the $(a,b) tile of this piece's shape
         $: (a,b) -> @s[b][a]
      }

      # Choose random/sequential color for the piece
      if not game.random-colors and shapes.length <= colors
         piece.c = colors[ random ]
      else
         piece.c = colors[ random-color! ]

      return piece

   # Creates a randomly insane shape
   # RETURN the shape matrix
   hell-shape = ->
      # Random seed
      seed = Math.round(Math.random() * 510 + 1).toString(2)
      seed = ('000000000' + seed).slice(-9)
      seedIterator = 0
      # Function row generator
      row = -> for til 3 then Number( seed[seedIterator++] )
      # Generate 3 rows
      for til 3 then row!

   # Determines if the :piece: can fall one more time
   # RETURNS true or false
   can-fall = (piece) ->
      # Floor collision
      if piece.j + piece.h is game.height
         return false

      # Map collision
      for i til piece.w
         for j from (piece.h - 1) to 0 by -1 
            # New positions for current tile
            nti = piece.i + i
            ntj = piece.j + j + 1

            # IF the tile is not solid OR the new position is 
            # out of "top" bounds -> continue with next tile
            if piece.$(i,j) is 0 or ntj < 0
               continue

            # IF the new position of the tile is already 
            # taken -> piece cannot fall
            if map.$(nti,ntj)? and map.$(nti,ntj).t is 1
               return false

      # No collision
      return true

   # It tries freeze the current piece
   # RETURNS true or false, depends on if all tiles are or not within the board
   try-freeze = ->
      for j from (piece.h - 1) to 0 by -1
         for i til piece.w when piece.$(i,j) is not 0
            # Positions for current tile
            ti = piece.i + i
            tj = piece.j + j

            # It's within the board
            if tj > -1 then
               # Fix tile to map
               game.map.$(ti, tj, { t: piece.t, c: piece.c })
            else
               # Tile is out of bounds
               return false

      # Updates the highest line value (minimum is higher)
      highest-line := current.j <? highest-line

      # Success
      return true

   # Functional methods (no game related)
   aux =
      u-shape: (str) !->
         tmp = atob(str).split(' ')
         for x, i in tmp
            tmp[i] = tmp[i].split('/')
            for y, j in tmp[i]
               tmp[i][j] = tmp[i][j].split('')
               for z, k in tmp[i][j] then tmp[i][j][k] = tmp[i][j][k] / 1
         return tmp

      # Object clonation
      clone: (obj) !->
         if obj is null or typeof obj is not 'object'
            return obj

         if obj instanceof Date
            copy = new Date
            copy.setTime(obj.getTime!)
            return copy

         if obj instanceof Array
            copy = []
            for i from 0 til obj.length
               copy[i] = aux.clone(obj[i])
            return copy

         if obj instanceof Object
            copy = {}
            for attr of obj when obj.hasOwnProperty(attr)
               copy[attr] = aux.clone(obj[attr])
            return copy

         throw new Error("Unable to copy obj! Its type isn't supported.")

      # Set timer
      requestTimeout: (delay, fn) !->
         start  = (new Date).getTime!
         handle = {}
            
         wait = !->
            current = (new Date).getTime!
            delta   = current - start
               
            if delta >= delay then fn.call!
            else handle.value = requestAnimationFrame(wait)
         
         handle.value = requestAnimationFrame(wait)
         return handle

      # Clear timer
      clearRequestTimeout: (handle) !->
         cancelAnimationFrame(handle.value)

   # Extends array to get 2D $(i,j) coordinate or write <v> to $(i,j,v)
   Array.prototype.$ = (i,j,v) ->
      try
         if not v? then return this[j][i] ## read
         this[j][i] = v ## write
      catch
         return null

   Array.prototype.shuffle = ->
      ((arr) ->
         j = x = void
         i = arr.length
         while i
            j = parseInt(Math.random! * i)
            x = arr[--i]
            arr[i] = arr[j]
            arr[j] = x
         arr
      )(this)

   deploy!

   # Public handlers
   return {
   }