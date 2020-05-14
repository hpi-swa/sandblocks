Class {
	#name : #SBEditor,
	#superclass : #SBBlock,
	#instVars : [
		'selection',
		'undoStack',
		'redoStack',
		'currentInput',
		'currentInputCommand',
		'copyBuffer',
		'copyBufferPreview',
		'modeLabel',
		'selectionLabel',
		'selectionDownHistory',
		'multiSelection',
		'mode',
		'inputShortcuts',
		'globalShortcuts',
		'commandShortcuts',
		'singleSelectionShortcuts',
		'multiSelectionShortcuts',
		'scroll',
		'methodContainer',
		'colorPolicy',
		'bottomPanel',
		'compileTimeButton',
		'compileTime',
		'workspace',
		'errors',
		'searchInput',
		'helpOverlay'
	],
	#category : #'Sandblocks-Core'
}

{ #category : #'initialize-release' }
SBEditor class >> newFor: aMethodOrClass [

	| editor |
	editor := self new.
	editor open: aMethodOrClass.
	editor clearUndoStack.
	
	^ editor
]

{ #category : #'initialize-release' }
SBEditor class >> open [

	| editor |
	editor := self new.
	editor openInWindow.
	^ editor
]

{ #category : #'initialize-release' }
SBEditor class >> openFor: aMethodOrClass [

	^ (self newFor: aMethodOrClass) openInWindow; yourself
]

{ #category : #'initialize-release' }
SBEditor class >> openWorkspace: aString [

	SBWorkspaceHistory default items detect: [:workspace | workspace name = aString] ifFound: [:workspace | workspace open] ifNone: [self error: 'no such workspace']
]

{ #category : #actions }
SBEditor >> acceptChild: aBlock [

	^ aBlock isArtefact
]

{ #category : #shortcuts }
SBEditor >> acceptedRepresentation [

	^ #isToplevelMorph
]

{ #category : #shortcuts }
SBEditor >> addCommandShortcut: aShortcut do: anActionBlock [

	commandShortcuts add: {aShortcut asSandblockShortcut. anActionBlock}
]

{ #category : #shortcuts }
SBEditor >> addDefaultShortcuts [

	SBLabel text: ['Tree Modification'].
	self
		addSingleSelectionShortcut: $K do: #swapLeft;
		addSingleSelectionShortcut: $J do: #swapRight;
		addSingleSelectionShortcut: $( do: #leftRotate;
		addSingleSelectionShortcut: $r do: #replaceWithCopyBuffer;
		addSingleSelectionShortcut: $, do: #promptCodeAction;
		addSingleSelectionShortcut: $X do: #deleteAroundSelection;
		addMultiSelectionShortcut: $x do: #deleteSelection;
		addMultiSelectionShortcut: $# do: #wrapInLiteralArray.
	SBLabel text: ['Insert mode'].
	self
		addSingleSelectionShortcut: $i do: #startInputAtStart;
		addSingleSelectionShortcut: $a do: #startInputAtEnd;
		addSingleSelectionShortcut: $s do: #startInputSubstituting;
		addSingleSelectionShortcut: $c do: #changeSelection;
		addSingleSelectionShortcut: $c command do: #copyString;
		addSingleSelectionShortcut: $v command do: #pasteString;
		addSingleSelectionShortcut: Character tab shift do: [:editor | editor inputPreviousUnknown];
		addSingleSelectionShortcut: Character tab do: [:editor | editor inputNextUnknown].
	SBLabel text: ['Create nodes'].
	self
		addSingleSelectionShortcut: $d do: #insertLabelBelow;
		addSingleSelectionShortcut: $D do: #insertLabelAbove;
		addSingleSelectionShortcut: $O do: #insertStatementAbove;
		addSingleSelectionShortcut: $p do: #pasteStatementBelow;
		addSingleSelectionShortcut: $P do: #pasteStatementAbove;
		addSingleSelectionShortcut: $: do: #wrapInAssignment;
		addSingleSelectionShortcut: $^ do: #wrapInReturn;
		addSingleSelectionShortcut: Character space shift do: #wrapAsArgument;
		addSingleSelectionShortcut: Character space do: #wrapInMessageSend;
		addSingleSelectionShortcut: $o do: #insertStatementBelow;
		addSingleSelectionShortcut: $. do: #addElement;
		addSingleSelectionShortcut: $+ do: #insertElementAfter;
		addSingleSelectionShortcut: $* do: #insertElementBefore;
		addMultiSelectionShortcut: $[ do: #wrapInBlock;
		addMultiSelectionShortcut: ${ do: #wrapInDynamicArray;
		addMultiSelectionShortcut: $; do: #wrapInCascade.
	SBLabel text: ['Navigation'].
	self
		addSingleSelectionShortcut: $$ do: #selectRightMostBlock;
		addSingleSelectionShortcut: $z do: #toggleCollapsed;
		addSingleSelectionShortcut: $m do: #placeMark;
		addSingleSelectionShortcut: $' do: #goToMark;
		addMultiSelectionShortcut: $l do: #selectNext;
		addMultiSelectionShortcut: $h do: #selectPrevious;
		addMultiSelectionShortcut: $k do: #selectUp;
		addMultiSelectionShortcut: $j do: #selectDown;
		addMultiSelectionShortcut: $h command do: [:editor | editor selectToplevelTowards: #left];
		addMultiSelectionShortcut: $j command do: [:editor | editor selectToplevelTowards: #bottom];
		addMultiSelectionShortcut: $k command do: [:editor | editor selectToplevelTowards: #top];
		addMultiSelectionShortcut: $l command do: [:editor | editor selectToplevelTowards: #right];
		addMultiSelectionShortcut: $H do: #selectPreviousStatement;
		addMultiSelectionShortcut: $L do: #selectNextStatement;
		addCommandShortcut: $1 do: #resetZoom;
		addCommandShortcut: $g do: #selectArtefact;
		addCommandShortcut: $G do: #selectLast;
		addCommandShortcut: $! do: #refocus.
	SBLabel text: ['Refactoring'].
	self
		addSingleSelectionShortcut: $= do: #extractVariable;
		addMultiSelectionShortcut: $t do: #extractMethod.
	SBLabel text: ['Tools'].
	self
		addSingleSelectionShortcut: $W do: #watchSelection;
		addSingleSelectionShortcut: $w do: #watchSelectionForExample;
		addSingleSelectionShortcut: $m command do: #implementorsOfIt;
		addSingleSelectionShortcut: $b command do: #browseSelection;
		addSingleSelectionShortcut: $p command do: #evaluateSelection;
		addSingleSelectionShortcut: $P command do: #debugSelection;
		addSingleSelectionShortcut: $n command do: #sendersOfIt;
		addSingleSelectionShortcut: $? do: #showUsageInfo;
		addCommandShortcut: $r command do: #openRepl;
		addCommandShortcut: $x command do: #openOpenWindow;
		addMultiSelectionShortcut: $" do: #wrapInToggledCode;
		addCommandShortcut: $a command do: #addExample;
		addCommandShortcut: $, command do: #promptMenu;
		addCommandShortcut: $/ do: #startSearch;
		addCommandShortcut: $n do: #nextSearchResult;
		addCommandShortcut: $S command do: #saveWorkspace;
		addCommandShortcut: $O command do: #promptOpenWorkspace;
		addCommandShortcut: $f command do: #toggleFullscreen;
		addCommandShortcut: $T do: #createEmptyMethod.
	SBLabel text: ['Tools: Debugger'].
	self
		addCommandShortcut: $> do: #stepOver;
		addCommandShortcut: $< do: #stepInto;
		addCommandShortcut: $R command do: #restartFrame;
		addCommandShortcut: $e do: #focusErrors;
		addCommandShortcut: $E do: #focusPreviousErrorFrame.
	SBLabel text: ['Persistence/History'].
	self
		addCommandShortcut: $s command do: #save;
		addCommandShortcut: $u do: #undo;
		addCommandShortcut: $U do: #redo.
	self
		addMultiSelectionShortcut: Character escape do: #endMultiSelection;
		addMultiSelectionShortcut: $y do: #copySelection;
		addSingleSelectionShortcut: $Y do: #copyAroundSelection;
		addMultiSelectionShortcut: $v do: #startOrAddToMultiSelection;
		addCommandShortcut: Character escape command do: #close;
		addInputShortcut: Character escape do: #endInput;
		addInputShortcut: Character arrowLeft do: [:editor | editor textMorph moveCursor: -1];
		addInputShortcut: Character arrowRight do: [:editor | editor textMorph moveCursor: 1];
		addInputShortcut: Character backspace do: [:editor | editor textMorph deleteBeforeCursor];
		addInputShortcut: Character delete do: [:editor | editor textMorph deleteAfterCursor];
		addInputShortcut: $h command do: [:editor | editor textMorph moveCursor: -1];
		addInputShortcut: $l command do: [:editor | editor textMorph moveCursor: 1];
		addInputShortcut: $a command do: [:editor | editor textMorph moveCursorTo: 1];
		addInputShortcut: $e command do: [:editor | editor textMorph moveCursorTo: 900000000];
		addInputShortcut: $x command do: [:editor | editor textMorph clear];
		addInputShortcut: Character tab shift do: [:editor | editor inputPreviousUnknown];
		addInputShortcut: Character tab do: [:editor | editor inputNextUnknown];
		addInputShortcut: $j command, Character arrowDown
			do: [:editor | editor currentInput suggestionMenuDo: #next];
		addInputShortcut: $k command, Character arrowUp
			do: [:editor | editor currentInput suggestionMenuDo: #previous];
		addInputShortcut: Character cr asSandblockShortcut do: [:editor | editor currentInput useSuggestion];
		addInputShortcut: $1 command do: [:editor | editor endInputWith: self method arguments first contents];
		addInputShortcut: $2 command do: [:editor | editor endInputWith: self method arguments second contents];
		addInputShortcut: $3 command do: [:editor | editor endInputWith: self method arguments third contents];
		addInputShortcut: $4 command do: [:editor | editor endInputWith: self method arguments fourth contents];
		addInputShortcut: $5 command do: [:editor | editor endInputWith: self method arguments fifth contents]
]

{ #category : #actions }
SBEditor >> addElement [

	| cmd |
	cmd := (self selection insertCommandRequest: true near: (self selection childSandblocks ifNotEmpty: #last ifEmpty: [nil])) ifNil: [^ self].
	
	self do: cmd.
	
	cmd shouldMergeWithNext ifTrue: [
		self startInput: self selection at: 0 replacingContents: false]
]

{ #category : #actions }
SBEditor >> addExample [

	self selection ifNotNil: [:selected | selected isExample ifTrue: [^ selected toggleRunning]].
	
	self do: ((SBInsertCommand newFor: self method)
		container: self method body;
		index: 2;
		morph: (SBExample new
			self: (self method isClassSide
				ifTrue: [SBName contents: self method methodClass theNonMetaClassName]
				ifFalse: [
					(SBMessageSend new
						receiver: (SBName contents: self method methodClass name)
						selector: (self method selector = #initialize ifTrue: [#basicNew] ifFalse: [#new]))])
			args: (SBArray new
				type: #dynamic
				contents: (Array streamContents: [:str | self method arguments size timesRepeat: [str nextPut: SBUnknown new]]))
			label: 'simple'))
]

{ #category : #shortcuts }
SBEditor >> addGlobalShortcut: aShortcut do: anActionBlock [

	globalShortcuts add: {aShortcut asSandblockShortcut. anActionBlock}
]

{ #category : #shortcuts }
SBEditor >> addInputShortcut: aShortcut do: anActionBlock [

	inputShortcuts add: {aShortcut asSandblockShortcut. anActionBlock}
]

{ #category : #shortcuts }
SBEditor >> addMultiSelectionShortcut: aShortcut do: anActionBlock [

	multiSelectionShortcuts add: {aShortcut asSandblockShortcut. anActionBlock}
]

{ #category : #shortcuts }
SBEditor >> addSingleSelectionShortcut: aShortcut do: anActionBlock [

	singleSelectionShortcuts add: {aShortcut asSandblockShortcut. anActionBlock}
]

{ #category : #actions }
SBEditor >> addToMultiSelection [

	multiSelection copy do: [:morph | (morph hasOwner: self selection) ifTrue: [multiSelection remove: morph]].
	
	multiSelection add: self selection.
	self selection attachDecorator: SBMultiSelectionDecorator new.
	self updateSelectionLabel
]

{ #category : #accessing }
SBEditor >> allActiveMorphExamples [

	^ Array streamContents: [:stream |
		self allBlocksDo: [:b | (b isMorphExample and: [b visible]) ifTrue: [stream nextPut: b]]]
]

{ #category : #actions }
SBEditor >> anyNearbyClass [

	| artefact |
	scroll hasSubmorphs ifFalse: [^ nil].
	
	artefact := (self selection ifNil: [self methods first]) containingArtefact.
	artefact isMethod ifTrue: [^ artefact methodClass].
	artefact isClassContainer ifTrue: [^ artefact shownClass].
	^ nil
]

{ #category : #selection }
SBEditor >> batchedChangeStep: aBlock [

	" send this message when you are updating the tree rapidly for each update, but don't want to submit a command for each update, only at the end "
	compileTime = #compileOnChange ifTrue: [ | artefact |
		self save: aBlock containingArtefact tryFixing: false quick: true.
		artefact := self selectedArtefact.
		self allBlocksDo: [:block | block artefactChanged: artefact]]
]

{ #category : #accessing }
SBEditor >> bindingFor: aString class: aClass ifPresent: aBlock [

	Symbol hasInterned: aString ifTrue: [:sym | | binding |
		binding := aClass bindingOf: sym environment: aClass environment.
		binding ifNotNil: [^ aBlock value: ((SBName poolDeclaration: aString) binding: binding)]].
	
	^ nil
]

{ #category : #accessing }
SBEditor >> blockForClass: aClass ifPresent: aBlock ifAbsent: anotherBlock [

	^ scroll submorphs detect: [:morph | morph isSandblock and: [morph isClassContainer and: [morph shownClass = aClass]]] ifFound: aBlock ifNone: anotherBlock
]

{ #category : #actions }
SBEditor >> browseSelection [

	self selection browse
]

{ #category : #'as yet unclassified' }
SBEditor >> buildCommandBar [

	^ SBRow new
		changeTableLayout;
		hResizing: #spaceFill;
		cellGap: 4 withScalingFactor;
		layoutInset: 4 withScalingFactor;
		addMorphBack: (SBButton new icon: SBIcon iconUndo shortcut: $u asSandblockShortcut do: [self undo]);
		addMorphBack: (SBButton new icon: SBIcon iconRepeat shortcut: $U asSandblockShortcut do: [self redo]);
		addMorphBack: (SBButton new icon: SBIcon iconFolder_open shortcut: $x command do: [self openOpenWindow]);
		addMorphBack: (SBButton new
			icon: SBIcon iconPlus shortcut: nil do: [self promptAddArtifact];
			balloonText: 'Add artifact');
		addMorphBack: (Morph new
			height: 0;
			color: Color transparent;
			hResizing: #spaceFill);
		addMorphBack: (SBButton new
			icon: SBIcon iconWindow_maximize shortcut: nil do: [self promptWorkspaceActions];
			balloonText: 'Manage Workspaces');
		addMorphBack: (SBButton new icon: SBIcon iconExpand shortcut: $f command do: [self toggleFullscreen])
]

{ #category : #'as yet unclassified' }
SBEditor >> buildDebugCommandBar [

	^ SBRow new
		changeTableLayout;
		hResizing: #spaceFill;
		cellGap: 4 withScalingFactor;
		layoutInset: 4 withScalingFactor;
		addMorphBack: (SBButton new
			icon: SBIcon iconLong_arrow_right shortcut: $> asSandblockShortcut do: [self stepOver];
			balloonText: 'Step over');
		addMorphBack: (SBButton new
			icon: SBIcon iconLevel_down shortcut: $< asSandblockShortcut do: [self stepInto];
			balloonText: 'Step into');
		addMorphBack: (SBButton new
			icon: SBIcon iconForward shortcut: nil do: [self stepThrough];
			balloonText: 'Step through');
		addMorphBack: (SBButton new
			icon: SBIcon iconFast_backward shortcut: $R command do: [self restartFrame];
			balloonText: 'Restart frame')
]

{ #category : #actions }
SBEditor >> canDeleteChild: aBlock [

	" code containers might be inside of us, they can be freely deleted "
	^ true
]

{ #category : #actions }
SBEditor >> changeSelection [

	| new |
	new := SBUnknown new.
	(new hasRepresentationThat: (self selection parentSandblock contextAcceptedRepresentationAt: self selection childIndex)) ifTrue: [
		self setCopyBuffer: self selection.
		
		self do: ((SBReplaceCommand newFor: self method)
			target: self selection;
			replacer: new;
			shouldMergeWithNext: true;
			yourself).
	
		self startInput: new at: 0 replacingContents: false]
]

{ #category : #actions }
SBEditor >> childSandblocksDo: aBlock [

	scroll submorphsDo: [:b | b isSandblock ifTrue: [aBlock value: b]]
]

{ #category : #accessing }
SBEditor >> classes [

	^ scroll submorphs select: [:morph | morph isSandblock and: [morph isClassContainer]]
]

{ #category : #'initialize-release' }
SBEditor >> clearUndoStack [

	undoStack := OrderedCollection new.
	redoStack  := OrderedCollection new
]

{ #category : #selection }
SBEditor >> click: anEvent [

	self selectClick: nil
]

{ #category : #actions }
SBEditor >> close [

	self containingWindow ifNotNil: #delete.
	self delete.
	self valueOfProperty: #previousWindow ifPresentDo: #delete
]

{ #category : #drawing }
SBEditor >> color [

	^ Color white
]

{ #category : #'initialize-release' }
SBEditor >> colorPolicy [

	^ colorPolicy
]

{ #category : #'initialize-release' }
SBEditor >> colorPolicy: aPolicy [

	colorPolicy := aPolicy.
	self allMorphsDo: #layoutChanged
]

{ #category : #actions }
SBEditor >> compiledMethod: aMethod [

	self openMorphInView: aMethod asSandblock
]

{ #category : #selection }
SBEditor >> containingArtefact [

	^ nil
]

{ #category : #actions }
SBEditor >> copyAroundSelection [

	| replacer around |
	" create a copy of our surroundings with ourselves replaced "
	replacer := SBPastePlaceholder new.
	around := self selection.
	around replaceBy: replacer.
	self setCopyBuffer: replacer parentSandblock.
	replacer replaceBy: around
]

{ #category : #'as yet unclassified' }
SBEditor >> copyBufferPreviewSize [

	^ 120 @ (self fontToUse height * 1.5) rounded
]

{ #category : #actions }
SBEditor >> copySelection [

	self setCopyBuffer: self multiSelection
]

{ #category : #actions }
SBEditor >> copyString [

	Clipboard clipboardText: self selection prettySourceString
]

{ #category : #actions }
SBEditor >> createEmptyClass [

	| class |
	class := SBClass new category: (self anyNearbyClass ifNotNil: #category ifNil: ['UserObjects']).
	self openMorphInView: class.
	self startInput: class childSandblocks first at: 1 replacingContents: false
]

{ #category : #actions }
SBEditor >> createEmptyMethod [

	| method |
	self openMorphInView: (method := SBMethod new
		selector: ''
			arguments: #()
			class: ((self selectedArtefact ifNotNil: [:container | container relatedClass]) ifNil: [UIManager default chooseClassOrTrait]);
		body: (SBBlockBody new statements: {SBUnknown new})).
	self startInput: method at: 1 replacingContents: true
]

{ #category : #accessing }
SBEditor >> currentInput [

	^ currentInput
]

{ #category : #accessing }
SBEditor >> currentMethodMap [

	^ (self methods select: #exists) collect: [:method | method compiledMethod sandblocksFastHash -> method] as: Dictionary
]

{ #category : #actions }
SBEditor >> debugSelection [

	| source artefact cue context process |
	source := self selection.
	artefact := source containingArtefact.
	context := errors focusedArtefact = artefact ifTrue: [errors focusedContext] ifFalse: [nil].
	cue := source compilationCueWith: artefact for: context.
	
	process := Process
		forMethod: (Compiler new compileCue: cue noPattern: true ifFail: nil) generateWithTempNames
		receiver: (context ifNotNil: #receiver).
	
	self reportError: nil process: process
]

{ #category : #actions }
SBEditor >> declareBlockLocalVariable: aString [ 

	self method declareBlockLocalVariable: aString
]

{ #category : #actions }
SBEditor >> declareClassVariable: aString for: aClass [

	| class |
	class := self openClass: aClass.
	self do: ((SBInsertCommand newFor: class)
		container: class classVariables;
		index: class classVariables submorphCount + 1;
		morph: (SBName contents: aString))
]

{ #category : #actions }
SBEditor >> declareInstanceVariable: aString for: aClass [

	| class |
	class := self openClass: aClass.
	self do: ((SBInsertCommand newFor: class)
		container: class instanceVariables;
		index: class instanceVariables submorphCount + 1;
		morph: (SBName contents: aString))
]

{ #category : #actions }
SBEditor >> declareTemporaryVariable: aString [ 

	self method declareTemporaryVariable: aString
]

{ #category : #actions }
SBEditor >> deleteAroundSelection [

	| replacer around |
	(self selection hasRepresentationThat: (self selection parentSandblock parentSandblock contextAcceptedRepresentationAt: self selection parentSandblock childIndex)) ifTrue: [
		" create a copy of our surroundings with ourselves replaced "
		replacer := SBPastePlaceholder new.
		around := self selection.
		around replaceBy: replacer.
		self setCopyBuffer: replacer parentSandblock.
		replacer replaceBy: around.
		
		replacer := self selection veryDeepCopy.
		self do: ((SBReplaceCommand newFor: self method)
			target: self selection parentSandblock;
			replacer: replacer).
		replacer postDuplicate]
]

{ #category : #'submorphs-add\/remove' }
SBEditor >> deleteCommandFor: aBlock [

	^ SBDeleteCommand newNonEdit target: aBlock
]

{ #category : #actions }
SBEditor >> deleteSelection [

	self setCopyBuffer: self multiSelection.
	
	self doMultiSelectionEach: [:selected |
		selected parentSandblock deleteCommandFor: selected]
]

{ #category : #actions }
SBEditor >> do: aCommand [

	" the command may interrupt/replace an input "
	currentInputCommand notNil ifTrue: [self endInput].
	
	(undoStack notEmpty and: [undoStack last shouldMergeWithNext])
		ifTrue: [undoStack addLast: (SBCombinedCommand newWith: {undoStack removeLast. aCommand})]
		ifFalse: [undoStack addLast: aCommand].
	
	redoStack removeAll.
	
	aCommand previousSelection: self selection.
	self select: aCommand do.
	aCommand postDo.
	
	self markChangesAfterCommand: aCommand
]

{ #category : #actions }
SBEditor >> doMultiSelection: aBlock [

	| command |
	command := aBlock value: self sortedMultiSelection.
	command commands ifNotEmpty: [
		self do: command.
		mode = #selection ifTrue: [self endMultiSelection]]
]

{ #category : #actions }
SBEditor >> doMultiSelectionEach: aBlock [

	self doMultiSelection: [:sel | SBCombinedCommand newWith: (sel collect: aBlock thenSelect: #notNil)]
]

{ #category : #input }
SBEditor >> endInput [

	| command input |
	(currentInput isNil or: [currentInputCommand isNil]) ifTrue: [^ self].
	command := currentInputCommand.
	input := currentInput.
	currentInput := nil.
	currentInputCommand := nil.
	
	input stopEditing: command.
	self mode: #command.
	
	command hasChange
		ifTrue: [self do: command]
		ifFalse: [undoStack ifNotEmpty: [undoStack last shouldMergeWithNext: false]]
]

{ #category : #actions }
SBEditor >> endInputWith: aString [

	self currentInput contents: aString.
	self endInput
]

{ #category : #actions }
SBEditor >> endMultiSelection [

	multiSelection do: [:b | b detachDecorators: SBMultiSelectionDecorator].
	multiSelection := OrderedCollection new.
	self mode: #command
]

{ #category : #actions }
SBEditor >> evaluateSelection [

	| result explorer source artefact |
	source := self selection.
	artefact := source containingArtefact.
	result := source evaluateWith: artefact for: (errors focusedArtefact = artefact ifTrue: [errors focusedContext] ifFalse: [nil]).
	
	source containingArtefact ifNotNil: [source containingArtefact cacheType: result class for: source].
	
	self openMorphInView: (explorer := result asSandblock
		focusAfterDelete: source;
		yourself).
	
	scroll addMorph: ((SBConnectorLine new connectorType: #dots)
		color: Color black;
		connect: source to: explorer;
		yourself)
]

{ #category : #actions }
SBEditor >> extractMethod [

	self multiSelectionIsConsecutive ifFalse: [^ self].
	
	self doMultiSelection: [:extracting | | arguments localBindings method |
		self flag: #todo. " consider write vs read access "
		localBindings := extracting gather: #resolveLocalBindings.
		localBindings := ((KeyedSet keyBlock: #name) addAll: localBindings; yourself) asArray.
		arguments := localBindings collect: [:arg | SBName contents: arg contents].
		
		method := SBMethod new
				selector: (#extracted numArgs: localBindings size)
				arguments: localBindings veryDeepCopy
				class: self method methodClass;
				body: SBBlockBody new.
		
		SBCombinedCommand newWith:
			{(SBReplaceConsecutiveCommand newFor: self method)
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
			{self openMorphInViewCommand: method}
		]
]

{ #category : #actions }
SBEditor >> extractVariable [

	| name var block |
	name := (UIManager default request: 'Name for variable?') ifEmpty: [^ self].
	var := SBName contents: name.
	block := self selection containingBlock.
	
	self do: (SBCombinedCommand newWith: {
			block declareTemporaryVariableCommand: name.
			(SBReplaceCommand newFor: self method) target: self selection; replacer: var.
			(SBInsertCommand newFor: self method) container: block; index: 2; morph: self selection.
			(SBWrapCommand newFor: self method) inner: self selection; outer: SBAssignment new; wrap: [:outer :inner | outer binding: var veryDeepCopy value: inner].
		})
]

{ #category : #events }
SBEditor >> filterEvent: anEvent for: aMorph [

	anEvent keyValue = 251
		ifTrue: [self toggleHelperTimer: anEvent type = #keyDown]
		ifFalse: [self removeHelperTimer].
	(anEvent type == #keystroke or: [false]) ifFalse: [^ anEvent].
	self processShortcutList: globalShortcuts for: anEvent ifMatched: [^ anEvent ignore].
	mode = #input ifTrue: [
		self processShortcutList: inputShortcuts for: anEvent ifMatched: [^ anEvent ignore].
		currentInput keyStroke: anEvent.
		^ anEvent ignore].
	mode = #command ifTrue: [
		self processShortcutList: commandShortcuts for: anEvent ifMatched: [^ anEvent ignore]].
	self selection ifNotNil: [
		self processShortcutList: multiSelectionShortcuts for: anEvent ifMatched: [^ anEvent ignore].
		mode ~= #selection ifTrue: [
			self processShortcutList: singleSelectionShortcuts for: anEvent ifMatched: [^ anEvent ignore]]].
	^ anEvent
]

{ #category : #actions }
SBEditor >> focusErrors [

	errors focus.
	errors topLeft: scroll topLeft
]

{ #category : #actions }
SBEditor >> focusPreviousErrorFrame [

	errors focusPreviousFrame
]

{ #category : #actions }
SBEditor >> goToMark [

	self waitForLetterDo: [:letter |
		self allBlocksDo: [:morph | (morph withDecorator: SBMarkedDecorator do: [:mark | mark letter = letter ifTrue: [^ self select: morph]])]]
]

{ #category : #'submorphs-add\/remove' }
SBEditor >> handleDroppedBlock: aMorph event: anEvent [

	aMorph object
		representationThat: #isToplevelMorph
		do: [:repr |
			self openMorphInView: repr.
			repr center: ((scroll transformFrom: nil) globalPointToLocal: anEvent position)]
		ifNone: []
]

{ #category : #actions }
SBEditor >> implementorsOfIt [

	self selection browseImplementors
]

{ #category : #'initialize-release' }
SBEditor >> initialize [

	super initialize.
	
	singleSelectionShortcuts := OrderedCollection new.
	multiSelectionShortcuts := OrderedCollection new.
	commandShortcuts := OrderedCollection new.
	globalShortcuts := OrderedCollection new.
	inputShortcuts := OrderedCollection new.
	multiSelection := OrderedCollection new.
	colorPolicy := SBAlternatingColorPolicy new.
	compileTime := #compileOnSave.
	
	self
		addKeyboardCaptureFilter: self;
		addDefaultShortcuts;
		
		extent: 500 asPoint;
		changeTableLayout;
		vResizing: #shrinkWrap;
		hResizing: #shrinkWrap;
		listDirection: #topToBottom;
		
		addMorphBack: (errors := SBErrorPanel new
			disableLayout: true;
			topLeft: self topLeft;
			yourself);
			
		addMorphBack: self buildCommandBar;
		"addMorphBack: self buildDebugCommandBar;"
		
		addMorphBack: (scroll := SBEditorCanvas new
			hResizing: #spaceFill;
			vResizing: #spaceFill;
			yourself);
		
		addMorphBack: (bottomPanel := Morph new
			changeTableLayout;
			cellPositioning: #center;
			vResizing: #shrinkWrap;
			cellGap: 8 withScalingFactor;
			hResizing: #spaceFill;
			wrapCentering: #center;
			layoutInset: 4 withScalingFactor;
			listDirection: #leftToRight;
			color: Color transparent;
			addMorphBack: (modeLabel := StringMorph new emphasis: TextEmphasis bold emphasisCode);
			addMorphBack: (selectionLabel := StringMorph new contents: '');
			addMorphBack: (searchInput := SBSearchPanel new);
			addMorphBack: (Morph new extent: 0 @ 0; hResizing: #spaceFill; color: Color transparent);
			addMorphBack: (compileTimeButton := StringMorph new
				contents: 'Compile on save';
				on: #click send: #promptChangeCompile to: self);
			addMorphBack: (SBButton new balloonText: 'Copy'; icon: SBIcon iconCopy shortcut: $y asSandblockShortcut do: [self copy]);
			addMorphBack: (SBButton new balloonText: 'Copy around'; icon: SBIcon iconClipboard shortcut: $Y asSandblockShortcut do: [self copyAroundSelection]);
			addMorphBack: (copyBufferPreview := ImageMorph new image: (Form extent: 1 @ 1));
			yourself);
		
		resetState
]

{ #category : #actions }
SBEditor >> inputNextUnknown [

	(self selection activeMorph nextMorphThat: [:m | m isSandblock and: [m isUnknown]]) ifNotNil: [:m | self startInput: m at: 1 replacingContents: true]
]

{ #category : #actions }
SBEditor >> inputPreviousUnknown [

	(self selection previousMorphThat: [:m | m isSandblock and: [m isUnknown]]) ifNotNil: [:m | self startInput: m at: 1 replacingContents: true]
]

{ #category : #actions }
SBEditor >> insertElement: aBoolean [

	| cmd |
	cmd := (self selection parentSandblock insertCommandRequest: aBoolean near: self selection) ifNil: [^ self].
	
	self do: cmd.
	
	cmd shouldMergeWithNext ifTrue: [
		self startInput: self selection at: 0 replacingContents: false]
]

{ #category : #actions }
SBEditor >> insertElementAfter [

	self insertElement: true
]

{ #category : #actions }
SBEditor >> insertElementBefore [

	self insertElement: false
]

{ #category : #actions }
SBEditor >> insertLabelAbove [

	self insertLabelAboveOrBelow: true
]

{ #category : #actions }
SBEditor >> insertLabelAboveOrBelow: anAboveBoolean [

	| currentStatement index newStatement |
	newStatement :=  SBLabel new.
	
	currentStatement := self selection containingStatement.
	index := currentStatement owner submorphIndexOf: currentStatement.
	
	self do: ((SBInsertCommand newFor: self method)
		index: (anAboveBoolean
			ifTrue: [index] ifFalse: [index + 1]);
		container: currentStatement owner;
		morph: newStatement;
		shouldMergeWithNext: true;
		yourself).
	
	self startInput: newStatement at: 1 replacingContents: false
]

{ #category : #actions }
SBEditor >> insertLabelBelow [

	self insertLabelAboveOrBelow: false
]

{ #category : #actions }
SBEditor >> insertStatementAbove [

	self insertStatementAboveOrBelow: true
]

{ #category : #actions }
SBEditor >> insertStatementAboveOrBelow: anAboveBoolean [

	| currentStatement index newStatement |
	newStatement :=  SBUnknown new.
	self selection isCodeContainer ifTrue: [self select: self selection method].
	
	self selection = self method
		ifTrue: [
			self do: ((SBInsertCommand newFor: self method)
				index: (anAboveBoolean ifTrue: [2] ifFalse: [self method body submorphCount + 1]);
				container: self method body;
				morph: newStatement;
				shouldMergeWithNext: true;
				yourself)]
		ifFalse: [
			currentStatement := self selection containingStatement.
			index := currentStatement owner submorphIndexOf: currentStatement.
	
			self do: ((SBInsertCommand newFor: self selection containingArtefact)
				index: (anAboveBoolean
					ifTrue: [index] ifFalse: [index + 1]);
				container: currentStatement owner;
				morph: newStatement;
				shouldMergeWithNext: true;
				yourself)].
	
	self startInput: newStatement at: 1 replacingContents: false
]

{ #category : #actions }
SBEditor >> insertStatementBelow [

	self insertStatementAboveOrBelow: false
]

{ #category : #selection }
SBEditor >> internalSelect: aBlock [

	aBlock ~= selection ifTrue: [ | previousSelection |
		previousSelection := selection.
		selection := aBlock.
		selection ifNotNil: [
			selection
				 attachDecorator: SBSelectionDecorator new;
				 wasSelected;
				 ensureVisible].
		
		previousSelection ifNotNil: [
			previousSelection
				 detachDecorators: SBSelectionDecorator;
				 wasDeselected].
		
		self triggerEvent: #selectionChanged with: selection.
		self updateSelectionLabel]
]

{ #category : #input }
SBEditor >> labelString [

	^ 'Sandblocks Editor', (workspace ifNotNil: [:w | ' - ', w name] ifNil: [''])
]

{ #category : #selection }
SBEditor >> leftRotate [

	(self selection isFirstChild or: [self selection isLastChild]) ifFalse: [^ self].
	self do: ((SBSubtreeRotateCommand newFor: self method)
		 target: self selection;
		 yourself)
]

{ #category : #'initialize-release' }
SBEditor >> markChangesAfterCommand: aCommand [

	aCommand wasEdit ifTrue: [
		aCommand affectedArtefacts do: [:artefact | | saved |
			saved := false.
			compileTime = #compileOnChange ifTrue: [saved := self save: artefact tryFixing: false quick: false].
			
			artefact hasUnsavedChanges: saved not.
			self allBlocksDo: [:block | block artefactChanged: artefact]]]
]

{ #category : #'as yet unclassified' }
SBEditor >> method [

	^ (self selection ifNotNil: #containingArtefact) ifNil: [self methods first]
]

{ #category : #actions }
SBEditor >> methodForContext: aContext ifOpen: aBlock ifClosed: anotherBlock [

	^ self methods
		detect: [:m | m methodClass = aContext methodClass and: [m selector = aContext selector]]
		ifFound: aBlock
		ifNone: anotherBlock
]

{ #category : #accessing }
SBEditor >> methods [

	^ scroll submorphs select: [:morph | morph isSandblock and: [morph isMethod]]
]

{ #category : #accessing }
SBEditor >> mode: aSymbol [

	aSymbol = #input
		ifTrue: [self assert: currentInput notNil]
		ifFalse: [self assert: currentInput isNil].
	
	aSymbol = #selection
		ifFalse: [self assert: multiSelection isEmpty].
	
	mode := aSymbol.
	modeLabel contents: (mode caseOf: {
		[#input] -> ['INPUT'].
		[#selection] -> ['SELECTION'].
		[#command] -> ['COMMAND']
	}).
	bottomPanel color: (mode caseOf: {
		[#input] -> [Color red alpha: 0.2].
		[#selection] -> [Color blue alpha: 0.2].
		[#command] -> [Color white]
	}).
	self updateSelectionLabel
]

{ #category : #selection }
SBEditor >> multiSelection [

	^ mode = #selection
		ifTrue: [multiSelection select: [:bubble | bubble owner notNil]]
		ifFalse: [self selection ifNotNil: [{self selection}] ifNil: [#()]]
	"^ multiSelection ifEmpty: [self selection ifNotNil: [{self selection}] ifNil: [#()]]"
]

{ #category : #selection }
SBEditor >> multiSelectionIsConsecutive [

	| sorted |
	sorted := self sortedMultiSelection.
	sorted overlappingPairsDo: [:a :b |
		a submorphAfter = b ifFalse: [^ false]].
	^ true
]

{ #category : #actions }
SBEditor >> nextSearchResult [

	searchInput nextResult
]

{ #category : #selection }
SBEditor >> noteNewOwner: aMorph [

	" ignore "
]

{ #category : #actions }
SBEditor >> okToChange [

	^ self unsavedChanges not or: [UIManager default confirm: 'Discard unsaved changes?']
]

{ #category : #actions }
SBEditor >> open: aMethodOrClass [

	aMethodOrClass isBehavior ifTrue: [
		self openClass: aMethodOrClass.
		^ aMethodOrClass methodsDo: [:compiledMethod | self openCompiledMethod: compiledMethod]].
	
	aMethodOrClass isCompiledMethod ifTrue: [^ self openCompiledMethod: aMethodOrClass].
	
	aMethodOrClass isCollection ifTrue: [^ aMethodOrClass do: [:methodOrClass | self open: methodOrClass]].
	
	self error: 'not supported for opening'
]

{ #category : #actions }
SBEditor >> openClass: aClass [

	^ self classes
		detect: [:m | m shownClass = aClass]
		ifFound: [:m | m select; yourself]
		ifNone: [self openMorphInView: (SBClass new class: aClass)]
]

{ #category : #actions }
SBEditor >> openCompiledMethod: aMethod [

	^ self methods
		detect: [:m | m selector = aMethod selector and: [m methodClass = aMethod methodClass]]
		ifFound: [:m | m select]
		ifNone: [self openMorphInView: aMethod asSandblock]
]

{ #category : #input }
SBEditor >> openInWindow [

	| window |
	window := self embeddedInMorphicWindowLabeled: self labelString.
	window model: self.
	
	window := window openInWorldExtent: self extent.
	(Project uiManager openToolsAttachedToMouseCursor)
		ifTrue: [
			window setProperty: #initialDrop toValue: true.
			window hasDropShadow: false.
			self currentHand attachMorph: window].
	^ window
]

{ #category : #'submorphs-add\/remove' }
SBEditor >> openMorph: aMorph [

	scroll addMorphBack: aMorph
]

{ #category : #'submorphs-add\/remove' }
SBEditor >> openMorphInView: aMorph [

	self do: (self openMorphInViewCommand: aMorph).
	^ aMorph
]

{ #category : #'submorphs-add\/remove' }
SBEditor >> openMorphInViewCommand: aMorph [

	| position |
	position := (self selection ifNotNil: #center ifNil: [scroll offset + (self extent // 2)]).
	^ SBInsertCommand newNonEdit
		index: 1;
		container: scroll;
		morph: (aMorph fullBounds; center: position; yourself);
		yourself
]

{ #category : #actions }
SBEditor >> openOpenWindow [

	| selected |
	selected := self selectedArtefact.
	((selected notNil and: [selected artefact isCompiledCode or: [selected artefact isBehavior]])
		ifTrue: [SBCodeOpener new positionNear: self; openFor: selected artefact]
		ifFalse: [SBCodeOpener new positionNear: self; open]) ifNotNil: [:methodOrClass | self open: methodOrClass]
]

{ #category : #actions }
SBEditor >> openRepl [

	| repl |
	repl := self openMorphInView: SBRepl new.
	self startInput: repl body childSandblocks first at: 1 replacingContents: true
]

{ #category : #shortcuts }
SBEditor >> outOfWorld: aWorld [

	super outOfWorld: aWorld.
	
	helpOverlay ifNotNil: #delete
]

{ #category : #'as yet unclassified' }
SBEditor >> parentSandblock [

	^ nil
]

{ #category : #actions }
SBEditor >> pasteStatementAbove [

	self pasteStatementAboveOrBelow: true
]

{ #category : #actions }
SBEditor >> pasteStatementAboveOrBelow: anAboveBoolean [

	| index target adjacent morph |
	copyBuffer ifNil: [^ self].
	
	copyBuffer wrapsAround ifTrue: [^ self wrapSelectionWith: copyBuffer].
	
	target := copyBuffer isSelection ifTrue: [copyBuffer firstSubmorph] ifFalse: [copyBuffer].
	
	adjacent := self selection.
	[adjacent parentSandblock acceptChild: target] whileFalse: [adjacent := adjacent parentSandblock].
	
	index := adjacent owner submorphIndexOf: adjacent.
	morph := target veryDeepCopy.
	
	self do: ((SBInsertCommand newFor: self selectedArtefact)
		index: (anAboveBoolean
			ifTrue: [index] ifFalse: [index + 1]);
		container: adjacent owner;
		morph: morph;
		yourself).
	
	morph postDuplicate
]

{ #category : #actions }
SBEditor >> pasteStatementBelow [

	self pasteStatementAboveOrBelow: false
]

{ #category : #actions }
SBEditor >> pasteString [

	| doIt block baseIndex |
	doIt := Parser new parse: Clipboard clipboardText class: nil class noPattern: true notifying: nil ifFail: [^ nil].
	block := doIt block statements last expr asSandblock.
	baseIndex := self selection containingStatement owner submorphIndexOf: self selection containingStatement.
	
	self do: ((SBCombinedCommand newFor: self selectedArtefact)
		commands:
			{(SBReplaceCommand newFor: self method) target: self selection; replacer: block},
			(doIt block statements allButLast withIndexCollect: [:statement :index |
				(SBInsertCommand newFor: self selectedArtefact)
					index: baseIndex + index - 1;
					container: self selection containingStatement owner;
					morph: statement asSandblock]))
]

{ #category : #actions }
SBEditor >> placeMark [

	(self selection hasDecorator: SBMarkedDecorator)
		ifTrue: [self selection detachDecorators: SBMarkedDecorator]
		ifFalse: [
			self waitForLetterDo: [:letter |
				self selection attachDecorator: (SBMarkedDecorator new letter: letter)]]
]

{ #category : #shortcuts }
SBEditor >> processShortcutList: aCollection for: anEvent ifMatched: aBlock [

	aCollection do: [:def |
		(def first asOrderedCollection anySatisfy: [:shortcut | shortcut matchesEvent: anEvent]) ifTrue: [
			" allow handlers to explicitly opt out by returning false "
			(def second value: self) = false ifFalse: [^ aBlock value]]]
]

{ #category : #'as yet unclassified' }
SBEditor >> promptAddArtifact [

	| index |
	index := UIManager default chooseFrom: {'Add method (T)'. 'Add class (Control+,)'}.
	index = 1 ifTrue: [^ self createEmptyMethod].
	index = 2 ifTrue: [^ self createEmptyClass]
]

{ #category : #'initialize-release' }
SBEditor >> promptChangeCompile [

	| index labels |
	labels := {'Compile on save'. 'Compile on change'}.
	index := UIManager default chooseFrom: labels.
	index < 1 ifTrue: [^ self].
	
	compileTimeButton contents: (labels at: index).
	compileTime := index = 1 ifTrue: [#compileOnSave] ifFalse: [#compileOnChange]
]

{ #category : #actions }
SBEditor >> promptCodeAction [

	self selection codeActions ifNotEmpty: [:actions | self selection proposeCodeActions: actions for: self selection]
]

{ #category : #actions }
SBEditor >> promptMenu [

	| options |
	options := {
		{'Change Color Policy'. [
			self colorPolicy: ((UIManager default chooseFrom: SBColorPolicy withAllSubclasses values: SBColorPolicy withAllSubclasses) ifNil: [^ self])
				new;
				changed.
			self allMorphsDo: [:morph | morph removeProperty: #sandblockBlockColor]]}.
		{'Change Compile Method'. [self promptChangeCompile]}.
		{'New Class'. [self createEmptyClass]}
	}.
	
	(UIManager default chooseFrom: (options collect: #first) values: (options collect: #second)) ifNotNil: #value
]

{ #category : #actions }
SBEditor >> promptOpenWorkspace [

	| items index |
	items := SBWorkspaceHistory default items.
	index := UIManager default chooseFrom: items.
	index = 0 ifTrue: [^ self].
	self close.
	(items at: index) open
]

{ #category : #'as yet unclassified' }
SBEditor >> promptWorkspaceActions [

	| index |
	index := UIManager default chooseFrom: {'Open Workspace (Cmd+O)'. 'Save Workspace (Cmd+S)'}.
	index = 1 ifTrue: [^ self promptOpenWorkspace].
	index = 2 ifTrue: [^ self saveWorkspace]
]

{ #category : #actions }
SBEditor >> redo [

	| command |
	redoStack ifNotEmpty: [
		command := redoStack removeLast.
		undoStack addLast: command.
		self select: command do.
		self markChangesAfterCommand: command]
]

{ #category : #actions }
SBEditor >> refocus [

	self selection ifNotNil: #ensureVisible
]

{ #category : #'as yet unclassified' }
SBEditor >> removeHelperTimer [

	helpOverlay ifNotNil: #delete.
	helpOverlay := nil.
	self removeAlarm: #showHelper
]

{ #category : #input }
SBEditor >> replaceInput: aMorph [
	" inform the editor that the current input morph has been replaced by another where input should continue "

	self assert: currentInput notNil.
	currentInput := aMorph.
	self select: aMorph containingSandblock
]

{ #category : #actions }
SBEditor >> replaceWithCopyBuffer [

	copyBuffer ifNotNil: [ | new |
		new := (copyBuffer isSelection ifTrue: [copyBuffer firstSubmorph] ifFalse: [copyBuffer]) veryDeepCopy.
		self do: ((SBReplaceCommand newFor: self selectedArtefact)
			target: self selection;
			replacer: new).
		new postDuplicate]
]

{ #category : #actions }
SBEditor >> reportError: anError process: aProcess [

	^ errors addError: anError process: aProcess
]

{ #category : #actions }
SBEditor >> reportTypeInfo: anObject at: aContext [

	self methods
		detect: [:method | method methodClass = aContext methodClass and: [method selector = aContext selector]]
		ifFound: [:method | method cacheType: anObject class for: (method blockForPC: aContext pc)]
]

{ #category : #actions }
SBEditor >> reportTypeInfo: anObject at: aContext findNode: aBlock [

	self methods
		detect: [:method | method methodClass = aContext methodClass and: [method selector = aContext selector]]
		ifFound: [:method | method cacheType: anObject class for: (aBlock value: method)]
]

{ #category : #'initialize-release' }
SBEditor >> resetState [

	self clearUndoStack.
	selectionDownHistory := OrderedCollection new.
	selection := self methods ifNotEmpty: #first ifEmpty: [nil].
	colorPolicy := colorPolicy class new.
	self mode: #command
]

{ #category : #actions }
SBEditor >> resetZoom [

	scroll scale: 1 @ 1.
	scroll viewportPosition: scroll currentPosition rounded
]

{ #category : #'as yet unclassified' }
SBEditor >> resizeToFit [

	| extent outer |
	self deprecated.
	
	self fullBounds.
	outer := (self ownerThatIsA: SystemWindow) ifNil: [self].
	extent := scroll extentToFit + outer extent - scroll extent + (20 @ 20 * self scalingFactor).
	outer extent: extent x @ (extent y min: Display height - (100 * self scalingFactor))
]

{ #category : #actions }
SBEditor >> restartFrame [

	errors restart
]

{ #category : #'as yet unclassified' }
SBEditor >> sandblockEditor [

	^ self
]

{ #category : #actions }
SBEditor >> save [

	self selection ifNotNil: [self saveTryFixing: true quick: false]
]

{ #category : #actions }
SBEditor >> save: anArtefact tryFixing: aFixBoolean quick: aQuickBoolean [

	^ (anArtefact saveTryFixing: aFixBoolean quick: aQuickBoolean)
		ifTrue: [
			self allBlocksDo: [:block | block artefactSaved: self method].
			true]
		ifFalse: [false]
]

{ #category : #actions }
SBEditor >> saveTryFixing: aFixBoolean quick: aQuickBoolean [

	^ (self selectedArtefact saveTryFixing: aFixBoolean quick: aQuickBoolean)
		ifTrue: [
			self allBlocksDo: [:block | block artefactSaved: self method].
			true]
		ifFalse: [false]
]

{ #category : #actions }
SBEditor >> saveWorkspace [

	workspace
		ifNotNil: [workspace updateFrom: self]
		ifNil: [ | name |
			name := (UIManager default
				request: 'Workspace name?'
				initialAnswer: (((self methods collect: #methodClass) collect: #name) asSet asArray joinSeparatedBy: ', ')) ifNil: [^ self].
			
			self workspace: (SBWorkspaceHistory default
				save: self
				named: name)]
]

{ #category : #selection }
SBEditor >> scrollToShow: aBlock [

	(aBlock hasOwner: scroll) ifTrue: [
		scroll scrollToShow: aBlock]
]

{ #category : #selection }
SBEditor >> select: aBlock [

	self assert: (aBlock isNil or: [aBlock isSandblock]).
	
	(currentInput ~= nil and: [currentInput ~= aBlock]) ifTrue: [self endInput].
	
	self internalSelect: aBlock
]

{ #category : #actions }
SBEditor >> selectArtefact [

	self select: (self selection containingArtefact = self selection
		ifTrue: [self selection parentSandblock containingArtefact]
		ifFalse: [self selection containingArtefact])
]

{ #category : #selection }
SBEditor >> selectClick: aBlock [

	selectionDownHistory removeAll.
	self select: (aBlock == self selection ifTrue: [nil] ifFalse: [aBlock])
]

{ #category : #selection }
SBEditor >> selectDown [

	| next from |
	from := self selection.
	
	" try to follow our steps back down "
	next := selectionDownHistory ifEmpty: [] ifNotEmpty: #removeLast.
	(self selection childSandblocks includes: next) ifFalse: [
		selectionDownHistory removeAll.
		next := self selection firstMorphThat: #isSandblock].
	
	next ifNotNil: [self select: next]
]

{ #category : #actions }
SBEditor >> selectLast [

	self select: self selection containingArtefact lastDeepChild
]

{ #category : #selection }
SBEditor >> selectLeftMostBlock [

	self select: self selection leftMostBlock
]

{ #category : #selection }
SBEditor >> selectNext [

	| from |
	from := self selection.
	
	selectionDownHistory removeAll.
	from nextBlock ifNotNil: [:b | self select: b]
]

{ #category : #selection }
SBEditor >> selectNextStatement [

	selectionDownHistory removeAll.
	(self selection nextBlockThat: #isMessageSend) ifNotNil: [:b | ^ self select: b]
	
	"(self selection topFirstMorphThat: [:m | m isStatement and: [m ~= self selection]]) ifNotNil: [:s | ^ self select: s].
	(self selection morphAfterThat: #isStatement) ifNotNil: [:s | ^ self select: s].
	(self selection ownerSatisfying: #isStatement) ifNotNil: [:owner | (owner morphAfterThat: #isStatement) ifNotNil: [:s | self select: s]]"
]

{ #category : #selection }
SBEditor >> selectPrevious [

	| from |
	from := self selection.
	
	selectionDownHistory removeAll.
	from previousBlock ifNotNil: [:b | self select: b]
]

{ #category : #selection }
SBEditor >> selectPreviousStatement [

	selectionDownHistory removeAll.
	(self selection previousBlockThat: #isMessageSend) ifNotNil: [:b | ^ self select: b]
]

{ #category : #selection }
SBEditor >> selectRightMostBlock [

	self select: self selection rightMostBlock
]

{ #category : #actions }
SBEditor >> selectToplevelTowards: aSideSymbol [

	| opposite |
	opposite := aSideSymbol caseOf: {[#left] -> [#right]. [#right] -> [#left]. [#top] -> [#bottom]. [#bottom] -> [#top]}.
	
	self select: (self selection containingArtefact closestAdjacentFrom: (aSideSymbol, 'Center') asSymbol to: (opposite, 'Center') asSymbol)
]

{ #category : #selection }
SBEditor >> selectUp [

	| from |
	from := self selection.
	
	from parentSandblock ifNotNil: [:b |
		selectionDownHistory addLast: self selection.
		self select: b]
]

{ #category : #'as yet unclassified' }
SBEditor >> selectedArtefact [

	^ (self selection ifNotNil: #containingArtefact) ifNil: [self methods ifNotEmpty: #first ifEmpty: [nil]]
]

{ #category : #selection }
SBEditor >> selection [

	^ selection ifNotNil: [selection owner ifNil: [nil] ifNotNil: [selection]]
]

{ #category : #actions }
SBEditor >> sendersOfIt [

	self selection browseSenders
]

{ #category : #'as yet unclassified' }
SBEditor >> setCopyBuffer: aMorphOrCollection [

	| form list |
	list := (aMorphOrCollection isCollection ifTrue: [aMorphOrCollection] ifFalse: [{aMorphOrCollection}]) select: #canCopy.
	list ifEmpty: [^ self].
	
	copyBuffer := SBSelection new
		methodClass: (list first containingArtefact ifNotNil: #relatedClass);
		colorPolicy: self colorPolicy.
	
	list select: [:m | m isCodeContainer not] thenDo: [:m | copyBuffer addMorphBack: m veryDeepCopy].
	form := copyBuffer imageForm.
	"copyBufferPreview image: ((form scaledIntoFormOfSize: (self copyBufferPreviewSize min: form extent)) collectColors: [:c | c alpha: c alpha * 0.7])."
	copyBufferPreview image: ((form scaledToHeight: self copyBufferPreviewSize y) collectColors: [:c | c alpha: c alpha * 0.7])
]

{ #category : #'as yet unclassified' }
SBEditor >> showHelper [

	(helpOverlay isNil and: [self isInWorld]) ifTrue: [helpOverlay := SBHelpOverlay new target: self selection]
]

{ #category : #actions }
SBEditor >> showUsageInfo [

	self selection showUsageInfo
]

{ #category : #selection }
SBEditor >> sortedMultiSelection [

	| unsorted order |
	unsorted := self multiSelection.
	unsorted size < 2 ifTrue: [^ unsorted].
	
	order := self allMorphs.
	^ unsorted sort: [:a :b | (order indexOf: a) < (order indexOf: b)]
]

{ #category : #input }
SBEditor >> startInput: aMorph at: aNumber replacingContents: aBoolean [

	" needs to be set first, as startInputAt: may choose to immediately replace this "
	self select: aMorph.
	currentInput := aMorph.
	(aMorph startInputAt: aNumber replacingContents: aBoolean)
		ifNotNil: [:cmd |
			currentInputCommand := cmd.
			self mode: #input]
		ifNil: [currentInput := nil]
]

{ #category : #actions }
SBEditor >> startInputAtEnd [

	self startInput: self selection at: 9e8 replacingContents: false
]

{ #category : #actions }
SBEditor >> startInputAtStart [

	self startInput: self selection at: 1 replacingContents: false
]

{ #category : #actions }
SBEditor >> startInputSubstituting [

	self startInput: self selection at: 1 replacingContents: true
]

{ #category : #actions }
SBEditor >> startOrAddToMultiSelection [

	mode = #selection ifTrue: [
		^ (multiSelection includes: self selection)
			ifTrue: [
				self selection detachDecorators: SBMultiSelectionDecorator.
				multiSelection remove: self selection.
				multiSelection ifEmpty: [self mode: #command]]
			ifFalse: [self addToMultiSelection]].
	
	self addToMultiSelection.
	self mode: #selection
]

{ #category : #actions }
SBEditor >> startSearch [

	searchInput startSearch
]

{ #category : #actions }
SBEditor >> stepInto [

	errors stepInto
]

{ #category : #actions }
SBEditor >> stepOver [

	errors stepOver
]

{ #category : #actions }
SBEditor >> storeOn: aStream [

	aStream
		nextPut: $(;
		nextPutAll: self className;
		nextPutAll: ' new'.
	scroll submorphs do: [:morph |
		aStream cr.
		aStream nextPutAll: 'openMorph: '.
		morph storeOn: aStream.
		aStream nextPut: $;].
	aStream nextPutAll: 'yourself)'
]

{ #category : #actions }
SBEditor >> swapLeft [

	| next children |
	children := self selection parentSandblock childSandblocks.
	next := children atWrap: (children indexOf: self selection) - 1.
	
	(next notNil and: [self selection canSwap and: [next canSwap]]) ifTrue: [
		self do: ((SBSwapCommand newFor: self method) a: self selection; b: next)]
]

{ #category : #actions }
SBEditor >> swapRight [

	| next children |
	children := self selection parentSandblock childSandblocks.
	next := children atWrap: (children indexOf: self selection) + 1.
	
	(next notNil and: [self selection canSwap and: [next canSwap]]) ifTrue: [
		self do: ((SBSwapCommand newFor: self method) a: self selection; b: next)]
]

{ #category : #accessing }
SBEditor >> textMorph [

	^ currentInput currentTextMorph
]

{ #category : #shortcuts }
SBEditor >> toggleCollapsed [

	self selection ifNotNil: #toggleCollapsed
]

{ #category : #shortcuts }
SBEditor >> toggleFullscreen [

	self owner = self world
		ifTrue: [(self valueOfProperty: #previousWindow) addMorph: self frame: (0@0 extent: 1@1)]
		ifFalse: [
			self
				setProperty: #previousWindow toValue: self owner;
				openInWorld;
				extent: Display extent;
				position: 0 @ 0]
]

{ #category : #'as yet unclassified' }
SBEditor >> toggleHelperTimer: aBoolean [

	aBoolean
		ifTrue: [
			self addAlarm: #showHelper after: 1 second asMilliSeconds]
		ifFalse: [self removeHelperTimer]
]

{ #category : #actions }
SBEditor >> undo [

	| command |
	undoStack ifNotEmpty: [ | ret |
		command := undoStack removeLast.
		redoStack addLast: command.
		ret := command undo.
		self select: ((command previousSelection notNil and: [command previousSelection isInWorld]) ifTrue: [command previousSelection] ifFalse: [ret]).
		self markChangesAfterCommand: command]
]

{ #category : #actions }
SBEditor >> unsavedChanges [

	self allBlocksDo: [:block | (block isArtefact and: [block hasUnsavedChanges]) ifTrue: [^ true]].
	^ false
]

{ #category : #'as yet unclassified' }
SBEditor >> updateSearch [

	searchInput contents
]

{ #category : #selection }
SBEditor >> updateSelectionLabel [

	selectionLabel contents: (mode = #selection
		ifTrue: [multiSelection size asString, (' element' asPluralBasedOn: multiSelection)]
		ifFalse: [
			(self selection notNil and: [self selection isInWorld])
				ifTrue: [ | class |
					class := self selection guessClassExpensive.
					(self selection containingArtefact isNil or: [class isNil])
						ifTrue: [self selection printString]
						ifFalse:  ['{1} ({2})' format: {self selection printString. class asString}]]
				ifFalse: ['']])
]

{ #category : #actions }
SBEditor >> waitForLetterDo: aBlock [

	| delay keyEvent |
	delay := Delay forMilliseconds: 50.
	[Sensor anyButtonPressed not and: [(keyEvent := Sensor peekKeyboardEvent) isNil]]
		whileTrue: [delay wait].
	keyEvent ifNotNil: [ | letter |
		letter := (ActiveHand generateKeyboardEvent: keyEvent) keyCharacter.
		letter isLetter ifTrue: [aBlock value: letter]]
]

{ #category : #actions }
SBEditor >> watchExampleExpression: aBlock [

	self watchExpression: aBlock with: SBExampleWatch
]

{ #category : #actions }
SBEditor >> watchExpression: aBlock [

	self watchExpression: aBlock with: SBWatch
]

{ #category : #actions }
SBEditor >> watchExpression: aBlock with: aWatchClass [

	self selection isExpression ifFalse: [^ self].
	
	self selection isWatch
		ifTrue: [^ self do: ((SBReplaceCommand newFor: self method) target: self selection; replacer: self selection childSandblocks first)].
	
	self selection parentSandblock isWatch ifTrue: [^ self deleteAroundSelection].
	
	self do: ((SBWrapCommand newFor: self method)
			outer: aWatchClass new newIdentifier;
			inner: aBlock;
			wrap: [:outer :inner | outer expression: inner])
]

{ #category : #actions }
SBEditor >> watchSelection [

	self watchExpression: self selection
]

{ #category : #actions }
SBEditor >> watchSelectionForExample [

	self watchExampleExpression: self selection
]

{ #category : #accessing }
SBEditor >> workspace: aWorkspaceRecord [

	workspace := aWorkspaceRecord.
	self changed: #relabel
]

{ #category : #actions }
SBEditor >> wrapAsArgument [

	| msg |
	msg := SBMessageSend new.
	self do: ((SBWrapCommand newFor: self method)
		outer: msg;
		inner: self selection;
		shouldMergeWithNext: true;
		wrap: [:outer :inner |
			outer
				receiver: SBUnknown new
				selector: SBMessageSend placeholderSelector
				arguments: {inner}];
		yourself).
	
	self startInput: msg receiver at: 0 replacingContents: false
]

{ #category : #actions }
SBEditor >> wrapInArrayType: aSymbol [

	self do: ((SBWrapCommand newFor: self method)
		outer: SBArray new;
		inner: self selection;
		wrap: [:outer :inner | outer type: aSymbol contents: {inner}];
		yourself)
]

{ #category : #actions }
SBEditor >> wrapInAssignment [

	| binding |
	binding := SBName new.
	self do: ((SBWrapCommand newFor: self method)
		outer: SBAssignment new;
		inner: self selection;
		wrap: [:outer :inner | outer binding: binding value: inner];
		shouldMergeWithNext: true;
		yourself).
	
	self startInput: binding at: 0 replacingContents: true
]

{ #category : #actions }
SBEditor >> wrapInBlock [

	self doMultiSelection: [:statements |
		self flag: #todo. " inner needs to support an array :/ "
		(SBWrapCommand newFor: self method)
			outer: SBBlockBody new;
			inner: self selection;
			wrap: [:outer :inner | outer statements: statements];
			yourself]
]

{ #category : #actions }
SBEditor >> wrapInCascade [

	| cascade |
	cascade := SBCascade new.
	self doMultiSelection: [:selected |
		SBCombinedCommand newWith: {
			(SBMoveCommand newFor: self method)
				morph: selected first receiver;
				container: cascade;
				index: 1;
				yourself.
			(SBWrapCommand newFor: self method)
				outer: cascade;
				inner: selected first;
				wrap: [:outer :inner | outer addMorphBack: inner];
				yourself}, (selected allButFirst collectWithIndex: [:message :index |
			SBCombinedCommand newWith: {
				(SBInsertCommand newFor: self method)
					container: cascade;
					morph: message;
					index: index + 1;
					yourself.
				(SBDeleteCommand newFor: self method)
					target: message receiver;
					yourself
			}])].
	self select: cascade
]

{ #category : #actions }
SBEditor >> wrapInDynamicArray [

	self wrapInArrayType: #dynamic
]

{ #category : #actions }
SBEditor >> wrapInLiteralArray [

	self wrapInArrayType: #literal
]

{ #category : #actions }
SBEditor >> wrapInMessageSend [

	self wrapInMessageSend: ''
]

{ #category : #actions }
SBEditor >> wrapInMessageSend: aString [

	| msg |
	self selection isExpression ifFalse: [^ self].
	
	msg := SBMessageSend new.
	self do: ((SBWrapCommand newFor: self method)
		outer: msg;
		inner: self selection;
		shouldMergeWithNext: true;
		wrap: [:outer :inner |
			outer
				receiver: inner
				selector: aString
				arguments: (aString numArgs > 0 ifTrue: [(1 to: aString numArgs) collect: [:i | SBUnknown new]] ifFalse: [#()])];
		yourself).
	
	self startInput: msg at: 9e8 replacingContents: false
]

{ #category : #actions }
SBEditor >> wrapInReturn [

	self do: ((SBWrapCommand newFor: self method)
		outer: SBReturn new;
		inner: self selection;
		wrap: [:outer :inner | outer expression: inner];
		yourself)
]

{ #category : #actions }
SBEditor >> wrapInToggledCode [

	self do: ((SBWrapCommand newFor: self method)
		outer: SBToggledCode new;
		inner: self selection;
		wrap: [:outer :inner | outer comment: '' active: 0 do: {SBBlockBody new statements: {inner}}];
		yourself)
]

{ #category : #actions }
SBEditor >> wrapSelectionWith: aSelection [

	| around new |
	around := self selection.
	new := aSelection veryDeepCopy.
	
	self do: (SBCombinedCommand newWith: {
		(SBReplaceCommand newFor: self selectedArtefact)
			target: around;
			replacer: new firstSubmorph.
		(SBReplaceCommand newFor: self selectedArtefact)
			target: new placeholder;
			replacer: around.
	}).
	
	new postDuplicate
]
