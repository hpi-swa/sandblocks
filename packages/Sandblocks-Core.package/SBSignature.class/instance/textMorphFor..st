as yet unclassified
textMorphFor: aString

	| text |
	text := SBMessagePart new contents: aString.
	"SBColorPolicy boldMessageSends ifTrue: [text emphasis: TextEmphasis bold]."
	^ text