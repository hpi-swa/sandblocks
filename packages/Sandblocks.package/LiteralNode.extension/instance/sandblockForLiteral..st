*Sandblocks
sandblockForLiteral: anObject

	anObject isNumber ifTrue: [^ SBNumber new contents: anObject asString].
	anObject isSymbol ifTrue: [^ SBSymbol new contents: anObject asString].
	anObject isString ifTrue: [^ SBString new contents: anObject].
	anObject isArray ifTrue: [^ SBArray new type: #literal contents: (anObject collect: [:o | self sandblockForLiteral: o])].
	anObject isCharacter ifTrue: [^ SBCharacter new contents: anObject asString].
	^ self shouldBeImplemented