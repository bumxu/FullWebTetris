fwt3g = do !->

   can-fall = (piece) ->
      # Floor collision
      if piece.j + piece.h is game.height
         return false

      # Map collision
      for i from 0 til piece.w
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
            if game.map.$(nti,ntj)? and game.map.$(nti,ntj).t is 1
               return false

      # No collision
      return true

   # Functional methods (no game related)
   aux =
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

   # Extend array to get 2D $(i,j) coordinate
   Array.prototype.$ = (i,j) ->
      return this[j][i]

   # Public handlers
   return {
   }