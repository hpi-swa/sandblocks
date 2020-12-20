as yet unclassified
numArguments: aString

	aString last = $: ifTrue: [^ (self extractKeywords: aString) size].
	aString first isSpecial ifTrue: [^ 1].
	^ 0