Class {
	#name : #SBObservableExample,
	#superclass : #Object,
	#instVars : [
		'listeners'
	],
	#classInstVars : [
		'listenerMap'
	],
	#category : #'Sandblocks-Tutorial'
}

{ #category : #example }
SBObservableExample class >> example [

	| observable sub observer |
	observable := self class new.
	observer := Object new.
	observable notify: #test1.
	observable notify: #test2.
	sub := observable listen: observer for: #test1.
	observer onDelete: [observable removeSubscription: sub].
	observable notify: #test1
]

{ #category : #initialize }
SBObservableExample class >> initialize [

	listenerMap := Dictionary new
]

{ #category : #observer }
SBObservableExample class >> listen: anObject for: aString [

	| sub |
	sub := Notification new.
	(self listenerMap at: aString ifAbsentPut: [Dictionary new]) add: sub -> anObject.
	^ sub
]

{ #category : #observer }
SBObservableExample class >> listenerMap [

	^ listenerMap
]

{ #category : #observer }
SBObservableExample class >> notify: aTopicString [

	(self listenerMap at: aTopicString) keysAndValuesDo: [:sub :listener | listener notify]
]

{ #category : #'forward declarations' }
SBObservableExample class >> onDelete: aBlock [
]

{ #category : #observer }
SBObservableExample class >> removeSubscription: aSubscription [

	listenerMap valuesDo: [:listener | listener at: aSubscription ifPresent: [listener removeKey: aSubscription]]
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
