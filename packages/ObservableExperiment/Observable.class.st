Class {
	#name : #Observable,
	#superclass : #Object,
	#instVars : [
		'listeners'
	],
	#category : #ObservableExperiment
}

{ #category : #'as yet unclassified' }
Observable >> example [

	| observable observer |
	observable := Observable new.
	observer := Object new.
	
	observable notify: #test.
	
	observable listen: observer
]

{ #category : #'as yet unclassified' }
Observable >> initialize [

	listeners := OrderedCollection new
]

{ #category : #'as yet unclassified' }
Observable >> listen: anObject [

	listeners add: anObject.
]

{ #category : #'as yet unclassified' }
Observable >> listeners [

	^ listeners
]

{ #category : #'as yet unclassified' }
Observable >> notify [

	self listeners do: [:listener | listener notify]
]

{ #category : #'as yet unclassified' }
Observable >> removeSubscription: anObject [

	listeners removeAllSuchThat: [:listener | listener ~= anObject]
]
