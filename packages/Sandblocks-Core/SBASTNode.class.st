Class {
	#name : #SBASTNode,
	#superclass : #SBBlock,
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBASTNode >> acceptedRepresentation [

	^ (self parentSandblock notNil and: [self parentSandblock isASTNode]) ifTrue: [
		self parentSandblock contextAcceptedRepresentationAt: self childIndex] ifFalse: [#()]
]

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
				contents: (Array streamContents: [:str | method arguments size timesRepeat: [str nextPut: SBUnknown new]]))
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
		container := SBCodeAccordion new.
		calls do: [:call |
			container  addMorphBack: (SBCodeLens forMethod: call compiledMethod selector: sel)].
		container openNear: self]
]

{ #category : #actions }
SBASTNode >> changeToUnknown [
	<action>

	| new |
	new := SBUnknown new.
	(new hasRepresentationThat: (self parentSandblock contextAcceptedRepresentationAt: self childIndex)) ifTrue: [
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

{ #category : #'as yet unclassified' }
SBASTNode >> handleDroppedBlock: aBlock event: anEvent [

	| replacer |
	replacer := aBlock object representationThat: (self parentSandblock contextAcceptedRepresentationAt: self childIndex).
	self sandblockEditor do: ((SBReplaceCommand newFor: self containingArtefact)
		target: self;
		replacer: replacer).
	replacer postDuplicate
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
	newStatement := SBUnknown new.
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

{ #category : #'as yet unclassified' }
SBASTNode >> textContents [

	^ self prettySourceString
]

{ #category : #actions }
SBASTNode >> unpackAsStatements [
	<action>

	self sandblockEditor do: ((SBUnwrapConsecutiveCommand newFor: self containingArtefact) target: self)
]

{ #category : #'actions input' }
SBASTNode >> useFifthArgument [
	<inputAction>
	
	self sandblockEditor endInputWith: self containingArtefact arguments fifth contents
]

{ #category : #'actions input' }
SBASTNode >> useFirstArgument [
	<inputAction>
	
	self sandblockEditor endInputWith: self containingArtefact arguments first contents
]

{ #category : #'actions input' }
SBASTNode >> useFourthArgument [
	<inputAction>
	
	self sandblockEditor endInputWith: self containingArtefact arguments fourth contents
]

{ #category : #'actions input' }
SBASTNode >> useSecondArgument [
	<inputAction>
	
	self sandblockEditor endInputWith: self containingArtefact arguments second contents
]

{ #category : #'actions input' }
SBASTNode >> useThirdArgument [
	<inputAction>
	
	self sandblockEditor endInputWith: self containingArtefact arguments third contents
]

{ #category : #'as yet unclassified' }
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

	| msg |
	msg := SBMessageSend new.
	self sandblockEditor
		do: ((SBWrapCommand newFor: self containingArtefact)
			outer: msg;
			inner: self;
			shouldMergeWithNext: true;
			wrap: [:outer :inner |
				outer receiver: SBUnknown new selector: SBMessageSend placeholderSelector arguments: {inner}];
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
SBASTNode >> wrapInCascade [
	<multiSelectAction>

	| cascade |
	self isMessageSend ifFalse: [^ self].
	self assert: self isSelected.
	cascade := SBCascade new.
	self sandblockEditor multiSelectionIsConsecutive ifFalse: [^ self].
	self sandblockEditor doMultiSelection: [:selected |
		(SBWrapConsecutiveCommand newFor: self containingArtefact)
			targets: selected;
			outer: SBCascade new;
			wrap: [:outer :inner |
				outer addMorphFront: inner first receiver.
				outer addAllMorphs: inner];
			wrapUndo: [:outer :inner |
				inner do: [:message | message receiver: outer receiver veryDeepCopy].
				outer removeAllMorphs]]
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

	self wrapInMessageSend: ''
]

{ #category : #actions }
SBASTNode >> wrapInMessageSend: aString [

	| msg |
	self isExpression ifFalse: [^ self].
	msg := SBMessageSend new
		receiver: SBUnknown new
		selector: aString
		arguments: (aString numArgs > 0 ifTrue: [
			(1 to: aString numArgs) collect: [:i | SBUnknown new]] ifFalse: [#()]).
	self sandblockEditor do: ((SBWrapCommand newFor: self containingArtefact)
		outer: msg;
		inner: self;
		shouldMergeWithNext: true;
		wrap: [:outer :inner | outer receiver: inner];
		yourself).
	self sandblockEditor startInput: msg at: 900000000 replacingContents: false
]

{ #category : #actions }
SBASTNode >> wrapInReturn [
	<action>

	self sandblockEditor do: ((SBWrapCommand newFor: self containingArtefact)
		outer: SBReturn new;
		inner: self;
		wrap: [:outer :inner | outer expression: inner];
		yourself)
]

{ #category : #actions }
SBASTNode >> wrapInToggledCode [
	<action>

	self sandblockEditor do: ((SBWrapCommand newFor: self containingArtefact)
		outer: SBToggledCode new;
		inner: self;
		wrap: [:outer :inner | outer comment: '' active: 0 do: {SBBlockBody new statements: {inner}}];
		yourself)
]

{ #category : #actions }
SBASTNode >> wrapWithExampleWatch [
	<action>

	self watchWith: SBExampleWatch
]

{ #category : #actions }
SBASTNode >> wrapWithWatch [
	<action>

	self watchWith: SBWatch
]
