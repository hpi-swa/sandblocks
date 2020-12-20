Class {
	#name : #SBCodeAction,
	#superclass : #Object,
	#instVars : [
		'label',
		'target',
		'action'
	],
	#category : 'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBCodeAction class >> labeled: aString for: aNodeBlock do: aBlock [

	^ self new
		label: aString;
		target: aNodeBlock;
		action: aBlock;
		yourself
]

{ #category : #accessing }
SBCodeAction >> action [
	^ action
]

{ #category : #accessing }
SBCodeAction >> action: anObject [
	action := anObject
]

{ #category : #accessing }
SBCodeAction >> do [

	self action value: self target
]

{ #category : #accessing }
SBCodeAction >> label [
	^ label
]

{ #category : #accessing }
SBCodeAction >> label: anObject [
	label := anObject
]

{ #category : #accessing }
SBCodeAction >> target [
	^ target
]

{ #category : #accessing }
SBCodeAction >> target: anObject [
	target := anObject
]
