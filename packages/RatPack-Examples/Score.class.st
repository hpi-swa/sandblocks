Class {
	#name : #Score,
	#superclass : #Object,
	#instVars : [
		'game',
		'score',
		'player'
	],
	#category : #'RatPack-Examples'
}

{ #category : #accessing }
Score >> game [
	^ game
]

{ #category : #accessing }
Score >> game: anObject [
	game := anObject
]

{ #category : #accessing }
Score >> player [
	^ player
]

{ #category : #accessing }
Score >> player: anObject [
	player := anObject
]

{ #category : #accessing }
Score >> score [
	^ score
]

{ #category : #accessing }
Score >> score: anObject [
	score := anObject
]
