"
This is a data class. It contains all data which should be saved into the database.
"
Class {
	#name : #Game,
	#superclass : #Object,
	#instVars : [
		'name',
		'description',
		'image',
		'password'
	],
	#category : #'RatPack-Examples'
}

{ #category : #accessing }
Game >> description [
	^ description
]

{ #category : #accessing }
Game >> description: anObject [
	description := anObject
]

{ #category : #accessing }
Game >> image [
	^ image
]

{ #category : #accessing }
Game >> image: anObject [
	image := anObject
]

{ #category : #accessing }
Game >> name [
	^ name
]

{ #category : #accessing }
Game >> name: anObject [
	name := anObject
]

{ #category : #accessing }
Game >> password [
	^ password
]

{ #category : #accessing }
Game >> password: anObject [
	password := anObject
]
