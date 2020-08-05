Class {
	#name : #SBString,
	#superclass : #SBLiteral,
	#category : 'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBString >> guessedClass [

	^ String
]

{ #category : #'as yet unclassified' }
SBString >> initialize [

	super initialize.
	
	text maxWidth: 500
]

{ #category : #'as yet unclassified' }
SBString >> isStringBlock [

	^ true
]

{ #category : #'as yet unclassified' }
SBString >> keyStroke: anEvent [

	(anEvent keyCharacter = $v and: [anEvent commandKeyPressed]) ifTrue: [
		^ text insertString: Clipboard clipboardText].
	
	(anEvent keyCharacter = Character backspace and: [self contents isEmpty]) ifTrue: [
		^ self replaceWithUnknown].
	
	self acceptInputEvent: anEvent
]

{ #category : #'as yet unclassified' }
SBString >> printOn: aStream [

	aStream nextPutAll: 'string '.
	aStream nextPutAll: (self contents truncateWithElipsisTo: 20)
]

{ #category : #'as yet unclassified' }
SBString >> symbols [

	^ self colorPolicy symbolsForString: self
]

{ #category : #'as yet unclassified' }
SBString >> textMorphClass [

	^ SBMultilineOwnTextMorph
]

{ #category : #'as yet unclassified' }
SBString >> writeSourceOn: aStream [

	self contents asString storeOn: aStream
]
