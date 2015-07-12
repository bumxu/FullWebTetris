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

   # Extend array to get 2D $(i,j) coordinate
   Array.prototype.$ = (i,j) ->
      return this[j][i]

   # Public handlers
   return {
   }