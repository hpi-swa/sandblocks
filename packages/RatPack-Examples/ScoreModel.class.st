Class {
	#name : #ScoreModel,
	#superclass : #RPModel,
	#instVars : [
		'game',
		'score',
		'player'
	],
	#category : #'RatPack-Examples'
}

{ #category : #'as yet unclassified' }
ScoreModel class >> dataTypes [ 

^ Dictionary newFrom: { 
						'game'-> 'INT'.
						'player'-> 'INT'.
						'score' -> 'VARCHAR(50)' 
					}
	
]

{ #category : #'as yet unclassified' }
ScoreModel class >> defaultRoute [

	^ 'highscores'
]

{ #category : #'as yet unclassified' }
ScoreModel class >> defaultValues [  

^ Dictionary newFrom: {
						'game' -> 1.
						'player' -> 1.
						'score' -> '42'}
	
]

{ #category : #'as yet unclassified' }
ScoreModel class >> overridesDefaultRoute [ 

	^ true
	

]

{ #category : #'as yet unclassified' }
ScoreModel class >> refClass [

	^ Score
	
]

{ #category : #'as yet unclassified' }
ScoreModel class >> tableName [
	
	^ self refClass name asString
]
