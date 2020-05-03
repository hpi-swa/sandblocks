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
SBString >> prefix [

	^ ''''
]

{ #category : #'as yet unclassified' }
SBString >> printOn: aStream [

	aStream nextPutAll: 'string '.
	aStream nextPutAll: self contents
]

{ #category : #'as yet unclassified' }
SBString >> spaceForPrefix [

	^ super spaceForPrefix + (4 * self scalingFactor)
]

{ #category : #'as yet unclassified' }
SBString >> textMorphClass [

	^ SBMultilineOwnTextMorph
]

{ #category : #'as yet unclassified' }
SBString >> writeSourceOn: aStream [

	self contents asString storeOn: aStream
]
