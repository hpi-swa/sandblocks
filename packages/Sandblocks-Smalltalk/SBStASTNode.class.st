Class {
	#name : #SBStASTNode,
	#superclass : #SBBlock,
	#category : #'Sandblocks-Smalltalk'
}

{ #category : #actions }
SBStASTNode >> addExample [
	<action>

	| method class |
	method := self containingArtefact.
	class := method methodClass.
	
	self sandblockEditor do: ((SBInsertCommand newFor: method)
		container: method body;
		index: 2;
		morph: (SBExample new
			self: (method isClassSide
				ifTrue: [SBStName contents: class theNonMetaClassName]
				ifFalse: [
					(SBStMessageSend new
						receiver: (SBStName contents: class name)
						selector: (method selector = #initialize ifTrue: [#basicNew] ifFalse: [#new]))])
			args: (SBStArray new
				type: #dynamic
				contents: (Array streamContents: [:str | method arguments size timesRepeat: [str nextPut: self newNullBlock]]))
			label: 'example'))
]

{ #category : #converting }
SBStASTNode >> asMessagePart: aConverter [
	<convert>
	
	^ aConverter
		if: [self currentTextMorph notNil]
		do: [SBStMessagePart new contents: self contents]
]

{ #category : #converting }
SBStASTNode >> asMorphBlock: converter [
	<convert>
	
	" we can't generally convert ourselves to morphs since we need our artefact owner "
]

{ #category : #actions }
SBStASTNode >> browseImplementors [
	<action>

	| list |
	self selector ifNotNil: [:sel |
		list := self systemNavigation allImplementorsOf: sel asSymbol.
		list size = 1
			ifTrue: [self sandblockEditor open: list first compiledMethod]
			ifFalse: [self sandblockEditor openMorphInView: (SBCodeAccordion newFor: (list collect: #compiledMethod))]]
]

{ #category : #actions }
SBStASTNode >> browseSenders [
	<action>

	self selector ifNotNil: [:sel | | calls container |
		calls := self systemNavigation allCallsOn: sel asSymbol.
		calls ifEmpty: [^ self].
		calls size = 1 ifTrue: [^ self sandblockEditor open: calls first compiledMethod].
		
		container := SBCodeAccordion new.
		calls do: [:call | container  addMorphBack: (SBCodeLens forMethod: call compiledMethod selector: sel)].
		container openNear: self]
]

{ #category : #testing }
SBStASTNode >> canAppearInBlockBody [

	^ self isExpression
]

{ #category : #actions }
SBStASTNode >> changeToUnknown [
	<action>

	self newNullBlock
		convertedFor: self objectInterface
		do: [:new |
			new ifNotNil: [
				self sandblockEditor
					copyBuffer: self;
					do: ((SBReplaceCommand newFor: self containingArtefact)
						target: self;
						replacer: new;
						shouldMergeWithNext: true;
						yourself);
					startInput: new at: 0 replacingContents: false]]
]

{ #category : #actions }
SBStASTNode >> copyString [
	<action>

	Clipboard clipboardText: self prettySourceString
]

{ #category : #actions }
SBStASTNode >> debugExpression [
	<action>
	
	| artefact cue context process |
	artefact := self containingArtefact.
	context := self sandblockEditor errors focusedArtefact = artefact ifTrue: [self sandblockEditor errors focusedContext] ifFalse: [nil].
	cue := self compilationCueWith: artefact for: context.
	
	process := Process
		forMethod: (Compiler new compileCue: cue noPattern: true ifFail: nil) generateWithTempNames
		receiver: (context ifNotNil: #receiver).
	
	self sandblockEditor reportError: nil process: process
]

{ #category : #evaluate }
SBStASTNode >> evaluate [

	^ self containingArtefact
		ifNotNil: [:artefact | | context |
			context := artefact evaluationContext.
			Compiler new
				evaluate: self sourceString
				in: context
				to: (context ifNil: [artefact evaluationReceiver] ifNotNil: #receiver)
				notifying: artefact
				ifFail: nil]
		ifNil: [Compiler evaluate: self sourceString]
]

{ #category : #evaluate }
SBStASTNode >> evaluateExpression [
	<action>
	<actionValidIf: #isExpression>

	| result |
	result := self evaluate.
	self containingArtefact ifNotNil: [
		self containingArtefact cacheType: result class for: self].
	
	result convertedFor: SBInterfaces topLevel do: [:morph |
		self sandblockEditor openMorphInView: morph.
		morph focusAfterDelete: self.
		self sandblockEditor connectFrom: self to: morph]
]

{ #category : #evaluate }
SBStASTNode >> evaluationContext [

	^ nil
]

{ #category : #evaluate }
SBStASTNode >> evaluationReceiver [

	^ nil
]

{ #category : #actions }
SBStASTNode >> extractMethod [
	<multiSelectAction>

	self sandblockEditor multiSelectionIsConsecutive ifFalse: [^ self].
	
	self sandblockEditor doMultiSelection: [:extracting | | arguments localBindings method |
		self flag: #todo. " consider write vs read access "
		localBindings := extracting gather: #resolveLocalBindings.
		localBindings := ((KeyedSet keyBlock: #name) addAll: localBindings; yourself) asArray.
		arguments := localBindings collect: [:arg | SBStName contents: arg contents].
		
		method := SBStMethod new
				selector: (#extracted numArgs: localBindings size)
				arguments: localBindings veryDeepCopy
				class: self containingArtefact methodClass;
				body: SBBlockBody new.
		
		SBCombinedCommand newWith:
			{(SBReplaceConsecutiveCommand newFor: self containingArtefact)
				targets: extracting;
				replacer: (SBStMessageSend new
					receiver: (SBStName contents: 'self')
					selector: method selector
					arguments: arguments veryDeepCopy)},
			(extracting withIndexCollect: [:stmt :index | (SBInsertCommand newFor: method)
				container: method body;
				index: index + 1;
				morph: stmt;
				yourself]),
			{
				(SBWrapCommand newFor: self containingArtefact)
					inner: extracting last;
					outer: SBStReturn new;
					wrap: [:outer :inner | outer expression: inner].
				self sandblockEditor openMorphInViewCommand: method}
		]
]

{ #category : #actions }
SBStASTNode >> extractVariable [
	<action>

	| name var block |
	name := (UIManager default request: 'Name for variable?') ifEmpty: [^ self].
	var := SBStName contents: name.
	block := self containingBlock.
	
	self sandblockEditor do: (SBCombinedCommand newWith: {
			block declareTemporaryVariableCommand: name.
			(SBReplaceCommand newFor: self containingArtefact) target: self; replacer: var.
			(SBInsertCommand newFor: self containingArtefact) container: block; index: 2; morph: self.
			(SBWrapCommand newFor: self containingArtefact) inner: self; outer: SBStAssignment new; wrap: [:outer :inner | outer binding: var veryDeepCopy value: inner].
		})
]

{ #category : #actions }
SBStASTNode >> fixedNumberOfChildren [
	" return whether you may only take a fixed number of children "

	^ true
]

{ #category : #'object interface' }
SBStASTNode >> guessClassExpensive [

	^ self guessedClass ifNil: [[(SBStSandboxSimulator new simulate: [self evaluate]) ifNotNil: #class] on: Error do: [nil]]
]

{ #category : #'object interface' }
SBStASTNode >> guessedClass [

	" return a non-nil value to help services like autocompletion do their job "
	^ nil
]

{ #category : #'actions input' }
SBStASTNode >> initialize [

	super initialize.
	
	self
		layoutPolicy: SBAlgebraLayout new;
		hResizing: #shrinkWrap;
		vResizing: #shrinkWrap
]

{ #category : #actions }
SBStASTNode >> insertLabelAbove [
	<action>

	self insertLabelAboveOrBelow: true
]

{ #category : #'object interface' }
SBStASTNode >> insertLabelAboveOrBelow: anAboveBoolean [

	| currentStatement index newStatement |
	newStatement :=  SBLabel new.
	
	currentStatement := self containingStatement.
	index := currentStatement owner submorphIndexOf: currentStatement.
	
	self sandblockEditor do: ((SBInsertCommand newFor: self containingArtefact)
		index: (anAboveBoolean
			ifTrue: [index] ifFalse: [index + 1]);
		container: currentStatement owner;
		morph: newStatement;
		shouldMergeWithNext: true;
		yourself).
	
	self sandblockEditor startInput: newStatement at: 1 replacingContents: false
]

{ #category : #actions }
SBStASTNode >> insertLabelBelow [
	<action>

	self insertLabelAboveOrBelow: false
]

{ #category : #actions }
SBStASTNode >> insertStatementAbove [
	<action>

	self insertStatementAboveOrBelow: true
]

{ #category : #actions }
SBStASTNode >> insertStatementAboveOrBelow: anAboveBoolean [

	| currentStatement index newStatement |
	newStatement := self newNullBlock.
	currentStatement := self containingStatement ifNil: [^ self containingArtefact insertStatementAboveOrBelow: anAboveBoolean].
	
	index := currentStatement owner submorphIndexOf: currentStatement.
	self sandblockEditor do: ((SBInsertCommand newFor: self containingArtefact)
		index: (anAboveBoolean ifTrue: [index] ifFalse: [index + 1]);
		container: currentStatement owner;
		morph: newStatement;
		shouldMergeWithNext: true;
		yourself).
	self sandblockEditor startInput: newStatement at: 1 replacingContents: false
]

{ #category : #actions }
SBStASTNode >> insertStatementBelow [
	<action>
	<actionValidIf: #hasNoSuggestions>

	self insertStatementAboveOrBelow: false
]

{ #category : #testing }
SBStASTNode >> isReturn [

	^ false
]

{ #category : #testing }
SBStASTNode >> isSmalltalk [

	^ true
]

{ #category : #testing }
SBStASTNode >> isStatement [

	^ self owner isBlockBody
]

{ #category : #actions }
SBStASTNode >> newNullBlock [

	^ SBUnknown new grammarHandler: SBStGrammarHandler new
]

{ #category : #'object interface' }
SBStASTNode >> object [

	^ self
]

{ #category : #'object interface' }
SBStASTNode >> objectInterfaceAt: aNumber adding: aBoolean [

	^ (self fixedNumberOfChildren and: [aBoolean]) ifTrue: [SBInterfaces never] ifFalse: [SBInterfaces stExpression]
]

{ #category : #actions }
SBStASTNode >> pasteString [
	<action>

	| doIt block baseIndex |
	doIt := Parser new parse: Clipboard clipboardText class: nil class noPattern: true notifying: nil ifFail: [^ nil].
	block := doIt block statements last expr asSandblock.
	baseIndex := self containingStatement owner submorphIndexOf: self containingStatement.
	
	self sandblockEditor do: ((SBCombinedCommand newFor: self containingArtefact)
		commands:
			{(SBReplaceCommand newFor: self containingArtefact) target: self; replacer: block},
			(doIt block statements allButLast withIndexCollect: [:statement :index |
				(SBInsertCommand newFor: self containingArtefact)
					index: baseIndex + index - 1;
					container: self containingStatement owner;
					morph: statement asSandblock])).
	block postDuplicate
]

{ #category : #'object interface' }
SBStASTNode >> pc [

	^ 0
]

{ #category : #'object interface' }
SBStASTNode >> pc: aNumber [

	" save a pc if you are an accessible point during execution "
]

{ #category : #'object interface' }
SBStASTNode >> prettySourceString [

	^ SBFormatter formatString: self sourceString class: self containingArtefact relatedClass noPattern: self ~= self containingArtefact
	
	"false
		ifTrue: [[Smalltalk at: #PPPPrinter ifPresent: [:p | text := p format: text]] on: Error do: []]
		ifFalse: [text := self class prettyPrinterClass format: text in: self containingArtefact methodClass notifying: nil]."
]

{ #category : #actions }
SBStASTNode >> selectNextSend [
	<multiSelectAction>

	self sandblockEditor selectionDownHistory removeAll.
	(self nextBlockThat: #isMessageSend) ifNotNil: #select
]

{ #category : #actions }
SBStASTNode >> selectPreviousSend [
	<multiSelectAction>

	self sandblockEditor selectionDownHistory removeAll.
	(self previousBlockThat: #isMessageSend) ifNotNil: #select
]

{ #category : #printing }
SBStASTNode >> selectRightMostBlock [
	<multiSelectAction>
	<inputAction>

	self containingStatement ifNil: [self rightMostBlock select] ifNotNil: [:statement | statement rightMostBlock select].
	
	self sandblockEditor maybeStartInputFromEnd
]

{ #category : #actions }
SBStASTNode >> selectStartOfStatement [
	<multiSelectAction>
	<inputAction>
	
	self containingStatement firstDeepChild select.
	
	self sandblockEditor maybeStartInputFromStart
]

{ #category : #printing }
SBStASTNode >> selectionLabel [

	^ String streamContents: [:stream |
		self printOn: stream.
		
		self guessedClass ifNotNil: [:c | stream space; nextPut: $(. c printOn: stream. stream nextPut: $)]]
]

{ #category : #'object interface' }
SBStASTNode >> sourceString [

	^ String streamContents: [:s | self writeSourceOn: s]
]

{ #category : #actions }
SBStASTNode >> unpackList [
	<action>
	<actionValidIf: #parentHasDynamicNumberOfChildren>

	self sandblockEditor do: ((SBUnwrapConsecutiveCommand newFor: self containingArtefact) target: self)
]

{ #category : #'object interface' }
SBStASTNode >> updatePCFrom: aBlock [

	self pc: aBlock pc
]

{ #category : #'actions input' }
SBStASTNode >> useFifthArgument [
	<inputAction>
	
	self containingArtefact arguments size >= 5 ifTrue: [
		self sandblockEditor endInputWith: self containingArtefact arguments fifth contents]
]

{ #category : #'actions input' }
SBStASTNode >> useFirstArgument [
	<inputAction>
	
	self containingArtefact arguments ifNotEmpty: [
		self sandblockEditor endInputWith: self containingArtefact arguments first contents]
]

{ #category : #'actions input' }
SBStASTNode >> useFourthArgument [
	<inputAction>
	
	self containingArtefact arguments size >= 4 ifTrue: [
		self sandblockEditor endInputWith: self containingArtefact arguments fourth contents]
]

{ #category : #'actions input' }
SBStASTNode >> useSecondArgument [
	<inputAction>
	
	self containingArtefact arguments size >= 2 ifTrue: [
		self sandblockEditor endInputWith: self containingArtefact arguments second contents]
]

{ #category : #'actions input' }
SBStASTNode >> useThirdArgument [
	<inputAction>
	
	self containingArtefact arguments size >= 3 ifTrue: [
		self sandblockEditor endInputWith: self containingArtefact arguments third contents]
]

{ #category : #actions }
SBStASTNode >> watchWith: aWatchClass [

	self isExpression ifFalse: [^ self].
	
	self isWatch
		ifTrue: [^ self sandblockEditor do: ((SBReplaceCommand newFor: self containingArtefact) target: self; replacer: self childSandblocks first)].
	
	self parentSandblock isWatch ifTrue: [^ self deleteAround].
	
	self sandblockEditor do: ((SBWrapCommand newFor: self containingArtefact)
			outer: aWatchClass new newIdentifier;
			inner: self;
			wrap: [:outer :inner | outer expression: inner])
]

{ #category : #actions }
SBStASTNode >> wrapAsArgument [
	<action>
	<actionValidIf: #isExpression>

	| msg |
	msg := SBStMessageSend new.
	self sandblockEditor
		do: ((SBWrapCommand newFor: self containingArtefact)
			outer: msg;
			inner: self;
			shouldMergeWithNext: true;
			wrap: [:outer :inner |
				outer receiver: self newNullBlock selector: SBStMessageSend placeholderSelector arguments: {inner}];
			yourself);
		startInput: msg receiver at: 0 replacingContents: false
]

{ #category : #actions }
SBStASTNode >> wrapInArrayType: aSymbol [

	self assert: self isSelected.
	self sandblockEditor multiSelectionIsConsecutive ifFalse: [^ self].
	self sandblockEditor doMultiSelection: [:selected |
		(SBWrapConsecutiveCommand newFor: self containingArtefact)
			outer: SBStArray new;
			targets: selected;
			wrap: [:outer :inner | outer type: aSymbol contents: inner];
			yourself]
]

{ #category : #actions }
SBStASTNode >> wrapInAssignment [
	<action>
	<actionValidIf: #isExpression>

	| binding |
	binding := SBStName new.
	self sandblockEditor do: ((SBWrapCommand newFor: self containingArtefact)
		outer: SBStAssignment new;
		inner: self;
		wrap: [:outer :inner | outer binding: binding value: inner];
		shouldMergeWithNext: true;
		yourself).
	
	self sandblockEditor startInput: binding at: 0 replacingContents: true
]

{ #category : #actions }
SBStASTNode >> wrapInBlock [
	<multiSelectAction>
	<actionValidIf: #isExpression>

	self assert: self isSelected.
	self sandblockEditor multiSelectionIsConsecutive ifFalse: [^ self].
	self sandblockEditor doMultiSelection: [:selected |
		(SBWrapConsecutiveCommand newFor: self containingArtefact)
			outer: SBStBlockBody new;
			targets: selected;
			wrap: [:outer :inner | outer statements: inner];
			yourself]
]

{ #category : #actions }
SBStASTNode >> wrapInDynamicArray [
	<multiSelectAction>

	self wrapInArrayType: #dynamic
]

{ #category : #actions }
SBStASTNode >> wrapInLiteralArray [
	<multiSelectAction>

	self wrapInArrayType: #literal
]

{ #category : #actions }
SBStASTNode >> wrapInMessageSend [
	<action>
	<actionValidIf: #isExpression>

	^ self wrapInMessageSend: ''
]

{ #category : #actions }
SBStASTNode >> wrapInMessageSend: aString [

	| msg |
	msg := SBStMessageSend new
		receiver: self newNullBlock
		selector: aString
		arguments: (aString numArgs > 0 ifTrue: [
			(1 to: aString numArgs) collect: [:i | self newNullBlock]] ifFalse: [#()]).
	self sandblockEditor do: ((SBWrapCommand newFor: self containingArtefact)
		outer: msg;
		inner: self;
		shouldMergeWithNext: true;
		wrap: [:outer :inner | outer receiver: inner];
		yourself).
	self sandblockEditor startInput: msg at: 900000000 replacingContents: false.
	^ msg
]

{ #category : #converting }
SBStASTNode >> wrapInPlayground: convert [
	<convert>
	
	convert do: [SBStPlayground new statements: {self veryDeepCopy}]
]

{ #category : #actions }
SBStASTNode >> wrapInReturn [
	<action>
	<actionValidIf: #isExpression>

	self sandblockEditor do: ((SBWrapCommand newFor: self containingArtefact)
		outer: SBStReturn new;
		inner: self;
		wrap: [:outer :inner | outer expression: inner];
		yourself)
]

{ #category : #actions }
SBStASTNode >> wrapInToggledCode [
	<multiSelectAction>

	| comment |
	self assert: self isSelected.
	comment := SBToggledCode new.
	self sandblockEditor multiSelectionIsConsecutive ifFalse: [^ self].
	self sandblockEditor doMultiSelection: [:selected |
		(SBWrapConsecutiveCommand newFor: self containingArtefact)
			outer: comment;
			targets: selected;
			wrap: [:outer :inner | outer comment: '' active: 0 do: {SBStBlockBody new statements: inner}];
			yourself]
]

{ #category : #actions }
SBStASTNode >> wrapWithExampleWatch [
	<action>
	<actionValidIf: #isExpression>

	self watchWith: SBExampleWatch
]

{ #category : #actions }
SBStASTNode >> wrapWithWatch [
	<action>
	<inputAction>
	<actionValidIf: #isExpression>

	self watchWith: SBWatch
]

{ #category : #printing }
SBStASTNode >> writeSourceOn: aStream [

	^ self subclassResponsibility
]
