"
A util class for the scale menu on example watches.
"
Class {
	#name : #SBDimension,
	#superclass : #Object,
	#instVars : [
		'label',
		'transformFunction'
	],
	#category : #'Sandblocks-Watch'
}

{ #category : #'initialize-release' }
SBDimension class >> newLabeled: aName transforming: aBlockTakingASingleParameter [

	^ self new
		label: aName;
		transformFunction:  aBlockTakingASingleParameter;
		yourself
]

{ #category : #'initialize-release' }
SBDimension class >> standardOptions [

	^ {
		self newLabeled: 'small' transforming: [:aMorph | aMorph extent: 50@50].
		self newLabeled: 'medium' transforming: [:aMorph | aMorph extent: 300@300].
		self newLabeled: 'big' transforming: [:aMorph | aMorph extent: 600@600].
		self newLabeled: 'original' transforming: [:aMorph | "Change nothing"]}
]

{ #category : #actions }
SBDimension >> applyOn: aMorph [

	self transformFunction value: aMorph
]

{ #category : #'initialize-release' }
SBDimension >> initialize [ 

	super initialize.
	
	self label: 'Original'.
	self transformFunction: [:aMorph | ].
]

{ #category : #accessing }
SBDimension >> label [

	^ label
]

{ #category : #accessing }
SBDimension >> label: aString [

	label := aString
]

{ #category : #printing }
SBDimension >> printString [ 

	^ self label
]

{ #category : #accessing }
SBDimension >> transformFunction [

	^ transformFunction
]

{ #category : #accessing }
SBDimension >> transformFunction: aBlockTakingASingleParameter [

	transformFunction := aBlockTakingASingleParameter
]
