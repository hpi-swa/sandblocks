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

	^ self newLabeled: 'big' transforming: [:anObject | anObject applyResize: (350@350) sbScaled]
]

{ #category : #'initialize-release' }
SBMorphResizer class >> newIdentity [

	^ self newLabeled: 'original' transforming: [:anObject | "Do nothing" anObject] 
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

	^ self newLabeled: 'medium' transforming: [:anObject | anObject applyResize: (200@200) sbScaled]
]

{ #category : #'initialize-release' }
SBMorphResizer class >> newSmall [

	^ self newLabeled: 'small' transforming: [:anObject | anObject applyResize: (100@100) sbScaled]
]

{ #category : #'initialize-release' }
SBMorphResizer class >> newThumbmail [

	^ self newLabeled: 'thumbmail' transforming: [:anObject | anObject applyResize: (40@40) sbScaled]
]

{ #category : #'initialize-release' }
SBMorphResizer class >> newTiny [

	^ self newLabeled: 'tiny' transforming: [:anObject | anObject applyResize: (15@15) sbScaled]
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

	^ self transformFunction value: aMorph.
	
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
