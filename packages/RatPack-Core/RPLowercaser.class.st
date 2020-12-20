Class {
	#name : #RPLowercaser,
	#superclass : #RPRouteNamingStrategy,
	#category : #'RatPack-Core'
}

{ #category : #routing }
RPLowercaser >> nameRoute: aModelClassName [

	^ aModelClassName asLowercase
]
