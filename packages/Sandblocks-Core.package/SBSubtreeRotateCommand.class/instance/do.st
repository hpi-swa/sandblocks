as yet unclassified
do

	undoTarget := target parentSandblock.
	wasLeft := target isLastChild.
	^ self rotateAround: target isLeftOrNil: wasLeft