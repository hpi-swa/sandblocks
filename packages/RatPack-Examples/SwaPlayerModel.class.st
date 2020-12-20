Class {
	#name : #SwaPlayerModel,
	#superclass : #RPModel,
	#category : #'RatPack-Examples'
}

{ #category : #'as yet unclassified' }
SwaPlayerModel class >> dataTypes [ 

	^ Dictionary newFrom: { 
		'name' -> 'VARCHAR(50)'. 
	 }
	
]

{ #category : #'as yet unclassified' }
SwaPlayerModel class >> defaultRoute [ 

	^ 'players'
]

{ #category : #'as yet unclassified' }
SwaPlayerModel class >> defaultValues [  

^ Dictionary newFrom: {
						'name' -> 'Player' 
					}
	
]

{ #category : #'as yet unclassified' }
SwaPlayerModel class >> overridesDefaultRoute [ 

	^ true
	

]

{ #category : #'as yet unclassified' }
SwaPlayerModel class >> refClass [

	^ SwaPlayer
	
]

{ #category : #'as yet unclassified' }
SwaPlayerModel class >> tableName [
	
	^ self refClass name asString
]
