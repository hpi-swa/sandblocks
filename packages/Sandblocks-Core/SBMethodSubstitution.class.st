Class {
	#name : #SBMethodSubstitution,
	#superclass : #SBBasicMethod,
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBMethodSubstitution class >> catchesAll [

	^ false
]

{ #category : #'as yet unclassified' }
SBMethodSubstitution class >> causesSideEffects [

	^ false
]

{ #category : #'as yet unclassified' }
SBMethodSubstitution class >> derive: anObject [

	^ anObject
]

{ #category : #'as yet unclassified' }
SBMethodSubstitution class >> identity [

	^ false
]

{ #category : #'as yet unclassified' }
SBMethodSubstitution class >> isLeaf [

	^ true
]

{ #category : #'as yet unclassified' }
SBMethodSubstitution class >> isToplevelMorph [

	^ true
]

{ #category : #'as yet unclassified' }
SBMethodSubstitution class >> matches: anObject [

	^ anObject isCompiledMethod or: [anObject isSandblock and: [anObject isMethod]]
]

{ #category : #'as yet unclassified' }
SBMethodSubstitution class >> newFor: anObject [

	^ self subclassResponsibility
]

{ #category : #'as yet unclassified' }
SBMethodSubstitution class >> prettyName [

	^ self name allButFirst: 2
]

{ #category : #'as yet unclassified' }
SBMethodSubstitution class >> priority [

	^ 10
]

{ #category : #'as yet unclassified' }
SBMethodSubstitution class >> supports: aSymbol [

	^ (self respondsTo: aSymbol) and: [self perform: aSymbol]
]
