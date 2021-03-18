Class {
	#name : #SBConvertOption,
	#superclass : #Object,
	#instVars : [
		'do',
		'name'
	],
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBConvertOption class >> named: aString do: aBlock [

	^ self new
		name: aString;
		do: aBlock
		yourself
]

{ #category : #'as yet unclassified' }
SBConvertOption class >> on: anObject send: aSymbol [

	^ self new
		name: aSymbol allButLast;
		do: [:converter | anObject perform: aSymbol with: converter];
		yourself
]

{ #category : #'as yet unclassified' }
SBConvertOption >> apply: aConverter [

	self do value: aConverter
]

{ #category : #'as yet unclassified' }
SBConvertOption >> do [

	^ do
]

{ #category : #'as yet unclassified' }
SBConvertOption >> do: aBlock [

	do := aBlock
]

{ #category : #'as yet unclassified' }
SBConvertOption >> name [

	^ name
]

{ #category : #'as yet unclassified' }
SBConvertOption >> name: aString [

	name := aString
]

{ #category : #'as yet unclassified' }
SBConvertOption >> printOn: aStream [

	aStream nextPutAll: self className; space; nextPutAll: self name
]
