as yet unclassified
tryFix: aNodeBlock ifFail: aBlock

	aNodeBlock fixActions ifNotEmpty: [:actions | self proposeCodeActions: actions for: aNodeBlock].
	^ aNodeBlock valid ifTrue: [true] ifFalse: aBlock