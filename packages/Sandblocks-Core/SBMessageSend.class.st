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
SBMessageSend >> browseAllImplementors [
	<action>

	super browseImplementors
]

{ #category : #'as yet unclassified' }
SBMessageSend >> browseImplementors [
	<action>

	self actualReceiver guessClassExpensive
		ifNotNil: [:class |
			(class lookupSelector: self selector asSymbol) ifNotNil: [:m |
				^ self sandblockEditor open: m]].
	
	super browseImplementors
]

{ #category : #'as yet unclassified' }
SBMessageSend >> canSwap [

	^ true
]

{ #category : #'as yet unclassified' }
SBMessageSend >> cellGap [

	^ self colorPolicy messageCellGap
]

{ #category : #'as yet unclassified' }
SBMessageSend >> childSandblocksDo: aBlock [

	self receiver ifNotNil: aBlock.
	signature childSandblocksDo: aBlock
]

{ #category : #accessing }
SBMessageSend >> codeActions [

	^ super codeActions, (SBSubstitution allSubclasses
		select: [:substition | substition matches: self]
		thenCollect: [:substitution |
			SBCodeAction
				labeled: 'Convert to ', substitution name
				for: self
				do: [:node |
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

{ #category : #'as yet unclassified' }
SBMessageSend >> contextAcceptedRepresentationAt: aNumber [

	| base |
	base := self isInCascade ifTrue: [0] ifFalse: 1.
	aNumber = base ifTrue: [^ #isSmalltalkExpression].
	^ (aNumber + base) odd
		ifTrue: [#isSmalltalkMessagePart]
		ifFalse: [#isSmalltalkExpression]
]

{ #category : #accessing }
SBMessageSend >> currentTextMorph [

	^ signature currentTextMorph
]

{ #category : #'as yet unclassified' }
SBMessageSend >> deleteCommandFor: aBlock [

	self isUnary ifTrue: [
		^ (SBReplaceCommand newFor: self containingArtefact)
			target: self;
			replacer: self receiver].
	
	^ aBlock = self receiver ifTrue: [super deleteCommandFor: aBlock] ifFalse: [signature deleteCommandFor: aBlock]
]

{ #category : #'as yet unclassified' }
SBMessageSend >> drawSubmorphsOn: aCanvas [

	super drawSubmorphsOn: aCanvas.
	self actualReceiver ifNotNil: [:r | r guessedClass ifNotNil: [:class |
		(class canUnderstand: self selector asSymbol) ifFalse: [self drawFrame: Color yellow on: aCanvas]]]
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

	^ self containingArtefact ifNotNil: [:a | a typeFor: self]
]

{ #category : #'as yet unclassified' }
SBMessageSend >> initialize [

	super initialize.
	
	pc := 0.
	self addMorphBack: (signature := SBSignature new)
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

	^ self isInCascade not
]

{ #category : #'as yet unclassified' }
SBMessageSend >> isInCascade [

	^ (self owner ifNotNil: #isSandblock ifNil: [false]) and: [self owner isCascade and: [self ~= self owner receiver]]
]

{ #category : #'as yet unclassified' }
SBMessageSend >> isKeyword [

	^ self signature isKeyword
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
SBMessageSend >> isUnary [

	^ self signature isUnary
]

{ #category : #'as yet unclassified' }
SBMessageSend >> keyStroke: anEvent [

	(anEvent keyCharacter = Character space or: [
		(self selector notEmpty and: [self isBinary not]) and: [anEvent keyCharacter isSpecial]]) ifTrue: [
			self sandblockEditor endInput.
			^ self wrapInMessageSend: (anEvent keyCharacter isSpecial ifTrue: [anEvent keyCharacter asString] ifFalse: [''])].
	
	(anEvent keyCharacter = Character backspace and: [self selector isEmpty]) ifTrue: [ | receiver |
		receiver := self receiver.
		^ self sandblockEditor
			endInput;
			do: ((SBReplaceCommand newFor: self containingArtefact)
				target: self;
				replacer: receiver);
			startInput: receiver at: 9e8 replacingContents: false].
	
	signature keyStroke: anEvent.
	self updateSuggestions
]

{ #category : #'as yet unclassified' }
SBMessageSend >> layoutCommands [

	^ SBAlgebraCommand container
		morph: self;
		data: (self receiver
			ifNil: [{self signature layoutCommands}]
			ifNotNil: [{
				self receiver layoutCommands.
				SBAlgebraCommand indent data: {
					SBAlgebraCommand softLineOrGap.
					self signature layoutCommands}}])
]

{ #category : #'as yet unclassified' }
SBMessageSend >> layoutInset [

	^ self isInCascade
		ifTrue: [(SBEdgeInsets left: 20 withScalingFactor right: 0 top: 0 bottom: 0) + super layoutInset]
		ifFalse: [super layoutInset]
]

{ #category : #accessing }
SBMessageSend >> mergeArguments: arguments declarations: declarations [

	declarations size = arguments size ifTrue: [^ arguments].
	declarations size < arguments size ifTrue: [^ arguments first: declarations size].
	declarations size > arguments size ifTrue: [^ arguments copyWithAll: ((1 to: declarations size - arguments size) collect: [:i | SBUnknown new])]
]

{ #category : #actions }
SBMessageSend >> mergeWithParentSend [
	<action>
	<actionValidIf: #parentIsKeywordSend>

	| signature |
	
	signature := self parentSandblock signature.
	self sandblockEditor do: (SBCombinedCommand newWith: (self messageParts
		with: self arguments
		collect: [:part :arg |
			{
				((SBMoveCommand newFor: self containingArtefact)
					container: signature;
					index: signature submorphCount + 900000000;
					morph: part).
				((SBMoveCommand newFor: self containingArtefact)
					container: signature;
					index: signature submorphCount + 900000000;
					morph: arg)
			}]) flatten, {
		((SBReplaceCommand newFor: self containingArtefact)
			target: self;
			replacer: self receiver)
	})
]

{ #category : #'as yet unclassified' }
SBMessageSend >> messageParts [

	^ signature messageParts
]

{ #category : #actions }
SBMessageSend >> messageSend [

	^ self
]

{ #category : #accessing }
SBMessageSend >> moveCursorTo: aNumber [

	signature moveCursorTo: aNumber
]

{ #category : #'as yet unclassified' }
SBMessageSend >> noteNewOwner: aMorph [

	super noteNewOwner: aMorph.
	
	self isInCascade ifTrue: [self receiver: nil]
]

{ #category : #'as yet unclassified' }
SBMessageSend >> parentIsKeywordSend [

	^ self parentSandblock ifNotNil: [:p | p isMessageSend and: [p isKeyword]] ifNil: [false]
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
SBMessageSend >> postDuplicateSelf [

	self isInCascade ifTrue: [self receiver: nil].
	super postDuplicateSelf
]

{ #category : #'as yet unclassified' }
SBMessageSend >> precedence [

	self selector ifEmpty: [^ 1].
	self selector last = $: ifTrue: [^ 3].
	self selector first canBeIdentifierInitial ifTrue: [^ 1].
	^ 2
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
SBMessageSend >> symbols [

	^ self colorPolicy symbolsForMessageSend: self
]

{ #category : #'as yet unclassified' }
SBMessageSend >> tryDelete [

	| receiver |
	receiver := self receiver.
	^ self sandblockEditor
		endInput;
		do: ((SBReplaceCommand newFor: self containingArtefact)
			target: self;
			replacer: receiver);
		startInput: receiver at: 9e8 replacingContents: false
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
	<action>
	<actionValidIf: #isUnary>

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

{ #category : #actions }
SBMessageSend >> wrapInCascade [
	<multiSelectAction>

	| cascade |
	self assert: self isSelected.
	cascade := SBCascade new.
	self sandblockEditor doMultiSelection: [:selected | | targets |
		targets := selected collect: #messageSend.
		(self sandblockEditor submorphsAreConsecutive: targets)
			ifFalse: [nil]
			ifTrue: [
				(SBWrapConsecutiveCommand newFor: self containingArtefact)
					targets: (selected collect: #messageSend);
					outer: SBCascade new;
					wrap: [:outer :inner |
						outer addMorphFront: inner first receiver.
						outer addAllMorphs: inner];
					wrapUndo: [:outer :inner |
						inner do: [:message | message receiver: outer receiver veryDeepCopy].
						outer removeAllMorphs]]]
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
