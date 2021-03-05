Class {
	#name : #SBStGrammarHandler,
	#superclass : #SBGrammarHandler,
	#instVars : [
		'currentBlock'
	],
	#category : #'Sandblocks-Smalltalk'
}

{ #category : #actions }
SBStGrammarHandler >> addExample [
	<action>

	| method class |
	self block isExample ifTrue: [^ self block toggleRunning].
	
	method := self block containingArtefact.
	class := method methodClass.
	
	self block sandblockEditor do: ((SBInsertCommand newFor: method)
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
				contents: (Array streamContents: [:str | method arguments size timesRepeat: [str nextPut: self block newNullBlock]]))
			label: 'example'))
]

{ #category : #actions }
SBStGrammarHandler >> browseImplementors [
	<action>

	| list |
	self block selector ifNotNil: [:sel |
		self block sandblockEditor isSingleArtefactView ifTrue: [^ self changeToBlockView: (self systemNavigation browseAllImplementorsOf: sel asSymbol)].
		
		list := self systemNavigation allImplementorsOf: sel asSymbol.
		list size = 1
			ifTrue: [self block sandblockEditor open: list first compiledMethod]
			ifFalse: [
				self block sandblockEditor openMorphInView: (SBCodeAccordion newFor: (list collect: #compiledMethod))]]
]

{ #category : #actions }
SBStGrammarHandler >> browseSenders [
	<action>

	self block selector ifNotNil: [:sel | | calls container |
		self block sandblockEditor isSingleArtefactView ifTrue: [^ self changeToBlockView: (self systemNavigation browseAllCallsOn: sel asSymbol)].
		
		calls := self systemNavigation allCallsOn: sel asSymbol.
		calls ifEmpty: [^ self].
		calls size = 1 ifTrue: [^ self block sandblockEditor open: calls first compiledMethod].
		
		container := SBCodeAccordion new.
		calls do: [:call | container addMorphBack: (SBCodeLens forMethod: call compiledMethod selector: sel)].
		container openNear: self block]
]

{ #category : #'callback helpers' }
SBStGrammarHandler >> changeToBlockView: aWindow [

	aWindow model toggleBlockEditor.
	^ aWindow
]

{ #category : #actions }
SBStGrammarHandler >> debugExpression [
	<action>
	
	| artefact cue context process |
	artefact := self block containingArtefact.
	context := self block sandblockEditor errors focusedArtefact = artefact ifTrue: [self block sandblockEditor errors focusedContext] ifFalse: [nil].
	cue := self block compilationCueWith: artefact for: context.
	
	process := Process
		forMethod: (Compiler new compileCue: cue noPattern: true ifFail: nil) generateWithTempNames
		receiver: (context ifNotNil: #receiver).
	
	self block sandblockEditor reportError: nil process: process
]

{ #category : #'callback helpers' }
SBStGrammarHandler >> emptyLine: aBlock [
	<action>
	<actionValidIf: #isStatement>
	
	aBlock sandblockEditor do: ((SBReplaceCommand newFor: aBlock containingArtefact)
		target: aBlock;
		replacer: SBStEmptyLine new)
]

{ #category : #actions }
SBStGrammarHandler >> extractMethod [
	<multiSelectAction>

	self block sandblockEditor multiSelectionIsConsecutive ifFalse: [^ self].
	
	self block sandblockEditor doMultiSelection: [:extracting | | arguments localBindings method |
		SBLabel text: [' consider write vs read access '].
		self flag: #todo.
		localBindings := extracting gather: #resolveLocalBindings.
		localBindings := ((KeyedSet keyBlock: #name)
			addAll: localBindings;
			yourself) asArray.
		arguments := localBindings collect: [:arg | SBStName contents: arg contents].
		
		method := SBStMethod new
			selector: (localBindings size = 0
					ifTrue: [(UIManager default request: 'Name of Method?') ifEmpty: [^ self]]
					ifFalse: [#extracted numArgs: localBindings size])
				arguments: localBindings veryDeepCopy
				class: self block containingArtefact methodClass;
			body: SBStBlockBody new.
		
		SBCombinedCommand newWith: ({
			(SBReplaceConsecutiveCommand newFor: self block containingArtefact)
				targets: extracting;
				replacer: (SBStMessageSend new receiver: (SBStName contents: 'self') selector: method selector arguments: arguments veryDeepCopy)
		}, (extracting withIndexCollect: [:stmt :index |
			(SBInsertCommand newFor: method)
				container: method body;
				index: index + 1;
				morph: stmt;
				yourself])), {
			(SBWrapCommand newFor: self block containingArtefact)
				inner: extracting last;
				outer: SBStReturn new;
				wrap: [:outer :inner | outer expression: inner].
			self block sandblockEditor openMorphInViewCommand: method
		}]
]

{ #category : #actions }
SBStGrammarHandler >> extractVariable [
	<action>

	| name var block |
	name := (UIManager default request: 'Name for variable?') ifEmpty: [^ self].
	var := SBStName contents: name.
	block := self block containingBlock.
	
	self block sandblockEditor do: (SBCombinedCommand newWith: {
			block declareTemporaryVariableCommand: name.
			(SBReplaceCommand newFor: self block containingArtefact) target: self block; replacer: var.
			(SBInsertCommand newFor: self block containingArtefact) container: block; index: 2; morph: self block.
			(SBWrapCommand newFor: self block containingArtefact) inner: self block; outer: SBStAssignment new; wrap: [:outer :inner | outer binding: var veryDeepCopy value: inner].
		})
]

{ #category : #'action helpers' }
SBStGrammarHandler >> insert: aBlock aboveOrBelow: anAboveBoolean [

	| currentStatement index |
	currentStatement := self block containingStatement.
	index := currentStatement owner submorphIndexOf: currentStatement.
	
	self block sandblockEditor do: ((SBInsertCommand newFor: self block containingArtefact)
		index: (anAboveBoolean
			ifTrue: [index] ifFalse: [index + 1]);
		container: currentStatement owner;
		morph: aBlock;
		shouldMergeWithNext: true;
		yourself).
	
	self block sandblockEditor startInput: aBlock at: 1 replacingContents: false
]

{ #category : #actions }
SBStGrammarHandler >> insertHaltAbove [
	<action>

	self insert: SBHalt new aboveOrBelow: true
]

{ #category : #actions }
SBStGrammarHandler >> insertHaltBelow [
	<action>

	self insert: SBHalt new aboveOrBelow: false
]

{ #category : #actions }
SBStGrammarHandler >> insertLabelAbove [
	<action>

	self insert: SBLabel new aboveOrBelow: true
]

{ #category : #actions }
SBStGrammarHandler >> insertLabelBelow [
	<action>

	self insert: SBLabel new aboveOrBelow: false
]

{ #category : #actions }
SBStGrammarHandler >> pasteString [
	<action>

	| doIt block baseIndex |
	doIt := Parser new parse: Clipboard clipboardText class: nil class noPattern: true notifying: nil ifFail: [^ nil].
	block := doIt block statements last expr asSandblock.
	baseIndex := self block containingStatement owner submorphIndexOf: self block containingStatement.
	
	self block sandblockEditor do: ((SBCombinedCommand newFor: self block containingArtefact)
		commands:
			{(SBReplaceCommand newFor: self block containingArtefact) target: self block; replacer: block},
			(doIt block statements allButLast withIndexCollect: [:statement :index |
				(SBInsertCommand newFor: self block containingArtefact)
					index: baseIndex + index - 1;
					container: self block containingStatement owner;
					morph: statement asSandblock])).
	block postDuplicate
]

{ #category : #callbacks }
SBStGrammarHandler >> perform: char for: aBlock empty: aBoolean [

	aBoolean ifTrue: [
		(char isDigit or: [char = $-]) ifTrue: [^ self replace: aBlock with: (SBStNumber new contents: char asString)].
		(char isAlphaNumeric or: [char = $_]) ifTrue: [^ self replace: aBlock with: (SBStName contents: char asString)].
		char = $$ ifTrue: [^ self replace: aBlock with: (SBStCharacter new contents: '')].
		char = $' ifTrue: [^ self replace: aBlock with: (SBStString new contents: '')].
		char = $# ifTrue: [^ self replace: aBlock with: (SBStSymbol new contents: '')].
		((char = Character space or: [char = Character cr]) and: [aBlock isStatement]) ifTrue: [^ self emptyLine: aBlock].
		(char = $: and: [aBlock parentSandblock isBlockBody and: [aBlock parentSandblock isMethodBody not]]) ifTrue: [ | block |
			block := aBlock parentSandblock.
			aBlock parentSandblock statements size > 1 ifTrue: [
				aBlock sandblockEditor do: ((SBDeleteCommand newFor: aBlock containingArtefact) target: aBlock; shouldMergeWithNext: true)].
			^ block addBlockArgument].
	char = $< ifTrue: [^ self replaceWithPragma: aBlock].
	char = Character backspace ifTrue: [^ self tryDelete: aBlock]].
	
	char = Character space ifTrue: [^ self wrap: aBlock do: [:outer :inner | outer receiver: inner selector: '' arguments: #()] with: SBStMessageSend new focusOuter: true].
	char isSpecial ifTrue: [^ self wrap: aBlock do: [:outer :inner | outer receiver: inner selector: char asString arguments: {outer newNullBlock}] with: SBStMessageSend new focusOuter: true].
	char = ${ ifTrue: [^ self wrap: aBlock do: [:outer :inner | outer type: #dynamic contents: {inner}] with: SBStArray new].
	char = $( ifTrue: [^ self wrap: aBlock do: [:outer :inner | outer type: #literal contents: {inner}] with: SBStArray new].
	char = $[ ifTrue: [^ self wrap: aBlock do: [:outer :inner | outer statements: {inner}] with: SBStBlockBody new].
	char = $^ ifTrue: [^ self wrap: aBlock do: [:outer :inner | outer expression: inner] with: SBStReturn new].
	
	char = Character cr ifTrue: [
		ActiveEvent shiftPressed
			ifTrue: [aBlock performAction: #insertStatementAbove]
			ifFalse: [aBlock performAction: #insertStatementBelow]]
]

{ #category : #'callback helpers' }
SBStGrammarHandler >> replaceWithPragma: aBlock [

	| pragma |
	pragma := SBStPragma new.
	aBlock stopEditing.
	aBlock sandblockEditor do: ((SBReplaceCommand newFor: aBlock containingArtefact)
		target: aBlock;
		replacer: pragma;
		shouldMergeWithNext: true).
	^ pragma sandblockEditor startInput: pragma at: 1 replacingContents: true
]

{ #category : #'actions input' }
SBStGrammarHandler >> useFifthArgument [
	<inputAction>
	
	self block containingArtefact arguments size >= 5 ifTrue: [
		self block sandblockEditor endInputWith: self block containingArtefact arguments fifth contents]
]

{ #category : #'actions input' }
SBStGrammarHandler >> useFirstArgument [
	<inputAction>
	
	self block containingArtefact arguments ifNotEmpty: [
		self block sandblockEditor endInputWith: self block containingArtefact arguments first contents]
]

{ #category : #'actions input' }
SBStGrammarHandler >> useFourthArgument [
	<inputAction>
	
	self block containingArtefact arguments size >= 4 ifTrue: [
		self block sandblockEditor endInputWith: self block containingArtefact arguments fourth contents]
]

{ #category : #'actions input' }
SBStGrammarHandler >> useSecondArgument [
	<inputAction>
	
	self block containingArtefact arguments size >= 2 ifTrue: [
		self block sandblockEditor endInputWith: self block containingArtefact arguments second contents]
]

{ #category : #'actions input' }
SBStGrammarHandler >> useThirdArgument [
	<inputAction>
	
	self block containingArtefact arguments size >= 3 ifTrue: [
		self block sandblockEditor endInputWith: self block containingArtefact arguments third contents]
]

{ #category : #'action helpers' }
SBStGrammarHandler >> watchWith: aWatchClass [

	self block isExpression ifFalse: [^ self].
	
	self block isWatch
		ifTrue: [^ self block sandblockEditor do: ((SBReplaceCommand newFor: self block containingArtefact) target: self block; replacer: self block childSandblocks first)].
	
	self block parentSandblock isWatch ifTrue: [^ self block deleteAround].
	
	self block sandblockEditor do: ((SBWrapCommand newFor: self block containingArtefact)
			outer: aWatchClass new newIdentifier;
			inner: self block;
			wrap: [:outer :inner | outer expression: inner])
]

{ #category : #actions }
SBStGrammarHandler >> wrapAsArgument [
	<action>
	<actionValidIf: #isExpression>

	| msg |
	msg := SBStMessageSend new.
	self block sandblockEditor
		do: ((SBWrapCommand newFor: self block containingArtefact)
			outer: msg;
			inner: self block;
			shouldMergeWithNext: true;
			wrap: [:outer :inner |
				outer receiver: self block newNullBlock selector: SBStMessageSend placeholderSelector arguments: {inner}];
			yourself);
		startInput: msg receiver at: 0 replacingContents: false
]

{ #category : #'action helpers' }
SBStGrammarHandler >> wrapInArrayType: aSymbol [

	self assert: self block isSelected.
	self block sandblockEditor multiSelectionIsConsecutive ifFalse: [^ self].
	self block sandblockEditor doMultiSelection: [:selected |
		(SBWrapConsecutiveCommand newFor: self block containingArtefact)
			outer: SBStArray new;
			targets: selected;
			wrap: [:outer :inner | outer type: aSymbol contents: inner];
			yourself]
]

{ #category : #actions }
SBStGrammarHandler >> wrapInAssignment [
	<action>
	<actionValidIf: #isExpression>

	| binding |
	binding := SBStName new.
	self block sandblockEditor do: ((SBWrapCommand newFor: self block containingArtefact)
		outer: SBStAssignment new;
		inner: self block;
		wrap: [:outer :inner | outer binding: binding value: inner];
		shouldMergeWithNext: true;
		yourself).
	
	self block sandblockEditor startInput: binding at: 0 replacingContents: true
]

{ #category : #actions }
SBStGrammarHandler >> wrapInBlock [
	<multiSelectAction>
	<actionValidIf: #isExpression>

	self assert: self block isSelected.
	self block sandblockEditor multiSelectionIsConsecutive ifFalse: [^ self].
	self block sandblockEditor doMultiSelection: [:selected |
		(SBWrapConsecutiveCommand newFor: self block containingArtefact)
			outer: SBStBlockBody new;
			targets: selected;
			wrap: [:outer :inner | outer statements: inner];
			yourself]
]

{ #category : #actions }
SBStGrammarHandler >> wrapInDynamicArray [
	<multiSelectAction>

	self wrapInArrayType: #dynamic
]

{ #category : #actions }
SBStGrammarHandler >> wrapInLiteralArray [
	<multiSelectAction>

	self wrapInArrayType: #literal
]

{ #category : #actions }
SBStGrammarHandler >> wrapInMessageSend [
	<action>
	<actionValidIf: #isExpression>

	^ self wrapInMessageSend: ''
]

{ #category : #'action helpers' }
SBStGrammarHandler >> wrapInMessageSend: aString [

	| msg |
	msg := SBStMessageSend new
		receiver: self block newNullBlock
		selector: aString
		arguments: (aString numArgs > 0 ifTrue: [
			(1 to: aString numArgs) collect: [:i | self block newNullBlock]] ifFalse: [#()]).
	self block sandblockEditor do: ((SBWrapCommand newFor: self block containingArtefact)
		outer: msg;
		inner: self block;
		shouldMergeWithNext: true;
		wrap: [:outer :inner | outer receiver: inner];
		yourself).
	self block sandblockEditor startInput: msg at: 900000000 replacingContents: false.
	^ msg
]

{ #category : #actions }
SBStGrammarHandler >> wrapInReturn [
	<action>
	<actionValidIf: #isExpression>

	self block sandblockEditor do: ((SBWrapCommand newFor: self block containingArtefact)
		outer: SBStReturn new;
		inner: self block;
		wrap: [:outer :inner | outer expression: inner];
		yourself)
]

{ #category : #actions }
SBStGrammarHandler >> wrapInToggledCode [
	<multiSelectAction>

	| comment |
	self assert: self block isSelected.
	comment := SBToggledCode new.
	self block sandblockEditor multiSelectionIsConsecutive ifFalse: [^ self].
	self block sandblockEditor doMultiSelection: [:selected |
		(SBWrapConsecutiveCommand newFor: self block containingArtefact)
			outer: comment;
			targets: selected;
			wrap: [:outer :inner | outer comment: '' active: 0 do: {SBStBlockBody new statements: inner}];
			yourself]
]

{ #category : #actions }
SBStGrammarHandler >> wrapWithExampleWatch [
	<action>
	<actionValidIf: #isExpression>

	self watchWith: SBExampleWatch
]

{ #category : #actions }
SBStGrammarHandler >> wrapWithWatch [
	<action>
	<inputAction>
	<actionValidIf: #isExpression>

	self watchWith: SBWatch
]
