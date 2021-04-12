Class {
	#name : #Observable1,
	#superclass : #Object,
	#instVars : [
		'listeners'
	],
	#category : #ObservableExperiment
}

{ #category : #'as yet unclassified' }
Observable1 >> example [

	| observable observer sub |
	observable := MailService new.
	observer := Object new.

	observable notify: #test.

	observable listen: observer.
]

{ #category : #'as yet unclassified' }
Observable1 >> initialize [

	listeners := OrderedCollection new
]

{ #category : #'as yet unclassified' }
Observable1 >> listen: anObject for: aTopicg [

	| sub |
	sub := Subscription new.
	listeners add: anObject
]

{ #category : #'as yet unclassified' }
Observable1 >> listeners [

	^ listeners
]

{ #category : #'as yet unclassified' }
Observable1 >> notify [

	self listeners do: [:listener | listener notify]
]

{ #category : #'as yet unclassified' }
Observable1 >> removeSubscription: anObject [

	self listeners removeAllSuchThat: [:listener | listener ~= anObject]
]
