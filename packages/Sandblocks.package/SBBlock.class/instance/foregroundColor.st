as yet unclassified
foregroundColor

	^ self drawnColor luminance > 0.6 ifTrue: [Color black] ifFalse: [Color white]