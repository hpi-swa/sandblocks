Class {
	#name : #SBStNameList,
	#superclass : #SBStArray,
	#instVars : [
		'addType'
	],
	#category : #'Sandblocks-Smalltalk'
}

{ #category : #'as yet unclassified' }
SBStNameList >> isExpression [

	^ false
]

{ #category : #'as yet unclassified' }
SBStNameList >> newNullBlock [

	^ SBStName new
]

{ #category : #'as yet unclassified' }
SBStNameList >> objectInterfaceAt: aNumber adding: aBoolean [

	^ SBInterfaces stName
]
