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
SBString >> isStringBubble [

	^ true
]

{ #category : #'as yet unclassified' }
SBString >> keyStroke: anEvent [

	(anEvent keyCharacter = $v and: [anEvent commandKeyPressed]) ifTrue: [
		^ text insertString: Clipboard clipboardText].
	
	self acceptInputEvent: anEvent
]

{ #category : #'as yet unclassified' }
SBString >> printOn: aStream [

	aStream nextPutAll: 'string '.
	aStream nextPutAll: self contents
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
