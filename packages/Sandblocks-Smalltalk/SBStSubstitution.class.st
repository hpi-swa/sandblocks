Class {
	#name : #SBStSubstitution,
	#superclass : #SBStASTNode,
	#instVars : [
		'pc'
	],
	#category : #'Sandblocks-Smalltalk'
}

{ #category : #testing }
SBStSubstitution class >> applyAutomatically [

	^ true
]

{ #category : #testing }
SBStSubstitution class >> catchesAll [

	^ false
]

{ #category : #testing }
SBStSubstitution class >> causesSideEffects [

	^ false
]

{ #category : #'as yet unclassified' }
SBStSubstitution class >> derive: anObject [

	^ anObject
]

{ #category : #testing }
SBStSubstitution class >> identity [

	^ false
]

{ #category : #suggestions }
SBStSubstitution class >> instanceSuggestion [
	"Answer a factory block that creates a new instance of the receiver. To be overridden by subclasses."

	^ nil
]

{ #category : #testing }
SBStSubstitution class >> isLeaf [

	^ true
]

{ #category : #testing }
SBStSubstitution class >> isSmalltalkExpression [

	^ true
]

{ #category : #testing }
SBStSubstitution class >> matches: aMessageSend [

	^ aMessageSend isSandblock and: [(aMessageSend isMessageSend and: [aMessageSend receiver notNil]) or: [self matchesCascades and: [aMessageSend isCascade]]]
]

{ #category : #testing }
SBStSubstitution class >> matchesCascades [

	^ false
]

{ #category : #'instance creation' }
SBStSubstitution class >> newFor: aMessage [

	^ self subclassResponsibility
]

{ #category : #accessing }
SBStSubstitution class >> prettyName [

	^ self name allButFirst: 2
]

{ #category : #accessing }
SBStSubstitution class >> priority [

	^ 10
]

{ #category : #testing }
SBStSubstitution class >> selector: aString receiverMatches: aMessage [

	^ (aMessage receiver satisfies: #(notNil isBinding)) and: [self name = aMessage receiver contents and: [aMessage selector = aString]]
]

{ #category : #suggestions }
SBStSubstitution class >> suggestion [
	"Answer a completion block that inserts a new instance of the receiver into a provided block. Subclasses may override this, but in many cases only need to override #instanceSuggestion."

	^ self instanceSuggestion ifNotNil: [:factory |
		[:block |
			block sandblockEditor do: (SBReplaceCommand new
				target: block;
				replacer: factory value;
				yourself)]]
]

{ #category : #testing }
SBStSubstitution class >> supports: aSymbol [

	^ (self respondsTo: aSymbol) and: [self perform: aSymbol]
]

{ #category : #'as yet unclassified' }
SBStSubstitution >> asSmalltalk: converter [
	<convert>
	
	converter do: [self sourceString parseAsSandblockWithoutSubstitution]
]

{ #category : #'as yet unclassified' }
SBStSubstitution >> constructorString: aString arguments: aCollection on: aStream [

	SBExample
		self: [SBStSubstitution new]
		args: [{'replace:'. ({(SBStNumber new contents: '3')}). '' writeStream}]
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
SBStSubstitution >> initialize [

	super initialize.
	
	pc := 0
]

{ #category : #testing }
SBStSubstitution >> isExpression [

	^ true
]

{ #category : #'as yet unclassified' }
SBStSubstitution >> pc [

	^ pc
]

{ #category : #'as yet unclassified' }
SBStSubstitution >> pc: aNumber [

	pc := aNumber
]
