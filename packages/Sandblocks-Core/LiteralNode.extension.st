Extension { #name : #LiteralNode }

{ #category : #'*Sandblocks-Core' }
LiteralNode >> asSandblock [

	^ self class sandblockForLiteral: self key
]

{ #category : #'*Sandblocks-Core' }
LiteralNode class >> sandblockForLiteral: anObject [

	anObject isNumber ifTrue: [^ SBNumber new contents: anObject asString].
	anObject isSymbol ifTrue: [^ SBSymbol new contents: anObject asString].
	anObject isString ifTrue: [^ SBString new contents: anObject].
	anObject isArray ifTrue: [^ SBArray new type: #literal contents: (anObject collect: [:o | self sandblockForLiteral: o])].
	anObject isCharacter ifTrue: [^ SBCharacter new contents: anObject asString].
	anObject isCollection ifTrue: [^ SBArray new type: #literal contents: (anObject collect: [:num | SBNumber new contents: num asString] as: Array)].
	(#(nil true false) includes: anObject) ifTrue: [^ SBName contents: anObject asString].
	^ self shouldBeImplemented
]