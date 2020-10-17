Class {
	#name : #SBClassNameInput,
	#superclass : #SBComboBox,
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBClassNameInput >> doubleClick: anEvent [

	self promptChangeClass
]

{ #category : #'as yet unclassified' }
SBClassNameInput >> object [

	^ self selectedClass
]

{ #category : #'as yet unclassified' }
SBClassNameInput >> printOn: aStream [

	aStream nextPutAll: 'class input '.
	aStream print: self object
]

{ #category : #'as yet unclassified' }
SBClassNameInput >> promptChangeClass [

	(UIManager default chooseClassOrTrait) ifNotNil: [:class |
		self sandblockEditor do: ((SBMutatePropertyCommand newFor: self containingArtefact)
			target: self;
			selector: #contents;
			value: class name)]
]

{ #category : #'as yet unclassified' }
SBClassNameInput >> selectedClass [

	^ (self contents endsWith: ' class')
		ifTrue: [(Smalltalk at: (self contents allButLast: ' class' size) asSymbol) class]
		ifFalse: [Smalltalk at: self contents asSymbol]
]

{ #category : #'as yet unclassified' }
SBClassNameInput >> startInputAt: aNumber replacingContents: aBoolean [

	self promptChangeClass.
	
	^ nil
]
