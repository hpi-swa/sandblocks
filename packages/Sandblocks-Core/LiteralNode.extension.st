Extension { #name : #LiteralNode }

{ #category : #'*Sandblocks-Core' }
LiteralNode class >> sandblockForLiteral: anObject [

	anObject = #ppEmptyLine ifTrue: [^ SBUnknown new grammarHandler: SBStGrammarHandler new].
	anObject isNumber ifTrue: [^ SBStNumber new contents: anObject asString].
	anObject isSymbol ifTrue: [^ SBStSymbol new contents: anObject asString].
	anObject isString ifTrue: [^ SBStString new contents: anObject].
	(anObject isKindOf: ByteArray) ifTrue: [^ SBStArray new type: #byte contents: (anObject collect: [:o | self sandblockForLiteral: o] as: Array)].
	anObject isArray ifTrue: [^ SBStArray new type: #literal contents: (anObject collect: [:o | self sandblockForLiteral: o])].
	anObject isCharacter ifTrue: [^ SBStCharacter new contents: anObject asString].
	anObject isCollection ifTrue: [^ SBStArray new type: #literal contents: (anObject collect: [:num | SBStNumber new contents: num asString] as: Array)].
	(#(nil true false) includes: anObject) ifTrue: [^ SBStName contents: anObject asString].
	^ self shouldBeImplemented
]
