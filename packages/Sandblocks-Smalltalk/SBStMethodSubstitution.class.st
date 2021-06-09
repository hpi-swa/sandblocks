Class {
	#name : #SBStMethodSubstitution,
	#superclass : #SBStBasicMethod,
	#category : #'Sandblocks-Smalltalk'
}

{ #category : #'as yet unclassified' }
SBStMethodSubstitution class >> catchesAll [

	^ false
]

{ #category : #'as yet unclassified' }
SBStMethodSubstitution class >> causesSideEffects [

	^ false
]

{ #category : #'as yet unclassified' }
SBStMethodSubstitution class >> derive: anObject [

	^ anObject
]

{ #category : #'as yet unclassified' }
SBStMethodSubstitution class >> identity [

	^ false
]

{ #category : #'as yet unclassified' }
SBStMethodSubstitution class >> isLeaf [

	^ true
]

{ #category : #'as yet unclassified' }
SBStMethodSubstitution class >> isToplevelMorph [

	^ true
]

{ #category : #'as yet unclassified' }
SBStMethodSubstitution class >> matches: anObject [

	^ anObject isCompiledMethod or: [anObject isSandblock and: [anObject isMethod and: [self matchSpecific: anObject]]]
]

{ #category : #'as yet unclassified' }
SBStMethodSubstitution class >> newFrom: aBlock [

	^ self new selector: aBlock selector arguments: aBlock arguments class: aBlock methodClass
]

{ #category : #'as yet unclassified' }
SBStMethodSubstitution class >> prettyName [

	^ self name allButFirst: 2
]

{ #category : #'as yet unclassified' }
SBStMethodSubstitution class >> priority [

	^ 10
]

{ #category : #'as yet unclassified' }
SBStMethodSubstitution class >> supports: aSymbol [

	^ (self respondsTo: aSymbol) and: [self perform: aSymbol]
]
