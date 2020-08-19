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
		'helpOverlay',
		'verticalSelectionPosition',
		'countModifier',
		'globalShortcutListeners'
	],
	#classVars : [
		'DefaultColorPolicy',
		'Shortcuts'
	],
	#category : #'Sandblocks-Core'
}

{ #category : #'initialize-release' }
SBEditor class >> anyShortcutForAction: aSymbol [

	^ (self shortcutsForAction: aSymbol) ifNotEmpty: #first ifEmpty: [nil]
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

	self registerDefaultShortcuts
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
	
	Shortcuts := nil.
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
		
		" refactor "
		registerShortcut: $T do: #extractMethod;
		registerShortcut: $t do: #createEmptyMethod;
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
		registerShortcut: $c command do: #openOpenWindow;
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
		(self shortcutsForAction: anAction) do: [:shortcut | shortcut printDisplayOn: stream] separatedBy: [stream space].
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
		addCommandShortcut: $t do: #createEmptyMethod.
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

	multiSelection copy do: [:morph | (morph hasOwner: aBlock) ifTrue: [self removeMultiSelected: morph]].
	
	aBlock allOwnersDo: [:morph | (multiSelection includes: morph) ifTrue: [self removeMultiSelected: morph]].
	
	multiSelection add: aBlock.
	aBlock attachDecorator: SBMultiSelectionDecorator new.
	self triggerEvent: #selectionChanged with: selection.
	self updateSelectionLabel
]

{ #category : #accessing }
SBEditor >> allActiveMorphExamples [

	^ Array streamContents: [:stream |
		self allBlocksDo: [:b | (b isMorphExample and: [b visible]) ifTrue: [stream nextPut: b]]]
]

{ #category : #actions }
SBEditor >> anyNearbyClass [

	| artefacts |
	artefacts := self artefacts.
	artefacts ifEmpty: [^ UndefinedObject].
	
	^ (self selection ifNotNil: #containingArtefact ifNil: [artefacts first]) relatedClass
]

{ #category : #actions }
SBEditor >> artefacts [

	^ scroll submorphs select: [:s | s isSandblock and: [s isArtefact]]
]

{ #category : #artefacts }
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
		"addMorphBack: (compileTimeButton := StringMorph new
			contents: 'Compile on save';
			on: #click send: #promptChangeCompile to: self);"
		addMorphBack: (SBButton new
			balloonText: 'Copy';
			icon: SBIcon iconCopy shortcut: (self class anyShortcutForAction: #copyToBuffer) do: [self selection copyToBuffer]);
		addMorphBack: (SBButton new
			balloonText: 'Copy around';
			icon: SBIcon iconClipboard
				shortcut: (self class anyShortcutForAction: #copyAround)
				do: [self selection copyAround]);
		addMorphBack: (copyBufferPreview := ImageMorph new image: (Form extent: 1 @ 1));
		yourself
]

{ #category : #ui }
SBEditor >> buildCommandBar [

	^ SBRow new
		changeTableLayout;
		hResizing: #spaceFill;
		cellGap: 4 withScalingFactor;
		layoutInset: 4 withScalingFactor;
		addMorphBack: (SBButton new icon: SBIcon iconUndo shortcut: (self class anyShortcutForAction: #undo) do: [self undo]);
		addMorphBack: (SBButton new icon: SBIcon iconRepeat shortcut: (self class anyShortcutForAction: #redo) do: [self redo]);
		addMorphBack: (SBButton new icon: SBIcon iconFolder_open shortcut: (self class anyShortcutForAction: #openOpenWindow) do: [self openOpenWindow]);
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
		addMorphBack: (SBButton new icon: SBIcon iconExpand shortcut: (self class anyShortcutForAction: #toggleFullscreen) do: [self toggleFullscreen])
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

{ #category : #actions }
SBEditor >> childSandblocksDo: aBlock [

	scroll submorphsDo: [:b | b isSandblock ifTrue: [aBlock value: b]]
]

{ #category : #accessing }
SBEditor >> classes [

	^ scroll submorphs select: [:morph | morph isSandblock and: [morph isClassContainer]]
]

{ #category : #'actions input' }
SBEditor >> clearInput [
	<inputAction>
	
	self textMorph clear
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

{ #category : #actions }
SBEditor >> closeAll [
	<action>
	
	scroll hasSubmorphs ifTrue: [
		self do: (SBCombinedCommand newWith: (scroll submorphs collect: [:m | SBDeleteCommand newNonEdit target: m]))]
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
	self allMorphsDo: #layoutChanged.
	self clearCache.
	self changed
]

{ #category : #'as yet unclassified' }
SBEditor >> connectFrom: aMorph to: anotherMorph [

	scroll addMorph: ((SBConnectorLine new connectorType: #dots)
		color: Color black;
		connect: aMorph to: anotherMorph;
		yourself)
]

{ #category : #selection }
SBEditor >> containingArtefact [

	^ nil
]

{ #category : #accessing }
SBEditor >> contextAcceptedRepresentationAt: aNumber [

	^ #isToplevelMorph
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
	"copyBufferPreview image: ((form scaledIntoFormOfSize: (self copyBufferPreviewSize min: form extent)) collectColors: [:c | c alpha: c alpha * 0.7])."
	copyBufferPreview image: ((form scaledToHeight: self copyBufferPreviewSize y) collectColors: [:c | c alpha: c alpha * 0.7])
]

{ #category : #accessing }
SBEditor >> copyBufferPreviewSize [

	^ 120 @ (self fontToUse height * 1.5) rounded
]

{ #category : #accessing }
SBEditor >> countModifier [

	^ countModifier ifEmpty: [0] ifNotEmpty: [countModifier asNumber]
]

{ #category : #actions }
SBEditor >> createEmptyClass [
	<action>

	| class |
	class := SBClass new category: (self anyNearbyClass ifNotNil: #category ifNil: ['UserObjects']).
	self openMorphInView: class.
	self startInput: class childSandblocks first at: 1 replacingContents: false
]

{ #category : #actions }
SBEditor >> createEmptyMethod [
	<action>

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
		mode = #selection ifTrue: [self endMultiSelection]]
]

{ #category : #actions }
SBEditor >> doMultiSelectionEach: aBlock [

	self doMultiSelection: [:sel | SBCombinedCommand newWith: (sel collect: aBlock thenSelect: #notNil)]
]

{ #category : #'actions input' }
SBEditor >> endInput [
	<inputAction>

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
	<multiSelectAction>

	multiSelection do: [:b | b detachDecorators: SBMultiSelectionDecorator].
	multiSelection := OrderedCollection new.
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
		anEvent isMouseDown ifTrue: [anEvent hand newKeyboardFocus: self].
		^ anEvent].
	
	anEvent isKeystroke ifFalse: [^ anEvent ignore].
	
	anEvent keyValue = 251 ifTrue: [self toggleHelperTimer: anEvent type = #keyDown] ifFalse: [self removeHelperTimer].
	
	(self performShortcutFor: anEvent)
		ifTrue: [
			countModifier := ''.
			^ anEvent ignore]
		ifFalse: [
			anEvent keyCharacter isDigit ifTrue: [
				countModifier := countModifier, anEvent keyCharacter.
				^ anEvent ignore]].
	
	anEvent wasHandled: false.
	^ anEvent ignore
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

{ #category : #'submorphs-add/remove' }
SBEditor >> handleDroppedBlock: aMorph event: anEvent [

	aMorph object representIn: self as: #isToplevelMorph near: ((scroll transformFrom: nil) globalPointToLocal: anEvent position)
]

{ #category : #'initialize-release' }
SBEditor >> initialize [

	super initialize.
	
	singleSelectionShortcuts := OrderedCollection new.
	multiSelectionShortcuts := OrderedCollection new.
	commandShortcuts := OrderedCollection new.
	inputShortcuts := OrderedCollection new.
	multiSelection := OrderedCollection new.
	colorPolicy := self class defaultColorPolicy new.
	compileTime := #compileOnSave.
	verticalSelectionPosition := 0.
	countModifier := ''.
	globalShortcutListeners := OrderedCollection new.
	
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
		"addMorphBack: self buildDebugCommandBar;"
		
		addMorphBack: (scroll := SBEditorCanvas new
			hResizing: #spaceFill;
			vResizing: #spaceFill;
			yourself);
		
		addMorphBack: (bottomPanel := self buildBottomPanel);
		
		registerGlobalShortcutListener: self;
		registerGlobalShortcutListener: errors;
		
		resetState
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
		self triggerEvent: #selectionChanged with: selection.
		self updateSelectionLabel]
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

	^ 'Sandblocks Editor', (workspace ifNotNil: [:w | ' - ', w name] ifNil: [''])
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

{ #category : #actions }
SBEditor >> methodForContext: aContext ifOpen: aBlock ifClosed: anotherBlock [

	^ self methods
		detect: [:m | m methodClass = aContext methodClass and: [m selector = aContext selector]]
		ifFound: aBlock
		ifNone: anotherBlock
]

{ #category : #accessing }
SBEditor >> methods [

	^ scroll submorphs select: [:morph | morph isSandblock and: [morph object isCompiledMethod]]
]

{ #category : #accessing }
SBEditor >> mode [

	^ mode
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
SBEditor >> moveCursorLeft [
	<inputAction>

	self textMorph moveCursor: -1
]

{ #category : #'actions input' }
SBEditor >> moveCursorRight [
	<inputAction>

	self textMorph moveCursor: 1
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

{ #category : #actions }
SBEditor >> okToChange [

	^ self unsavedChanges not or: [UIManager default confirm: 'Discard unsaved changes?']
]

{ #category : #actions }
SBEditor >> open: anObject [

	^ scroll submorphs
		detect: [:morph | morph isSandblock and: [morph object = anObject]]
		ifFound: #select
		ifNone: [
		 	anObject
				representIn: self
				as: #isToplevelMorph
				near: scroll offset + (self extent // 2)]
]

{ #category : #actions }
SBEditor >> openAll: aCollection [

	aCollection do: [:object | self open: object]
]

{ #category : #actions }
SBEditor >> openClass: aClass [

	self open: aClass.
	aClass methodsDo: [:m | self open: m]
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

{ #category : #'submorphs-add/remove' }
SBEditor >> openMorph: aMorph [

	scroll addMorphFront: aMorph
]

{ #category : #'submorphs-add/remove' }
SBEditor >> openMorphInView: aMorph [

	self do: (self openMorphInViewCommand: aMorph).
	^ aMorph
]

{ #category : #'submorphs-add/remove' }
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
	<action>

	| selected |
	selected := self selectedArtefact.
	((selected notNil and: [selected artefact isCompiledCode or: [selected artefact isBehavior]])
		ifTrue: [SBCodeOpener new positionNear: self; openFor: selected artefact]
		ifFalse: [SBCodeOpener new positionNear: self; open]) ifNotNil: [:methodOrClass | self open: methodOrClass]
]

{ #category : #actions }
SBEditor >> openProfiler [
	<action>

	self openMorphInView: SBProfiler new
]

{ #category : #actions }
SBEditor >> openRepl [
	<action>

	| repl |
	repl := self openMorphInView: SBRepl new.
	self startInput: repl body childSandblocks first at: 1 replacingContents: true
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
SBEditor >> perform: anAction for: aBlock [

	(aBlock lookupAction: anAction) ifNotNil: [:method |
		(((mode = #selection and: [(method pragmaAt: #multiSelectAction) notNil]) or: [
			(mode = #command and: [
				(method pragmaAt: #multiSelectAction) notNil or: [(method pragmaAt: #action) notNil]]) or: [
				mode = #input and: [(method pragmaAt: #inputAction) notNil]]]) and: [
			(method pragmaAt: #actionValidIf:) ifNotNil: [:pragma | aBlock perform: pragma arguments first] ifNil: [true]]) ifTrue: [
			aBlock performAction: anAction.
			^ true]].
	^ false
]

{ #category : #shortcuts }
SBEditor >> performShortcutFor: anEvent [

	self shortcuts do: [:assoc |
		(assoc key matchesEvent: anEvent) ifTrue: [
			(self selection notNil and: [self perform: assoc value for: self selection]) ifTrue: [^ true].
			globalShortcutListeners do: [:listener |
				(self perform: assoc value for: listener) ifTrue: [^ true]]]].
	
	mode = #input ifTrue: [
		currentInput keyStroke: anEvent.
		^ true].
	
	^ false
]

{ #category : #'as yet unclassified' }
SBEditor >> promptAddArtifact [

	| index |
	index := UIManager default chooseFrom: {
		('Add method ', (self class shortcutStringForAction: #createEmptyMethod)).
		('Add class ', (self class shortcutStringForAction: #createEmptyClass))
	}.
	
	index = 1 ifTrue: [^ self createEmptyMethod].
	index = 2 ifTrue: [^ self createEmptyClass]
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
	
	compileTimeButton contents: (labels at: index).
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
		({'New Class'. [self createEmptyClass]})
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
	selectionDownHistory := OrderedCollection new.
	selection := self methods ifNotEmpty: #first ifEmpty: [nil].
	colorPolicy := colorPolicy class new.
	self mode: #command
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

	self selection ifNotNil: [self save: self selectedArtefact tryFixing: true quick: false]
]

{ #category : #artefacts }
SBEditor >> save: anArtefact tryFixing: aFixBoolean quick: aQuickBoolean [

	^ (anArtefact saveTryFixing: aFixBoolean quick: aQuickBoolean)
		ifTrue: [
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
	scroll submorphs do: [:morph |
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
SBEditor >> undo [
	<action>

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
				ifTrue: [self selection selectionLabel]
				ifFalse: ['']])
]

{ #category : #selection }
SBEditor >> updateVerticalSelectionPosition [

	verticalSelectionPosition := selection center x - (selection containingArtefact ifNotNil: [:a | a left] ifNil: [0]).
]

{ #category : #accessing }
SBEditor >> verticalSelectionPosition [

	^ verticalSelectionPosition
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
SBEditor >> wantsKeyboardFocus [

	^ true
]

{ #category : #workspaces }
SBEditor >> workspace: aWorkspaceRecord [

	workspace := aWorkspaceRecord.
	self changed: #relabel
]
