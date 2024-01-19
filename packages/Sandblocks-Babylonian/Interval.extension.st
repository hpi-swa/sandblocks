Extension { #name : #Interval }

{ #category : #'*Sandblocks-Babylonian' }
Interval class >> exampleBlock [

	^ '1 to: 10' parseAsSandblock
]

{ #category : #'*Sandblocks-Babylonian' }
Interval class >> exampleBlockContainingClass: aClass [

	^ self exampleBlock 
	
	
]

{ #category : #'*Sandblocks-Babylonian' }
Interval class >> exampleObject [

	^ 1 to: 10
]

{ #category : #'*Sandblocks-Babylonian' }
Interval class >> exampleObjectContainingClass: aClass [

	^ self exampleObject
]
