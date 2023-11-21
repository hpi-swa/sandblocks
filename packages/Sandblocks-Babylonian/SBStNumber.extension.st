Extension { #name : #SBStNumber }

{ #category : #'*Sandblocks-Babylonian' }
SBStNumber >> wrapInVariantCoveringRange [
	<action>
	
	| rangeString range |
	rangeString := UIManager default
		request: 'Enter range of numbers'
		initialAnswer: '1 to: 5'.
	rangeString ifNil: [^ self].
	
	range := [Compiler evaluate: rangeString] on: Error do: [:ex | UIManager inform: 'Not a valid range'. ^ self].
	range start > range stop ifTrue: [range := range stop to: range start. range := range reversed].
	
	self wrapInVariantGivenInterval: range.
	
	
	
]

{ #category : #'*Sandblocks-Babylonian' }
SBStNumber >> wrapInVariantGivenInterval: anInterval [

	| variant |
	variant := SBVariant new.
	self sandblockEditor do:
		(SBWrapCommand new
			selectAfter: #block;
			outer: variant;
			inner: self;
			wrap: [:outer :inner | variant 
				named: anInterval asString
				alternatives: (anInterval collect: [:aNumber | 
					SBNamedBlock block: (SBStBlockBody new 
						statements: {(inner veryDeepCopy value: aNumber)}) 
						named: aNumber asString])
				activeIndex: 1])
	
	
	
]
