Class {
	#name : #SBNameList,
	#superclass : #SBArray,
	#instVars : [
		'addType'
	],
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBNameList >> isExpression [

	^ false
]

{ #category : #'as yet unclassified' }
SBNameList >> newChild [

	^ SBName new
]

{ #category : #'as yet unclassified' }
SBNameList >> objectInterfaceAt: aNumber adding: aBoolean [

	^ SBInterfaces stName
]
