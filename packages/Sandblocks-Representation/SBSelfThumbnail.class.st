Class {
	#name : #SBSelfThumbnail,
	#superclass : #SBASTNode,
	#instVars : [
		'form'
	],
	#category : #'Sandblocks-Representation'
}

{ #category : #'as yet unclassified' }
SBSelfThumbnail >> drawOn: aCanvas [

	aCanvas drawImage: form at: self position
]

{ #category : #'as yet unclassified' }
SBSelfThumbnail >> extent: aPoint [

	super extent: (form ifNotNil: [form extent] ifNil: [aPoint])
]

{ #category : #'as yet unclassified' }
SBSelfThumbnail >> form: aForm [

	form := aForm.
	self changed
]

{ #category : #'as yet unclassified' }
SBSelfThumbnail >> guessedClass [

	^ self containingArtefact evaluationReceiver class
]

{ #category : #'as yet unclassified' }
SBSelfThumbnail >> isExpression [

	^ true
]

{ #category : #'as yet unclassified' }
SBSelfThumbnail >> object [

	^ self containingArtefact evaluationReceiver
]

{ #category : #'as yet unclassified' }
SBSelfThumbnail >> object: anObject [

	SBToggledCode comment: 'currently requires a morph' active: 1 do: {[self form: (anObject iconOrThumbnail scaledToFit: 48 asPoint)]}
]

{ #category : #'as yet unclassified' }
SBSelfThumbnail >> writeSourceOn: aStream [

	aStream nextPutAll: 'self'
]
