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
		'scroll',
		'methodContainer',
		'colorPolicy',
		'bottomPanel',
		'compileTime',
		'workspace',
		'errors',
		'searchInput',
		'helpOverlay',
		'verticalSelectionPosition',
		'globalShortcutListeners',
		'inputMapping',
		'ignoreNext',
		'paletteContainer'
	],
	#classVars : [
		'DefaultColorPolicy',
		'InputMappingClass',
		'Shortcuts'
	],
	#category : #'Sandblocks-Core'
}

{ #category : #'initialize-release' }
SBEditor class >> anyShortcutForAction: aSymbol [

	^ (self shortcutsForAction: aSymbol) ifNotEmpty: #first ifEmpty: [nil]
]

{ #category : #'initialize-release' }
SBEditor class >> clearShortcuts [

	Shortcuts := nil
]

{ #category : #'initialize-release' }
SBEditor class >> current [
	" find the most recently used SBEditor instance "
	
	^ (SystemWindow windowsIn: ActiveWorld satisfying: [:w | w model isKindOf: SBEditor]) first model
]

{ #category : #configuration }
SBEditor class >> defaultColorPolicy [

	^ DefaultColorPolicy ifNil: [DefaultColorPolicy := SBColorMinimalPolicy]
]

{ #category : #configuration }
SBEditor class >> defaultColorPolicy: aColorPolicyClass [

	DefaultColorPolicy := aColorPolicyClass
]

{ #category : #'initialize-release' }
SBEditor class >> initialize [

	self newInputMapping applyFor: self
]

{ #category : #'initialize-release' }
SBEditor class >> newFor: aMethodOrClass [

	| editor |
	editor := self new.
	editor open: aMethodOrClass.
	editor clearUndoStack.
	
	^ editor
]

{ #category : #'initialize-release' }
SBEditor class >> newInputMapping [

	^ (InputMappingClass ifNil: [SBVimInputMapping]) new
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

{ #category : #'initialize-release' }
SBEditor class >> registerDefaultShortcuts [
	"self registerDefaultShortcuts"

	(Shortcuts notNil and: [Shortcuts notEmpty and: [(UIManager default confirm: 'This will reset all custom shortcuts, continue?') not]]) ifTrue: [^ self].
	
	self clearShortcuts.
	self
		" navigation "
		registerShortcut: $h do: #selectPrevious;
		registerShortcut: $l do: #selectNext;
		registerShortcut: $J do: #selectDown;
		registerShortcut: $K do: #selectUp;
		registerShortcut: $G do: #selectLast;
		registerShortcut: $g do: #selectArtefact;
		registerShortcut: $$ do: #selectRightMostBlock;
		registerShortcut: Character tab shift do: #inputPreviousUnknown;
		registerShortcut: Character tab do: #inputNextUnknown;
		registerShortcut: $z do: #toggleCollapsed;
		registerShortcut: $m do: #placeMark;
		registerShortcut: $' do: #goToMark;
		registerShortcut: $h command do: #selectLeftToplevel;
		registerShortcut: $j command do: #selectBottomToplevel;
		registerShortcut: $k command do: #selectTopToplevel;
		registerShortcut: $l command do: #selectRightToplevel;
		registerShortcut: $k do: #selectPreviousGroup;
		registerShortcut: $j do: #selectNextGroup;
		registerShortcut: $! do: #ensureVisible;
		registerShortcut: $0 do: #selectStartOfStatement;
		
		" modify general "
		registerShortcut: $, do: #promptAction;
		registerShortcut: $i do: #startInputAtStart;
		registerShortcut: $a do: #startInputAtEnd;
		registerShortcut: $s do: #startInputSubstituting;
		registerShortcut: $c do: #changeToUnknown;
		registerShortcut: $Y do: #copyAround;
		registerShortcut: $y do: #copyToBuffer;
		registerShortcut: $X do: #deleteAround;
		registerShortcut: $x do: #deleteBlock;
		registerShortcut: $d do: #deleteAdjacent;
		registerShortcut: $( do: #leftRotate;
		registerShortcut: $. do: #addElement;
		registerShortcut: $+ do: #insertElementAfter;
		registerShortcut: $* do: #insertElementBefore;
		registerShortcut: $H do: #swapLeft;
		registerShortcut: $L do: #swapRight;
		registerShortcut: $c command do: #copyString;
		registerShortcut: $v command do: #pasteString;
		registerShortcut: $p do: #pasteBelow;
		registerShortcut: $P do: #pasteAbove;
		registerShortcut: $v do: #startOrAddToMultiSelection;
		registerShortcut: $V command do: #startContinuousMultiSelection;
		registerShortcut: $V do: #multiSelectChildren;
		registerShortcut: Character escape do: #endMultiSelection;
		registerShortcut: $r do: #replaceWithCopyBuffer;

		" modify smalltalk "
		registerShortcut: $" do: #wrapInToggledCode;
		registerShortcut: $D do: #insertLabelAbove;
		registerShortcut: $O do: #insertStatementAbove;
		registerShortcut: $o do: #insertStatementBelow;
		registerShortcut: $[ do: #wrapInBlock;
		registerShortcut: ${ do: #wrapInDynamicArray;
		registerShortcut: $# do: #wrapInLiteralArray;
		registerShortcut: $: do: #wrapInAssignment;
		registerShortcut: $; do: #wrapInCascade;
		registerShortcut: $^ do: #wrapInReturn;
		registerShortcut: Character space shift do: #wrapAsArgument;
		registerShortcut: Character space do: #wrapInMessageSend;
		
		" input "
		registerShortcut: Character escape do: #endInput;
		registerShortcut: Character cr do: #useSuggestion;
		registerShortcut: Character arrowLeft do: #moveCursorLeft;
		registerShortcut: $h command do: #moveCursorLeft;
		registerShortcut: Character arrowRight do: #moveCursorRight;
		registerShortcut: $l command do: #moveCursorRight;
		registerShortcut: $a command do: #moveCursorToStart;
		registerShortcut: $e command do: #moveCursorToEnd;
		registerShortcut: $x command do: #clearInput;
		registerShortcut: $j command do: #focusNextSuggestion;
		registerShortcut: $k command do: #focusPreviousSuggestion;
		registerShortcut: $1 command do: #useFirstArgument;
		registerShortcut: $2 command do: #useSecondArgument;
		registerShortcut: $3 command do: #useThirdArgument;
		registerShortcut: $4 command do: #useFourthArgument;
		registerShortcut: $5 command do: #useFifthArgument;
		registerShortcut: $' command do: #splitStringAtCursor;
		
		" refactor "
		registerShortcut: $T do: #extractMethod;
		registerShortcut: $t do: #createEmptySmalltalkMethod;
		registerShortcut: $= do: #extractVariable;
		
		" debugging "
		registerShortcut: $> do: #stepOver;
		registerShortcut: $< do: #stepInto;
		registerShortcut: $y command do: #stepThrough;
		registerShortcut: $Y command do: #restartFrame;
		registerShortcut: $e do: #focusErrors;
		registerShortcut: $E do: #focusPreviousErrorFrame;
		
		" tools "
		registerShortcut: $W do: #wrapWithWatch;
		registerShortcut: $w do: #wrapWithExampleWatch;
		registerShortcut: $p command do: #evaluateExpression;
		registerShortcut: $d command do: #doExpression;
		registerShortcut: $P command do: #debugExpression;
		registerShortcut: $a command do: #addExample;
		registerShortcut: $m command do: #browseImplementors;
		registerShortcut: $n command do: #browseSenders;
		registerShortcut: $x command do: #openOpenWindow;
		registerShortcut: $b command do: #browse;
		
		" editor "
		registerShortcut: $u do: #undo;
		registerShortcut: $U do: #redo;
		registerShortcut: $s command do: #save;
		registerShortcut: $r command do: #openRepl;
		registerShortcut: $, command do: #promptMenu;
		registerShortcut: $/ do: #startSearch;
		registerShortcut: $n do: #nextSearchResult;
		registerShortcut: $S command do: #saveWorkspace;
		registerShortcut: $O command do: #promptOpenWorkspace;
		registerShortcut: $f command do: #toggleFullscreen
]

{ #category : #'initialize-release' }
SBEditor class >> registerShortcut: aShortcut do: aSymbol [

	self shortcuts add: aShortcut asSandblockShortcut -> aSymbol
]

{ #category : #'initialize-release' }
SBEditor class >> shortcutStringForAction: anAction [

	^ String streamContents: [:stream |
		stream nextPut: $(.
		(self shortcutsForAction: anAction) do: [:shortcut | (shortcut isCollection ifTrue: [shortcut first] ifFalse: [shortcut]) printDisplayOn: stream] separatedBy: [stream space].
		stream nextPut: $)]
]

{ #category : #'initialize-release' }
SBEditor class >> shortcuts [

	^ Shortcuts ifNil: [Shortcuts := OrderedCollection new]
]

{ #category : #'initialize-release' }
SBEditor class >> shortcutsForAction: anAction [

	^ self shortcuts select: [:assoc | assoc value = anAction] thenCollect: [:assoc | assoc key]
]

{ #category : #'initialize-release' }
SBEditor class >> useInputMapping: anInputMappingClass [
	" self useInputMapping: SBTextInputMapping "

	InputMappingClass := anInputMappingClass.
	anInputMappingClass new applyFor: self
]

{ #category : #actions }
SBEditor >> acceptChild: aBlock [

	^ aBlock isArtefact
]

{ #category : #accessing }
SBEditor >> acceptedRepresentation [

	^ #isToplevelMorph
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
		addMultiSelectionShortcut: $x do: #deleteSelection.
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
		addMultiSelectionShortcut: $# do: #wrapInLiteralArray;
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
		addMultiSelectionShortcut: $g do: #selectArtefact;
		addMultiSelectionShortcut: $G do: #selectLast;
		addMultiSelectionShortcut: $! do: #refocus.
	SBLabel text: ['Refactoring'].
	self
		addSingleSelectionShortcut: $= do: #extractVariable;
		addMultiSelectionShortcut: $T do: #extractMethod.
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
		addCommandShortcut: $t do: #createEmptySmalltalkMethod.
	SBLabel text: ['Tools: Debugger'].
	self
		addCommandShortcut: $> do: #stepOver;
		addCommandShortcut: $< do: #stepInto;
		addCommandShortcut: $y command do: #stepThrough;
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
		addMultiSelectionShortcut: $V do: #multiSelectChildren;
		addInputShortcut: Character escape do: #endInput;
		addInputShortcut: Character arrowLeft do: [:editor | editor textMorph moveCursor: -1];
		addInputShortcut: Character arrowRight do: [:editor | editor textMorph moveCursor: 1];
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
		addInputShortcut: $1 command
			do: [:editor |
				editor endInputWith: self method arguments first contents];
		addInputShortcut: $2 command
			do: [:editor |
				editor endInputWith: self method arguments second contents];
		addInputShortcut: $3 command
			do: [:editor |
				editor endInputWith: self method arguments third contents];
		addInputShortcut: $4 command
			do: [:editor |
				editor endInputWith: self method arguments fourth contents];
		addInputShortcut: $5 command
			do: [:editor |
				editor endInputWith: self method arguments fifth contents]
]

{ #category : #actions }
SBEditor >> addToMultiSelection: aBlock [

	multiSelection add: aBlock.
	multiSelection copy do: [:morph | (morph hasOwner: aBlock) ifTrue: [self removeMultiSelected: morph]].
	
	aBlock allOwnersDo: [:morph | (multiSelection includes: morph) ifTrue: [self removeMultiSelected: morph]].
	
	aBlock attachDecorator: SBMultiSelectionDecorator new.
	self triggerEvent: #selectionChanged with: selection.
	self updateSelectionLabel
]

{ #category : #accessing }
SBEditor >> allActiveMorphExamples [

	^ Array streamContents: [:stream |
		self allBlocksDo: [:b | (b isMorphExample and: [b visible]) ifTrue: [stream nextPut: b]]]
]

{ #category : #'as yet unclassified' }
SBEditor >> allBlocksFor: anObject withInterfaces: aCollection [

	^ Array streamContents: [:stream |
		self allBlocksDo: [:morph |
			(morph isSandblock and: [morph object = anObject and: [morph satisfies: aCollection]]) ifTrue: [stream nextPut: morph]]]
]

{ #category : #actions }
SBEditor >> anyNearbyClass [

	| artefacts |
	artefacts := self artefacts.
	artefacts ifEmpty: [^ UndefinedObject].
	
	^ ((self selection ifNotNil: #containingArtefact) ifNil: [artefacts first]) relatedClass
]

{ #category : #actions }
SBEditor >> artefacts [

	^ scroll scroller submorphs select: [:s | s isSandblock and: [s isArtefact]]
]

{ #category : #artefacts }
SBEditor >> batchedChangeStep: aBlock [

	" send this message when you are updating the tree rapidly for each update, but don't want to submit a command for each update, only at the end "
	self compileTime = #compileOnChange ifTrue: [ | artefact |
		self save: aBlock containingArtefact tryFixing: false quick: true.
		artefact := self selectedArtefact.
		artefact triggerEvent: #changed.
		self allBlocksDo: [:block | block artefactChanged: artefact]]
]

{ #category : #accessing }
SBEditor >> binding: aString for: block class: aClass ifPresent: aBlock [

	Symbol hasInterned: aString ifTrue: [:sym | | binding |
		binding := aClass bindingOf: sym environment: aClass environment.
		binding ifNotNil: [^ aBlock value: ((SBStName poolDeclaration: aString) binding: binding)]].
	
	^ nil
]

{ #category : #'as yet unclassified' }
SBEditor >> blockFor: anObject withInterfaces: aCollection ifOpen: aBlock ifClosed: anotherBlock [

	^ self
		allBlocksDetect: [:morph | morph isSandblock and: [morph object = anObject and: [morph satisfies: aCollection]]]
		ifFound: aBlock
		ifNone: anotherBlock
]

{ #category : #accessing }
SBEditor >> blockForClass: aClass ifPresent: aBlock ifAbsent: anotherBlock [

	^ scroll scroller submorphs detect: [:morph | morph isSandblock and: [morph isClassContainer and: [morph shownClass = aClass]]] ifFound: aBlock ifNone: anotherBlock
]

{ #category : #'initialize-release' }
SBEditor >> buildBottomPanel [

	^ Morph new
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
		addMorphBack: (Morph new
			extent: 0 @ 0;
			hResizing: #spaceFill;
			color: Color transparent);
		addMorphBack: (SBButton new
			balloonText: 'Convert to ...';
			icon: SBIcon iconRetweet
				shortcut: (self class anyShortcutForAction: #convertTo)
				do: [self selection convertTo]);
		addMorphBack: (SBButton new
			balloonText: 'Copy';
			icon: SBIcon iconCopy
				shortcut: (self class anyShortcutForAction: #copyToBuffer)
				do: [self selection copyToBuffer]);
		addMorphBack: (SBButton new
			balloonText: 'Copy around';
			icon: SBIcon iconClipboard
				shortcut: (self class anyShortcutForAction: #copyAround)
				do: [self selection copyAround]);
		addMorphBack: (copyBufferPreview := ImageMorph new
			image: (Form extent: 1 @ 1);
			balloonText: 'Pickup clipboard contents';
			on: #startDrag send: #dragCopyBuffer: to: self);
		yourself
]

{ #category : #ui }
SBEditor >> buildCommandBar [

	^ SBRow new
		changeTableLayout;
		hResizing: #spaceFill;
		cellGap: 4 withScalingFactor;
		layoutInset: 4 withScalingFactor;
		addMorphBack: (SBButton new icon: SBIcon iconColumns shortcut: nil do: [self togglePalette]);
		addMorphBack: (SBButton new icon: SBIcon iconUndo shortcut: (self class anyShortcutForAction: #undo) do: [self undo]);
		addMorphBack: (SBButton new icon: SBIcon iconRepeat shortcut: (self class anyShortcutForAction: #redo) do: [self redo]);
		addMorphBack: (SBButton new
			icon: SBIcon iconFolder_open
			shortcut: (self class anyShortcutForAction: #openOpenWindow)
			do: [self openOpenWindow]);
		addMorphBack: (SBButton new
			icon: SBIcon iconPlus shortcut: nil do: [self promptAddArtifact];
			balloonText: 'Add artifact');
		addMorphBack: (Morph new
			height: 0;
			color: Color transparent;
			hResizing: #spaceFill);
		addMorphBack: (SBRow new
			addMorphBack: (SBButton new
				cornerStyle: #square;
				icon: SBIcon iconAlign_left shortcut: nil do: [self colorPolicy: SBTextColorPolicy new];
				balloonText: 'Text-like Layout');
			addMorphBack: (SBButton new
				cornerStyle: #square;
				icon: SBIcon iconTh shortcut: nil do: [self colorPolicy: SBColorMinimalPolicy new];
				balloonText: 'Compact Layout');
			addMorphBack: (SBButton new
				cornerStyle: #square;
				icon: SBIcon iconTh_large shortcut: nil do: [self colorPolicy: SBScratchColorPolicy new];
				balloonText: 'Scratch Layout'));
		addMorphBack: (SBButton new
			icon: SBIcon iconWindow_maximize shortcut: nil do: [self promptWorkspaceActions];
			balloonText: 'Manage Workspaces');
		addMorphBack: (SBButton new
			icon: SBIcon iconExpand
			shortcut: (self class anyShortcutForAction: #toggleFullscreen)
			do: [self toggleFullscreen])
]

{ #category : #ui }
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

{ #category : #'actions input' }
SBEditor >> cancelInput [
	" disregard the current input command and directly return to command mode (preserves shouldMergeWithNext of previous command) "
	<inputAction>

	| command input |
	(currentInput isNil or: [currentInputCommand isNil]) ifTrue: [^ self].
	command := currentInputCommand.
	input := currentInput.
	currentInput := nil.
	currentInputCommand := nil.
	
	input stopEditing: command.
	self mode: #command
]

{ #category : #accessing }
SBEditor >> canvas [

	^ scroll
]

{ #category : #actions }
SBEditor >> childSandblocksDo: aBlock [

	scroll scroller submorphsDo: [:b | b isSandblock ifTrue: [aBlock value: b]]
]

{ #category : #accessing }
SBEditor >> classes [

	^ scroll scroller submorphs select: [:morph | morph isSandblock and: [morph isClassContainer]]
]

{ #category : #'actions input' }
SBEditor >> clearInput [
	<inputAction>
	
	self textMorph clear
]

{ #category : #selection }
SBEditor >> clearMultiSelection [

	multiSelection do: [:b | b detachDecorators: SBMultiSelectionDecorator].
	multiSelection := OrderedCollection new
]

{ #category : #shortcuts }
SBEditor >> clearShortcuts [

	self shortcutsOverride: OrderedCollection new
]

{ #category : #'initialize-release' }
SBEditor >> clearUndoStack [

	undoStack := OrderedCollection new.
	redoStack  := OrderedCollection new
]

{ #category : #selection }
SBEditor >> click: anEvent [

	self select: nil
]

{ #category : #actions }
SBEditor >> close [

	self containingWindow ifNotNil: #delete.
	self delete.
	self valueOfProperty: #previousWindow ifPresentDo: #delete
]

{ #category : #actions }
SBEditor >> closeAll [
	<action>
	
	scroll scroller hasSubmorphs ifTrue: [
		self do: (SBCombinedCommand newWith: (scroll submorphs collect: [:m | SBDeleteCommand newNonEdit target: m]))]
]

{ #category : #drawing }
SBEditor >> color [

	^ self colorPolicy ifNotNil: #colorForEditor ifNil: [Color white]
]

{ #category : #'initialize-release' }
SBEditor >> colorPolicy [

	^ colorPolicy
]

{ #category : #'initialize-release' }
SBEditor >> colorPolicy: aPolicy [

	colorPolicy := aPolicy.
	self allMorphsDo: #layoutChanged.
	self clearCache.
	paletteContainer clearCache.
	self changed
]

{ #category : #'initialize-release' }
SBEditor >> compileTime [

	^ self errors hasSubmorphs ifTrue: [#compileOnSave] ifFalse: [compileTime]
]

{ #category : #'as yet unclassified' }
SBEditor >> connectFrom: aMorph to: anotherMorph [

	scroll scroller addMorph: ((SBConnectorLine new connectorType: #dots)
		color: Color black;
		connect: aMorph to: anotherMorph;
		yourself)
]

{ #category : #selection }
SBEditor >> containingArtefact [

	^ nil
]

{ #category : #accessing }
SBEditor >> copyBuffer [

	^ copyBuffer
]

{ #category : #accessing }
SBEditor >> copyBuffer: aMorphOrCollection [

	| form list |
	list := (aMorphOrCollection isCollection ifTrue: [aMorphOrCollection] ifFalse: [{aMorphOrCollection}]) select: #canCopy.
	list ifEmpty: [^ self].
	
	copyBuffer := SBSelection new
		methodClass: (list first containingArtefact ifNotNil: #relatedClass);
		colorPolicy: self colorPolicy.
	
	list do: [:m | copyBuffer addMorphBack: m veryDeepCopy].
	form := copyBuffer imageForm.
	copyBufferPreview image: ((form scaledToHeight: self copyBufferPreviewSize y)" collectColors: [:c | c alpha: c alpha * 0.7]")
]

{ #category : #accessing }
SBEditor >> copyBufferPreviewSize [

	^ 120 @ (self fontToUse height * 1.5) rounded
]

{ #category : #accessing }
SBEditor >> countModifier [

	^ inputMapping countModifier
]

{ #category : #accessing }
SBEditor >> currentInput [

	^ currentInput
]

{ #category : #accessing }
SBEditor >> currentInputCommand [

	^ currentInputCommand
]

{ #category : #accessing }
SBEditor >> currentMethodMap [

	^ (self methods select: #exists) collect: [:method | method compiledMethod sandblocksFastHash -> method] as: Dictionary
]

{ #category : #actions }
SBEditor >> declareClassVariable: aString for: aClass [

	| class |
	class := self openClass: aClass.
	self do: ((SBInsertCommand newFor: class)
		container: class classVariables;
		index: class classVariables submorphCount + 1;
		morph: (SBStName contents: aString))
]

{ #category : #actions }
SBEditor >> declareInstanceVariable: aString for: aClass [

	| class |
	class := self openForEdit: aClass.
	self do: ((SBInsertCommand newFor: class)
		container: class instanceVariables;
		index: class instanceVariables submorphCount + 1;
		morph: (SBStName contents: aString))
]

{ #category : #'actions input' }
SBEditor >> deleteAfterCursor [
	<inputAction>

	self textMorph deleteAfterCursor
]

{ #category : #'actions input' }
SBEditor >> deleteBeforeCursor [
	"<inputAction>"

	self textMorph deleteBeforeCursor
]

{ #category : #actions }
SBEditor >> deleteBlock [
	<action>
	
	(UIManager default confirm: 'Are sure you want to close the editor?')
		ifTrue: [self close]
]

{ #category : #'submorphs-add/remove' }
SBEditor >> deleteCommandFor: aBlock [

	^ SBDeleteCommand newNonEdit target: aBlock
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
	
	self markChangesAfterCommand: aCommand.
	self updateVerticalSelectionPosition 
]

{ #category : #actions }
SBEditor >> doMultiSelection: aBlock [

	| command |
	command := aBlock value: self sortedMultiSelection.
	(command notNil and: [command valid]) ifTrue: [
		self do: command.
		(mode = #selection or: [mode = #continuousSelection]) ifTrue: [self endMultiSelection]]
]

{ #category : #actions }
SBEditor >> doMultiSelectionEach: aBlock [

	self doMultiSelection: [:sel | SBCombinedCommand newWith: (sel collect: aBlock thenSelect: #notNil)]
]

{ #category : #accessing }
SBEditor >> dragCopyBuffer: anEvent [

	anEvent hand grabMorph: self copyBuffer
]

{ #category : #'event handling' }
SBEditor >> dropFiles: anEvent [

	| numFiles |
	numFiles := anEvent contents.
	1
		to: numFiles
		do: [:i |
			(FileStream primDropRequestFileName: i) ifNotNil: [:name | | folderRef isFolder |
				folderRef := FileDirectory on: '/', name.
				isFolder := folderRef / '..' directoryExists: folderRef localName.
				isFolder
					ifTrue: [self handleDroppedFolder: folderRef event: anEvent]
					ifFalse: [self handleDroppedFile: folderRef name event: anEvent]]]
]

{ #category : #'actions input' }
SBEditor >> endInput [
	<inputAction>

	| command |
	(currentInput isNil or: [currentInputCommand isNil]) ifTrue: [^ self].
	command := currentInputCommand.
	self cancelInput.
	
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
	<multiSelectAction>

	self clearMultiSelection.
	self mode: #command
]

{ #category : #shortcuts }
SBEditor >> errorContextFor: anArtefact ifNone: anExceptionBlock [

	^ errors focusedArtefact = anArtefact ifTrue: [errors focusedContext] ifFalse: [anExceptionBlock value]
]

{ #category : #accessing }
SBEditor >> errors [

	^ errors
]

{ #category : #events }
SBEditor >> filterEvent: anEvent for: aMorph [

	anEvent isMouse ifTrue: [
		anEvent isMouseOver not ifTrue: [
			anEvent isMouseWheel ifTrue: [
				^ (ignoreNext ifNil: [false])
					ifTrue: [
						ignoreNext := false.
						anEvent hand sendMouseEvent: anEvent]
					ifFalse: [
						ignoreNext := true.
						anEvent]]].
		anEvent isMouseDown ifTrue: [anEvent hand newKeyboardFocus: self].
		^ anEvent].
	
	anEvent isKeystroke ifFalse: [^ anEvent ignore].
	
	anEvent keyValue = 251 ifTrue: [self toggleHelperTimer: anEvent type = #keyDown] ifFalse: [self removeHelperTimer].
	
	(self performShortcutFor: anEvent)
		ifTrue: [
			inputMapping handledEvent: anEvent in: self.
			^ anEvent ignore]
		ifFalse: [inputMapping unhandledEvent: anEvent in: self didHandle: [^ anEvent ignore]].
	
	anEvent wasHandled: false.
	^ anEvent ignore
]

{ #category : #accessing }
SBEditor >> fixedNumberOfChildren [

	^ false
]

{ #category : #'actions input' }
SBEditor >> focusNextSuggestion [
	<inputAction>
	
	self currentInput suggestionMenuDo: #next
]

{ #category : #'actions input' }
SBEditor >> focusPreviousSuggestion [
	<inputAction>
	
	self currentInput suggestionMenuDo: #previous
]

{ #category : #actions }
SBEditor >> goToMark [
	<action>

	self waitForLetterDo: [:letter |
		self allBlocksDo: [:morph | (morph withDecorator: SBMarkedDecorator do: [:mark | mark letter = letter ifTrue: [^ self select: morph]])]]
]

{ #category : #'as yet unclassified' }
SBEditor >> handleDroppedFile: name event: anEvent [

	^ FileStream
		readOnlyFileNamed: name
		do: [:file |
			file
				convertedFor: self objectInterfaceForDrop
				do: [:converted | self handleDroppedBlock: converted event: anEvent adding: true near: nil]]
]

{ #category : #'as yet unclassified' }
SBEditor >> handleDroppedFolder: aFileDirectory event: anEvent [

	aFileDirectory
		convertedFor: self objectInterfaceForDrop
		do: [:converted | self handleDroppedBlock: converted event: anEvent adding: true near: nil]
]

{ #category : #'event handling' }
SBEditor >> handleDroppedItem: anItem event: anEvent [

	self halt
]

{ #category : #'initialize-release' }
SBEditor >> initialize [

	super initialize.
	
	multiSelection := OrderedCollection new.
	colorPolicy := self class defaultColorPolicy new.
	compileTime := #compileOnSave.
	verticalSelectionPosition := 0.
	globalShortcutListeners := OrderedCollection new.
	inputMapping := self class newInputMapping.
	inputMapping applyFor: self.
	
	paletteContainer := SBUpdatingPaletteContainer new
		vResizing: #spaceFill;
		hResizing: #rigid;
		width: 330;
		yourself.
	
	self
		addKeyboardCaptureFilter: self;
		addMouseCaptureFilter: self;
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
		addMorphBack: (SBRow new
			changeTableLayout;
			hResizing: #spaceFill;
			vResizing: #spaceFill;
			addMorphBack: (scroll := self scrollerClass new
				hResizing: #spaceFill;
				vResizing: #spaceFill;
				yourself));
		addMorphBack: (bottomPanel := self buildBottomPanel);
		registerGlobalShortcutListener: self;
		registerGlobalShortcutListener: errors;
		resetState;
		when: #selectionChanged send: #selectionChanged: to: paletteContainer
]

{ #category : #actions }
SBEditor >> insertCommandRequest: anAfterBoolean near: aBlock [

	^ self openMorphInViewCommand: SBBlock new
]

{ #category : #selection }
SBEditor >> internalSelect: aBlock [

	aBlock ~= selection ifTrue: [ | previousSelection |
		previousSelection := selection.
		selection := aBlock.
		selection ifNotNil: [
			self updateVerticalSelectionPosition.
			selection
				attachDecorator: SBSelectionDecorator new;
				wasSelected;
				ensureVisible].
		
		previousSelection ifNotNil: [
			previousSelection
				detachDecorators: SBSelectionDecorator;
				wasDeselected].
		
		self mode = #continuousSelection ifTrue: [self addToMultiSelection: selection].
		
		self triggerEvent: #selectionChanged with: selection.
		self updateSelectionLabel]
]

{ #category : #input }
SBEditor >> interruptInputDuring: aBlock [

	| cursor |
	self selection ifNil: [^ aBlock value].
	
	cursor := self selection currentTextMorph ifNotNil: #cursor.
	self endInput.
	aBlock value.
	cursor ifNotNil: [self maybeStartInputAt: cursor]
]

{ #category : #accessing }
SBEditor >> isMethodOpen: aCompiledMethod [

	^ self methods anySatisfy: [:method | method selector = aCompiledMethod selector and: [method methodClass = aCompiledMethod methodClass]]
]

{ #category : #accessing }
SBEditor >> keepVerticalSelectionPositionDuring: aBlock [

	| restore |
	restore := verticalSelectionPosition.
	aBlock ensure: [verticalSelectionPosition := restore]
]

{ #category : #events }
SBEditor >> keyboardFocusChange: aBoolean [

	self triggerEvent: #keyboardFocusChanged with: aBoolean
]

{ #category : #accessing }
SBEditor >> labelString [

	^ 'Editor', (workspace ifNotNil: [:w | ' - ', w name] ifNil: [''])
]

{ #category : #'initialize-release' }
SBEditor >> markChangesAfterCommand: aCommand [

	aCommand wasEdit ifTrue: [
		aCommand affectedArtefacts do: [:candidate | | saved artefact |
			artefact := candidate canPersist ifTrue: [candidate] ifFalse: [candidate artefactForPersisting ifNil: [candidate]].
			
			saved := false.
			self compileTime = #compileOnChange ifTrue: [saved := self save: artefact tryFixing: false quick: false].
			artefact hasUnsavedChanges: saved not.
			artefact triggerEvent: #changed.
			self allBlocksDo: [:block | block artefactChanged: artefact]]]
]

{ #category : #input }
SBEditor >> maybeStartInputAt: aNumber [

	inputMapping defaultState = #input ifTrue: [
		self selection currentTextMorph ifNotNil: [:textMorph |
			self startInput: self selection at: aNumber replacingContents: false]]
]

{ #category : #input }
SBEditor >> maybeStartInputFromEnd [

	inputMapping defaultState = #input ifTrue: [
		self startInput: self selection at: 9e8 replacingContents: false]
]

{ #category : #input }
SBEditor >> maybeStartInputFromStart [

	inputMapping defaultState = #input ifTrue: [
		self startInput: self selection at: 0 replacingContents: false]
]

{ #category : #input }
SBEditor >> maybeStartInputNear: aPoint [

	inputMapping defaultState = #input ifTrue: [
		self selection currentTextMorph ifNotNil: [:textMorph |
			self startInput: self selection at: (textMorph cursorIndexForPosition: aPoint) replacingContents: false]]
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

	^ self allBlocksSelect: [:block | block object isCompiledMethod]
]

{ #category : #accessing }
SBEditor >> mode [

	^ mode
]

{ #category : #accessing }
SBEditor >> mode: aSymbol [

	self clearMultiSelection.
		
	aSymbol = #input ifTrue: [self assert: currentInput notNil] ifFalse: [self assert: currentInput isNil].
	(aSymbol = #selection or: [aSymbol = #continuousSelection]) ifFalse: [self assert: multiSelection isEmpty].
	
	mode := aSymbol.
	modeLabel contents: (mode caseOf: {
		([#input] -> ['INPUT']).
		([#selection] -> ['SELECTION']).
		([#continuousSelection] -> ['CONT. SELECTION']).
		([#command] -> ['COMMAND'])
	}).
	bottomPanel color: (mode caseOf: {
		([#input] -> [Color red alpha: 0.2]).
		([#selection] -> [Color blue alpha: 0.2]).
		([#continuousSelection] -> [Color blue alpha: 0.2]).
		([#command] -> [Color white])
	}).
	self selection ifNotNil: [:s | s invalidRect: (s outerBounds expandBy: 4)].
	self updateSelectionLabel
]

{ #category : #'initialize-release' }
SBEditor >> modelWakeUp [

	" when our window takes focus again and we're detached, bring us back to the front "
	Project current addDeferredUIMessage: [
		self valueOfProperty: #previousWindow ifPresentDo: [:window | self owner addMorphFront: self]]
]

{ #category : #'actions input' }
SBEditor >> moveCursorDown [
	<inputAction>

	self textMorph moveCursorVertically: 1 ifAtBound: [ | next |
		next := self selection nextVerticalNear: self sandblockEditor verticalSelectionPosition.
		next ifNotNil: [self startInput: next at: 9e8 replacingContents: false]]
]

{ #category : #'actions input' }
SBEditor >> moveCursorLeft [
	<inputAction>

	self textMorph
		moveCursor: -1
		ifAtBound: [ | next |
			next := self class navigation previousFrom: self selection do: [:b |
				(self selection canJumpTo: b) ifTrue: [b] ifFalse: [nil]].
			next ifNotNil: [self select: next; startInput: next at: 900000000 replacingContents: false]]
		wordWise: (ActiveEvent commandKeyPressed or: [ActiveEvent controlKeyPressed])
]

{ #category : #'actions input' }
SBEditor >> moveCursorRight [
	<inputAction>

	self textMorph
		moveCursor: 1
		ifAtBound: [ | next |
			next := self class navigation nextFrom: self selection do: [:b |
				(self selection canJumpTo: b) ifTrue: [b] ifFalse: [nil]].
			next ifNotNil: [self select: next; startInput: next at: 0 replacingContents: false]]
		wordWise: (ActiveEvent commandKeyPressed or: [ActiveEvent controlKeyPressed])
]

{ #category : #'actions input' }
SBEditor >> moveCursorToEnd [
	<inputAction>

	self textMorph moveCursorTo: 9e8
]

{ #category : #'actions input' }
SBEditor >> moveCursorToStart [
	<inputAction>

	self textMorph moveCursorTo: 1
]

{ #category : #'actions input' }
SBEditor >> moveCursorUp [
	<inputAction>

	self textMorph moveCursorVertically: -1 ifAtBound: [ | next |
		next := self selection previousVerticalNear: self sandblockEditor verticalSelectionPosition.
		next ifNotNil: [self startInput: next at: 9e8 replacingContents: false]]
]

{ #category : #selection }
SBEditor >> multiSelection [

	^ (mode = #selection or: [mode = #continuousSelection])
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
	<action>

	searchInput nextResult
]

{ #category : #selection }
SBEditor >> noteNewOwner: aMorph [

	" ignore "
]

{ #category : #accessing }
SBEditor >> object [

	^ nil
]

{ #category : #'object interface' }
SBEditor >> objectInterface [

	^ SBInterfaces never
]

{ #category : #accessing }
SBEditor >> objectInterfaceAt: aNumber adding: aBoolean [

	^ SBInterfaces block, SBInterfaces topLevel
]

{ #category : #actions }
SBEditor >> okToChange [

	^ self unsavedChanges not or: [UIManager default confirm: 'Discard unsaved changes?']
]

{ #category : #actions }
SBEditor >> open: anObject [

	^ self open: anObject withInterfaces: #()
]

{ #category : #'as yet unclassified' }
SBEditor >> open: anObject withInterfaces: aCollection [

	^ self blockFor: anObject withInterfaces: aCollection ifOpen: #select ifClosed: [
		anObject
			convertedFor: (self objectInterfaceAt: 1 adding: true), aCollection
			do: [:repr | self openMorphInView: repr]]
]

{ #category : #actions }
SBEditor >> openAll: aCollection [

	aCollection do: [:object | self open: object]
]

{ #category : #actions }
SBEditor >> openClass: aClass [

	| cl |
	cl := self open: aClass.
	aClass methodsDo: [:m | self open: m].
	^ cl
]

{ #category : #actions }
SBEditor >> openCompiledMethod: aMethod [

	^ self methods
		detect: [:m | m selector = aMethod selector and: [m methodClass = aMethod methodClass]]
		ifFound: [:m | m select]
		ifNone: [self openMorphInView: aMethod asSandblock]
]

{ #category : #'as yet unclassified' }
SBEditor >> openForEdit: anObject [

	^ self open: anObject withInterfaces: SBInterfaces editor
]

{ #category : #'initialize-release' }
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

{ #category : #'submorphs-add/remove' }
SBEditor >> openMorph: aMorph [

	scroll scroller addMorphFront: aMorph
]

{ #category : #'submorphs-add/remove' }
SBEditor >> openMorphInView: aMorph [

	self do: (self openMorphInViewCommand: aMorph).
	^ aMorph
]

{ #category : #'submorphs-add/remove' }
SBEditor >> openMorphInViewCommand: aMorph [

	| position |
	position := scroll scroller offset + (self extent // 2).
	^ SBInsertCommand newNonEdit
		index: 1;
		container: scroll scroller;
		morph: (aMorph
			fullBounds;
			center: position;
			yourself);
		yourself
]

{ #category : #actions }
SBEditor >> openOpenWindow [
	<action>

	| selected |
	selected := self selectedArtefact.
	((selected notNil and: [selected object isCompiledCode or: [selected object isBehavior]])
		ifTrue: [SBStCodeOpener new colorPolicy: self colorPolicy; positionNear: self; openFor: selected object]
		ifFalse: [SBStCodeOpener new colorPolicy: self colorPolicy; positionNear: self; open]) ifNotNil: [:methodOrClass | self openForEdit: methodOrClass]
]

{ #category : #'submorphs-add/remove' }
SBEditor >> openPopup: aMorph [

	aMorph disableLayout: true.
	self addMorphFront: aMorph
]

{ #category : #actions }
SBEditor >> openProfiler [
	<action>

	self openMorphInView: SBProfiler new
]

{ #category : #'initialize-release' }
SBEditor >> outOfWorld: aWorld [

	super outOfWorld: aWorld.
	
	helpOverlay ifNotNil: #delete
]

{ #category : #accessing }
SBEditor >> parentSandblock [

	^ nil
]

{ #category : #shortcuts }
SBEditor >> perform: anAction for: aBlock event: anEvent [
	"
	we used to have a distinction in action that are valid only in input or select mode
	
	((mode = #selection or: [mode = #continuousSelection]) and: [(method pragmaAt: #multiSelectAction) notNil]) or: [
		(mode = #command and: [
		(method pragmaAt: #multiSelectAction) notNil or: [(method pragmaAt: #action) notNil]]) or: [
		mode = #input and: [(method pragmaAt: #inputAction) notNil]]]]."

	(aBlock lookupAction: anAction) ifNotNil: [:method | | validShortcut validMode validInvocation |
		validShortcut := mode ~= #input or: [anEvent anyModifierKeyPressed or: [anEvent keyCharacter isLikelyUnmodifiedOnKeyboard not]].
		validMode := method pragmas anySatisfy: [:p | (mode = #input ifTrue: [#(#action #inputAction #multiSelectAction)] ifFalse: [#(#action #multiSelectAction)]) includes: p keyword].
		validInvocation := (method pragmaAt: #actionValidIf:) ifNotNil: [:pragma | aBlock perform: pragma arguments first] ifNil: [true].
		
		(validShortcut and: [validMode and: [validInvocation]]) ifTrue: [
			aBlock performAction: anAction.
			^ true]].
	^ false
]

{ #category : #shortcuts }
SBEditor >> performForSelection: anActionSymbol [

	self perform: anActionSymbol for: self selection event: (KeyboardEvent new
		setType: #keystroke
		buttons: 64
		position: 0 @ 0
		keyValue: $a
		hand: nil
		stamp: nil)
]

{ #category : #shortcuts }
SBEditor >> performShortcutFor: anEvent [

	self shortcuts do: [:assoc |
		(assoc key matchesEvent: anEvent) ifTrue: [
			(self selection notNil and: [self perform: assoc value for: self selection event: anEvent]) ifTrue: [^ true].
			
			globalShortcutListeners do: [:listener |
				(self perform: assoc value for: listener event: anEvent) ifTrue: [^ true]]]].
	
	mode = #input ifTrue: [
		currentInput keyStroke: anEvent.
		^ true].
	
	^ false
]

{ #category : #'as yet unclassified' }
SBEditor >> promptAddArtifact [

	| index pragmas |
	pragmas := Pragma allNamed: #addAction from: self class to: Object.
	index := UIManager default chooseFrom: (pragmas collect: [:p | (p method pragmaAt: #label:) ifNotNil: [:label | label arguments first] ifNil: [p selector]]).
	
	index > 0 ifTrue: [self perform: (pragmas at: index) selector]
]

{ #category : #'as yet unclassified' }
SBEditor >> promptChangeColorPolicy [

	| policy |
	policy := (UIManager default chooseFrom: SBColorPolicy withAllSubclasses values: SBColorPolicy withAllSubclasses) ifNil: [^ self].
	self class defaultColorPolicy: policy.
	self colorPolicy: policy new
]

{ #category : #'initialize-release' }
SBEditor >> promptChangeCompile [

	| index labels |
	labels := {'Compile on save'. 'Compile on change'}.
	index := UIManager default chooseFrom: labels.
	index < 1 ifTrue: [^ self].
	
	compileTime := index = 1 ifTrue: [#compileOnSave] ifFalse: [#compileOnChange]
]

{ #category : #actions }
SBEditor >> promptMenu [
	<action>

	| options |
	options := {
		({'Change UI Theme'. [self promptChangeColorPolicy]}).
		({'Reset UI Theme'. [self resetColorPolicy]}).
		({'Change Compile Method'. [self promptChangeCompile]}).
		({'New Class'. [self createEmptySmalltalkClass]}).
	}.
	(UIManager default chooseFrom: (options collect: #first) values: (options collect: #second)) ifNotNil: #value
]

{ #category : #workspaces }
SBEditor >> promptOpenWorkspace [
	<action>

	| items index |
	items := SBWorkspaceHistory default items.
	index := UIManager default chooseFrom: items.
	index = 0 ifTrue: [^ self].
	self close.
	(items at: index) open
]

{ #category : #workspaces }
SBEditor >> promptWorkspaceActions [

	| index |
	index := UIManager default chooseFrom: {
		('Open Workspace ', (self class shortcutStringForAction: #promptOpenWorkspace)).
		('Save Workspace ', (self class shortcutStringForAction: #saveWorkspace))
	}.
	index = 1 ifTrue: [^ self promptOpenWorkspace].
	index = 2 ifTrue: [^ self saveWorkspace]
]

{ #category : #actions }
SBEditor >> redo [
	<action>
	<inputAction>

	| command |
	redoStack ifNotEmpty: [
		command := redoStack removeLast.
		undoStack addLast: command.
		self select: command do.
		self markChangesAfterCommand: command]
]

{ #category : #actions }
SBEditor >> refocus [
	<multiSelectAction>

	self selection ifNotNil: #ensureVisible
]

{ #category : #'initialize-release' }
SBEditor >> registerGlobalShortcutListener: aMorph [

	globalShortcutListeners add: aMorph
]

{ #category : #shortcuts }
SBEditor >> registerShortcut: aShortcut do: aSymbol [

	self shortcuts add: aShortcut asSandblockShortcut -> aSymbol
]

{ #category : #helper }
SBEditor >> removeHelperTimer [

	helpOverlay ifNotNil: #delete.
	helpOverlay := nil.
	self removeAlarm: #showHelper
]

{ #category : #actions }
SBEditor >> removeMultiSelected: aMorph [

	aMorph detachDecorators: SBMultiSelectionDecorator.
	multiSelection remove: aMorph.
	multiSelection ifEmpty: [self mode: #command]
]

{ #category : #input }
SBEditor >> replaceInput: aMorph [
	" inform the editor that the current input morph has been replaced by another where input should continue "

	self assert: currentInput notNil.
	currentInput := aMorph.
	self select: aMorph containingSandblock
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

{ #category : #'as yet unclassified' }
SBEditor >> resetColorPolicy [

	self colorPolicy: self class defaultColorPolicy new
]

{ #category : #'initialize-release' }
SBEditor >> resetState [

	self clearUndoStack.
	
	"self inputMapping resetState."
	selectionDownHistory := OrderedCollection new.
	selection := nil.
	self mode: #command.
	
	colorPolicy := colorPolicy class new
]

{ #category : #actions }
SBEditor >> resetZoom [
	<multiSelectAction>

	scroll scale: 1.
	scroll viewportPosition: scroll currentPosition rounded
]

{ #category : #accessing }
SBEditor >> sandblockEditor [

	^ self
]

{ #category : #actions }
SBEditor >> save [
	<action>
	<inputAction>

	self interruptInputDuring: [
		self selection ifNotNil: [
			self selection artefactForPersisting ifNotNil: [:a |
				self save: a tryFixing: true quick: false]]]
]

{ #category : #artefacts }
SBEditor >> save: anArtefact tryFixing: aFixBoolean quick: aQuickBoolean [

	^ (anArtefact saveTryFixing: aFixBoolean quick: aQuickBoolean)
		ifTrue: [
			anArtefact hasUnsavedChanges: false.
			self triggerEvent: #artefactSaved with: anArtefact.
			self allBlocksDo: [:block | block artefactSaved: self selectedArtefact].
			true]
		ifFalse: [false]
]

{ #category : #workspaces }
SBEditor >> saveWorkspace [
	<action>

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

	(aBlock isMorph not or: [aBlock hasOwner: scroll scroller]) ifTrue: [
		scroll scrollToShow: aBlock]
]

{ #category : #accessing }
SBEditor >> scrollerClass [

	^ SBEditorCanvas
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
SBEditor >> selectClick: aBlock at: aPoint [

	aBlock select.
	self maybeStartInputNear: aPoint
]

{ #category : #artefacts }
SBEditor >> selectToplevelTowards: aSideSymbol [

	self submorphs detect: [:m | m isSandblock] ifFound: #select ifNone: []
]

{ #category : #artefacts }
SBEditor >> selectedArtefact [

	^ (self selection ifNotNil: #containingArtefact) ifNil: [self methods ifNotEmpty: #first ifEmpty: [nil]]
]

{ #category : #selection }
SBEditor >> selection [

	^ selection ifNotNil: [selection owner ifNil: [nil] ifNotNil: [selection]]
]

{ #category : #accessing }
SBEditor >> selectionDownHistory [

	^ selectionDownHistory
]

{ #category : #shortcuts }
SBEditor >> shortcuts [

	^ self valueOfProperty: #shortcutsOverride ifAbsent: [self class shortcuts]
]

{ #category : #shortcuts }
SBEditor >> shortcutsOverride: aCollection [

	self setProperty: #shortcutsOverride toValue: aCollection
]

{ #category : #helper }
SBEditor >> showHelper [

	(helpOverlay isNil and: [self isInWorld and: [self selection notNil]]) ifTrue: [helpOverlay := SBHelpOverlay new target: self selection]
]

{ #category : #selection }
SBEditor >> sortedMultiSelection [

	| unsorted order |
	unsorted := self multiSelection.
	unsorted size < 2 ifTrue: [^ unsorted].
	
	order := self allMorphs.
	^ unsorted sort: [:a :b | (order indexOf: a) < (order indexOf: b)]
]

{ #category : #accessing }
SBEditor >> startDrag: anEvent [

	" ignored "
]

{ #category : #input }
SBEditor >> startInput: aMorph at: aNumber replacingContents: aBoolean [

	aMorph ifNil: [^ nil].
	
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
SBEditor >> startOrAddToMultiSelection: aBlock [

	mode = #selection ifTrue: [
		^ (multiSelection includes: aBlock)
			ifTrue: [self removeMultiSelected: aBlock]
			ifFalse: [self addToMultiSelection: aBlock]].
	
	self mode: #selection.
	self addToMultiSelection: aBlock
]

{ #category : #actions }
SBEditor >> startSearch [
	<action>

	searchInput startSearch
]

{ #category : #actions }
SBEditor >> storeOn: aStream [

	aStream
		nextPut: $(;
		nextPutAll: self className;
		nextPutAll: ' new'.
	scroll scroller submorphs do: [:morph |
		aStream cr.
		aStream nextPutAll: 'openMorph: '.
		morph storeOn: aStream.
		aStream nextPut: $;].
	aStream nextPutAll: 'yourself)'
]

{ #category : #selection }
SBEditor >> submorphsAreConsecutive: aCollection [

	| sorted order |
	order := self allMorphs.
	sorted := aCollection sort: [:a :b | (order indexOf: a) < (order indexOf: b)].
	
	sorted overlappingPairsDo: [:a :b |
		a submorphAfter = b ifFalse: [^ false]].
	
	^ true
]

{ #category : #accessing }
SBEditor >> textMorph [

	^ currentInput currentTextMorph
]

{ #category : #actions }
SBEditor >> toggleFullscreen [
	<action>

	self owner = self world
		ifTrue: [
			(self valueOfProperty: #previousWindow) addMorph: self frame: (0@0 extent: 1@1).
			self removeProperty: #previousWindow]
		ifFalse: [
			self
				setProperty: #previousWindow toValue: self owner;
				openInWorld;
				extent: Display extent;
				position: 0 @ 0]
]

{ #category : #helper }
SBEditor >> toggleHelperTimer: aBoolean [

	aBoolean
		ifTrue: [
			self addAlarm: #showHelper after: 1 second asMilliSeconds]
		ifFalse: [self removeHelperTimer]
]

{ #category : #actions }
SBEditor >> togglePalette [
	<action>
	
	paletteContainer owner ifNotNil: [paletteContainer delete] ifNil: [self submorphs third addMorphFront: paletteContainer]
]

{ #category : #actions }
SBEditor >> undo [
	<action>
	<inputAction>

	| command |
	self endInput.
	
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
				ifTrue: [self selection selectionLabel]
				ifFalse: ['']])
]

{ #category : #selection }
SBEditor >> updateVerticalSelectionPosition [

	selection ifNotNil: [
		verticalSelectionPosition := selection center x - (selection containingArtefact ifNotNil: [:a | a left] ifNil: [0])]
]

{ #category : #input }
SBEditor >> useTextInput [

	inputMapping := SBTextInputMapping new.
	inputMapping applyFor: self
]

{ #category : #input }
SBEditor >> useVimInput [

	inputMapping := SBVimInputMapping new.
	inputMapping applyFor: self
]

{ #category : #accessing }
SBEditor >> verticalSelectionPosition [

	^ verticalSelectionPosition
]

{ #category : #actions }
SBEditor >> waitForLetterDo: aBlock [

	| delay character |
	delay := Delay forMilliseconds: 50.
	[
		Sensor anyButtonPressed not and: [(character := Sensor peekKeyboard) isNil]] whileTrue: [delay wait].
	character ifNotNil: [
		character isLetter ifTrue: [aBlock value: character]]
]

{ #category : #'event handling' }
SBEditor >> wantsDropFiles: anEvent [

	^ true
]

{ #category : #actions }
SBEditor >> wantsKeyboardFocus [

	^ true
]

{ #category : #workspaces }
SBEditor >> workspace: aWorkspaceRecord [

	workspace := aWorkspaceRecord.
	self changed: #relabel
]
