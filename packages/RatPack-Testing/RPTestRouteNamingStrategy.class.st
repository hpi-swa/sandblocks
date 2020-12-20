Class {
	#name : #RPTestRouteNamingStrategy,
	#superclass : #RPRouteNamingStrategy,
	#instVars : [
		'app'
	],
	#category : #'RatPack-Testing'
}

{ #category : #'as yet unclassified' }
RPTestRouteNamingStrategy >> nameRoute: aModelClassName [

	^ aModelClassName, 'test'
]
