as yet unclassified
testInsertEmptyLineMarkers

	self
		assert: 'a.
	#sbEmptyLine.
	b.
      #sbEmptyLine.
     ''abc
     
     def''.
#sbEmptyLine.
     ^ a'
		equals: 'a.
	#sbEmptyLine.
	b.
      
     ''abc
     
     def''.

     ^ a' codeWithEmptyLineMarkers