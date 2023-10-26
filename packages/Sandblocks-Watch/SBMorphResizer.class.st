"
A util class for the scale menu on example watches.
"
Class {
	#name : #SBMorphResizer,
	#superclass : #Object,
	#instVars : [
		'label',
		'transformFunction'
	],
	#category : #'Sandblocks-Watch'
}

{ #category : #'initialize-release' }
SBMorphResizer class >> newIdentity [

	^ self newLabeled: 'original' transforming: [:aMorph | "Do nothing"] 
]

{ #category : #'initialize-release' }
SBMorphResizer class >> newLabeled: aName transforming: aBlockTakingASingleParameter [

	^ self new
		label: aName;
		transformFunction:  aBlockTakingASingleParameter;
		yourself
]

{ #category : #'initialize-release' }
SBMorphResizer class >> standardOptions [

	^ {
		self newLabeled: 'small' transforming: [:aMorph | aMorph extent: 30@30].
		self newLabeled: 'medium' transforming: [:aMorph | aMorph extent: 150@150].
		self newLabeled: 'big' transforming: [:aMorph | aMorph extent: 350@350].
		self newIdentity}
]

{ #category : #actions }
SBMorphResizer >> applyOn: aMorph [

	self transformFunction value: aMorph.
	^ aMorph
]

{ #category : #'initialize-release' }
SBMorphResizer >> initialize [ 

	super initialize.
	
	self label: 'Original'.
	self transformFunction: [:aMorph | ].
]

{ #category : #accessing }
SBMorphResizer >> label [

	^ label
]

{ #category : #accessing }
SBMorphResizer >> label: aString [

	label := aString
]

{ #category : #printing }
SBMorphResizer >> printString [ 

	^ self label
]

{ #category : #accessing }
SBMorphResizer >> transformFunction [

	^ transformFunction
]

{ #category : #accessing }
SBMorphResizer >> transformFunction: aBlockTakingASingleParameter [

	transformFunction := aBlockTakingASingleParameter
]
