Class {
	#name : #SBStClassNameInput,
	#superclass : #SBComboBox,
	#category : #'Sandblocks-Smalltalk'
}

{ #category : #'as yet unclassified' }
SBStClassNameInput >> class: aClass [

	self contents: aClass name
]

{ #category : #'as yet unclassified' }
SBStClassNameInput >> doubleClick: anEvent [

	self promptChangeClass
]

{ #category : #'as yet unclassified' }
SBStClassNameInput >> handleDroppedBlock: aBlock event: anEvent adding: aBoolean near: aMorph [

	aBlock unpackSelection object convertedFor: self objectInterfaceForDrop do: [:class |
		self selectedClass: class]
]

{ #category : #'as yet unclassified' }
SBStClassNameInput >> object [

	^ self selectedClass
]

{ #category : #'as yet unclassified' }
SBStClassNameInput >> objectInterface [

	^ SBInterfaces stClass
]

{ #category : #'as yet unclassified' }
SBStClassNameInput >> printOn: aStream [

	aStream nextPutAll: 'class input '.
	aStream print: self object
]

{ #category : #'as yet unclassified' }
SBStClassNameInput >> promptChangeClass [

	(UIManager default chooseClassOrTrait) ifNotNil: [:class |
		self selectedClass: class]
]

{ #category : #'as yet unclassified' }
SBStClassNameInput >> selectedClass [

	self contents ifEmpty: [^ nil].
	
	^ (self contents endsWith: ' class')
		ifTrue: [(Smalltalk at: (self contents allButLast: ' class' size) asSymbol ifAbsent: [nil]) ifNotNil: #class]
		ifFalse: [Smalltalk at: self contents asSymbol ifAbsent: [nil]]
]

{ #category : #'as yet unclassified' }
SBStClassNameInput >> selectedClass: aClass [

	self sandblockEditor do: ((SBMutatePropertyCommand newFor: self containingArtefact)
		target: self;
		selector: #contents;
		value: aClass name)
]

{ #category : #'as yet unclassified' }
SBStClassNameInput >> startInputAt: aNumber replacingContents: aBoolean [

	self promptChangeClass.
	
	^ nil
]

{ #category : #'as yet unclassified' }
SBStClassNameInput >> wantsInput [

	^ false
]
