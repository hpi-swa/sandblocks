Class {
	#name : #SBEditor,
	#superclass : #SBBlock,
	#instVars : [
		'selection',
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
		'colorPolicy',
		'bottomPanel',
		'compileTime',
		'errors',
		'searchInput',
		'helpOverlay',
		'verticalSelectionPosition',
		'globalShortcutListeners',
		'inputMapping',
		'ignoreNext',
		'paletteContainer',
		'history'
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

{ #category : #'action helpers' }
SBEditor >> addToMultiSelection: aBlock [

	multiSelection add: aBlock.
	multiSelection copy do: [:morph | (morph hasOwner: aBlock) ifTrue: [self removeMultiSelected: morph]].
	
	aBlock allOwnersDo: [:morph | (multiSelection includes: morph) ifTrue: [self removeMultiSelected: morph]].
	
	aBlock attachDecorator: SBMultiSelectionDecorator new.
	self triggerEvent: #selectionChanged with: selection.
	self updateSelectionLabel
]

{ #category : #accessing }
SBEditor >> artefacts [

	^ scroll scroller submorphs select: [:s | s isSandblock and: [s isArtefact]]
]

{ #category : #'do/undo/redo' }
SBEditor >> batchedChangeStep: aBlock [
	" send this message when you are updating the tree rapidly for each update, but don't want to submit a command for each update, only at the end "

	self compileTime = #compileOnChange ifTrue: [ | artefact |
		self save: aBlock containingArtefact tryFixing: false quick: true.
		artefact := self selectedArtefact.
		artefact triggerEvent: #changed.
		self allBlocksDo: [:block | block artefactChanged: artefact]]
]

{ #category : #'ast helpers' }
SBEditor >> binding: aString for: block class: aClass ifPresent: aBlock [

	Symbol hasInterned: aString ifTrue: [:sym | | binding |
		binding := aClass bindingOf: sym environment: aClass environment.
		binding ifNotNil: [^ aBlock value: ((SBStName poolDeclaration: aString) binding: binding)]].
	
	^ nil
]

{ #category : #ui }
SBEditor >> buildBottomPanel [

	searchInput := SBSearchPanel new.
	self registerGlobalShortcutListener: searchInput.

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
		addMorphBack: searchInput;
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

{ #category : #'insert/delete' }
SBEditor >> canDeleteChild: aBlock [

	" code containers might be inside of us, they can be freely deleted "
	^ true
]

{ #category : #'action helpers' }
SBEditor >> cancelInput [
	" disregard the current input command and directly return to command mode (preserves shouldMergeWithNext of previous command) "

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

{ #category : #hierarchy }
SBEditor >> childSandblocksDo: aBlock [

	scroll scroller submorphsDo: [:b | b isSandblock ifTrue: [aBlock value: b]]
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

{ #category : #'event handling' }
SBEditor >> click: anEvent [

	self select: nil
]

{ #category : #'as yet unclassified' }
SBEditor >> close [

	self containingWindow ifNotNil: #delete.
	self delete.
	self valueOfProperty: #previousWindow ifPresentDo: #delete
]

{ #category : #drawing }
SBEditor >> color [

	^ self colorPolicy ifNotNil: #colorForEditor ifNil: [Color white]
]

{ #category : #accessing }
SBEditor >> colorPolicy [

	^ colorPolicy
]

{ #category : #accessing }
SBEditor >> colorPolicy: aPolicy [

	colorPolicy := aPolicy.
	self allMorphsDo: #layoutChanged.
	self clearCache.
	paletteContainer clearCache.
	self changed
]

{ #category : #accessing }
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

{ #category : #hierarchy }
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

{ #category : #'submorphs-add/remove' }
SBEditor >> createArtefactInView: aMorph [
	" open this morph and mark it has currently being unsaved "

	self assert: aMorph isArtefact.
	
	self openMorphInView: aMorph.
	self do: (SBDoItCommand newFor: aMorph).
	^ aMorph
]

{ #category : #'actions creating' }
SBEditor >> createEmptyJavascriptModule [
	<addAction>
	<label: 'Javascript Module'>
	<globalAction>

	| module |
	self createArtefactInView: (module := SBJsModule new).
	module inputContainedUnknown
]

{ #category : #'actions creating' }
SBEditor >> createEmptySchemeModule [
	<addAction>
	<label: 'Scheme Module'>
	<globalAction>

	| module |
	self createArtefactInView: (module := SBScmModule new).
	module inputContainedUnknown
]

{ #category : #'actions creating' }
SBEditor >> createEmptySmalltalkClass [
	<addAction>
	<label: 'Smalltalk Class'>
	<globalAction>

	| class |
	class := SBStClass new category: ((self selectedArtefact ifNotNil: [:container | container relatedClass]) ifNotNil: #category ifNil: ['UserObjects']).
	self createArtefactInView: class.
	class inputContainedUnknown
]

{ #category : #'actions creating' }
SBEditor >> createEmptySmalltalkMethod [
	<addAction>
	<label: 'Smalltalk Method'>
	<globalAction>

	| method |
	self createArtefactInView: (method := SBStMethod new
		selector: ''
		arguments: #()
		class: ((self selectedArtefact ifNotNil: [:container | container relatedClass]) ifNil: [UIManager default chooseClassOrTrait ifNil: [^ self]]);
		body: (SBStBlockBody new in: [:b | b statements: {b newNullBlock}])).
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

{ #category : #actions }
SBEditor >> deleteBlock [
	<action>
	
	" ignored "
]

{ #category : #'submorphs-add/remove' }
SBEditor >> deleteCommandFor: aBlock [

	^ SBDeleteCommand newNonEdit target: aBlock
]

{ #category : #'action helpers' }
SBEditor >> do: aCommand [

	" the command may interrupt/replace an input "
	currentInputCommand notNil ifTrue: [self endInput].

	history do: aCommand previousSelection: self selection selectDo: [:block :artefacts |
		self select: block.
		self markChangesAfterCommand: artefacts.
		self updateVerticalSelectionPosition]
]

{ #category : #'action helpers' }
SBEditor >> doMultiSelection: aBlock [

	| command |
	command := aBlock value: self sortedMultiSelection.
	(command notNil and: [command valid]) ifTrue: [
		self do: command.
		(mode = #selection or: [mode = #continuousSelection]) ifTrue: [self endMultiSelection]]
]

{ #category : #'action helpers' }
SBEditor >> doMultiSelectionEach: aBlock [

	self doMultiSelection: [:sel | SBCombinedCommand newWith: (sel collect: aBlock thenSelect: #notNil)]
]

{ #category : #'event handling' }
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

{ #category : #'action helpers' }
SBEditor >> endInput [

	| command |
	(currentInput isNil or: [currentInputCommand isNil]) ifTrue: [^ self].
	command := currentInputCommand.
	self cancelInput.
	
	command hasChange
		ifTrue: [self do: command]
		ifFalse: [history noMoreMerge]
]

{ #category : #'action helpers' }
SBEditor >> endInputWith: aString [

	self currentInput contents: aString.
	self endInput
]

{ #category : #actions }
SBEditor >> endMultiSelection [
	<globalAction>

	self clearMultiSelection.
	self mode: #command
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

{ #category : #'testing hierarchy' }
SBEditor >> fixedNumberOfChildren [

	^ false
]

{ #category : #testing }
SBEditor >> floating [

	^ true
]

{ #category : #actions }
SBEditor >> goToMark [
	<globalAction>

	self waitForLetterDo: [:letter |
		self allBlocksDo: [:morph | (morph withDecorator: SBMarkedDecorator do: [:mark | mark letter = letter ifTrue: [^ self select: morph]])]]
]

{ #category : #'event handling' }
SBEditor >> handleDroppedFile: name event: anEvent [

	^ FileStream
		readOnlyFileNamed: name
		do: [:file |
			file
				convertedFor: self objectInterfaceForDrop
				do: [:converted | self handleDroppedBlock: converted event: anEvent adding: true near: nil]]
]

{ #category : #'event handling' }
SBEditor >> handleDroppedFolder: aFileDirectory event: anEvent [

	aFileDirectory
		convertedFor: self objectInterfaceForDrop
		do: [:converted | self handleDroppedBlock: converted event: anEvent adding: true near: nil]
]

{ #category : #'do/undo/redo' }
SBEditor >> hasUnsavedChanges: anArtefact [

	^ history hasUnsavedChanges: anArtefact
]

{ #category : #initialization }
SBEditor >> initialize [

	super initialize.
	
	history := SBHistoryStack new.
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
		registerGlobalShortcutListener: errors;
		registerGlobalShortcutListener: self;
		resetState;
		when: #selectionChanged send: #selectionChanged: to: paletteContainer
]

{ #category : #'insert/delete' }
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

{ #category : #testing }
SBEditor >> isSingleArtefactView [

	^ false
]

{ #category : #'as yet unclassified' }
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

{ #category : #'do/undo/redo' }
SBEditor >> markChangesAfterCommand: artefacts [

	artefacts do: [:candidate | | artefact |
		artefact := candidate canPersist ifTrue: [candidate] ifFalse: [candidate artefactForPersisting ifNil: [candidate]].
		
		(self compileTime = #compileOnChange and: [self save: artefact tryFixing: false quick: false])
			ifTrue: [history markSaved: true].
		
		artefact triggerEvent: #changed.
		self allBlocksDo: [:block | block artefactChanged: artefact]]
]

{ #category : #input }
SBEditor >> maybeStartInputAt: aNumber [

	inputMapping defaultState = #input ifTrue: [
		(self selection ifNotNil: #currentTextMorph) ifNotNil: [:textMorph | self startInput: self selection at: aNumber replacingContents: false]]
]

{ #category : #input }
SBEditor >> maybeStartInputFromEnd [

	(inputMapping defaultState = #input and: [self selection currentTextMorph notNil]) ifTrue: [self startInput: self selection at: 900000000 replacingContents: false]
]

{ #category : #input }
SBEditor >> maybeStartInputFromStart [

	(inputMapping defaultState = #input and: [self selection currentTextMorph notNil]) ifTrue: [self startInput: self selection at: 0 replacingContents: false]
]

{ #category : #input }
SBEditor >> maybeStartInputNear: aPoint [

	inputMapping defaultState = #input ifTrue: [
		self selection currentTextMorph ifNotNil: [:textMorph |
			self startInput: self selection at: (textMorph cursorIndexForPosition: aPoint) replacingContents: false]]
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

	| defaultModeColor specialModeColor |
	self clearMultiSelection.
	
	aSymbol = #input ifTrue: [self assert: currentInput notNil] ifFalse: [self assert: currentInput isNil].
	(aSymbol = #selection or: [aSymbol = #continuousSelection]) ifFalse: [self assert: multiSelection isEmpty].
	
	mode := aSymbol.
	modeLabel contents: (mode caseOf: {
		[#input] -> ['INPUT'].
		[#selection] -> ['SELECTION'].
		[#continuousSelection] -> ['CONT. SELECTION'].
		[#command] -> ['COMMAND']
	}).
	
	defaultModeColor := Color white.
	specialModeColor := Color red alpha: 0.2.
	
	bottomPanel color: (mode caseOf: {
		[#input] -> [inputMapping defaultState = #input ifTrue: [defaultModeColor] ifFalse: [specialModeColor]].
		[#selection] -> [Color blue alpha: 0.2].
		[#continuousSelection] -> [Color blue alpha: 0.2].
		[#command] -> [defaultModeColor]
	}).
	self selection ifNotNil: [:s | s invalidRect: (s outerBounds expandBy: 4)].
	self updateSelectionLabel
]

{ #category : #initialization }
SBEditor >> modelWakeUp [

	" when our window takes focus again and we're detached, bring us back to the front "
	Project current addDeferredUIMessage: [
		self valueOfProperty: #previousWindow ifPresentDo: [:window | self owner addMorphFront: self]]
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

{ #category : #'event handling' }
SBEditor >> noteNewOwner: aMorph [

	" ignore "
]

{ #category : #'object interface' }
SBEditor >> object [

	^ nil
]

{ #category : #'object interface' }
SBEditor >> objectInterface [

	^ SBInterfaces never
]

{ #category : #'object interface' }
SBEditor >> objectInterfaceAt: aNumber adding: aBoolean [

	^ SBInterfaces block, SBInterfaces topLevel
]

{ #category : #testing }
SBEditor >> okToChange [

	^ self unsavedChanges not or: [UIManager default confirm: 'Discard unsaved changes?']
]

{ #category : #'insert/delete' }
SBEditor >> open: anObject [

	^ self open: anObject withInterfaces: #()
]

{ #category : #'insert/delete' }
SBEditor >> open: anObject withInterfaces: aCollection [

	^ self blockFor: anObject withInterfaces: aCollection ifOpen: #select ifClosed: [
		anObject
			convertedFor: (self objectInterfaceAt: 1 adding: true), aCollection
			do: [:repr | self openMorphInView: repr. repr]]
]

{ #category : #'insert/delete' }
SBEditor >> openAll: aCollection [

	aCollection do: [:object | self open: object]
]

{ #category : #'insert/delete' }
SBEditor >> openForEdit: anObject [

	^ self open: anObject withInterfaces: SBInterfaces editor
]

{ #category : #initialization }
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

{ #category : #'actions creating' }
SBEditor >> openOpenWindow [
	<action>
	<globalAction>

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

{ #category : #'actions creating' }
SBEditor >> openRepl [
	<addAction>
	<label: 'Smalltalk Workspace'>
	<globalAction>

	| repl |
	repl := self openMorphInView: SBStPlayground new.
	self startInput: repl body childSandblocks first at: 1 replacingContents: true
]

{ #category : #initialization }
SBEditor >> outOfWorld: aWorld [

	super outOfWorld: aWorld.
	
	helpOverlay ifNotNil: #delete
]

{ #category : #hierarchy }
SBEditor >> parentSandblock [

	^ nil
]

{ #category : #shortcuts }
SBEditor >> performForSelection: anActionSymbol [

	self selection notNil and: [(self selection lookupAction: anActionSymbol) ifNotNil: [self selection performAction: anActionSymbol. ^ true]].
	
	globalShortcutListeners do: [:listener |
		(listener lookupGlobalAction: anActionSymbol) ifNotNil: [listener perform: anActionSymbol. ^ true]].
	
	^ false
]

{ #category : #shortcuts }
SBEditor >> performShortcutFor: anEvent [

	(mode = #input and: [self currentInput absorbsInput: anEvent]) ifTrue: [
		currentInput keyStroke: anEvent.
		^ true].
	
	self shortcuts do: [:assoc |
		(assoc key matchesEvent: anEvent mode: self mode) ifTrue: [(self performForSelection: assoc value) ifTrue: [^ true]]].
	
	mode = #input ifTrue: [
		currentInput keyStroke: anEvent.
		^ true].
	
	^ false
]

{ #category : #actions }
SBEditor >> promptAddArtifact [
	<globalAction>

	| index pragmas |
	pragmas := Pragma allNamed: #addAction from: self class to: Object.
	index := UIManager default chooseFrom: (pragmas collect: [:p | (p method pragmaAt: #label:) ifNotNil: [:label | label arguments first] ifNil: [p selector]]).
	
	index > 0 ifTrue: [self perform: (pragmas at: index) selector]
]

{ #category : #'action helpers' }
SBEditor >> promptChangeColorPolicy [

	| policy |
	policy := (UIManager default chooseFrom: SBColorPolicy withAllSubclasses values: SBColorPolicy withAllSubclasses) ifNil: [^ self].
	self class defaultColorPolicy: policy.
	self colorPolicy: policy new
]

{ #category : #'action helpers' }
SBEditor >> promptChangeCompile [

	| index labels |
	labels := {'Compile on save'. 'Compile on change'}.
	index := UIManager default chooseFrom: labels.
	index < 1 ifTrue: [^ self].
	
	compileTime := index = 1 ifTrue: [#compileOnSave] ifFalse: [#compileOnChange]
]

{ #category : #actions }
SBEditor >> promptMenu [
	<globalAction>

	| options |
	options := {
		({'Change UI Theme'. [self promptChangeColorPolicy]}).
		({'Change Compile Method'. [self promptChangeCompile]}).
		({'New Class'. [self createEmptySmalltalkClass]}).
	}.
	(UIManager default chooseFrom: (options collect: #first) values: (options collect: #second)) ifNotNil: #value
]

{ #category : #'do/undo/redo' }
SBEditor >> redo [
	<action>
	<inputAction>
	<globalAction>

	self endInput.
	
	history redoDo: [:block :artefacts |
		self select: block.
		self markChangesAfterCommand: artefacts]
]

{ #category : #'event handling' }
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

{ #category : #'action helpers' }
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

{ #category : #errors }
SBEditor >> reportError: anError process: aProcess [

	^ errors addError: anError process: aProcess
]

{ #category : #initialization }
SBEditor >> resetState [

	history clearUndoStack.
	
	"self inputMapping resetState."
	selectionDownHistory := OrderedCollection new.
	selection := nil.
	self mode: #command.
	
	colorPolicy := colorPolicy class new
]

{ #category : #accessing }
SBEditor >> sandblockEditor [

	^ self
]

{ #category : #actions }
SBEditor >> save [
	<action>
	<inputAction>
	<globalAction>

	self interruptInputDuring: [
		self selection ifNotNil: [:selected |
			selected artefactForPersisting ifNotNil: [:a |
				self save: a tryFixing: true quick: false]]]
]

{ #category : #artefacts }
SBEditor >> save: anArtefact tryFixing: aFixBoolean quick: aQuickBoolean [

	^ (anArtefact saveTryFixing: aFixBoolean quick: aQuickBoolean)
		ifTrue: [
			history markSaved: anArtefact.
			self triggerEvent: #artefactSaved with: anArtefact.
			self allBlocksDo: [:block | block artefactSaved: self selectedArtefact].
			true]
		ifFalse: [false]
]

{ #category : #selection }
SBEditor >> scrollToShow: aBlock [

	(aBlock isMorph not or: [aBlock hasOwner: scroll scroller]) ifTrue: [
		scroll scrollToShow: aBlock]
]

{ #category : #'as yet unclassified' }
SBEditor >> scrollerClass [

	^ SBEditorCanvas
]

{ #category : #accessing }
SBEditor >> searchInput [

	^ searchInput
]

{ #category : #selection }
SBEditor >> select: aBlock [

	self assert: (aBlock isNil or: [aBlock isSandblock]).
	
	(currentInput ~= nil and: [currentInput ~= aBlock]) ifTrue: [self endInput].
	
	self internalSelect: aBlock
]

{ #category : #selection }
SBEditor >> selectClick: aBlock at: aPoint [

	aBlock select.
	self maybeStartInputNear: aPoint
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

{ #category : #'event handling' }
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

{ #category : #'action helpers' }
SBEditor >> startOrAddToMultiSelection: aBlock [

	mode = #selection ifTrue: [
		^ (multiSelection includes: aBlock)
			ifTrue: [self removeMultiSelected: aBlock]
			ifFalse: [self addToMultiSelection: aBlock]].
	
	self mode: #selection.
	self addToMultiSelection: aBlock
]

{ #category : #printing }
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

{ #category : #actions }
SBEditor >> toggleFullscreen [
	<globalAction>

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
	<globalAction>

	paletteContainer owner ifNotNil: [paletteContainer delete] ifNil: [self submorphs third addMorphFront: paletteContainer]
]

{ #category : #'do/undo/redo' }
SBEditor >> undo [
	<action>
	<inputAction>
	<globalAction>

	self endInput.
	
	history undoDo: [:block :artefacts |
		self select: block.
		self markChangesAfterCommand: artefacts]
]

{ #category : #testing }
SBEditor >> unsavedChanges [

	self allBlocksDo: [:block | (block isArtefact and: [block hasUnsavedChanges]) ifTrue: [^ true]].
	^ false
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
		verticalSelectionPosition := selection center x - (selection containingFloat ifNotNil: [:a | a left] ifNil: [0])]
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

{ #category : #'action helpers' }
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

{ #category : #events }
SBEditor >> wantsKeyboardFocus [

	^ true
]
