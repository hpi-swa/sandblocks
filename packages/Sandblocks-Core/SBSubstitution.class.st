Class {
	#name : #SBSubstitution,
	#superclass : #SBASTNode,
	#instVars : [
		'pc'
	],
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBSubstitution class >> applyAutomatically [

	^ true
]

{ #category : #'as yet unclassified' }
SBSubstitution class >> catchesAll [

	^ false
]

{ #category : #'as yet unclassified' }
SBSubstitution class >> causesSideEffects [

	^ false
]

{ #category : #'as yet unclassified' }
SBSubstitution class >> derive: anObject [

	^ anObject
]

{ #category : #'as yet unclassified' }
SBSubstitution class >> identity [

	^ false
]

{ #category : #'as yet unclassified' }
SBSubstitution class >> isLeaf [

	^ true
]

{ #category : #'as yet unclassified' }
SBSubstitution class >> isSmalltalkExpression [

	^ true
]

{ #category : #'as yet unclassified' }
SBSubstitution class >> matches: aMessageSend [

	^ aMessageSend isSandblock and: [aMessageSend isMessageSend or: [self matchesCascades and: [aMessageSend isCascade]]]
]

{ #category : #'as yet unclassified' }
SBSubstitution class >> matchesCascades [

	^ false
]

{ #category : #'as yet unclassified' }
SBSubstitution class >> newFor: aMessage [

	^ self subclassResponsibility
]

{ #category : #'as yet unclassified' }
SBSubstitution class >> prettyName [

	^ self name allButFirst: 2
]

{ #category : #'as yet unclassified' }
SBSubstitution class >> priority [

	^ 10
]

{ #category : #'as yet unclassified' }
SBSubstitution class >> selector: aString receiverMatches: aMessage [

	^ aMessage receiver isBinding and: [self name = aMessage receiver contents and: [aMessage selector = aString]]
]

{ #category : #'as yet unclassified' }
SBSubstitution class >> suggestion [

	^ nil
]

{ #category : #'as yet unclassified' }
SBSubstitution class >> supports: aSymbol [

	^ (self respondsTo: aSymbol) and: [self perform: aSymbol]
]

{ #category : #'as yet unclassified' }
SBSubstitution >> codeActions [

	^super codeActions, {SBCodeAction
		labeled: 'Show as Message Send'
		for: self
		do: #replaceWithMessageSend}
]

{ #category : #'as yet unclassified' }
SBSubstitution >> constructorString: aString arguments: aCollection on: aStream [

	SBExample
		self: [SBSubstitution new]
		args: [{'replace:'. ({(SBNumber new contents: '3')}). '' writeStream}]
		label: 'simple'.
	aStream nextPut: $(.
	aStream nextPutAll: self className.
	aStream space.
	aString keywords
		with: aCollection
		do: [:keyword :arg | 
			aStream nextPutAll: keyword.
			aStream space.
			arg writeSourceOn: aStream.
			aStream space].
	aStream nextPut: $)
]

{ #category : #initialization }
SBSubstitution >> initialize [

	super initialize.
	
	pc := 0
]

{ #category : #testing }
SBSubstitution >> isExpression [

	^ true
]

{ #category : #'as yet unclassified' }
SBSubstitution >> pc [

	^ pc
]

{ #category : #'as yet unclassified' }
SBSubstitution >> pc: aNumber [

	pc := aNumber
]

{ #category : #'as yet unclassified' }
SBSubstitution >> replaceWithMessageSend [

	| doIt |
	doIt := Parser new parse: self sourceString class: nil class noPattern: true notifying: nil ifFail: nil.
	
	self sandblockEditor do: ((SBReplaceCommand newFor: self containingArtefact)
			replacer: (doIt block statements first expr asSandblockWithoutSubstitution pc: self pc);
			target: self)
]
