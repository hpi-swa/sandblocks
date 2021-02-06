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
SBMethod >> argumentsDo: aBlock [

	^ signature argumentsDo: aBlock
]

{ #category : #'as yet unclassified' }
SBMethod >> childSandblocksDo: aBlock [

	aBlock value: classPrefix.
	signature childSandblocksDo: aBlock.
	self body visible ifTrue: [aBlock value: self body]
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
SBMethod >> contextAcceptedRepresentationAt: aNumber [

	SBToggledCode
		comment: 'need insert vs replace semantics for this :('
		active: 0
		do: {[aNumber = self childSandblocks size ifTrue: [^ #isSmalltalkBlock]]}.
	^ aNumber odd ifTrue: [#isSmalltalkMessagePart] ifFalse: [#isSmalltalkExpression]
]

{ #category : #'as yet unclassified' }
SBMethod >> currentTextMorph [

	^ nil
]

{ #category : #'as yet unclassified' }
SBMethod >> deleteCommandFor: aBlock [

	aBlock = self body ifTrue: [^ nil].
	aBlock = classPrefix ifTrue: [^ nil].
	
	^ signature deleteCommandFor: aBlock
]

{ #category : #'as yet unclassified' }
SBMethod >> ensureExpanded [

	self isCollapsed ifTrue: [self toggleCollapsed]
]

{ #category : #'as yet unclassified' }
SBMethod >> initialize [

	super initialize.
	
	self
		useAlgebraLayout;
		cellPositioning: #topLeft;
		layoutInset: 6 withScalingFactor;
		extent: 300 @ 50;
		
		attachDecorator: SBResizableDecorator new;
		addMorphBack: (SBRow new
			layoutPolicy: nil;
			addMorphBack: (classPrefix := SBClassNameInput new suffix: ' >> '; bordered: false);
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

{ #category : #accessing }
SBMethod >> layoutCommands [

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
SBMethod >> messageParts [

	^ signature messageParts
]

{ #category : #'as yet unclassified' }
SBMethod >> methodClass [

	^ classPrefix selectedClass
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
	classPrefix object: aClass.
	self savedMethodHasComments ifTrue: [
		self firstSubmorph
			addMorphBack: (Morph new
				color: Color transparent;
				extent: 12 @ 0);
			addMorphBack: (SBIcon iconWarning balloonText: 'Method has comments that cannot be saved')]
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
