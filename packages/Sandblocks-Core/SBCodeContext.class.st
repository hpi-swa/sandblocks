Class {
	#name : #SBCodeContext,
	#superclass : #Object,
	#instVars : [
		'pc',
		'selector',
		'methodClass',
		'stringRepresentation'
	],
	#category : 'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBCodeContext class >> class: aClass selector: aSymbol [

	^ self new
		methodClass: aClass;
		selector: aSymbol;
		stringRepresentation: aClass name, ' >> #', aSymbol;
		yourself
]

{ #category : #'as yet unclassified' }
SBCodeContext class >> class: aClass selector: aSymbol ifValid: aBlock [

	(aClass methodDict includesKey: aSymbol) ifTrue: [
		^ aBlock value: (self class: aClass selector: aSymbol)]
]

{ #category : #'as yet unclassified' }
SBCodeContext class >> for: aContext [

	^ self new
		pc: aContext pc;
		methodClass: aContext methodClass;
		selector: aContext selector;
		stringRepresentation: aContext asString;
		yourself
]

{ #category : #'as yet unclassified' }
SBCodeContext class >> forPreviousOf: aContext [

	
	^ self new
		pc: aContext previousPc;
		methodClass: aContext methodClass;
		selector: aContext selector;
		stringRepresentation: aContext asString;
		yourself
]

{ #category : #'as yet unclassified' }
SBCodeContext >> = aCodeContext [

	^ self methodClass = aCodeContext methodClass and: [self selector = aCodeContext selector and: [self pc = aCodeContext pc]]
]

{ #category : #'as yet unclassified' }
SBCodeContext >> decrementPC: aNumber [

	pc := pc - aNumber
]

{ #category : #'as yet unclassified' }
SBCodeContext >> hash [

	^ (self methodClass hash bitXor: (self selector hash bitXor: self pc hash)) hashMultiply
]

{ #category : #'as yet unclassified' }
SBCodeContext >> imageForm [

	^ ((SBEditor new openCompiledMethod: self method; yourself) method blockForPC: self pc) imageForm
]

{ #category : #'as yet unclassified' }
SBCodeContext >> method [

	^ self methodClass methodDict at: self selector ifAbsent: [nil]
]

{ #category : #'as yet unclassified' }
SBCodeContext >> methodClass [

	^ methodClass
]

{ #category : #'as yet unclassified' }
SBCodeContext >> methodClass: aClass [

	methodClass := aClass
]

{ #category : #'as yet unclassified' }
SBCodeContext >> pc [

	^ pc
]

{ #category : #'as yet unclassified' }
SBCodeContext >> pc: aNumber [

	pc := aNumber
]

{ #category : #'as yet unclassified' }
SBCodeContext >> printOn: aStream [

	aStream
		nextPutAll: self className;
		nextPut: $(;
		nextPutAll: self stringRepresentation;
		nextPut: $@;
		nextPutAll: pc asString;
		nextPut: $)
]

{ #category : #'as yet unclassified' }
SBCodeContext >> selector [

	^ selector
]

{ #category : #'as yet unclassified' }
SBCodeContext >> selector: aSymbol [

	selector := aSymbol
]

{ #category : #'as yet unclassified' }
SBCodeContext >> stringRepresentation [

	^ stringRepresentation
]

{ #category : #'as yet unclassified' }
SBCodeContext >> stringRepresentation: aString [

	stringRepresentation := aString
]
