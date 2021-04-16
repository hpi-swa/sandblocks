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
SBStNameList >> newEmptyChildNear: aBlock before: aBoolean [

	^ SBStName new
]

{ #category : #'as yet unclassified' }
SBStNameList >> objectInterfaceNear: aBlock at: aSymbol [

	^ SBInterfaces stName
]
