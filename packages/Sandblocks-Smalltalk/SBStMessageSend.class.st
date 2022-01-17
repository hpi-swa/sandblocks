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
SBStMessageSend >> actualReceiver [

	^ self isInCascade ifTrue: [self owner receiver] ifFalse: [self receiver]
]

{ #category : #'as yet unclassified' }
SBStMessageSend >> arguments [

	^ signature arguments
]

{ #category : #converting }
SBStMessageSend >> asLanguageBox: converter [
	<convert>
	<automatic>

	converter
		if: [self selector = 'eval:lang:' and: [self receiver isBinding and: [self receiver contents = 'SBLanguageBox']]]
		do: [SBLanguageBox new source: self arguments first contents lang: self arguments second contents]
]

{ #category : #converting }
SBStMessageSend >> asMessageSend: converter [
	<convert>
	
	converter
		if: [self isInCascade]
		do: [self veryDeepCopy]
]

{ #category : #converting }
SBStMessageSend >> asOhmGrammar: converter [
	<convert>
	<automatic>

	converter
		if: [self selector = 'new:' and: [self receiver isBinding and: [self receiver contents = 'OhmGrammar']]]
		do: [SBOhmGrammar from: self arguments first contents]
]

{ #category : #converting }
SBStMessageSend >> asReactComponent: converter [
	<convert>
	<automatic>

	converter
		if: [self selector = 'build' and: [self receiver isMessageSend and: [self receiver selector = 'asElementBuilder']]]
		do: [
			SBStReactComponent new
				componentClass: self receiver receiver
				props: SBStArray new
				children: SBStArray new]
]

{ #category : #converting }
SBStMessageSend >> asWatch: converter [
	<convert>
	<automatic>

	converter
		if: [self selector = 'report:for:' and: [self receiver isBinding and: [self receiver contents = 'SBWatch']]]
		do: [
			SBWatch new
				identifier: self arguments second contents asNumber;
				expression: self arguments first veryDeepCopy;
				yourself]
]

{ #category : #'as yet unclassified' }
SBStMessageSend >> balloonText [

	(self isInWorld and: [self selectorAppearsValid not]) ifTrue: [
		^ 'Object of guessed class ', (self actualReceiver guessedClass name, ' does not understand this selector.')].
	^ super balloonText
]

{ #category : #assignment }
SBStMessageSend >> binding: aBlock value: anotherBlock [
	" construct this send as an assignment "

	self receiver: aBlock selector: ':=' arguments: {anotherBlock}
]

{ #category : #'as yet unclassified' }
SBStMessageSend >> browse [

	self browseImplementors
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
			SBCodeAction labeled: 'Convert to ', substitution name for: self do: [:node |
				node sandblockEditor do: (SBReplaceCommand new
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

	aBlock = self receiver ifTrue: [
		^ SBReplaceCommand new
			target: (self isUnary ifTrue: [self] ifFalse: [aBlock]);
			replacer: (self isUnary ifTrue: [SBStName contents: self selector] ifFalse: [self newNullBlock])].
	
	(self arguments size < 2 and: [self isInCascade not and: [aBlock isMessagePart]]) ifTrue: [
		^ SBReplaceCommand new
			target: self;
			replacer: self receiver].
	
	^ signature deleteCommandFor: aBlock
]

{ #category : #'as yet unclassified' }
SBStMessageSend >> drawSubmorphsOn: aCanvas [

	super drawSubmorphsOn: aCanvas.
	(self selectorAppearsValid not and: [self isDefined]) ifTrue: [self drawFrame: Color yellow on: aCanvas]
]

{ #category : #assignment }
SBStMessageSend >> expression [

	self assert: self isAssignment.
	^ self arguments first
]

{ #category : #accessing }
SBStMessageSend >> fixActions [

	^ self isDefined not
		ifTrue: [ | class |
			class := self actualReceiver guessClassExpensive.
			{
				SBCodeAction
					labeled: 'Create method on ', (class ifNotNil: #name ifNil: ['...'])
					for: self
					do: [:node | | method |
						class := class ifNil: [UIManager default chooseClassOrTrait].
						class ifNotNil: [
							method := SBStMethod new
								selector: self selector
									arguments: (self arguments collectWithIndex: [:arg :index | arg isName ifTrue: [arg veryDeepCopy] ifFalse: [SBStName contents: 'anObject', index asString]])
									class: class;
								body: SBStBlockBody new.
							self sandblockEditor do: (SBEditorOpenMorphCommand new
								morph: method;
								editor: self sandblockEditor;
								isUnsaved: true;
								yourself)]].
				SBCodeAction labeled: 'Confirm selector' for: self do: [:node | node selector asSymbol]}]
		ifFalse: [#()]
]

{ #category : #testing }
SBStMessageSend >> fixedNumberOfChildren [

	^ false
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
SBStMessageSend >> insertCommandRequest: aBlock near: aMorph before: aBoolean [

	((aMorph = self receiver) or: [aBoolean and: [aMorph isNil]]) ifTrue: [^ nil].
	^ self signature insertCommandRequest: aBlock near: aMorph before: aBoolean
]

{ #category : #testing }
SBStMessageSend >> isAssignment [

	^ self selector = ':='
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

	^ (Symbol hasInterned: self selector ifTrue: [:sym | true]) or: [self containingArtefact isMethod and: [self containingArtefact selector = self selector]]
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

{ #category : #testing }
SBStMessageSend >> isMessageSend [

	^ self isAssignment not
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

	(anEvent keyCharacter = Character space or: [(self selector notEmpty and: [self isBinary not]) and: [anEvent keyCharacter isSpecial]]) ifTrue: [
		self sandblockEditor endInput.
		^ self grammarHandler wrapInMessageSend: (anEvent keyCharacter isSpecial
			ifTrue: [anEvent keyCharacter asString]
			ifFalse: [''])].
	
	(anEvent keyCharacter = Character backspace and: [self selector isEmpty]) ifTrue: [ | receiver |
		receiver := self receiver.
		^ self sandblockEditor
			endInput;
			do: (SBReplaceCommand new
				target: self;
				replacer: receiver);
			startInput: receiver at: 900000000 replacingContents: false].
	
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
					SBAlgebraCommand softLineOrGap withGap: true.
					self signature layoutCommands}}])
]

{ #category : #'as yet unclassified' }
SBStMessageSend >> layoutInset [

	^ self isInCascade
		ifTrue: [(SBEdgeInsets left: 20 right: 0 top: 0 bottom: 0) + super layoutInset]
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
	self sandblockEditor do: (SBCombinedCommand newWith: (self messageParts with: self arguments collect: [:part :arg |
		{
			SBMoveCommand new
				container: signature;
				index: signature submorphCount + 900000000;
				morph: part.
			SBMoveCommand new
				container: signature;
				index: signature submorphCount + 900000000;
				morph: arg}]) flatten, {
		SBReplaceCommand new
			target: self;
			replacer: self receiver})
]

{ #category : #'as yet unclassified' }
SBStMessageSend >> messageParts [

	^ signature messageParts
]

{ #category : #actions }
SBStMessageSend >> messageSend [

	^ self
]

{ #category : #'as yet unclassified' }
SBStMessageSend >> newNullBlock [

	^ super newNullBlock
]

{ #category : #'as yet unclassified' }
SBStMessageSend >> notInCascade [

	^ self isInCascade not
]

{ #category : #'as yet unclassified' }
SBStMessageSend >> noteNewOwner: aMorph [

	super noteNewOwner: aMorph.
	
	self isInCascade ifTrue: [self receiver: nil]
]

{ #category : #'as yet unclassified' }
SBStMessageSend >> objectInterfaceNear: aBlock at: aSymbol [

	(aBlock = self receiver and: [aSymbol = #replace]) ifTrue: [^ SBInterfaces stExpression].
	
	^ signature objectInterfaceNear: aBlock at: aSymbol argumentInterface: SBInterfaces stExpression
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

{ #category : #'colors and color policies' }
SBStMessageSend >> preferredColorIn: aColorPolicy [

	^ aColorPolicy default
]

{ #category : #converting }
SBStMessageSend >> printOn: aStream [

	aStream nextPutAll: 'send '; nextPutAll: self selector
]

{ #category : #'as yet unclassified' }
SBStMessageSend >> receiver [

	(self owner notNil and: [self isInCascade]) ifTrue: [^ self owner receiver].
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

	self assert: (aSymbol isUnary or: [aSymbol = #'']).
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

{ #category : #testing }
SBStMessageSend >> selectorAppearsValid [

	^ self selectorIsIncomplete or: [self isDefined not or: [(self actualReceiver ifNotNil: [:r | r guessedClass ifNotNil: [:class | class canUnderstand: self selector asSymbol]]) ifNil: [true]]]
]

{ #category : #'as yet unclassified' }
SBStMessageSend >> selectorIsIncomplete [

	^ self selector isEmpty or: [self selector includesSubstring: '::']
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

	| receiver editor |
	editor := self sandblockEditor.
	self isInCascade ifTrue: [
		editor do: (SBDeleteCommand new target: self).
		^ editor selection startInputAtEnd].
	
	receiver := self receiver.
	editor
		endInput;
		do: (SBReplaceCommand new
			target: self;
			replacer: receiver).
	editor selection startInputAtEnd
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

	self sandblockEditor do: (SBReplaceCommand new
		target: self;
		replacer: (SBStName contents: self selector))
]

{ #category : #'as yet unclassified' }
SBStMessageSend >> useSuggestion: aString [

	signature selectorAndEdit: aString withFilledArgs: false
]

{ #category : #'as yet unclassified' }
SBStMessageSend >> valid [
	" the selector is handled by the message parts, if they are incomplete don't double the invalid signal "

	^ self selectorIsIncomplete or: [self isDefined]
]

{ #category : #'as yet unclassified' }
SBStMessageSend >> validSelector [

	^ (self selector isEmpty or: [self selector = ':']) or: [(self selector first canBeIdentifierInitial and: [(self selector allSatisfy: [:c | c isAlphaNumeric or: [c = $: or: [c = $_]]]) and: [(self selector includesSubstring: '::') not]]) or: [self selector allSatisfy: #isSpecial]]
]

{ #category : #'as yet unclassified' }
SBStMessageSend >> veryDeepCopyWith: deepCopier [

	| new |
	" assure that copies of us have a unique id "
	new := super veryDeepCopyWith: deepCopier.
	self receiver ifNil: [new receiver: self newNullBlock].
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
	<actionValidIf: #notInCascade>

	| cascade |
	self assert: self isSelected.
	cascade := SBStCascade new.
	self sandblockEditor doMultiSelection: [:selected | | targets |
		targets := selected collect: #messageSend.
		(self sandblockEditor submorphsAreConsecutive: targets)
			ifFalse: [nil]
			ifTrue: [
				SBWrapConsecutiveCommand new
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
	self actualReceiver writeSourceOn: aStream.
	aStream space.
	signature writeSourceOn: aStream.
	aStream nextPut: $)
]
