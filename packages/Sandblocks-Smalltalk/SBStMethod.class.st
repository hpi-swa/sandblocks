Class {
	#name : #SBStMethod,
	#superclass : #SBStBasicMethod,
	#instVars : [
		'signature',
		'classPrefix'
	],
	#category : #'Sandblocks-Smalltalk'
}

{ #category : #'as yet unclassified' }
SBStMethod class >> newFor: aMethod at: aPoint [

	^ aMethod asSandblock position: aPoint; yourself
]

{ #category : #'method protocol' }
SBStMethod >> argumentsDo: aBlock [

	^ signature argumentsDo: aBlock
]

{ #category : #accessing }
SBStMethod >> collapsed: aBoolean [

	self body visible not = aBoolean ifTrue: [^ self].
	
	self body
		visible: aBoolean not;
		disableLayout: aBoolean.
	
	(aBoolean not and: [self isSelected not]) ifTrue: [self select]
]

{ #category : #accessing }
SBStMethod >> contents [

	^ signature selector
]

{ #category : #accessing }
SBStMethod >> contents: aString [

	signature selector: aString
]

{ #category : #accessing }
SBStMethod >> currentClass: aClass [

	super currentClass: aClass.
	
	classPrefix object: aClass
]

{ #category : #accessing }
SBStMethod >> currentTextMorph [

	^ nil
]

{ #category : #'insert/delete' }
SBStMethod >> deleteCommandFor: aBlock [

	aBlock = self body ifTrue: [^ nil].
	aBlock = classPrefix ifTrue: [^ nil].
	
	^ signature deleteCommandFor: aBlock
]

{ #category : #'event handling' }
SBStMethod >> doubleClick: anEvent [

	self toggleCollapsed
]

{ #category : #'artefact protocol' }
SBStMethod >> ensureExpanded [

	self isCollapsed ifTrue: [self toggleCollapsed]
]

{ #category : #'initialize-release' }
SBStMethod >> initialize [

	super initialize.
	
	self
		useAlgebraLayout;
		cellPositioning: #topLeft;
		layoutInset: 6;
		extent: 300 @ 50;
		attachDecorator: SBResizableDecorator new;
		addMorphBack: (SBRow new
			layoutPolicy: SBAlgebraLayout new;
			addMorphBack: (classPrefix := SBStClassNameInput new
				suffix: ' >> ';
				bordered: false);
			addMorphBack: (signature := SBStSignature new))
]

{ #category : #'insert/delete' }
SBStMethod >> insertCommandRequest: aMorph near: aBlock before: aBoolean [

	^ self signature insertCommandRequest: aMorph near: aBlock before: aBoolean
]

{ #category : #layout }
SBStMethod >> isAttractedTo: aMorph [

	^ aMorph relatedClass theNonMetaClass = self relatedClass theNonMetaClass and: [(aMorph isKindOf: SBStMethod) or: [aMorph isKindOf: SBStClass]]
]

{ #category : #testing }
SBStMethod >> isCollapsed [

	^ self body visible not
]

{ #category : #'event handling' }
SBStMethod >> keyStroke: anEvent [

	signature keyStroke: anEvent.
	self updateSuggestions
]

{ #category : #accessing }
SBStMethod >> layoutCommands [

	^ SBAlgebraCommand container
		morph: self;
		data: {
			SBAlgebraCommand container
				morph: self firstSubmorph;
				data: ((self firstSubmorph submorphs allButLast: 2) collect: [:c | c layoutCommands]), {
					(self firstSubmorph submorphs atLast: 2) layoutCommands.
					SBAlgebraCommand indent data: {SBAlgebraCommand softLine. self firstSubmorph submorphs last layoutCommands}}}, (self body visible
			ifTrue: [{SBAlgebraCommand hardLine withGap: true. self body layoutCommands}]
			ifFalse: [{}])
]

{ #category : #accessing }
SBStMethod >> messageParts [

	^ signature messageParts
]

{ #category : #accessing }
SBStMethod >> methodClass [

	^ classPrefix selectedClass ifNil: [self outerArtefact ifNotNil: #relatedClass]
]

{ #category : #'object interface' }
SBStMethod >> objectInterfaceNear: aBlock at: aSymbol [

	^ aBlock isBlockBody
		ifTrue: [aSymbol = #replace ifTrue: [SBInterfaces stBlock] ifFalse: [SBInterfaces never]]
		ifFalse: [signature objectInterfaceNear: aBlock at: aSymbol argumentInterface: SBInterfaces stName]
]

{ #category : #actions }
SBStMethod >> pasteString [
	<action>

	| method |
	method := (Clipboard clipboardText string parseAsMethodFor: self relatedClass) asSandblock.
	self sandblockEditor do: (SBReplaceCommand new
		target: self;
		replacer: method;
		artefact: method)
]

{ #category : #saving }
SBStMethod >> saveString [

	^ self currentSelector
		ifEmpty: [self saveStringWhenEmpty]
		ifNotEmpty: [self saveStringWhenNotEmpty]
]

{ #category : #printing }
SBStMethod >> saveStringWhenEmpty [

	^ String streamContents: [:stream |
		self printSaveStringPreambleOn: stream.
		stream
			nextPutAll: self className;
			nextPutAll: ' new';
			nextPutAll:  ' selector:  ';
			nextPut: $';
			nextPut: $';
			nextPutAll: ' arguments: #()';
			nextPutAll: ' class: ';
			nextPutAll: self currentClass name asString;
			nextPutAll: '; body: (SBStBlockBody new in: [:b | b statements: {b newNullBlock}]);';
			nextPutAll: ' position: ';
			nextPutAll:  self position asString 
		]
]

{ #category : #printing }
SBStMethod >> saveStringWhenNotEmpty [

	^ String streamContents: [:stream |
		self printSaveStringPreambleOn: stream.
		stream
			nextPutAll: self className;
			nextPutAll: ' newFor: (';
			nextPutAll:  self currentClass name asString;
			nextPutAll: ' compiledMethodAt: #';
			nextPutAll: self currentSelector asString;
			nextPutAll: ') at:';
			nextPutAll:  self position asString 
		]
]

{ #category : #'method protocol' }
SBStMethod >> selector [

	^ signature selector
]

{ #category : #'method protocol' }
SBStMethod >> selector: aSymbol arguments: aCollection [

	signature selector: aSymbol arguments: aCollection
]

{ #category : #accessing }
SBStMethod >> selector: aSymbol arguments: aCollection class: aClass [

	super selector: aSymbol arguments: aCollection class: aClass.
	signature selector: aSymbol arguments: aCollection
]

{ #category : #'method protocol' }
SBStMethod >> showRenameHint: aMorph [

	self firstSubmorph addMorphFront: aMorph
]

{ #category : #accessing }
SBStMethod >> signature [

	^ signature
]

{ #category : #input }
SBStMethod >> startInputAt: aNumber replacingContents: aBoolean [

	^ signature startInputAt: aNumber replacingContents: aBoolean
]

{ #category : #input }
SBStMethod >> stopEditing: aCommand [

	signature stopEditing: aCommand.
	self removeSuggestionMenu
]

{ #category : #printing }
SBStMethod >> storeOn: aStream [

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

{ #category : #suggestions }
SBStMethod >> updateSuggestions [

	| selector |
	selector := (signature selector splitBy: ':') first.
	selector size > 2 ifTrue: [
		self
			updateSuggestions: (Array streamContents: [:stream | Symbol allSymbols do: [:sym | (sym asString sandblockMatch: selector) ifTrue: [stream nextPut: (SBSuggestionItem selector: sym label: 'method')]]])
			showNear: signature]
]

{ #category : #suggestions }
SBStMethod >> useSuggestion: aString [

	signature selectorAndEdit: aString withFilledArgs: true.
	(signature arguments anySatisfy: #wantsInput) ifFalse: [self inputNextUnknown]
]

{ #category : #'method protocol' }
SBStMethod >> writeSignatureSourceOn: aStream [

	signature writeSourceOn: aStream
]
