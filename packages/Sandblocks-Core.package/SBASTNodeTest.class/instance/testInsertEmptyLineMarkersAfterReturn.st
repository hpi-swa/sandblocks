as yet unclassified
testInsertEmptyLineMarkersAfterReturn

	self assert: 'a
    ^ test.

    " hello "' equals: 'a
    ^ test.

    " hello "' codeWithEmptyLineMarkers