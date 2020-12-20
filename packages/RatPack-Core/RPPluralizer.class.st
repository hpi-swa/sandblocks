Class {
	#name : #RPPluralizer,
	#superclass : #RPRouteNamingStrategy,
	#category : #'RatPack-Core'
}

{ #category : #routing }
RPPluralizer >> nameRoute: aClassName [

	^ aClassName, 's'
]
