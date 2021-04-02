Class {
	#name : #SBObservableExample,
	#superclass : #Object,
	#instVars : [
		'listeners'
	],
	#category : #'Sandblocks-Tutorial'
}

{ #category : #'forward declarations' }
SBObservableExample class >> onDelete: aBlock [
]

{ #category : #'test/example' }
SBObservableExample >> example [

	| observable observer |
	observable := self class new.
	observer := Object new.
	
	observable notify: #test.
	
	observable listen: observer
]

{ #category : #'initialize-release' }
SBObservableExample >> initialize [

	listeners := OrderedCollection new
]

{ #category : #observer }
SBObservableExample >> listen: anObject [

	self listeners add: anObject
]

{ #category : #observer }
SBObservableExample >> listeners [

	^ listeners
]

{ #category : #observer }
SBObservableExample >> notify [

	self listeners do: [:listener | listener notify]
]

{ #category : #observer }
SBObservableExample >> removeSubscription: anObject [

	listeners removeAllSuchThat: [:listener | listener ~= anObject]
]
