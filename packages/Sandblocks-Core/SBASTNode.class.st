Class {
	#name : #SBASTNode,
	#superclass : #SBBlock,
	#category : #'Sandblocks-Core'
}

{ #category : #actions }
SBASTNode >> addExample [
	<action>

	| method class |
	method := self containingArtefact.
	class := method methodClass.
	
	self sandblockEditor do: ((SBInsertCommand newFor: method)
		container: method body;
		index: 2;
		morph: (SBExample new
			self: (method isClassSide
				ifTrue: [SBName contents: class theNonMetaClassName]
				ifFalse: [
					(SBMessageSend new
						receiver: (SBName contents: class name)
						selector: (method selector = #initialize ifTrue: [#basicNew] ifFalse: [#new]))])
			args: (SBArray new
				type: #dynamic
				contents: (Array streamContents: [:str | method arguments size timesRepeat: [str nextPut: self newNullBlock]]))
			label: 'example'))
]

{ #category : #actions }
SBASTNode >> browseImplementors [
	<action>

	| list |
	self selector ifNotNil: [:sel |
		list := self systemNavigation allImplementorsOf: sel asSymbol.
		list size = 1
			ifTrue: [self sandblockEditor open: list first compiledMethod]
			ifFalse: [self sandblockEditor openMorphInView: (SBCodeAccordion newFor: (list collect: #compiledMethod))]]
]

{ #category : #actions }
SBASTNode >> browseSenders [
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
SBASTNode >> canAppearInBlockBody [

	^ self isExpression
]

{ #category : #actions }
SBASTNode >> changeToUnknown [
	<action>

	| new |
	new := self newNullBlock anyRepresentationThat: self acceptedRepresentation.
	new ifNotNil: [
		self sandblockEditor
			copyBuffer: self;
			do: ((SBReplaceCommand newFor: self containingArtefact)
				target: self;
				replacer: new;
				shouldMergeWithNext: true;
				yourself);
			startInput: new at: 0 replacingContents: false]
]

{ #category : #'as yet unclassified' }
SBASTNode >> contextAcceptedRepresentationAt: aNumber [

	^ #isSmalltalkExpression
]

{ #category : #actions }
SBASTNode >> copyString [
	<action>

	Clipboard clipboardText: self prettySourceString
]

{ #category : #actions }
SBASTNode >> debugExpression [
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

{ #category : #actions }
SBASTNode >> extractMethod [
	<multiSelectAction>

	self sandblockEditor multiSelectionIsConsecutive ifFalse: [^ self].
	
	self sandblockEditor doMultiSelection: [:extracting | | arguments localBindings method |
		self flag: #todo. " consider write vs read access "
		localBindings := extracting gather: #resolveLocalBindings.
		localBindings := ((KeyedSet keyBlock: #name) addAll: localBindings; yourself) asArray.
		arguments := localBindings collect: [:arg | SBName contents: arg contents].
		
		method := SBMethod new
				selector: (#extracted numArgs: localBindings size)
				arguments: localBindings veryDeepCopy
				class: self containingArtefact methodClass;
				body: SBBlockBody new.
		
		SBCombinedCommand newWith:
			{(SBReplaceConsecutiveCommand newFor: self containingArtefact)
				targets: extracting;
				replacer: (SBMessageSend new
					receiver: (SBName contents: 'self')
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
					outer: SBReturn new;
					wrap: [:outer :inner | outer expression: inner].
				self sandblockEditor openMorphInViewCommand: method}
		]
]

{ #category : #actions }
SBASTNode >> extractVariable [
	<action>

	| name var block |
	name := (UIManager default request: 'Name for variable?') ifEmpty: [^ self].
	var := SBName contents: name.
	block := self containingBlock.
	
	self sandblockEditor do: (SBCombinedCommand newWith: {
			block declareTemporaryVariableCommand: name.
			(SBReplaceCommand newFor: self containingArtefact) target: self; replacer: var.
			(SBInsertCommand newFor: self containingArtefact) container: block; index: 2; morph: self.
			(SBWrapCommand newFor: self containingArtefact) inner: self; outer: SBAssignment new; wrap: [:outer :inner | outer binding: var veryDeepCopy value: inner].
		})
]

{ #category : #actions }
SBASTNode >> fixedNumberOfChildren [
	" return whether you may only take a fixed number of children "

	^ true
]

{ #category : #'as yet unclassified' }
SBASTNode >> guessClassExpensive [

	^ self guessedClass ifNil: [[(SBSandboxSimulator new simulate: [self evaluate]) ifNotNil: #class] on: Error do: [nil]]
]

{ #category : #'as yet unclassified' }
SBASTNode >> guessedClass [

	" return a non-nil value to help services like autocompletion do their job "
	^ nil
]

{ #category : #'as yet unclassified' }
SBASTNode >> handleDroppedBlock: aBlock event: anEvent [

	self fixedNumberOfChildren
		ifTrue: [ | replacer |
			replacer := aBlock object anyRepresentationThat: self acceptedRepresentation.
			self sandblockEditor do: ((SBReplaceCommand newFor: self containingArtefact)
				target: self;
				replacer: replacer).
			replacer postDuplicate]
		ifFalse: [ | replacer |
			self dropLocationDo: [:position :morph :horizontal |
				replacer := aBlock object anyRepresentationThat: (self contextAcceptedRepresentationAt: morph childIndex).
				self sandblockEditor do: ((self insertCommandRequest: false near: morph) shouldMergeWithNext: true).
				self sandblockEditor do: ((SBReplaceCommand newFor: self containingArtefact)
					target: self sandblockEditor selection;
					replacer: replacer)]]
]

{ #category : #'actions input' }
SBASTNode >> initialize [

	super initialize.
	
	self
		layoutPolicy: SBAlgebraLayout new;
		hResizing: #shrinkWrap;
		vResizing: #shrinkWrap
]

{ #category : #actions }
SBASTNode >> insertLabelAbove [
	<action>

	self insertLabelAboveOrBelow: true
]

{ #category : #'as yet unclassified' }
SBASTNode >> insertLabelAboveOrBelow: anAboveBoolean [

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
SBASTNode >> insertLabelBelow [
	<action>

	self insertLabelAboveOrBelow: false
]

{ #category : #actions }
SBASTNode >> insertStatementAbove [
	<action>

	self insertStatementAboveOrBelow: true
]

{ #category : #actions }
SBASTNode >> insertStatementAboveOrBelow: anAboveBoolean [

	| currentStatement index newStatement |
	newStatement := self newNullBlock.
	currentStatement := self containingStatement.
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
SBASTNode >> insertStatementBelow [
	<action>
	<actionValidIf: #hasNoSuggestions>

	self insertStatementAboveOrBelow: false
]

{ #category : #'as yet unclassified' }
SBASTNode >> isASTNode [

	^ true
]

{ #category : #testing }
SBASTNode >> isReturn [

	^ false
]

{ #category : #testing }
SBASTNode >> isStatement [

	^ self owner isBlockBody
]

{ #category : #actions }
SBASTNode >> newNullBlock [

	^ SBUnknown new
]

{ #category : #'as yet unclassified' }
SBASTNode >> object [

	^ self
]

{ #category : #actions }
SBASTNode >> pasteString [
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

{ #category : #'as yet unclassified' }
SBASTNode >> pc [

	^ 0
]

{ #category : #'as yet unclassified' }
SBASTNode >> pc: aNumber [

	" save a pc if you are an accessible point during execution "
]

{ #category : #'as yet unclassified' }
SBASTNode >> prettySourceString [

	^ SBFormatter formatString: self sourceString class: self containingArtefact relatedClass noPattern: self ~= self containingArtefact
	
	"false
		ifTrue: [[Smalltalk at: #PPPPrinter ifPresent: [:p | text := p format: text]] on: Error do: []]
		ifFalse: [text := self class prettyPrinterClass format: text in: self containingArtefact methodClass notifying: nil]."
]

{ #category : #actions }
SBASTNode >> selectNextSend [
	<multiSelectAction>

	self sandblockEditor selectionDownHistory removeAll.
	(self nextBlockThat: #isMessageSend) ifNotNil: #select
]

{ #category : #actions }
SBASTNode >> selectPreviousSend [
	<multiSelectAction>

	self sandblockEditor selectionDownHistory removeAll.
	(self previousBlockThat: #isMessageSend) ifNotNil: #select
]

{ #category : #printing }
SBASTNode >> selectRightMostBlock [
	<multiSelectAction>
	<inputAction>

	self containingStatement ifNil: [self rightMostBlock select] ifNotNil: [:statement | statement rightMostBlock select].
	
	self sandblockEditor maybeStartInputFromEnd
]

{ #category : #actions }
SBASTNode >> selectStartOfStatement [
	<multiSelectAction>
	<inputAction>
	
	self containingStatement firstDeepChild select.
	
	self sandblockEditor maybeStartInputFromStart
]

{ #category : #printing }
SBASTNode >> selectionLabel [

	^ String streamContents: [:stream |
		self printOn: stream.
		
		self guessedClass ifNotNil: [:c | stream space; nextPut: $(. c printOn: stream. stream nextPut: $)]]
]

{ #category : #'as yet unclassified' }
SBASTNode >> sourceString [

	^ String streamContents: [:s | self writeSourceOn: s]
]

{ #category : #actions }
SBASTNode >> unpackList [
	<action>
	<actionValidIf: #parentHasDynamicNumberOfChildren>

	self sandblockEditor do: ((SBUnwrapConsecutiveCommand newFor: self containingArtefact) target: self)
]

{ #category : #'as yet unclassified' }
SBASTNode >> updatePCFrom: aBlock [

	self pc: aBlock pc
]

{ #category : #'actions input' }
SBASTNode >> useFifthArgument [
	<inputAction>
	
	self containingArtefact arguments size >= 5 ifTrue: [
		self sandblockEditor endInputWith: self containingArtefact arguments fifth contents]
]

{ #category : #'actions input' }
SBASTNode >> useFirstArgument [
	<inputAction>
	
	self containingArtefact arguments ifNotEmpty: [
		self sandblockEditor endInputWith: self containingArtefact arguments first contents]
]

{ #category : #'actions input' }
SBASTNode >> useFourthArgument [
	<inputAction>
	
	self containingArtefact arguments size >= 4 ifTrue: [
		self sandblockEditor endInputWith: self containingArtefact arguments fourth contents]
]

{ #category : #'actions input' }
SBASTNode >> useSecondArgument [
	<inputAction>
	
	self containingArtefact arguments size >= 2 ifTrue: [
		self sandblockEditor endInputWith: self containingArtefact arguments second contents]
]

{ #category : #'actions input' }
SBASTNode >> useThirdArgument [
	<inputAction>
	
	self containingArtefact arguments size >= 3 ifTrue: [
		self sandblockEditor endInputWith: self containingArtefact arguments third contents]
]

{ #category : #actions }
SBASTNode >> watchWith: aWatchClass [

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
SBASTNode >> wrapAsArgument [
	<action>
	<actionValidIf: #isExpression>

	| msg |
	msg := SBMessageSend new.
	self sandblockEditor
		do: ((SBWrapCommand newFor: self containingArtefact)
			outer: msg;
			inner: self;
			shouldMergeWithNext: true;
			wrap: [:outer :inner |
				outer receiver: self newNullBlock selector: SBMessageSend placeholderSelector arguments: {inner}];
			yourself);
		startInput: msg receiver at: 0 replacingContents: false
]

{ #category : #actions }
SBASTNode >> wrapInArrayType: aSymbol [

	self assert: self isSelected.
	self sandblockEditor multiSelectionIsConsecutive ifFalse: [^ self].
	self sandblockEditor doMultiSelection: [:selected |
		(SBWrapConsecutiveCommand newFor: self containingArtefact)
			outer: SBArray new;
			targets: selected;
			wrap: [:outer :inner | outer type: aSymbol contents: inner];
			yourself]
]

{ #category : #actions }
SBASTNode >> wrapInAssignment [
	<action>
	<actionValidIf: #isExpression>

	| binding |
	binding := SBName new.
	self sandblockEditor do: ((SBWrapCommand newFor: self containingArtefact)
		outer: SBAssignment new;
		inner: self;
		wrap: [:outer :inner | outer binding: binding value: inner];
		shouldMergeWithNext: true;
		yourself).
	
	self sandblockEditor startInput: binding at: 0 replacingContents: true
]

{ #category : #actions }
SBASTNode >> wrapInBlock [
	<multiSelectAction>
	<actionValidIf: #isExpression>

	self assert: self isSelected.
	self sandblockEditor multiSelectionIsConsecutive ifFalse: [^ self].
	self sandblockEditor doMultiSelection: [:selected |
		(SBWrapConsecutiveCommand newFor: self containingArtefact)
			outer: SBBlockBody new;
			targets: selected;
			wrap: [:outer :inner | outer statements: inner];
			yourself]
]

{ #category : #actions }
SBASTNode >> wrapInDynamicArray [
	<multiSelectAction>

	self wrapInArrayType: #dynamic
]

{ #category : #actions }
SBASTNode >> wrapInLiteralArray [
	<multiSelectAction>

	self wrapInArrayType: #literal
]

{ #category : #actions }
SBASTNode >> wrapInMessageSend [
	<action>
	<actionValidIf: #isExpression>

	^ self wrapInMessageSend: ''
]

{ #category : #actions }
SBASTNode >> wrapInMessageSend: aString [

	| msg |
	msg := SBMessageSend new
		receiver: self newNullBlock
		selector: aString
		arguments: (aString numArgs > 0 ifTrue: [
			(1 to: aString numArgs) collect: [:i | SBUnknown new]] ifFalse: [#()]).
	self sandblockEditor do: ((SBWrapCommand newFor: self containingArtefact)
		outer: msg;
		inner: self;
		shouldMergeWithNext: true;
		wrap: [:outer :inner | outer receiver: inner];
		yourself).
	self sandblockEditor startInput: msg at: 900000000 replacingContents: false.
	^ msg
]

{ #category : #actions }
SBASTNode >> wrapInReturn [
	<action>
	<actionValidIf: #isExpression>

	self sandblockEditor do: ((SBWrapCommand newFor: self containingArtefact)
		outer: SBReturn new;
		inner: self;
		wrap: [:outer :inner | outer expression: inner];
		yourself)
]

{ #category : #actions }
SBASTNode >> wrapInToggledCode [
	<multiSelectAction>

	| comment |
	self assert: self isSelected.
	comment := SBToggledCode new.
	self sandblockEditor multiSelectionIsConsecutive ifFalse: [^ self].
	self sandblockEditor doMultiSelection: [:selected |
		(SBWrapConsecutiveCommand newFor: self containingArtefact)
			outer: comment;
			targets: selected;
			wrap: [:outer :inner | outer comment: '' active: 0 do: {SBBlockBody new statements: inner}];
			yourself]
]

{ #category : #actions }
SBASTNode >> wrapWithExampleWatch [
	<action>
	<actionValidIf: #isExpression>

	self watchWith: SBExampleWatch
]

{ #category : #actions }
SBASTNode >> wrapWithWatch [
	<action>
	<inputAction>
	<actionValidIf: #isExpression>

	self watchWith: SBNewWatch
]

{ #category : #printing }
SBASTNode >> writeSourceOn: aStream [

	^ self subclassResponsibility
]
