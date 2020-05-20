Class {
	#name : #SBMessageSend,
	#superclass : #SBASTNode,
	#instVars : [
		'signature',
		'pc'
	],
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBMessageSend class >> placeholderSelector [

	^ '----'
]

{ #category : #accessing }
SBMessageSend >> activeMorph [

	^ signature activeMorph ifNil: [self]
]

{ #category : #'as yet unclassified' }
SBMessageSend >> actualReceiver [

	^ self isInCascade ifTrue: [self owner receiver] ifFalse: [self receiver]
]

{ #category : #'as yet unclassified' }
SBMessageSend >> arguments [

	^ signature arguments
]

{ #category : #'as yet unclassified' }
SBMessageSend >> browse [

	self browseImplementors
]

{ #category : #'as yet unclassified' }
SBMessageSend >> canSwap [

	^ true
]

{ #category : #'as yet unclassified' }
SBMessageSend >> childSandblocksDo: aBlock [

	self receiver ifNotNil: aBlock.
	signature childSandblocksDo: aBlock
]

{ #category : #accessing }
SBMessageSend >> codeActions [

	^ super codeActions,
	
	(self signature isUnary ifTrue: [{SBCodeAction labeled: 'Use as variable' for: self do: #useAsVariable}] ifFalse: [#()]),
	
	(SBSubstitution allSubclasses
		select: [:substition | substition matches: self]
		thenCollect: [:substitution | SBCodeAction labeled: 'Convert to ', substitution name for: self do: [:node |
			node sandblockEditor do: ((SBReplaceCommand newFor: self containingArtefact)
				target: node;
				replacer: ((substitution newFrom: self) pc: self pc))]])
]

{ #category : #'as yet unclassified' }
SBMessageSend >> contents [

	^ self selector
]

{ #category : #'as yet unclassified' }
SBMessageSend >> contents: aString [

	signature selector: aString
]

{ #category : #accessing }
SBMessageSend >> currentTextMorph [

	^ signature currentTextMorph
]

{ #category : #'as yet unclassified' }
SBMessageSend >> drawSubmorphsOn: aCanvas [

	super drawSubmorphsOn: aCanvas.
	self actualReceiver guessedClass ifNotNil: [:class |
		(class canUnderstand: self selector asSymbol) ifFalse: [self drawFrame: Color yellow on: aCanvas]]
]

{ #category : #accessing }
SBMessageSend >> fixActions [

	^ self isDefined not
		ifTrue: [ | class |
			class := self actualReceiver guessClassExpensive.
			{
				(SBCodeAction
					labeled: 'Create method on ', (class ifNotNil: #name ifNil: ['...'])
					for: self
					do: [:node | 
						self sandblockEditor openMorphInView: (SBMethod new
							selector: self selector
								arguments: (self arguments collectWithIndex: [:arg :index | arg isName ifTrue: [arg veryDeepCopy] ifFalse: [SBName contents: 'anObject', index asString]])
								class: (class ifNil: [UIManager default chooseClassOrTrait ifNil: [^ self]]);
							body: SBBlockBody new;
							hasUnsavedChanges: true)])
			}]
		ifFalse: [#()]
]

{ #category : #'as yet unclassified' }
SBMessageSend >> guessedClass [

	^ self containingArtefact typeFor: self
]

{ #category : #'as yet unclassified' }
SBMessageSend >> initialize [

	super initialize.
	
	self layoutPolicy: SBMessageReceiverLayout new.
	self listDirection: #leftToRight.
	self hResizing: #shrinkWrap.
	self vResizing: #shrinkWrap.
	self cellGap: 2 * self scalingFactor.
	
	signature := SBSignature new layoutPolicy: SBKeywordMessageLayout new.
	pc := 0.
	self addMorphBack: signature
]

{ #category : #'as yet unclassified' }
SBMessageSend >> insertCommandRequest: anAfterBoolean near: aBlock [

	^ signature insertCommandRequest: anAfterBoolean near: aBlock
]

{ #category : #'as yet unclassified' }
SBMessageSend >> isBinary [

	^ self selector notEmpty and: [self selector allSatisfy: #isSpecial]
]

{ #category : #'as yet unclassified' }
SBMessageSend >> isConstructor: aString for: aClass [

	^ self receiver isBinding and: [self receiver contents = aClass name] and: [self selector = aString]
]

{ #category : #'as yet unclassified' }
SBMessageSend >> isDefined [

	^ Symbol hasInterned: self selector ifTrue: [:sym | true]
]

{ #category : #'as yet unclassified' }
SBMessageSend >> isExpression [

	^ true
]

{ #category : #'as yet unclassified' }
SBMessageSend >> isInCascade [

	^ (self owner ifNotNil: #isSandblock ifNil: [false]) and: [self owner isCascade and: [self ~= self owner receiver]]
]

{ #category : #'as yet unclassified' }
SBMessageSend >> isMessageSend [

	^ true
]

{ #category : #accessing }
SBMessageSend >> isSendToSelf [

	^ self receiver notNil and: [self receiver isName and: [self receiver isReserved] and: [self receiver contents = 'self']]
]

{ #category : #'as yet unclassified' }
SBMessageSend >> keyStroke: anEvent [

	(anEvent keyCharacter = Character space or: [
		(self selector notEmpty and: [self isBinary not]) and: [anEvent keyCharacter isSpecial]]) ifTrue: [
		^ self sandblockEditor
			endInput;
			wrapInMessageSend: (anEvent keyCharacter isSpecial ifTrue: [anEvent keyCharacter asString] ifFalse: [''])].
	(anEvent keyCharacter = Character backspace and: [self selector isEmpty]) ifTrue: [ | receiver |
		receiver := self receiver.
		^ self sandblockEditor
			endInput;
			do: ((SBReplaceCommand newFor: self containingArtefact)
				target: self;
				replacer: receiver);
			startInput: receiver at: 900000000 replacingContents: false].
	signature keyStroke: anEvent.
	self updateSuggestions
]

{ #category : #'as yet unclassified' }
SBMessageSend >> layoutInset [

	^ self isInCascade
		ifTrue: [super layoutInset + (SBEdgeInsets left: 20 withScalingFactor right: 0 top: 0 bottom: 0)]
		ifFalse: [super layoutInset]
]

{ #category : #accessing }
SBMessageSend >> mergeArguments: arguments declarations: declarations [

	declarations size = arguments size ifTrue: [^ arguments].
	declarations size < arguments size ifTrue: [^ arguments first: declarations size].
	declarations size > arguments size ifTrue: [^ arguments copyWithAll: ((1 to: declarations size - arguments size) collect: [:i | SBUnknown new])]
]

{ #category : #accessing }
SBMessageSend >> moveCursorTo: aNumber [

	signature moveCursorTo: aNumber
]

{ #category : #accessing }
SBMessageSend >> pc [

	^ pc
]

{ #category : #accessing }
SBMessageSend >> pc: aNumber [

	pc := aNumber
]

{ #category : #'as yet unclassified' }
SBMessageSend >> postDuplicate [

	self isInCascade ifTrue: [self receiver: nil].
	super postDuplicate
]

{ #category : #converting }
SBMessageSend >> printOn: aStream [

	aStream nextPutAll: 'send '; nextPutAll: self selector
]

{ #category : #'as yet unclassified' }
SBMessageSend >> receiver [

	(self owner notNil and: [self isInCascade]) ifTrue: [self owner receiver].
	self submorphCount = 2 ifTrue: [^ self firstSubmorph].
	^ nil
]

{ #category : #'as yet unclassified' }
SBMessageSend >> receiver: aBlock [

	self submorphCount > 1 ifTrue: [self firstSubmorph delete].
	aBlock ifNotNil: [self addMorph: aBlock]
]

{ #category : #'as yet unclassified' }
SBMessageSend >> receiver: aBlock selector: aSymbol [

	self assert: aSymbol isUnary.
	self receiver: aBlock selector: aSymbol arguments: #()
]

{ #category : #'as yet unclassified' }
SBMessageSend >> receiver: aBlock selector: aSymbol arguments: aCollection [

	signature selector: aSymbol arguments: aCollection.
	self receiver: aBlock
]

{ #category : #'as yet unclassified' }
SBMessageSend >> selector [

	^ signature selector
]

{ #category : #'as yet unclassified' }
SBMessageSend >> selector: aSymbol arguments: aCollection [

	signature selector: aSymbol arguments: aCollection
]

{ #category : #accessing }
SBMessageSend >> showUsageInfo [

	self actualReceiver guessedClass
		ifNotNil: [:class |  | method |
			method := class lookupSelector: self selector asSymbol.
			method ifNil: [^ self].
			Transcript showln: method]
]

{ #category : #'as yet unclassified' }
SBMessageSend >> signature [

	^ signature
]

{ #category : #'as yet unclassified' }
SBMessageSend >> startInputAt: aNumber replacingContents: aBoolean [

	^ signature startInputAt: aNumber replacingContents: aBoolean
]

{ #category : #'as yet unclassified' }
SBMessageSend >> stopEditing: aCommand [

	signature stopEditing: aCommand.
	self removeSuggestionMenu
]

{ #category : #'as yet unclassified' }
SBMessageSend >> textContents [

	^ self selector
]

{ #category : #'as yet unclassified' }
SBMessageSend >> updateSuggestions [

	| selector |
	self flag: #fixme. " we assume that the user is typing in the first cell and may want to override an existing message "
	selector := (signature selector splitBy: ':') first.
	self updateSuggestions: ((self actualReceiver completionSuggestionsFor: selector) collect: [:sel | SBSuggestionItem selector: sel label: 'send']) showNear: signature
]

{ #category : #accessing }
SBMessageSend >> useAsVariable [

	self sandblockEditor do: ((SBReplaceCommand newFor: self containingArtefact)
		target: self;
		replacer: (SBName contents: self selector))
]

{ #category : #'as yet unclassified' }
SBMessageSend >> useSuggestion: aString [

	signature selectorAndEdit: aString
]

{ #category : #'as yet unclassified' }
SBMessageSend >> valid [

	^ self validSelector and: [self isDefined]
]

{ #category : #'as yet unclassified' }
SBMessageSend >> validSelector [

	^ self selector notEmpty and: [(self selector first canBeIdentifierInitial and: [self selector allSatisfy: [:c | c isAlphaNumeric or: [c = $: or: [c = $_]]]]) or: [self selector allSatisfy: #isSpecial]]
]

{ #category : #'as yet unclassified' }
SBMessageSend >> veryDeepCopyWith: deepCopier [

	" assure that copies of us have a unique id "
	| new |
	new := super veryDeepCopyWith: deepCopier.
	self receiver ifNil: [
		self assert: self isInCascade.
		new receiver: self owner receiver veryDeepCopy].
	^ new
]

{ #category : #converting }
SBMessageSend >> writeSendSourceOn: aStream [

	signature writeSourceOn: aStream
]

{ #category : #converting }
SBMessageSend >> writeSourceOn: aStream [

	aStream nextPut: $(.
	self firstSubmorph writeSourceOn: aStream.
	aStream space.
	signature writeSourceOn: aStream.
	aStream nextPut: $)
]
