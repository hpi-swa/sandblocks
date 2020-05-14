Class {
	#name : #SBMethod,
	#superclass : #SBBasicMethod,
	#instVars : [
		'signature',
		'classPrefix'
	],
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBMethod class >> newFor: aMethod at: aPoint [

	^ aMethod asSandblock position: aPoint; yourself
]

{ #category : #'as yet unclassified' }
SBMethod >> activeMorph [

	^ signature activeMorph ifNil: [self]
]

{ #category : #'as yet unclassified' }
SBMethod >> argumentsDo: aBlock [

	^ signature argumentsDo: aBlock
]

{ #category : #'as yet unclassified' }
SBMethod >> childSandblocksDo: aBlock [

	signature childSandblocksDo: aBlock.
	aBlock value: self body
]

{ #category : #'as yet unclassified' }
SBMethod >> codeActions [

	^ super codeActions, {
		(SBCodeAction labeled: 'Reload Method' for: self do: [:node | node reload])
	}
]

{ #category : #'as yet unclassified' }
SBMethod >> collapsed: aBoolean [

	self body visible not = aBoolean ifTrue: [^ self].
	
	self body
		visible: aBoolean not;
		disableLayout: aBoolean.
	
	(aBoolean not and: [self isSelected not]) ifTrue: [self select]
]

{ #category : #'as yet unclassified' }
SBMethod >> currentTextMorph [

	^ signature currentTextMorph
]

{ #category : #'as yet unclassified' }
SBMethod >> ensureExpanded [

	self isCollapsed ifTrue: [self toggleCollapsed]
]

{ #category : #'as yet unclassified' }
SBMethod >> initialize [

	super initialize.
	
	self
		layoutPolicy: SBVerticalLayout new;
		cellPositioning: #topLeft;
		layoutInset: 6 withScalingFactor;
		vResizing: #shrinkWrap; hResizing: #shrinkWrap;
		
		addMorphBack: (SBRow new
			addMorphBack: (classPrefix := SBStringMorph new);
			addMorphBack: (signature := SBSignature new))
]

{ #category : #'as yet unclassified' }
SBMethod >> insertCommandRequest: anAfterBoolean near: aBlock [

	^ signature insertCommandRequest: anAfterBoolean near: aBlock
]

{ #category : #'as yet unclassified' }
SBMethod >> isCollapsed [

	^ self body visible not
]

{ #category : #'as yet unclassified' }
SBMethod >> keyStroke: anEvent [

	signature keyStroke: anEvent.
	self updateSuggestions
]

{ #category : #'as yet unclassified' }
SBMethod >> object [

	^ self compiledMethod
]

{ #category : #'as yet unclassified' }
SBMethod >> selector [

	^ signature selector
]

{ #category : #'as yet unclassified' }
SBMethod >> selector: aSymbol arguments: aCollection [

	signature selector: aSymbol arguments: aCollection
]

{ #category : #'as yet unclassified' }
SBMethod >> selector: aSymbol arguments: aCollection class: aClass [

	super selector: aSymbol arguments: aCollection class: aClass.
	
	signature selector: aSymbol arguments: aCollection.
	classPrefix contents: aClass name, ' >> '
]

{ #category : #'as yet unclassified' }
SBMethod >> signature [

	^ signature
]

{ #category : #'as yet unclassified' }
SBMethod >> startInputAt: aNumber replacingContents: aBoolean [

	^ signature startInputAt: aNumber replacingContents: aBoolean
]

{ #category : #'as yet unclassified' }
SBMethod >> stopEditing: aCommand [

	signature stopEditing: aCommand.
	self removeSuggestionMenu
]

{ #category : #'as yet unclassified' }
SBMethod >> storeOn: aStream [

	aStream
		nextPut: $(;
		nextPutAll: self className;
		nextPutAll: ' newFor: ';
		nextPutAll: self methodClass name;
		nextPutAll: ' >> ';
		nextPutAll: self selector asSymbol storeString;
		nextPutAll: ' at: ';
		nextPutAll: self position storeString;
		nextPut: $)
]

{ #category : #'as yet unclassified' }
SBMethod >> toggleCollapsed [

	self body
		visible: self body visible not;
		disableLayout: self body visible not.
	
	(self body visible not and: [self isSelected not]) ifTrue: [self select]
]

{ #category : #'as yet unclassified' }
SBMethod >> updateSuggestions [

	| selector |
	selector := (signature selector splitBy: ':') first.
	selector size > 2 ifTrue: [
		self updateSuggestions: (Array streamContents: [:stream | Symbol allSymbols do: [:sym | (sym asString sandblockMatch: selector) ifTrue: [stream nextPut: (SBSuggestionItem selector: sym label: 'method')]]]) showNear: signature]
]

{ #category : #'as yet unclassified' }
SBMethod >> useSuggestion: aString [

	signature selectorAndEdit: aString
]

{ #category : #'as yet unclassified' }
SBMethod >> writeSignatureSourceOn: aStream [

	signature writeSourceOn: aStream
]
