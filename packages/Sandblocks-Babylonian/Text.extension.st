Extension { #name : #Text }

{ #category : #'*Sandblocks-Babylonian' }
Text class >> exampleBlock [

	^ ('Text fromString: ''', self exampleObject, '''') parseAsSandblock 
]

{ #category : #'*Sandblocks-Babylonian' }
Text class >> exampleBlockContainingClass: aClass [

	^ self exampleBlock 
	
	
]

{ #category : #'*Sandblocks-Babylonian' }
Text class >> exampleObject [

	^ self fromString: 'Hello, World'
]

{ #category : #'*Sandblocks-Babylonian' }
Text class >> exampleObjectContainingClass: aClass [

	^ self exampleObject
]

{ #category : #'*Sandblocks-Babylonian' }
Text >> sbWatchValueMorphFor: aSBWatchValue sized: aSBMorphResizer [

	^ (SBWatchValue newContainerMorphFor: aSBWatchValue)  
		addMorphBack: (SBStringMorph new contents: self)
		yourself
]
