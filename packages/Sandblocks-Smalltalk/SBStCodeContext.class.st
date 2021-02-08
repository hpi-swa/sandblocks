Class {
	#name : #SBStCodeContext,
	#superclass : #Object,
	#instVars : [
		'pc',
		'selector',
		'methodClass',
		'stringRepresentation'
	],
	#category : #'Sandblocks-Smalltalk'
}

{ #category : #'as yet unclassified' }
SBStCodeContext class >> class: aClass selector: aSymbol [

	^ self new
		methodClass: aClass;
		selector: aSymbol;
		stringRepresentation: aClass name, ' >> #', aSymbol;
		yourself
]

{ #category : #'as yet unclassified' }
SBStCodeContext class >> class: aClass selector: aSymbol ifValid: aBlock [

	(aClass methodDict includesKey: aSymbol) ifTrue: [
		^ aBlock value: (self class: aClass selector: aSymbol)]
]

{ #category : #'as yet unclassified' }
SBStCodeContext class >> for: aContext [

	^ self new
		pc: aContext pc;
		methodClass: aContext methodClass;
		selector: aContext selector;
		stringRepresentation: aContext asString;
		yourself
]

{ #category : #'as yet unclassified' }
SBStCodeContext class >> forPreviousOf: aContext [

	
	^ self new
		pc: aContext previousPc;
		methodClass: aContext methodClass;
		selector: aContext selector;
		stringRepresentation: aContext asString;
		yourself
]

{ #category : #'as yet unclassified' }
SBStCodeContext >> = aCodeContext [

	^ self methodClass = aCodeContext methodClass and: [self selector = aCodeContext selector and: [self pc = aCodeContext pc]]
]

{ #category : #'as yet unclassified' }
SBStCodeContext >> decrementPC: aNumber [

	pc := pc - aNumber
]

{ #category : #'as yet unclassified' }
SBStCodeContext >> hash [

	^ (self methodClass hash bitXor: (self selector hash bitXor: self pc hash)) hashMultiply
]

{ #category : #'as yet unclassified' }
SBStCodeContext >> imageForm [

	^ ((SBEditor new open: self method; yourself) method blockForPC: self pc) imageForm
]

{ #category : #'as yet unclassified' }
SBStCodeContext >> method [

	^ self methodClass methodDict at: self selector ifAbsent: [nil]
]

{ #category : #'as yet unclassified' }
SBStCodeContext >> methodClass [

	^ methodClass
]

{ #category : #'as yet unclassified' }
SBStCodeContext >> methodClass: aClass [

	methodClass := aClass
]

{ #category : #'as yet unclassified' }
SBStCodeContext >> pc [

	^ pc
]

{ #category : #'as yet unclassified' }
SBStCodeContext >> pc: aNumber [

	pc := aNumber
]

{ #category : #'as yet unclassified' }
SBStCodeContext >> printOn: aStream [

	aStream
		nextPutAll: self className;
		nextPut: $(;
		nextPutAll: self stringRepresentation;
		nextPut: $@;
		nextPutAll: pc asString;
		nextPut: $)
]

{ #category : #'as yet unclassified' }
SBStCodeContext >> selector [

	^ selector
]

{ #category : #'as yet unclassified' }
SBStCodeContext >> selector: aSymbol [

	selector := aSymbol
]

{ #category : #'as yet unclassified' }
SBStCodeContext >> stringRepresentation [

	^ stringRepresentation
]

{ #category : #'as yet unclassified' }
SBStCodeContext >> stringRepresentation: aString [

	stringRepresentation := aString
]
