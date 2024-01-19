Extension { #name : #String }

{ #category : #'*Sandblocks-Babylonian' }
String class >> exampleBlock [

	^ self exampleObject asSandblock 
]

{ #category : #'*Sandblocks-Babylonian' }
String class >> exampleBlockContainingClass: aClass [

	^ self exampleBlock 
	
	
]

{ #category : #'*Sandblocks-Babylonian' }
String class >> exampleObject [

	^ 'Hello, World'
]

{ #category : #'*Sandblocks-Babylonian' }
String class >> exampleObjectContainingClass: aClass [

	^ self exampleObject
]

{ #category : #'*Sandblocks-Babylonian' }
String >> sbWatchValueMorphFor: aSBWatchValue sized: aSBMorphResizer [

	^ (SBWatchValue newContainerMorphFor: aSBWatchValue) 
		addMorphBack: (SBStringMorph new contents: self asText)
		yourself
]
