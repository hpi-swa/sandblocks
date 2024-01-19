Extension { #name : #Collection }

{ #category : #'*Sandblocks-Babylonian' }
Collection class >> exampleBlockContainingClass: aClass [

	| class |
	self flag: #todo. 
	"Lazy way to avoid adding overrides with concrete classes in the huge amount of subclasses"
	class := (self = Collection) ifTrue: [OrderedCollection] ifFalse: self. 
	^ SBStMessageSend new
		receiver: (SBStName contents: class name)
		selector: #withAll:
		arguments: {SBStArray withContents: (class withAll: ((1 to: 5) collect: [:i | aClass exampleBlock]))}
	
	
]

{ #category : #'*Sandblocks-Babylonian' }
Collection class >> exampleObjectContainingClass: aClass [

	^ self withAll: ((1 to: 5) collect: [:i | aClass exampleObject])
]

{ #category : #'*Sandblocks-Babylonian' }
Collection >> sbWatchValueMorphFor: aSBWatchValue sized: aSBMorphResizer [

	^ (SBWatchValue newContainerMorphFor: aSBWatchValue) 
		addMorph: (SBStringMorph new contents: (self printStringLimitedTo: 1000));
		yourself
]
