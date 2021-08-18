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

{ #category : #'as yet unclassified' }
SBStMethod >> argumentsDo: aBlock [

	^ signature argumentsDo: aBlock
]

{ #category : #'as yet unclassified' }
SBStMethod >> collapsed: aBoolean [

	self body visible not = aBoolean ifTrue: [^ self].
	
	self body
		visible: aBoolean not;
		disableLayout: aBoolean.
	
	(aBoolean not and: [self isSelected not]) ifTrue: [self select]
]

{ #category : #'as yet unclassified' }
SBStMethod >> contents [

	^ signature selector
]

{ #category : #'as yet unclassified' }
SBStMethod >> contents: aString [

	signature selector: aString
]

{ #category : #'as yet unclassified' }
SBStMethod >> currentClass: aClass [

	super currentClass: aClass.
	
	classPrefix object: aClass
]

{ #category : #'as yet unclassified' }
SBStMethod >> currentTextMorph [

	^ nil
]

{ #category : #'as yet unclassified' }
SBStMethod >> deleteCommandFor: aBlock [

	aBlock = self body ifTrue: [^ nil].
	aBlock = classPrefix ifTrue: [^ nil].
	
	^ signature deleteCommandFor: aBlock
]

{ #category : #'as yet unclassified' }
SBStMethod >> doubleClick: anEvent [

	self toggleCollapsed
]

{ #category : #'as yet unclassified' }
SBStMethod >> ensureExpanded [

	self isCollapsed ifTrue: [self toggleCollapsed]
]

{ #category : #'as yet unclassified' }
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

{ #category : #'as yet unclassified' }
SBStMethod >> insertCommandRequest: aMorph near: aBlock before: aBoolean [

	^ self signature insertCommandRequest: aMorph near: aBlock before: aBoolean
]

{ #category : #'as yet unclassified' }
SBStMethod >> isAttractedTo: aMorph [

	^ aMorph relatedClass theNonMetaClass = self relatedClass theNonMetaClass and: [(aMorph isKindOf: SBStMethod) or: [aMorph isKindOf: SBStClass]]
]

{ #category : #'as yet unclassified' }
SBStMethod >> isCollapsed [

	^ self body visible not
]

{ #category : #'as yet unclassified' }
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
				data: {
					self firstSubmorph submorphs first layoutCommands.
					SBAlgebraCommand indent data: {SBAlgebraCommand softLine. self firstSubmorph submorphs second layoutCommands}
				}
		}, (self body visible
			ifTrue: [{SBAlgebraCommand hardLine withGap: true. self body layoutCommands}]
			ifFalse: [{}])
]

{ #category : #accessing }
SBStMethod >> messageParts [

	^ signature messageParts
]

{ #category : #'as yet unclassified' }
SBStMethod >> methodClass [

	^ classPrefix selectedClass ifNil: [self outerArtefact ifNotNil: #relatedClass]
]

{ #category : #'as yet unclassified' }
SBStMethod >> objectInterfaceNear: aBlock at: aSymbol [

	^ aBlock isBlockBody
		ifTrue: [aSymbol = #replace ifTrue: [SBInterfaces stBlock] ifFalse: [SBInterfaces never]]
		ifFalse: [signature objectInterfaceNear: aBlock at: aSymbol argumentInterface: SBInterfaces stName]
]

{ #category : #'as yet unclassified' }
SBStMethod >> pasteString [
	<action>

	| method |
	method := (Clipboard clipboardText string parseAsMethodFor: self relatedClass) asSandblock.
	self sandblockEditor do: (SBReplaceCommand new
		target: self;
		replacer: method;
		artefact: method)
]

{ #category : #'as yet unclassified' }
SBStMethod >> saveString [

	^ self currentSelector
		ifEmpty: [self saveStringWhenEmpty]
		ifNotEmpty: [self saveStringWhenNotEmpty]
]

{ #category : #'as yet unclassified' }
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

{ #category : #'as yet unclassified' }
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

{ #category : #'as yet unclassified' }
SBStMethod >> selector [

	^ signature selector
]

{ #category : #'as yet unclassified' }
SBStMethod >> selector: aSymbol arguments: aCollection [

	signature selector: aSymbol arguments: aCollection
]

{ #category : #'as yet unclassified' }
SBStMethod >> selector: aSymbol arguments: aCollection class: aClass [

	super selector: aSymbol arguments: aCollection class: aClass.
	signature selector: aSymbol arguments: aCollection
]

{ #category : #'as yet unclassified' }
SBStMethod >> signature [

	^ signature
]

{ #category : #'as yet unclassified' }
SBStMethod >> startInputAt: aNumber replacingContents: aBoolean [

	^ signature startInputAt: aNumber replacingContents: aBoolean
]

{ #category : #'as yet unclassified' }
SBStMethod >> stopEditing: aCommand [

	signature stopEditing: aCommand.
	self removeSuggestionMenu
]

{ #category : #'as yet unclassified' }
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

{ #category : #'as yet unclassified' }
SBStMethod >> updateSuggestions [

	| selector |
	selector := (signature selector splitBy: ':') first.
	selector size > 2 ifTrue: [
		self
			updateSuggestions: (Array streamContents: [:stream | Symbol allSymbols do: [:sym | (sym asString sandblockMatch: selector) ifTrue: [stream nextPut: (SBSuggestionItem selector: sym label: 'method')]]])
			showNear: signature]
]

{ #category : #'as yet unclassified' }
SBStMethod >> useSuggestion: aString [

	signature selectorAndEdit: aString withFilledArgs: true.
	(signature arguments anySatisfy: #wantsInput) ifFalse: [self inputNextUnknown]
]

{ #category : #'as yet unclassified' }
SBStMethod >> writeSignatureSourceOn: aStream [

	signature writeSourceOn: aStream
]
