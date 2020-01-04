as yet unclassified
foregroundColorForColor: aColor

	^ aColor luminance > 0.6 ifTrue: [Color black] ifFalse: [Color white]