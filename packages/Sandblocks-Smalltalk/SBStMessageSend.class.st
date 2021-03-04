Class {
	#name : #SBStMessageSend,
	#superclass : #SBStASTNode,
	#instVars : [
		'signature',
		'pc'
	],
	#category : #'Sandblocks-Smalltalk'
}

{ #category : #'as yet unclassified' }
SBStMessageSend class >> placeholderSelector [

	^ '----'
]

{ #category : #'as yet unclassified' }
SBStMessageSend >> actualReceiver [

	^ self isInCascade ifTrue: [self owner receiver] ifFalse: [self receiver]
]

{ #category : #'as yet unclassified' }
SBStMessageSend >> arguments [

	^ signature arguments
]

{ #category : #converting }
SBStMessageSend >> asMessageSend: converter [
	<convert>
	
	converter
		if: [self isInCascade]
		do: [self veryDeepCopy]
]

{ #category : #'as yet unclassified' }
SBStMessageSend >> browse [

	self browseImplementors
]

{ #category : #'as yet unclassified' }
SBStMessageSend >> browseAllImplementors [
	<action>

	super browseImplementors
]

{ #category : #'as yet unclassified' }
SBStMessageSend >> browseImplementors [
	<action>

	self actualReceiver guessClassExpensive
		ifNotNil: [:class |
			(class lookupSelector: self selector asSymbol) ifNotNil: [:m |
				^ self sandblockEditor open: m]].
	
	super browseImplementors
]

{ #category : #'as yet unclassified' }
SBStMessageSend >> cellGap [

	^ self colorPolicy messageCellGap
]

{ #category : #accessing }
SBStMessageSend >> codeActions [

	^ super codeActions, (SBStSubstitution allSubclasses
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
SBStMessageSend >> contents [

	^ self selector
]

{ #category : #'as yet unclassified' }
SBStMessageSend >> contents: aString [

	signature selector: aString
]

{ #category : #converting }
SBStMessageSend >> converterOptionsDo: aBlock [

	super converterOptionsDo: aBlock.
	
	SBStSubstitution allSubclassesDo: [:substitution |
		(substitution matches: self) ifTrue: [
			aBlock value: (SBConvertOption named: substitution prettyName do: [:converter | converter do: [substitution newFor: self]])]]
]

{ #category : #'as yet unclassified' }
SBStMessageSend >> deleteCommandFor: aBlock [

	aBlock = self receiver ifTrue: [^ super deleteCommandFor: aBlock].

	self isUnary ifTrue: [
		^ (SBReplaceCommand newFor: self containingArtefact)
			target: self;
			replacer: self receiver].
	
	^ signature deleteCommandFor: aBlock
]

{ #category : #'as yet unclassified' }
SBStMessageSend >> drawSubmorphsOn: aCanvas [

	super drawSubmorphsOn: aCanvas.
	self actualReceiver ifNotNil: [:r | r guessedClass ifNotNil: [:class |
		(class canUnderstand: self selector asSymbol) ifFalse: [self drawFrame: Color yellow on: aCanvas]]]
]

{ #category : #accessing }
SBStMessageSend >> fixActions [

	^ self isDefined not
		ifTrue: [ | class |
			class := self actualReceiver guessClassExpensive.
			{
				(SBCodeAction
					labeled: 'Create method on ', (class ifNotNil: #name ifNil: ['...'])
					for: self
					do: [:node | 
						self sandblockEditor createArtefactInView: (SBStMethod new
							selector: self selector
								arguments: (self arguments collectWithIndex: [:arg :index | arg isName ifTrue: [arg veryDeepCopy] ifFalse: [SBStName contents: 'anObject', index asString]])
								class: (class ifNil: [UIManager default chooseClassOrTrait ifNil: [^ self]]);
							body: SBStBlockBody new)])
			}]
		ifFalse: [#()]
]

{ #category : #'as yet unclassified' }
SBStMessageSend >> guessedClass [

	^ self containingArtefact ifNotNil: [:a | a typeFor: self]
]

{ #category : #'as yet unclassified' }
SBStMessageSend >> initialize [

	super initialize.
	
	pc := 0.
	self addMorphBack: (signature := SBStSignature new)
]

{ #category : #'as yet unclassified' }
SBStMessageSend >> insertCommandRequest: anAfterBoolean near: aBlock [

	^ signature insertCommandRequest: anAfterBoolean near: aBlock
]

{ #category : #'as yet unclassified' }
SBStMessageSend >> isBinary [

	^ self selector notEmpty and: [self selector allSatisfy: #isSpecial]
]

{ #category : #'as yet unclassified' }
SBStMessageSend >> isConstructor: aString for: aClass [

	^ (self receiver satisfies: #(notNil isBinding)) and: [self receiver contents = aClass name] and: [self selector = aString]
]

{ #category : #'as yet unclassified' }
SBStMessageSend >> isDefined [

	^ Symbol hasInterned: self selector ifTrue: [:sym | true]
]

{ #category : #'as yet unclassified' }
SBStMessageSend >> isExpression [

	^ self isInCascade not
]

{ #category : #'as yet unclassified' }
SBStMessageSend >> isInCascade [

	^ (self owner ifNotNil: #isSandblock ifNil: [false]) and: [self owner isCascade and: [self ~= self owner receiver]]
]

{ #category : #'as yet unclassified' }
SBStMessageSend >> isKeyword [

	^ self signature isKeyword
]

{ #category : #'as yet unclassified' }
SBStMessageSend >> isMessageSend [

	^ true
]

{ #category : #accessing }
SBStMessageSend >> isSendToSelf [

	^ self receiver notNil and: [self receiver isName and: [self receiver isReserved] and: [self receiver contents = 'self']]
]

{ #category : #'as yet unclassified' }
SBStMessageSend >> isUnary [

	^ self signature isUnary
]

{ #category : #'as yet unclassified' }
SBStMessageSend >> keyStroke: anEvent [

	(anEvent keyCharacter = Character space or: [
		(self selector notEmpty and: [self isBinary not]) and: [anEvent keyCharacter isSpecial]]) ifTrue: [
			self sandblockEditor endInput.
			^ self grammarHandler wrapInMessageSend: (anEvent keyCharacter isSpecial ifTrue: [anEvent keyCharacter asString] ifFalse: [''])].
	
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
SBStMessageSend >> layoutCommands [

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
SBStMessageSend >> layoutInset [

	^ self isInCascade
		ifTrue: [(SBEdgeInsets left: 20 withScalingFactor right: 0 top: 0 bottom: 0) + super layoutInset]
		ifFalse: [super layoutInset]
]

{ #category : #accessing }
SBStMessageSend >> mergeArguments: arguments declarations: declarations [

	declarations size = arguments size ifTrue: [^ arguments].
	declarations size < arguments size ifTrue: [^ arguments first: declarations size].
	declarations size > arguments size ifTrue: [^ arguments copyWithAll: ((1 to: declarations size - arguments size) collect: [:i | self newNullBlock])]
]

{ #category : #actions }
SBStMessageSend >> mergeWithParentSend [
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
SBStMessageSend >> messageParts [

	^ signature messageParts
]

{ #category : #actions }
SBStMessageSend >> messageSend [

	^ self
]

{ #category : #accessing }
SBStMessageSend >> moveCursorTo: aNumber [

	signature moveCursorTo: aNumber
]

{ #category : #'as yet unclassified' }
SBStMessageSend >> noteNewOwner: aMorph [

	super noteNewOwner: aMorph.
	
	self isInCascade ifTrue: [self receiver: nil]
]

{ #category : #'as yet unclassified' }
SBStMessageSend >> objectInterfaceAt: aNumber adding: aBoolean [

	| base |
	aBoolean ifTrue: [^ SBInterfaces never].
	
	base := self isInCascade ifTrue: [0] ifFalse: 1.
	aNumber = base ifTrue: [^ SBInterfaces stExpression].
	^ signature objectInterfaceAt: aNumber - base adding: aBoolean argumentInterface: SBInterfaces stExpression
]

{ #category : #'as yet unclassified' }
SBStMessageSend >> parentIsKeywordSend [

	^ self parentSandblock ifNotNil: [:p | p isMessageSend and: [p isKeyword]] ifNil: [false]
]

{ #category : #accessing }
SBStMessageSend >> pc [

	^ pc
]

{ #category : #accessing }
SBStMessageSend >> pc: aNumber [

	pc := aNumber
]

{ #category : #'as yet unclassified' }
SBStMessageSend >> postDuplicateSelf [

	self isInCascade ifTrue: [self receiver: nil].
	super postDuplicateSelf
]

{ #category : #'as yet unclassified' }
SBStMessageSend >> precedence [

	self selector ifEmpty: [^ 1].
	self selector last = $: ifTrue: [^ 3].
	self selector first canBeIdentifierInitial ifTrue: [^ 1].
	^ 2
]

{ #category : #converting }
SBStMessageSend >> printOn: aStream [

	aStream nextPutAll: 'send '; nextPutAll: self selector
]

{ #category : #'as yet unclassified' }
SBStMessageSend >> receiver [

	(self owner notNil and: [self isInCascade]) ifTrue: [self owner receiver].
	self submorphCount = 2 ifTrue: [^ self firstSubmorph].
	^ nil
]

{ #category : #'as yet unclassified' }
SBStMessageSend >> receiver: aBlock [

	self submorphCount > 1 ifTrue: [self firstSubmorph delete].
	aBlock ifNotNil: [self addMorph: aBlock]
]

{ #category : #'as yet unclassified' }
SBStMessageSend >> receiver: aBlock selector: aSymbol [

	self assert: aSymbol isUnary.
	self receiver: aBlock selector: aSymbol arguments: #()
]

{ #category : #'as yet unclassified' }
SBStMessageSend >> receiver: aBlock selector: aSymbol arguments: aCollection [

	signature selector: aSymbol arguments: aCollection.
	self receiver: aBlock
]

{ #category : #'as yet unclassified' }
SBStMessageSend >> selector [

	^ signature selector
]

{ #category : #'as yet unclassified' }
SBStMessageSend >> selector: aSymbol arguments: aCollection [

	signature selector: aSymbol arguments: aCollection
]

{ #category : #accessing }
SBStMessageSend >> showUsageInfo [

	self actualReceiver guessedClass
		ifNotNil: [:class |  | method |
			method := class lookupSelector: self selector asSymbol.
			method ifNil: [^ self].
			Transcript showln: method]
]

{ #category : #'as yet unclassified' }
SBStMessageSend >> signature [

	^ signature
]

{ #category : #testing }
SBStMessageSend >> skipLeftRightNavigation [

	^ true
]

{ #category : #'as yet unclassified' }
SBStMessageSend >> startInputAt: aNumber replacingContents: aBoolean [

	^ signature startInputAt: aNumber replacingContents: aBoolean
]

{ #category : #'as yet unclassified' }
SBStMessageSend >> stopEditing: aCommand [

	signature stopEditing: aCommand.
	self removeSuggestionMenu
]

{ #category : #'as yet unclassified' }
SBStMessageSend >> symbols [

	^ self colorPolicy symbolsForMessageSend: self
]

{ #category : #'as yet unclassified' }
SBStMessageSend >> tryDelete [

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
SBStMessageSend >> updateSuggestions [

	| selector |
	self flag: #fixme. " we assume that the user is typing in the first cell and may want to override an existing message "
	selector := (signature selector splitBy: ':') first.
	self updateSuggestions: ((self actualReceiver completionSuggestionsFor: selector) collect: [:sel | SBSuggestionItem selector: sel label: 'send']) showNear: signature
]

{ #category : #accessing }
SBStMessageSend >> useAsVariable [
	<action>
	<actionValidIf: #isUnary>

	self sandblockEditor do: ((SBReplaceCommand newFor: self containingArtefact)
		target: self;
		replacer: (SBStName contents: self selector))
]

{ #category : #'as yet unclassified' }
SBStMessageSend >> useSuggestion: aString [

	signature selectorAndEdit: aString
]

{ #category : #'as yet unclassified' }
SBStMessageSend >> valid [

	^ self validSelector and: [self isDefined]
]

{ #category : #'as yet unclassified' }
SBStMessageSend >> validSelector [

	^ self selector notEmpty and: [(self selector first canBeIdentifierInitial and: [self selector allSatisfy: [:c | c isAlphaNumeric or: [c = $: or: [c = $_]]]]) or: [self selector allSatisfy: #isSpecial]]
]

{ #category : #'as yet unclassified' }
SBStMessageSend >> veryDeepCopyWith: deepCopier [

	" assure that copies of us have a unique id "
	| new |
	new := super veryDeepCopyWith: deepCopier.
	self receiver ifNil: [
		self assert: self isInCascade.
		new receiver: self owner receiver veryDeepCopy].
	^ new
]

{ #category : #'as yet unclassified' }
SBStMessageSend >> veryDeepFixupWith: deepCopier [

	super veryDeepFixupWith: deepCopier.
	
	self isInCascade ifTrue: [self receiver: nil]
]

{ #category : #testing }
SBStMessageSend >> wantsExtraSpace [

	^ false
]

{ #category : #actions }
SBStMessageSend >> wrapInCascade [
	<multiSelectAction>

	| cascade |
	self assert: self isSelected.
	cascade := SBStCascade new.
	self sandblockEditor doMultiSelection: [:selected | | targets |
		targets := selected collect: #messageSend.
		(self sandblockEditor submorphsAreConsecutive: targets)
			ifFalse: [nil]
			ifTrue: [
				(SBWrapConsecutiveCommand newFor: self containingArtefact)
					targets: (selected collect: #messageSend);
					outer: SBStCascade new;
					wrap: [:outer :inner |
						outer addMorphFront: inner first receiver.
						outer addAllMorphs: inner];
					wrapUndo: [:outer :inner |
						inner do: [:message | message receiver: outer receiver veryDeepCopy].
						outer removeAllMorphs]]]
]

{ #category : #converting }
SBStMessageSend >> writeSendSourceOn: aStream [

	signature writeSourceOn: aStream
]

{ #category : #converting }
SBStMessageSend >> writeSourceOn: aStream [

	aStream nextPut: $(.
	self firstSubmorph writeSourceOn: aStream.
	aStream space.
	signature writeSourceOn: aStream.
	aStream nextPut: $)
]
