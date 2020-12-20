private
flipPoint: aPoint
	" this function makes sure that the primary direction is always in the x spot of the 
	  point for easier handling in code that needs to be aware of both vertical and horizontal "
	
	^ vertical ifTrue: [aPoint y @ aPoint x] ifFalse: [aPoint]