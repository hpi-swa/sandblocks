Class {
	#name : #SBStClassNameInput,
	#superclass : #SBComboBox,
	#category : #'Sandblocks-Smalltalk'
}

{ #category : #'as yet unclassified' }
SBStClassNameInput >> doubleClick: anEvent [

	self promptChangeClass
]

{ #category : #'as yet unclassified' }
SBStClassNameInput >> object [

	^ self selectedClass
]

{ #category : #'as yet unclassified' }
SBStClassNameInput >> printOn: aStream [

	aStream nextPutAll: 'class input '.
	aStream print: self object
]

{ #category : #'as yet unclassified' }
SBStClassNameInput >> promptChangeClass [

	(UIManager default chooseClassOrTrait) ifNotNil: [:class |
		self sandblockEditor do: ((SBMutatePropertyCommand newFor: self containingArtefact)
			target: self;
			selector: #contents;
			value: class name)]
]

{ #category : #'as yet unclassified' }
SBStClassNameInput >> selectedClass [

	^ (self contents endsWith: ' class')
		ifTrue: [(Smalltalk at: (self contents allButLast: ' class' size) asSymbol) class]
		ifFalse: [Smalltalk at: self contents asSymbol]
]

{ #category : #'as yet unclassified' }
SBStClassNameInput >> startInputAt: aNumber replacingContents: aBoolean [

	self promptChangeClass.
	
	^ nil
]
