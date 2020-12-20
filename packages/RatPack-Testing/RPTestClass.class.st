Class {
	#name : #RPTestClass,
	#superclass : #Object,
	#instVars : [
		'salary',
		'name'
	],
	#category : #'RatPack-Testing'
}

{ #category : #accessing }
RPTestClass >> name [
	^ name
]

{ #category : #accessing }
RPTestClass >> name: anObject [
	name := anObject
]

{ #category : #accessing }
RPTestClass >> salary [
	^ salary
]

{ #category : #accessing }
RPTestClass >> salary: anObject [
	salary := anObject
]
