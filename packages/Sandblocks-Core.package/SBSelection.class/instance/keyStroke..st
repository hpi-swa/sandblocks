as yet unclassified
keyStroke: anEvent
	"Abort the drag on an escape"

	anEvent keyCharacter = Character escape ifTrue: [self abortDrag: anEvent].