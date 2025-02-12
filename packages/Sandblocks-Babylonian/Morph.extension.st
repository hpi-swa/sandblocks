Extension { #name : #Morph }

{ #category : #'*Sandblocks-Babylonian' }
Morph >> applyResize: aPoint [

	^ self extent: aPoint
]

{ #category : #'*Sandblocks-Babylonian' }
Morph >> childrenFormCollection [
	
	^ (self isTextMorph or: [self isStringMorph])
		ifTrue: [{}]
		ifFalse: [{ImageMorph new newForm: self imageForm}]
]

{ #category : #'*Sandblocks-Babylonian' }
Morph class >> exampleObject [

	^ self new
]

{ #category : #'*Sandblocks-Babylonian' }
Morph >> hasBeenTagged [

	^ self tag isNilTag not
]

{ #category : #'*Sandblocks-Babylonian' }
Morph >> layoutedTaggedCopy [

	^ self class new
		extent: self extent;
		color: self color;
		layoutProperties: self layoutProperties;
		layoutPolicy: self layoutPolicy;
		borderStyle: self borderStyle;
		tag: self tag;
		yourself 
				
		
]

{ #category : #'*Sandblocks-Babylonian' }
Morph >> listensToPermutations [ 

	^ false
]

{ #category : #'*Sandblocks-Babylonian' }
Morph >> satisfiesTag: anotherSBTag [

	^ self tag satisfiesTag: anotherSBTag
]

{ #category : #'*Sandblocks-Babylonian' }
Morph >> sbWatchValueMorphFor: aSBWatchValue sized: aSBMorphResizer [

	^ (SBWatchValue newContainerMorphFor: aSBWatchValue)  
		addMorphBack: (aSBMorphResizer applyOn: self sbSnapshot asMorph);
		yourself
]

{ #category : #'*Sandblocks-Babylonian' }
Morph >> snapshot [

	^ self snapshotSatisfying: {} 
]

{ #category : #'*Sandblocks-Babylonian' }
Morph >> snapshotSatisfying: aCollectionOfTags [
	
	| emptyCopy |
	"normal morph, doesn't even know tags!"
	(self hasBeenTagged not and: [ self topLevelTaggedChildren isEmpty ])
		ifTrue: [^ ImageMorph new newForm: self imageForm ]. 
	
	"there are some tags in this layout that we want to preserve"
	emptyCopy := self layoutedTaggedCopy.
	
	"Not satisfying tag, filter out" 
	(self hasBeenTagged and: [aCollectionOfTags anySatisfy: [:aTag | (self satisfiesTag: aTag) not ]])
		ifTrue: [ ^ nil ]. 
	
	"When this is the last tag in the hierarchy, we can stop right here."
	(self hasBeenTagged and: [self topLevelTaggedChildren isEmpty]) 
		ifTrue: [ ^ (ImageMorph new newForm: self imageForm) tag: self tag].
			
	"Process and add tagged children."
	^ emptyCopy addAllMorphsBack: ((self submorphs 
											collect: [:aChild | aChild snapshotSatisfying: aCollectionOfTags])
											reject: #isNil)
	
]

{ #category : #'*Sandblocks-Babylonian' }
Morph >> tag [

	^ self valueOfProperty: #SBTag ifAbsentPut: [ SBNilTag new ]
]

{ #category : #'*Sandblocks-Babylonian' }
Morph >> tag: aSBTag [
	
	self setProperty: #SBTag toValue: aSBTag 
]

{ #category : #'*Sandblocks-Babylonian' }
Morph >> topLevelTaggedChildren [

	| childrenToCheck foundTaggedChildren |
	childrenToCheck := self submorphs asOrderedCollection.
	foundTaggedChildren := OrderedCollection new.
	[childrenToCheck isEmpty] whileFalse: [ | child |
		child := childrenToCheck removeFirst. 
		child hasBeenTagged
			ifTrue: [foundTaggedChildren add: child]
			ifFalse: [childrenToCheck addAll: child submorphs]].
	^ foundTaggedChildren 
	
]

{ #category : #'*Sandblocks-Babylonian' }
Morph >> topLevelVariants [

	^ Array streamContents: [:stream | self topLevelVariantsDo: [:block | stream nextPut: block]]
]

{ #category : #'*Sandblocks-Babylonian' }
Morph >> topLevelVariantsDo: aBlock [

	self submorphsDo: [:morph |
		(morph isSandblock and: [morph isVariant])
			ifTrue: [aBlock value: morph]
			ifFalse: [morph topLevelVariantsDo: aBlock]]
]
