Extension { #name : #SBUnknown }

{ #category : #'*Sandblocks-Smalltalk' }
SBUnknown >> absorbsInput: anEvent [

	self flag: #fixme. " this is a shaky assumption that all langs use space in unknowns to create emptylines "
	^ anEvent keyCharacter = Character space and: [anEvent anyModifierKeyPressed not]
]

{ #category : #'*Sandblocks-Smalltalk' }
SBUnknown >> asMessagePart: converter [
	<convert>
	
	converter do: [SBStMessagePart new contents: '']
]

{ #category : #'*Sandblocks-Smalltalk' }
SBUnknown >> asStName: converter [
	<convert>

	converter do: [SBStName new contents: '']
]

{ #category : #'*Sandblocks-Smalltalk' }
SBUnknown >> canAppearInBlockBody [

	^ true
]

{ #category : #'*Sandblocks-Smalltalk' }
SBUnknown >> guessClassExpensive [

	^ nil
]

{ #category : #'*Sandblocks-Smalltalk' }
SBUnknown >> guessedClass [

	^ nil
]

{ #category : #'*Sandblocks-Smalltalk' }
SBUnknown >> isSmalltalk [

	^ self grammarHandler isKindOf: SBStGrammarHandler
]

{ #category : #'*Sandblocks-Smalltalk' }
SBUnknown >> updatePCFrom: anObject [
]

{ #category : #'*Sandblocks-Smalltalk' }
SBUnknown >> writeStSourceOn: aStream [

	self assert: self isStatement.
	" don't place an empty line in an otherwise empty block "
	self parentSandblock statements size > 1 ifTrue: [
		aStream nextPutAll: '#ppEmptyLine']
]
