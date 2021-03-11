Extension { #name : #LiteralNode }

{ #category : #'*Sandblocks-Core' }
LiteralNode >> asSandblock [

	^ self class sandblockForLiteral: self key
]

{ #category : #'*Sandblocks-Core' }
LiteralNode class >> sandblockForLiteral: anObject [

	anObject = #ppEmptyLine ifTrue: [^ SBStEmptyLine new].
	anObject isNumber ifTrue: [^ SBStNumber new contents: anObject asString].
	anObject isSymbol ifTrue: [^ SBStSymbol new contents: anObject asString].
	anObject isString ifTrue: [^ SBStString new contents: anObject].
	anObject isArray ifTrue: [^ SBStArray new type: #literal contents: (anObject collect: [:o | self sandblockForLiteral: o])].
	anObject isCharacter ifTrue: [^ SBStCharacter new contents: anObject asString].
	anObject isCollection ifTrue: [^ SBStArray new type: #literal contents: (anObject collect: [:num | SBStNumber new contents: num asString] as: Array)].
	(#(nil true false) includes: anObject) ifTrue: [^ SBStName contents: anObject asString].
	^ self shouldBeImplemented
]
