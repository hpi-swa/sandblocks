Class {
	#name : #SBMetaBlock,
	#superclass : #SBBlock,
	#instVars : [
		'factory',
		'objectInterface',
		'childObjectInterface',
		'symbols',
		'textFieldPattern',
		'textField'
	],
	#category : #'Sandblocks-TreeSitter'
}

{ #category : #'as yet unclassified' }
SBMetaBlock >> childObjectInterface: aSymbolOrCollection [

	childObjectInterface := aSymbolOrCollection
]

{ #category : #'as yet unclassified' }
SBMetaBlock >> currentTextMorph [

	^ textField
]

{ #category : #'as yet unclassified' }
SBMetaBlock >> defaultRepeatableChildInterface: aSymbol [

	defaultRepeatableChildInterface := aSymbol
]

{ #category : #'as yet unclassified' }
SBMetaBlock >> extent: aPoint [

	super extent: (aPoint max: self spaceForSymbols sum + 2 @ self minimumHeight)
]

{ #category : #'as yet unclassified' }
SBMetaBlock >> factory: aFactory [

	factory := aFactory
]

{ #category : #'as yet unclassified' }
SBMetaBlock >> fixedNumberOfChildren [

	^ childObjectInterface isNil
]

{ #category : #'as yet unclassified' }
SBMetaBlock >> initialize [

	symbols := #(nil nil).
	
	super initialize.
	
	self
		changeTableLayout;
		listDirection: #leftToRight;
		hResizing: #shrinkWrap;
		vResizing: #shrinkWrap;
		symbols: #(nil nil)
]

{ #category : #'as yet unclassified' }
SBMetaBlock >> minimumHeight [

	^ TextStyle defaultFont height + 4
]

{ #category : #'as yet unclassified' }
SBMetaBlock >> newEmptyChildNear: aBlock before: aBoolean [

	childObjectInterface ifNil: [^ nil].
	^ childObjectInterface isCollection
		ifTrue: [
			SBMetaUnknown new
				objectInterfaces: childObjectInterface;
				factory: factory;
				yourself]
		ifFalse: [factory buildRule: childObjectInterface]
]

{ #category : #'as yet unclassified' }
SBMetaBlock >> objectInterface [

	^ objectInterface
]

{ #category : #'as yet unclassified' }
SBMetaBlock >> objectInterface: anInterface [

	objectInterface := anInterface
]

{ #category : #'as yet unclassified' }
SBMetaBlock >> printOn: aStream [

	aStream nextPutAll: objectInterface
]

{ #category : #'as yet unclassified' }
SBMetaBlock >> symbols [

	^ symbols
]

{ #category : #'as yet unclassified' }
SBMetaBlock >> symbols: aCollection [

	symbols := aCollection.
	self extent: 0 @ 0
]

{ #category : #'as yet unclassified' }
SBMetaBlock >> textFieldPattern: aString [

	textFieldPattern := aString.
	self addMorphBack: (textField := SBOwnTextMorph new)
]

{ #category : #'as yet unclassified' }
SBMetaBlock >> valid [

	^ textFieldPattern
		ifNotNil: [
			(textFieldPattern isKindOf: RxMatcher)
				ifTrue: [textFieldPattern matches: textField contents]
				ifFalse: [
					textFieldPattern isString
						ifTrue: [textField contents matchesRegex: textFieldPattern]
						ifFalse: [factory token: textFieldPattern matches: self contents]]]
		ifNil: [true]
]
