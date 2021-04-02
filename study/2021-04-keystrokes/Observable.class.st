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

{ #category : #'subscriptions' }
Observable >> listen: anObject [

	self listeners add: anObject
]

{ #category : #'subscriptions' }
Observable >> listeners [

	^ listeners
]

{ #category : #'subscriptions' }
Observable >> notify [

	self listeners do: [:listener | listener notify]
]

{ #category : #'subscriptions' }
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

