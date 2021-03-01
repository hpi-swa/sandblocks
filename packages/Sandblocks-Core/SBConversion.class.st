Class {
	#name : #SBConversion,
	#superclass : #Object,
	#instVars : [
		'object',
		'converted',
		'option'
	],
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBConversion >> applyTo: anObject [

	| convert |
	anObject = object ifTrue: [^ converted].
	
	object := anObject.
	convert := SBConvert new success: [:c | ^ converted := c].
	option apply: convert
]

{ #category : #'as yet unclassified' }
SBConversion >> option: aConvertOption object: anObject [

	option := aConvertOption.
	object := anObject
]
