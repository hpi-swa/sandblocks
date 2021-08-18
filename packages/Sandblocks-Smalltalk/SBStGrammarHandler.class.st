Class {
	#name : #SBStGrammarHandler,
	#superclass : #SBGrammarHandler,
	#instVars : [
		'currentBlock'
	],
	#category : #'Sandblocks-Smalltalk'
}

{ #category : #'as yet unclassified' }
SBStGrammarHandler class >> messageSendClass [

	^ SBStMessageSend
]

{ #category : #actions }
SBStGrammarHandler >> addExample [
	<action>

	| method class |
	self block isExample ifTrue: [^ self block toggleRunning].
	
	method := self block containingArtefact.
	class := method methodClass.
	
	self block sandblockEditor do: (SBInsertCommand new
		container: method body;
		index: 2;
		morph: (SBExample new
			self: (method isClassSide ifTrue: [SBStName contents: class theNonMetaClassName] ifFalse: [
				SBStMessageSend new
					receiver: (SBStName contents: class name)
					selector: (method selector = #initialize ifTrue: [#basicNew] ifFalse: [#new])])
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
		list := self systemNavigation allImplementorsOf: sel asSymbol.
		
		(self block sandblockEditor isSingleArtefactView or: [list size > 1]) ifTrue: [
			self block sandblockEditor model ifNotNil: [:model | (model isKindOf: MessageTrace) ifTrue: [^ model browseAllImplementorsOf: sel asSymbol]].
			^ self changeToBlockView: (self systemNavigation browseAllImplementorsOf: sel asSymbol)].
		
		self block sandblockEditor open: list first compiledMethod]
]

{ #category : #actions }
SBStGrammarHandler >> browseSenders [
	<action>

	self block selector ifNotNil: [:sel | | calls |
		calls := self systemNavigation allCallsOn: sel asSymbol.
		calls ifEmpty: [^ self].
		
		(self block sandblockEditor isSingleArtefactView or: [calls size > 1]) ifTrue: [
			self block sandblockEditor model ifNotNil: [:model | (model isKindOf: MessageTrace) ifTrue: [^ model browseAllCallsOn: sel asSymbol]].
			^ self changeToBlockView: (self systemNavigation browseAllCallsOn: sel asSymbol)].
		
		self block sandblockEditor open: calls first compiledMethod]
]

{ #category : #'callback helpers' }
SBStGrammarHandler >> changeToBlockView: aWindow [

	aWindow isSystemWindow ifFalse: [^ self].
	
	aWindow model contentsSymbol ~= #blockEditor
		ifTrue: [aWindow model toggleBlockEditor].
	^ aWindow
]

{ #category : #testing }
SBStGrammarHandler >> characterCanStartInput: aCharacter [

	^ aCharacter isAlphaNumeric or: [aCharacter isSpecial]
]

{ #category : #actions }
SBStGrammarHandler >> createNewEmptyModule [
	<action>

	
	self block sandblockEditor createEmptySmalltalkMethod
]

{ #category : #actions }
SBStGrammarHandler >> debugExpression [
	<action>
	<actionValidIf: #isExpression>

	| artefact context |
	artefact := SBExecutionEnvironment value ifNil: [self block containingArtefact].
	
	context := artefact ifNotNil: #evaluationContext.
	(Process
		forMethod: (Compiler new
			compileNoPattern: self block sourceString
			in: (artefact ifNotNil: #relatedClass ifNil: [nil class])
			context: (context ifNotNil: #receiver)
			notifying: artefact
			ifFail: nil) generateWithTempNames
		receiver: (context ifNil: [artefact ifNotNil: #evaluationReceiver] ifNotNil: #receiver)) debugWithTitle: 'Debug it'
]

{ #category : #actions }
SBStGrammarHandler >> doExpression [
	<action>
	
	| result |
	result := super doExpression.
	self block containingArtefact ifNotNil: [
		self block containingArtefact cacheType: result class for: self]
]

{ #category : #'callback helpers' }
SBStGrammarHandler >> emptyLine: aBlock [
	<action>
	<actionValidIf: #isStatement>

	aBlock sandblockEditor do: (SBReplaceCommand new
		target: aBlock;
		replacer: self newNullBlock)
]

{ #category : #actions }
SBStGrammarHandler >> evaluateExpression [
	<action>
	<actionValidIf: #isExpression>
	
	| result |
	result := super evaluateExpression.
	self block containingArtefact ifNotNil: [
		self block containingArtefact cacheType: result class for: self].
	^ result
]

{ #category : #actions }
SBStGrammarHandler >> extractMethod [
	<multiSelectAction>

	self block sandblockEditor multiSelectionIsConsecutive ifFalse: [^ self].
	
	self block sandblockEditor doMultiSelection: [:extracting | | arguments localBindings method |
		self flag: #todo.
		" consider write vs read access "
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
		
		SBCombinedCommand newWith: {
			SBReplaceConsecutiveCommand new
				targets: extracting;
				replacer: (SBStMessageSend new
					receiver: (SBStName contents: 'self')
					selector: method selector
					arguments: arguments veryDeepCopy)}, (extracting withIndexCollect: [:stmt :index |
			SBInsertCommand new
				container: method body;
				index: index + 1;
				morph: stmt;
				yourself]), {
			SBWrapCommand new
				inner: extracting last;
				outer: SBStReturn new;
				wrap: [:outer :inner | outer expression: inner].
			SBEditorOpenMorphCommand new
				editor: self block sandblockEditor;
				morph: method;
				isUnsaved: true;
				yourself}]
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
		SBReplaceCommand new
			target: self block;
			replacer: var.
		SBInsertCommand new
			container: block;
			index: ((block statements findFirst: [:s | s isExpression]) + 1 max: 2);
			morph: self block.
		SBWrapCommand new
			inner: self block;
			outer: SBStMessageSend new;
			wrap: [:outer :inner | outer binding: var veryDeepCopy value: inner]})
]

{ #category : #'action helpers' }
SBStGrammarHandler >> insert: aBlock aboveOrBelow: anAboveBoolean [

	| currentStatement index |
	currentStatement := self block containingStatement.
	index := currentStatement owner submorphIndexOf: currentStatement.
	
	self block sandblockEditor do: (SBInsertCommand new
		index: (anAboveBoolean ifTrue: [index] ifFalse: [index + 1]);
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

	self insert: self newCommentBlock aboveOrBelow: true
]

{ #category : #actions }
SBStGrammarHandler >> insertLabelBelow [
	<action>

	self insert: self newCommentBlock aboveOrBelow: false
]

{ #category : #'block creation' }
SBStGrammarHandler >> newCommentBlock [

	^ SBLabel new
		grammarHandler: self;
		delimiter: #('"' '"');
		yourself
]

{ #category : #actions }
SBStGrammarHandler >> pasteString [
	<action>

	| doIt block baseIndex |
	doIt := PPParser new
		parse: Clipboard clipboardText
		class: nil class
		noPattern: true
		notifying: nil
		ifFail: [^ nil].
	block := doIt block statements last asSandblock.
	baseIndex := self block containingStatement owner submorphIndexOf: self block containingStatement.
	
	self block sandblockEditor do: (SBCombinedCommand new commands: {
		SBReplaceCommand new
			target: self block;
			replacer: block}, (doIt block statements allButLast withIndexCollect: [:statement :index |
		SBInsertCommand new
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
		char = $" ifTrue: [^ self replace: aBlock with: self newCommentBlock].
		((char = Character space or: [char = Character cr]) and: [aBlock isStatement]) ifTrue: [^ self emptyLine: aBlock].
		(char = $: and: [aBlock parentSandblock isBlockBody and: [aBlock parentSandblock isMethodBody not]]) ifTrue: [ | block |
			block := aBlock parentSandblock.
			aBlock parentSandblock statements size > 1 ifTrue: [
				aBlock sandblockEditor do: (SBDeleteCommand new
					target: aBlock;
					shouldMergeWithNext: true)].
			^ block addBlockArgument].
		char = $< ifTrue: [^ self replaceWithPragma: aBlock]].
	
	char isSpecial ifTrue: [
		^ self
			wrap: aBlock
			do: [:outer :inner | outer receiver: inner selector: char asString arguments: {outer newNullBlock label: 'arg'}]
			with: self class messageSendClass new
			focusOuter: [:msg | msg messageParts first]].
	char = $( ifTrue: [^ self wrap: aBlock do: [:outer :inner | outer type: #literal contents: {inner}] with: SBStArray new]
]

{ #category : #'callback helpers' }
SBStGrammarHandler >> replaceWithPragma: aBlock [

	| pragma |
	pragma := SBStPragma new.
	aBlock stopEditing.
	aBlock sandblockEditor do: (SBReplaceCommand new
		target: aBlock;
		replacer: pragma;
		shouldMergeWithNext: true).
	^ pragma sandblockEditor
		startInput: pragma messageParts first
		at: 1
		replacingContents: true
]

{ #category : #callbacks }
SBStGrammarHandler >> startOverrideInput: anEvent in: anEditor [

	anEvent keyCharacter isSpecial ifTrue: [
		^ anEditor selection grammarHandler
			block: anEditor selection;
			wrapInMessageSend: anEvent keyCharacter asString].
	super startOverrideInput: anEvent in: anEditor
]

{ #category : #'action helpers' }
SBStGrammarHandler >> useArgument: aNumber [

	| artefact |
	artefact := self block containingArtefact.
	artefact arguments size >= aNumber ifTrue: [ | content editor |
		content := (artefact arguments at: aNumber) contents.
		editor := self block sandblockEditor.
		(SBStName contents: content) convertedFor: self block objectInterface do: [:replace |
			editor do: (SBReplaceCommand new
				replacer: replace;
				target: self block)].
		editor selection startInputAtEnd]
]

{ #category : #'actions input' }
SBStGrammarHandler >> useFifthArgument [
	<inputAction>
	<action>

	self useArgument: 5
]

{ #category : #'actions input' }
SBStGrammarHandler >> useFirstArgument [
	<inputAction>
	<action>

	self useArgument: 1
]

{ #category : #'actions input' }
SBStGrammarHandler >> useFourthArgument [
	<inputAction>
	<action>

	self useArgument: 4
]

{ #category : #'actions input' }
SBStGrammarHandler >> useSecondArgument [
	<inputAction>
	<action>

	self useArgument: 2
]

{ #category : #'actions input' }
SBStGrammarHandler >> useThirdArgument [
	<inputAction>
	<action>

	self useArgument: 3
]

{ #category : #actions }
SBStGrammarHandler >> wrapAsArgument [
	<action>
	<actionValidIf: #isExpression>

	| msg |
	msg := SBStMessageSend new.
	self block sandblockEditor
		do: (SBWrapCommand new
			outer: msg;
			inner: self block;
			shouldMergeWithNext: true;
			wrap: [:outer :inner | outer receiver: (self block newNullBlock label: 'rcvr') selector: '' arguments: {inner}];
			yourself);
		startInput: msg receiver at: 0 replacingContents: false
]

{ #category : #'action helpers' }
SBStGrammarHandler >> wrapInArrayType: aSymbol [

	self assert: self block isSelected.
	self block sandblockEditor multiSelectionIsConsecutive ifFalse: [^ self].
	self block sandblockEditor doMultiSelection: [:selected |
		SBWrapConsecutiveCommand new
			outer: SBStArray new;
			targets: selected;
			wrap: [:outer :inner | outer type: aSymbol contents: inner];
			yourself].
	self block startInput
]

{ #category : #actions }
SBStGrammarHandler >> wrapInAssignment [
	<action>
	<actionValidIf: #isExpression>

	| binding |
	binding := SBStName new.
	self block sandblockEditor do: (SBWrapCommand new
		outer: SBStMessageSend new;
		inner: self block;
		wrap: [:outer :inner | outer binding: binding value: inner];
		shouldMergeWithNext: true;
		yourself).
	
	self block sandblockEditor startInput: binding at: 0 replacingContents: true
]

{ #category : #actions }
SBStGrammarHandler >> wrapInBlock [
	<multiSelectAction>
	<actionValidIf: #canAppearInBlockBody>

	self assert: self block isSelected.
	self block sandblockEditor multiSelectionIsConsecutive ifFalse: [^ self].
	self block sandblockEditor doMultiSelection: [:selected |
		SBWrapConsecutiveCommand new
			outer: SBStBlockBody new;
			targets: selected;
			wrap: [:outer :inner | outer statements: inner];
			yourself].
	self block startInput
]

{ #category : #actions }
SBStGrammarHandler >> wrapInDynamicArray [
	<multiSelectAction>
	<actionValidIf: #isExpression>

	self wrapInArrayType: #dynamic
]

{ #category : #actions }
SBStGrammarHandler >> wrapInLiteralArray [
	<multiSelectAction>
	<actionValidIf: #isExpression>

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
	self block isExpression ifFalse: [^ self].
	msg := self class messageSendClass new
		receiver: (self block newNullBlock label: 'expr')
		selector: aString
		arguments: (aString numArgs > 0
			ifTrue: [(1 to: aString numArgs) collect: [:i | self block newNullBlock label: 'arg']]
			ifFalse: [#()]).
	self block sandblockEditor do: (SBWrapCommand new
		outer: msg;
		inner: self block;
		shouldMergeWithNext: true;
		wrap: [:outer :inner | outer receiver: inner];
		yourself).
	self block sandblockEditor
		startInput: msg messageParts first
		at: 900000000
		replacingContents: false.
	^ msg
]

{ #category : #actions }
SBStGrammarHandler >> wrapInReturn [
	<action>
	<actionValidIf: #isExpression>

	self block parentSandblock isReturn ifTrue: [^ self].
	
	self block sandblockEditor do: (SBWrapCommand new
		outer: SBStReturn new;
		inner: self block;
		wrap: [:outer :inner | outer expression: inner];
		yourself).
	self block startInputAtEnd
]

{ #category : #actions }
SBStGrammarHandler >> wrapInToggledCode [
	<multiSelectAction>
	<actionValidIf: #isExpression>

	| comment |
	self assert: self block isSelected.
	comment := SBToggledCode new.
	self block sandblockEditor multiSelectionIsConsecutive ifFalse: [^ self].
	self block sandblockEditor doMultiSelection: [:selected |
		SBWrapConsecutiveCommand new
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

{ #category : #printing }
SBStGrammarHandler >> writeSourceOn: aStream for: aBlock [

	aBlock writeStSourceOn: aStream
]
