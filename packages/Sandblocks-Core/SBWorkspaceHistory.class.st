Class {
	#name : #SBWorkspaceHistory,
	#superclass : #Object,
	#instVars : [
		'items'
	],
	#classVars : [
		'Instance'
	],
	#category : 'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBWorkspaceHistory class >> default [

	^ Instance ifNil: [Instance := self new]
]

{ #category : #'as yet unclassified' }
SBWorkspaceHistory class >> open: aString [

	self default open: aString
]

{ #category : #'as yet unclassified' }
SBWorkspaceHistory >> initialize [

	super initialize.
	
	items := SortedCollection sortBlock: [:a :b | a date > b date]
]

{ #category : #'as yet unclassified' }
SBWorkspaceHistory >> items [

	^ items
]

{ #category : #'as yet unclassified' }
SBWorkspaceHistory >> open: aString [

	self items detect: [:i | i name = aString] ifFound: #open
]

{ #category : #'as yet unclassified' }
SBWorkspaceHistory >> save: anEditor named: aString [

	^ items add: (SBWorkspaceRecord new
		workspaceString: anEditor storeString;
		name: aString;
		date: DateAndTime now;
		yourself)
]
