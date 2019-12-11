as yet unclassified
textMorphFor: aString

	| text |
	text := SBOwnTextMorph new contents: aString.
	SBColorPolicy boldMessageSends ifTrue: [text emphasis: TextEmphasis bold].
	^ text