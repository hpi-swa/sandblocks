as yet unclassified
spaceForPrefix

	^ self prefix ifNil: [0] ifNotNil: [:p | self fontToUse widthOfString: p]