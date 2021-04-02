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

{ #category : #subscriptions }
SBObservableExample >> listen: anObject [

	listeners add: anObject.
]

{ #category : #subscriptions }
SBObservableExample >> listeners [

	^ listeners
]

{ #category : #subscriptions }
SBObservableExample >> notify [

	self listeners do: [:listener | listener notify]
]

{ #category : #subscriptions }
SBObservableExample >> removeSubscription: anObject [

	listeners removeAllSuchThat: [:listener | listener ~= anObject]
]
