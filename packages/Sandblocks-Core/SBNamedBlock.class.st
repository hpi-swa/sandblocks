Class {
	#name : #SBNamedBlock,
	#superclass : #SBBlock,
	#instVars : [
		'name',
		'block',
		'hasBeenRenamed'
	],
	#category : #'Sandblocks-Core'
}

{ #category : #'instance creation' }
SBNamedBlock class >> block: aSBBlock [

	^ self new
		block: aSBBlock;
		name: self noRenameString 
]

{ #category : #'instance creation' }
SBNamedBlock class >> block: aSBBlock named: aString [

	^ self new
		block: aSBBlock;
		name: aString;
		hasBeenRenamed: aString ~= self noRenameString
]

{ #category : #'instance creation' }
SBNamedBlock class >> noRenameString [

	^ ''
]

{ #category : #accessing }
SBNamedBlock >> block [

	^ block
]

{ #category : #accessing }
SBNamedBlock >> block: aSBBlock [

	block := aSBBlock
]

{ #category : #accessing }
SBNamedBlock >> hasBeenRenamed [

	^ hasBeenRenamed
]

{ #category : #accessing }
SBNamedBlock >> hasBeenRenamed: aBoolean [

	hasBeenRenamed := aBoolean
]

{ #category : #initialization }
SBNamedBlock >> initialize [

	super initialize.
	
	self hasBeenRenamed: false;
		name: 'A Block';
		block: (SBLabel new contents: 'Some Content').
]

{ #category : #accessing }
SBNamedBlock >> name [

	^ name
]

{ #category : #accessing }
SBNamedBlock >> name: aString [

	name := aString
]

{ #category : #accessing }
SBNamedBlock >> nameToDisplay [

	^ self hasBeenRenamed 
		ifTrue: [self name] 
		ifFalse: [self suggestedName]
]

{ #category : #initialization }
SBNamedBlock >> suggestedName [

	| limitedString |
	self block statements ifEmpty: [^ 'empty' ].
	limitedString := 
		String streamContents: [:aStream | 
			aStream nextPutAll: ((self block statements collect: #suggestedAlternationName) 
															fold: [:a :b | a, ' ', b])] 
		limitedTo: 20.
	limitedString size < 20 ifTrue: [^ limitedString].
	^ limitedString , '...'
]

{ #category : #printing }
SBNamedBlock >> writeSourceOn: aStream [

	self hasBeenRenamed 
		ifTrue: [self name storeOn: aStream] 
		ifFalse: [self class noRenameString storeOn: aStream].
	aStream nextPutAll: ' -> '.
	self block writeSourceOn: aStream
]
