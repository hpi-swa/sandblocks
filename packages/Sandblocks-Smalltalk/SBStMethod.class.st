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
SBStMethod >> childSandblocksDo: aBlock [

	aBlock value: classPrefix.
	signature childSandblocksDo: aBlock.
	self body visible ifTrue: [aBlock value: self body]
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
SBStMethod >> ensureExpanded [

	self isCollapsed ifTrue: [self toggleCollapsed]
]

{ #category : #'as yet unclassified' }
SBStMethod >> initialize [

	super initialize.
	
	self
		useAlgebraLayout;
		cellPositioning: #topLeft;
		layoutInset: 6 withScalingFactor;
		extent: 300 @ 50;
		
		attachDecorator: SBResizableDecorator new;
		addMorphBack: (SBRow new
			layoutPolicy: nil;
			addMorphBack: (classPrefix := SBStClassNameInput new suffix: ' >> '; bordered: false);
			addMorphBack: (signature := SBStSignature new))
]

{ #category : #'as yet unclassified' }
SBStMethod >> insertCommandRequest: anAfterBoolean near: aBlock [

	^ signature insertCommandRequest: anAfterBoolean near: aBlock
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
			ifTrue: [{SBAlgebraCommand hardLine. self body layoutCommands}]
			ifFalse: [{}])
]

{ #category : #accessing }
SBStMethod >> messageParts [

	^ signature messageParts
]

{ #category : #'as yet unclassified' }
SBStMethod >> methodClass [

	^ classPrefix selectedClass
]

{ #category : #'as yet unclassified' }
SBStMethod >> objectInterfaceAt: aNumber adding: aBoolean [

	aBoolean ifTrue: [^ SBInterfaces never].
	
	^ aNumber = self childSandblocks size
		ifTrue: [SBInterfaces stBlock]
		ifFalse: [signature objectInterfaceAt: aNumber - 1 adding: aBoolean argumentInterface: SBInterfaces stName]
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
	signature selector: aSymbol arguments: aCollection.
	classPrefix object: aClass.
	self savedMethodHasComments ifTrue: [
		self firstSubmorph
			addMorphBack: (Morph new
				color: Color transparent;
				extent: 12 @ 0);
			addMorphBack: (SBIcon iconWarning balloonText: 'Method has comments that cannot be saved')]
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
		self updateSuggestions: (Array streamContents: [:stream | Symbol allSymbols do: [:sym | (sym asString sandblockMatch: selector) ifTrue: [stream nextPut: (SBSuggestionItem selector: sym label: 'method')]]]) showNear: signature]
]

{ #category : #'as yet unclassified' }
SBStMethod >> useSuggestion: aString [

	signature selectorAndEdit: aString
]

{ #category : #'as yet unclassified' }
SBStMethod >> writeSignatureSourceOn: aStream [

	signature writeSourceOn: aStream
]