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
SBMorphResizer class >> newBig [

	^ self newLabeled: 'big' transforming: [:aMorph | aMorph extent: 350@350]
]

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
SBMorphResizer class >> newMedium [

	^ self newLabeled: 'medium' transforming: [:aMorph | aMorph extent: 150@150]
]

{ #category : #'initialize-release' }
SBMorphResizer class >> newSmall [

	^ self newLabeled: 'small' transforming: [:aMorph | aMorph extent: 100@100]
]

{ #category : #'initialize-release' }
SBMorphResizer class >> newThumbmail [

	^ self newLabeled: 'thumbmail' transforming: [:aMorph | aMorph extent: 40@40]
]

{ #category : #'initialize-release' }
SBMorphResizer class >> newTiny [

	^ self newLabeled: 'small' transforming: [:aMorph | aMorph extent: 15@15]
]

{ #category : #'initialize-release' }
SBMorphResizer class >> standardOptions [

	^ {self newTiny.
		self newThumbmail.
		self newSmall.
		self newMedium.
		self newBig.
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
