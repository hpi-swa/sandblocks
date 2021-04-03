" keysAndValuesDo: ifAbsentPut: Dictionary ifPresent: removeKey: valuesDo: onDelete: "
Class {
	#name : #SBObservableExample,
	#superclass : #Object,
	#instVars : [
		'listeners'
	],
	#category : #ObservableExperiment
}

{ #category : #'initialize-release' }
Observable >> initialize [

	listeners := OrderedCollection new
]

{ #category : #'observer' }
Observable >> listen: anObject [

	self listeners add: anObject
]

{ #category : #'observer' }
Observable >> listeners [

	^ listeners
]

{ #category : #'observer' }
Observable >> notify [

	self listeners do: [:listener | listener notify]
]

{ #category : #'observer' }
Observable >> removeSubscription: anObject [

	listeners removeAllSuchThat: [:listener | listener ~= anObject]
]

{ #category : #'test/example' }
Observable >> example [

	| observable observer sub |
	observable := self class new.
	observer := Object new.

	observable notify: #test.

	observable listen: observer.
]

