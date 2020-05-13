"
A SBSelection is a container that wraps copied statements.
"
Class {
	#name : #SBSelection,
	#superclass : #SBBlock,
	#instVars : [
		'colorPolicy',
		'methodClass'
	],
	#category : 'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBSelection >> bindingFor: aString class: aClass ifPresent: aBlock [

	^ nil
]

{ #category : #'as yet unclassified' }
SBSelection >> blockForClass: aClass ifPresent: aBlock ifAbsent: anotherBlock [

	anotherBlock value
]

{ #category : #'as yet unclassified' }
SBSelection >> childSandblocksDo: aBlock [

	self submorphsDo: aBlock
]

{ #category : #'as yet unclassified' }
SBSelection >> colorPolicy [

	^ colorPolicy
]

{ #category : #'as yet unclassified' }
SBSelection >> colorPolicy: aPolicy [

	colorPolicy := aPolicy
]

{ #category : #'as yet unclassified' }
SBSelection >> containingArtefact [

	^ self
]

{ #category : #'as yet unclassified' }
SBSelection >> drawnColor [

	^ Color white
]

{ #category : #'as yet unclassified' }
SBSelection >> evaluate [

	^ self submorphCount = 1
		ifTrue: [self firstSubmorph evaluate]
		ifFalse: [self submorphs collect: #evaluate]
]

{ #category : #'as yet unclassified' }
SBSelection >> initialize [

	super initialize.
	
	self
		layoutPolicy: SBVerticalLayout new;
		vResizing: #shrinkWrap;
		hResizing: #shrinkWrap
]

{ #category : #'as yet unclassified' }
SBSelection >> isBlockBody [

	^ false
]

{ #category : #'as yet unclassified' }
SBSelection >> isMethodBody [

	^ true
]

{ #category : #'as yet unclassified' }
SBSelection >> isSelection [

	^ true
]

{ #category : #'as yet unclassified' }
SBSelection >> methodClass [
	
	^ methodClass
]

{ #category : #'as yet unclassified' }
SBSelection >> methodClass: aClass [
	
	methodClass := aClass
]

{ #category : #'as yet unclassified' }
SBSelection >> multiSelection [

	^ #()
]

{ #category : #'as yet unclassified' }
SBSelection >> object [

	^ self submorphCount > 1
		ifTrue: [
			SBBlockBody new statements: (self submorphs collect: [:morph | morph veryDeepCopy])]
		ifFalse: [self firstSubmorph]
]

{ #category : #'as yet unclassified' }
SBSelection >> parentSandblock [

	^ nil
]

{ #category : #'as yet unclassified' }
SBSelection >> placeholder [

	self allMorphsDo: [:m | (m isKindOf: SBPastePlaceholder) ifTrue: [^ m]].
	^ nil
]

{ #category : #'as yet unclassified' }
SBSelection >> relatedClass [

	^ self methodClass
]

{ #category : #'as yet unclassified' }
SBSelection >> sandblockEditor [

	^ self
]

{ #category : #'as yet unclassified' }
SBSelection >> selection [

	^ nil
]

{ #category : #'as yet unclassified' }
SBSelection >> statements [

	^ #()
]

{ #category : #'as yet unclassified' }
SBSelection >> wrapsAround [

	^ self placeholder notNil
]

{ #category : #'as yet unclassified' }
SBSelection >> writeSourceOn: aStream [

	self submorphCount = 1
		ifTrue: [self firstSubmorph writeSourceOn: aStream]
		ifFalse: [
			aStream nextPut: ${.
			self submorphs do: [:m | m writeSourceOn: aStream] separatedBy: [aStream nextPut: $.].
			aStream nextPut: $}]
]
