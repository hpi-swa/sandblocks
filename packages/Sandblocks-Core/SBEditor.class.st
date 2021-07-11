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
		'history',
		'dragHelper',
		'cursor',
		'activateForcesButton',
		'hoverHighlight',
		'suggestAlways'
	],
	#classVars : [
		'DefaultColorPolicy',
		'InputMappingClass'
	],
	#category : #'Sandblocks-Core'
}

{ #category : #shortcuts }
SBEditor class >> anyShortcutForAction: aSymbol [

	^ (self shortcutsForAction: aSymbol) ifNotEmpty: #first ifEmpty: [nil]
]

{ #category : #accessing }
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
SBEditor class >> newFor: aMethodOrClass [

	| editor |
	editor := self new.
	editor open: aMethodOrClass.
	
	^ editor
]

{ #category : #accessing }
SBEditor class >> newInputMapping [

	^ (InputMappingClass ifNil: [SBTextInputMapping]) new
]

{ #category : #opening }
SBEditor class >> open [

	| editor |
	editor := self new.
	editor openInWindow.
	^ editor
]

{ #category : #opening }
SBEditor class >> openFor: aMethodOrClass [

	^ (self newFor: aMethodOrClass) openInWindow; yourself
]

{ #category : #shortcuts }
SBEditor class >> shortcutStringForAction: anAction [

	^ String streamContents: [:stream |
		stream nextPut: $(.
		(self shortcutsForAction: anAction) do: [:shortcut | (shortcut isCollection ifTrue: [shortcut first] ifFalse: [shortcut]) printDisplayOn: stream automaticShift: true] separatedBy: [stream space].
		stream nextPut: $)]
]

{ #category : #shortcuts }
SBEditor class >> shortcutsForAction: anAction [

	^ self newInputMapping shortcuts select: [:assoc | assoc value = anAction] thenCollect: [:assoc | assoc key]
]

{ #category : #configuration }
SBEditor class >> useInputMapping: anInputMappingClass [
	" self useInputMapping: SBTextInputMapping "

	InputMappingClass := anInputMappingClass
]

{ #category : #'as yet unclassified' }
SBEditor >> activateForces [
	
	<globalAction>
	
	self childSandblocksDo: [:each | each withDecorator: SBForceMoveDecorator do:
		[:decorator | decorator activateForces]]
]

{ #category : #shortcuts }
SBEditor >> addShortcuts: aCollection [

	inputMapping addShortcuts: aCollection
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

	| artefact |
	" send this message when you are updating the tree rapidly for each update, but don't want to submit a command for each update, only at the end "
	artefact := aBlock containingArtefact.
	(self compileTime = #compileOnChange and: [artefact notNil]) ifTrue: [
		self save: artefact tryFixing: false quick: true.
		artefact triggerEvent: #changed.
		self allBlocksDo: [:block | block artefactChanged: artefact]]
]

{ #category : #'ast helpers' }
SBEditor >> binding: aString for: block class: aClass ifPresent: aBlock [

	^ nil
]

{ #category : #ui }
SBEditor >> buildBottomPanel [

	^ Morph new
		changeTableLayout;
		cellPositioning: #center;
		vResizing: #shrinkWrap;
		cellGap: 8;
		hResizing: #spaceFill;
		wrapCentering: #center;
		layoutInset: 4;
		listDirection: #leftToRight;
		addMorphBack: (modeLabel := SBStringMorph new emphasis: TextEmphasis bold emphasisCode);
		addMorphBack: (selectionLabel := SBStringMorph new contents: '');
		addMorphBack: searchInput;
		addMorphBack: (Morph new
			extent: 0 @ 0;
			hResizing: #spaceFill;
			color: Color transparent);
		addMorphBack: (SBButton new
			balloonText: 'Convert to ...';
			icon: SBIcon iconEye
				shortcut: (self class anyShortcutForAction: #wrapWithWatch)
				do: [self selection performAction: #wrapWithWatch]);
		addMorphBack: (SBButton new
			balloonText: 'Convert to ...';
			icon: SBIcon iconRetweet
				shortcut: (self class anyShortcutForAction: #convertTo)
				do: [self selection performAction: #convertTo]);
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
		cellGap: 4;
		layoutInset: 4;
		addMorphBack: (SBButton new icon: SBIcon iconColumns shortcut: nil do: [self togglePalette]);
		addMorphBack: (SBButton new
			icon: SBIcon iconUndo
			shortcut: (self class anyShortcutForAction: #undo)
			do: [self undo]);
		addMorphBack: (SBButton new
			icon: SBIcon iconRepeat
			shortcut: (self class anyShortcutForAction: #redo)
			do: [self redo]);
		addMorphBack: (SBButton new
			icon: SBIcon iconFolderOpen
			shortcut: (self class anyShortcutForAction: #openOpenWindow)
			do: [self openOpenWindow]);
		addMorphBack: (SBButton new
			icon: SBIcon iconPlus
				shortcut: (self class anyShortcutForAction: #promptAddArtifact)
				do: [self promptAddArtifact];
			balloonText: 'Add artifact');
		addMorphBack: (activateForcesButton := SBButton new
			icon: SBIcon iconMagnet
				shortcut: (self class anyShortcutForAction: #activateForces)
				do: [];
			balloonText: 'Activate Layouting');
		addMorphBack: (Morph new
			height: 0;
			color: Color transparent;
			hResizing: #spaceFill);
		addMorphBack: (SBButton new
			icon: SBIcon iconSearchPlus shortcut: nil do: [
				self colorPolicy toggleEnlarge.
				self allMorphsDo: #layoutChanged];
			balloonText: 'Toggle enlarge blocks insets');
		addMorphBack: (SBRow new
			addMorphBack: (SBButton new
				cornerStyle: #square;
				icon: SBIcon iconAlignLeft shortcut: nil do: [self colorPolicy: SBTextColorPolicy new];
				balloonText: 'Text-like Layout');
			addMorphBack: (SBButton new
				cornerStyle: #square;
				icon: SBIcon iconTh shortcut: nil do: [self colorPolicy: SBColorMinimalPolicy new];
				balloonText: 'Compact Layout');
			addMorphBack: (SBButton new
				cornerStyle: #square;
				icon: SBIcon iconThLarge shortcut: nil do: [self colorPolicy: SBScratchColorPolicy new];
				balloonText: 'Scratch Layout'));
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
		cellGap: 4;
		layoutInset: 4;
		addMorphBack: (SBButton new
			icon: SBIcon iconLongArrowRight shortcut: $> asSandblockShortcut do: [self stepOver];
			balloonText: 'Step over');
		addMorphBack: (SBButton new
			icon: SBIcon iconLevelDown shortcut: $< asSandblockShortcut do: [self stepInto];
			balloonText: 'Step into');
		addMorphBack: (SBButton new
			icon: SBIcon iconForward shortcut: nil do: [self stepThrough];
			balloonText: 'Step through');
		addMorphBack: (SBButton new
			icon: SBIcon iconFastBackward shortcut: $R command do: [self restartFrame];
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

{ #category : #'event handling' }
SBEditor >> click: anEvent [

	anEvent yellowButtonPressed ifTrue: [^ self promptGlobalAction].
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

	^ self colorPolicy ifNotNil: [:c | c colorForEditor: self] ifNil: [Color white]
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
	self containingWindow ifNotNil: [:w | | color |
		color := aPolicy colorForEditor: self.
		w
			paneColor: color;
			setStripeColorsFrom: color].
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
	copyBufferPreview ifNotNil: [copyBufferPreview image: (form scaledToFit: self copyBufferPreviewSize)]
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
	
	self do: (SBEditorOpenMorphCommand new
		morph: aMorph;
		editor: self sandblockEditor;
		isUnsaved: true;
		yourself).
	
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
	
	method := SBStMethod new
		selector: ''
			arguments: #()
			class: ((self selectedArtefact ifNotNil: [:container | container relatedClass]) ifNil: [UIManager default chooseClassOrTrait ifNil: [^ self]]);
		body: (SBStBlockBody new in: [:b | b statements: {b newNullBlock}]).
	
	self createArtefactInView: method.
	self startInput: method at: 1 replacingContents: true.
	
	^ method
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
SBEditor >> cursor [

	^ cursor
]

{ #category : #'as yet unclassified' }
SBEditor >> deactivateForces [
	
	<globalAction>
	
	self childSandblocksDo: [:each | each withDecorator: SBForceMoveDecorator do:
		[:decorator | decorator deactivateForces]]
]

{ #category : #actions }
SBEditor >> deleteBlock [
	<action>
	
	" ignored "
]

{ #category : #'submorphs-add/remove' }
SBEditor >> deleteCommandFor: aBlock [

	^ SBDeleteCommand new target: aBlock
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
	1 to: numFiles do: [:i |
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
		anEvent isMouseWheel ifTrue: [
			^ (ignoreNext ifNil: [false])
				ifTrue: [
					ignoreNext := false.
					anEvent hand sendMouseEvent: anEvent]
				ifFalse: [
					ignoreNext := true.
					anEvent]].
		
		anEvent isMouseMove ifTrue: [
			self updateMouseCursorFor: anEvent.
			(anEvent isDraggingEvent and: [anEvent hand hasSubmorphs])
				ifTrue: [
					(dragHelper ifNil: [dragHelper := SBDragHelper for: anEvent in: self]) ifNotNil: [:helper | helper mouseMove: anEvent].
					^ anEvent wasHandled: true]
				ifFalse: [
					dragHelper ifNotNil: #delete.
					dragHelper := nil]].
		
		anEvent isMouseDown ifTrue: [anEvent hand newKeyboardFocus: self].
		^ anEvent].
	
	anEvent isKeystroke ifFalse: [^ anEvent].
	
	anEvent keyValue = 251
		ifTrue: [self toggleHelperTimer: anEvent type = #keyDown]
		ifFalse: [self removeHelperTimer].
	
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

{ #category : #accessing }
SBEditor >> globalVerticalSelectionPosition [

	^ verticalSelectionPosition + self selection containingFloat left
]

{ #category : #actions }
SBEditor >> goToMark [
	<globalAction>

	self waitForLetterDo: [:letter |
		self allBlocksDo: [:morph | (morph withDecorator: SBMarkedDecorator do: [:mark | mark letter = letter ifTrue: [^ self select: morph]])]]
]

{ #category : #'event handling' }
SBEditor >> handleDropCancelMorph: aMorph [

	dragHelper ifNotNil: [
		dragHelper dragCancelled.
		dragHelper := nil]
]

{ #category : #'event handling' }
SBEditor >> handleDropMorph: anEvent [

	dragHelper ifNotNil: [
		(dragHelper applyHintAt: anEvent) ifTrue: [anEvent wasHandled: true].
		dragHelper := nil]
]

{ #category : #'event handling' }
SBEditor >> handleDroppedFile: name event: anEvent [

	self flag: #todo.
	"not adapted to new drag-and-drop system "
	^ FileStream readOnlyFileNamed: name do: [:file |
		file
			convertedFor: (self objectInterfaceNear: nil at: #after)
			do: [:converted | self openMorphInView: converted]]
]

{ #category : #'event handling' }
SBEditor >> handleDroppedFolder: aFileDirectory event: anEvent [

	self flag: #todo. "not adapted to new drag-and-drop system "
	aFileDirectory
		convertedFor: (self objectInterfaceNear: nil at: #after)
		do: [:converted | self handleDroppedBlock: converted event: anEvent adding: true near: nil]
]

{ #category : #'event handling' }
SBEditor >> handlesMouseDown: anEvent [

	^ true
]

{ #category : #'as yet unclassified' }
SBEditor >> handlesMouseOver: anEvent [

	^ true
]

{ #category : #'event handling' }
SBEditor >> handlesMouseOverDragging: evt [

	^ true
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
	suggestAlways := false.
	verticalSelectionPosition := 0.
	globalShortcutListeners := OrderedCollection new.
	inputMapping := self class newInputMapping.
	searchInput := SBSearchPanel new.
	cursor := SBBlockCursor new editor: self.
	
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
			yourself).
	
	self wantsMinimalLayout
		ifTrue: [self addMorphBack: searchInput toggleCollapsed]
		ifFalse: [self addMorphBack: self buildCommandBar].
	self addMorphBack: (SBRow new
		changeTableLayout;
		hResizing: #spaceFill;
		vResizing: #spaceFill;
		addMorphBack: (scroll := self scrollerClass new)).
	self wantsMinimalLayout ifFalse: [self addMorphBack: (bottomPanel := self buildBottomPanel)].
	
	self
		registerGlobalShortcutListener: self;
		registerGlobalShortcutListener: errors;
		registerGlobalShortcutListener: searchInput;
		registerGlobalShortcutListener: cursor;
		resetState.
	
	SBPreferences useNewCursor ifTrue: [self openMorph: cursor]
]

{ #category : #testing }
SBEditor >> inputIsDefault [

	^ inputMapping defaultState = #input
]

{ #category : #'as yet unclassified' }
SBEditor >> insertCommandRequest: aMorph near: aBlock before: aBoolean [

	^ SBEditorOpenMorphCommand new
		morph: aMorph;
		editor: self;
		isUnsaved: false;
		yourself
]

{ #category : #selection }
SBEditor >> internalSelect: aBlock [

	aBlock ~= selection ifTrue: [ | previousSelection |
		previousSelection := selection.
		selection := aBlock.
		
		previousSelection ifNotNil: [
			previousSelection
				detachDecorators: SBSelectionDecorator;
				wasDeselected].
		
		selection ifNotNil: [
			selection
				attachDecorator: SBSelectionDecorator new;
				wasSelected;
				ensureVisible].
		
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

{ #category : #accessing }
SBEditor >> keepForcesActivated [

	^ activateForcesButton ifNotNil: #pressed ifNil: [false]
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

{ #category : #drawing }
SBEditor >> keyboardFocusColor [

	^ nil
]

{ #category : #accessing }
SBEditor >> labelString [

	^ 'Editor', (workspace ifNotNil: [:w | ' - ', w name] ifNil: [''])
]

{ #category : #actions }
SBEditor >> loadBlocks [
	<globalAction>
	
	self objectsToSave do: [:each | each deleteBlock].
	self class savedBlocks do: [:each | self openMorphBack: each].
]

{ #category : #'do/undo/redo' }
SBEditor >> markChangesAfterCommand: artefacts [

	artefacts do: [:candidate | | artefact |
		artefact := candidate canPersist
			ifTrue: [candidate]
			ifFalse: [candidate artefactForPersisting ifNil: [candidate]].
		
		(self compileTime = #compileOnChange and: [self save: artefact tryFixing: false quick: false]) ifTrue: [history markSaved: true].
		
		artefact triggerEvent: #changed.
		self allBlocksDo: [:block | block artefactChanged: artefact]]
]

{ #category : #input }
SBEditor >> maybeStartInput: aSymbol [
	" provide #top or #bottom for the entry point "

	self maybeStartInputDo: [:textMorph |
		self
			startInput: self selection
			at: (textMorph cursorIndexForPosition: self verticalSelectionPosition + (self selection containingFloat ifNotNil: [:a | a left] ifNil: [0]) @ ((textMorph perform: aSymbol) + (aSymbol = #top ifTrue: [4] ifFalse: [-4])))
			replacingContents: false]
]

{ #category : #input }
SBEditor >> maybeStartInputAt: aNumber [

	self maybeStartInputDo: [:textMorph | self startInput: self selection at: aNumber replacingContents: false]
]

{ #category : #input }
SBEditor >> maybeStartInputBottom: aBoolean [

	self maybeStartInputDo: [:textMorph |
		self
			startInput: self selection
			at: (textMorph cursorIndexForPosition: self verticalSelectionPosition + (self selection containingFloat ifNotNil: [:a | a left] ifNil: [0]) @ (textMorph top + 4))
			replacingContents: false]
]

{ #category : #'as yet unclassified' }
SBEditor >> maybeStartInputDo: aBlock [

	^ (inputMapping defaultState = #input and: [(self selection ifNotNil: #currentTextMorph) notNil and: [#(command input) includes: mode]])
		ifTrue: [aBlock value: self selection currentTextMorph]
]

{ #category : #input }
SBEditor >> maybeStartInputFromEnd [

	self maybeStartInputDo: [:textMorph | self startInput: self selection at: 900000000 replacingContents: false]
]

{ #category : #input }
SBEditor >> maybeStartInputFromStart [

	self maybeStartInputDo: [:textMorph | self startInput: self selection at: 0 replacingContents: false]
]

{ #category : #input }
SBEditor >> maybeStartInputNear: aPoint [

	self maybeStartInputDo: [:textMorph | self startInput: self selection at: (textMorph cursorIndexForPosition: aPoint) replacingContents: false]
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
	
	aSymbol = #input ifTrue: [self assert: currentInput notNil] ifFalse: [self endInput].
	(aSymbol = #selection or: [aSymbol = #continuousSelection]) ifFalse: [self assert: multiSelection isEmpty].
	
	mode := aSymbol.
	modeLabel ifNotNil: [
		modeLabel contents: (mode caseOf: {
			[#input] -> ['INPUT'].
			[#selection] -> ['SELECTION'].
			[#continuousSelection] -> ['CONT. SELECTION'].
			[#command] -> ['COMMAND']})].
	
	defaultModeColor := Color transparent.
	specialModeColor := Color red alpha: 0.2.
	
	bottomPanel ifNotNil: [
		bottomPanel color: (mode caseOf: {
			[#input] -> [
				inputMapping defaultState = #input
					ifTrue: [defaultModeColor]
					ifFalse: [specialModeColor]].
			[#selection] -> [Color blue alpha: 0.2].
			[#continuousSelection] -> [Color blue alpha: 0.2].
			[#command] -> [defaultModeColor]})].
	self selection ifNotNil: [:s | s invalidRect: (s outerBounds expandBy: 4)].
	self updateSelectionLabel
]

{ #category : #initialization }
SBEditor >> modelWakeUp [

	" when our window takes focus again and we're detached, bring us back to the front "
	Project current addDeferredUIMessage: [
		self valueOfProperty: #previousWindow ifPresentDo: [:window | self owner addMorphFront: self]]
]

{ #category : #'as yet unclassified' }
SBEditor >> morphicLayerNumber [
	" make sure we're at least over the docking bar "

	^ 77 - 1
]

{ #category : #'as yet unclassified' }
SBEditor >> mouseLeave: anEvent [

	hoverHighlight ifNotNil: #detach
]

{ #category : #'event handling' }
SBEditor >> mouseLeaveDragging: anEvent [

	dragHelper ifNotNil: #delete.
	dragHelper := nil
]

{ #category : #selection }
SBEditor >> moveViewport: aPoint [

	scroll moveViewport: aPoint
]

{ #category : #selection }
SBEditor >> multiSelection [

	^ (mode = #selection or: [mode = #continuousSelection])
		ifTrue: [multiSelection select: [:bubble | bubble owner notNil]]
		ifFalse: [self selection ifNotNil: [{self selection}] ifNil: [#()]]
	"^ multiSelection ifEmpty: [self selection ifNotNil: [{self selection}] ifNil: [#()]]"
]

{ #category : #'action helpers' }
SBEditor >> multiSelection: aCollectionOfBlocks [

	self sandblockEditor mode = #select ifFalse: [self sandblockEditor mode: #selection].
	
	aCollectionOfBlocks do: [:block | self addToMultiSelection: block]
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

{ #category : #'as yet unclassified' }
SBEditor >> objectInterfaceNear: aBlock at: aSymbol [

	^ SBInterfaces block, (SBToggledCode comment: '' active: 1 do: {[SBInterfaces always]. [SBInterfaces topLevel]})
]

{ #category : #accessing }
SBEditor >> objectsToSave [

	^ scroll scroller submorphs select: [:s | (s isSandblock or: [s isConnector]) and: [s isArtefact]]
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
			convertedFor: (self objectInterfaceNear: nil at: #after), aCollection
			do: [:repr | self openMorphInView: repr. repr]]
]

{ #category : #'insert/delete' }
SBEditor >> openAll: aCollection [

	aCollection do: [:object | self open: object]
]

{ #category : #'actions creating' }
SBEditor >> openFile [
	<addAction>
	<label: 'Open file ...'>
	<globalAction>

	| file |
	file := (UIManager default chooseFileMatching: '*') ifNil: [^ self].
	FileStream readOnlyFileNamed: file do: [:stream |
		stream
			convertedFor: (self objectInterfaceNear: nil at: #after)
			do: [:morph | self openMorphInView: morph]]
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
	Project uiManager openToolsAttachedToMouseCursor ifTrue: [
		window setProperty: #initialDrop toValue: true.
		window hasDropShadow: false.
		self currentHand attachMorph: window].
	^ window
]

{ #category : #'submorphs-add/remove' }
SBEditor >> openMorph: aMorph [

	scroll scroller addMorphInLayer: aMorph
]

{ #category : #'submorphs-add/remove' }
SBEditor >> openMorphBack: aMorph [

	scroll scroller addMorphBack: aMorph
]

{ #category : #'submorphs-add/remove' }
SBEditor >> openMorphInOverlay: aMorph [

	scroll addMorphToOverlay: aMorph
]

{ #category : #'submorphs-add/remove' }
SBEditor >> openMorphInView: aMorph [

	self do: (self insertCommandRequest: aMorph near: nil before: false).
	^ aMorph
]

{ #category : #'submorphs-add/remove' }
SBEditor >> openMorphInViewCommand: aMorph [

	| position |
	position := scroll scroller offset + (self extent // 2).
	^ SBInsertCommand new
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

{ #category : #actions }
SBEditor >> openWelcome [
	<globalAction>
	
	self openMorphInView: SBWelcome new
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

	self selection notNil ifTrue: [(self selection performAction: anActionSymbol) ifTrue: [^ true]].
	
	globalShortcutListeners do: [:listener |
		(listener lookupGlobalAction: anActionSymbol) ifNotNil: [listener perform: anActionSymbol. ^ true]].
	
	^ false
]

{ #category : #shortcuts }
SBEditor >> performShortcutFor: anEvent [

	(mode = #input and: [self currentInput absorbsInput: anEvent]) ifTrue: [
		currentInput keyStroke: anEvent.
		self updateVerticalSelectionPosition.
		^ true].
	
	^ inputMapping
		actionFor: anEvent
		mode: self mode
		do: [:action | self performForSelection: action]
		ifNone: [
			mode = #input
				ifTrue: [
					currentInput keyStroke: anEvent.
					self updateVerticalSelectionPosition.
					true]
				ifFalse: [false]]
]

{ #category : #drawing }
SBEditor >> prefersNoBorder [

	^ true
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
	<globalAction>

	| policy |
	policy := (UIManager default chooseFrom: (SBColorPolicy withAllSubclasses collect: #name) values: SBColorPolicy withAllSubclasses) ifNil: [^ self].
	self class defaultColorPolicy: policy.
	self colorPolicy: policy new
]

{ #category : #'action helpers' }
SBEditor >> promptChangeCompile [
	<globalAction>

	| index labels |
	labels := {'Compile on save'. 'Compile on change'}.
	index := UIManager default chooseFrom: labels.
	index < 1 ifTrue: [^ self].
	
	compileTime := index = 1 ifTrue: [#compileOnSave] ifFalse: [#compileOnChange]
]

{ #category : #'action helpers' }
SBEditor >> promptGlobalAction [
	<action>
	<globalAction>

	| options index |
	options := Array streamContents: [:s | globalShortcutListeners do: [:listener | (Pragma allNamed: #globalAction from: listener class to: SBEditor) do: [:p | s nextPut: listener -> p]]].
	
	index := UIManager default chooseFrom: (options collect: [:option | option value selector, (' ', (SBEditor shortcutStringForAction: option value selector))]).
	
	index > 0 ifTrue: [(options at: index) key perform: (options at: index) value selector]
]

{ #category : #'action helpers' }
SBEditor >> rebuildPalette [

	paletteContainer rebuild
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
	multiSelection ifEmpty: [self mode: #command].
	self triggerEvent: #selectionChanged with: selection.
	self updateSelectionLabel
]

{ #category : #input }
SBEditor >> replaceInput: aMorph [
	" inform the editor that the current input morph has been replaced by another where input should continue "

	self assert: currentInput notNil.
	currentInput := aMorph.
	self select: aMorph containingSandblock
]

{ #category : #'as yet unclassified' }
SBEditor >> reportError: anError process: aProcess [

	^ errors addError: anError process: aProcess
]

{ #category : #errors }
SBEditor >> reportErrorWithProcessCopy: anError [

	| stack priority |
	stack := anError signalerContext copyStack.
	priority := Processor activeProcess priority.
	^ self reportError: anError process: ((Process forContext: stack priority: priority)
		shouldResumeFromDebugger: false;
		yourself)
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
			self allBlocksDo: [:block | block artefactSaved: anArtefact].
			true]
		ifFalse: [false]
]

{ #category : #actions }
SBEditor >> saveCopy [
	<globalAction>

	self interruptInputDuring: [self selection ifNotNil: [:selected | selected artefactForPersisting ifNotNil: [:a | a saveCopy]]]
]

{ #category : #actions }
SBEditor >> saveCurrentBlocks [
	<globalAction>
	
	| saveString |
	
	saveString := (self objectsToSave inject: '' into: [:string :artefact | string , artefact saveString, '.', Character cr]).
	saveString := 'savedBlocks', Character cr, '^ {', saveString, '}'.
	self class class compile: saveString classified: '*generated'


]

{ #category : #selection }
SBEditor >> scrollToShow: aBlock [

	(aBlock isMorph not or: [aBlock hasOwner: scroll scroller]) ifTrue: [
		scroll scrollToShow: aBlock]
]

{ #category : #'as yet unclassified' }
SBEditor >> scrollerClass [

	^ SBEditorCanvasWithOverlay
]

{ #category : #accessing }
SBEditor >> search [

	^ searchInput
]

{ #category : #selection }
SBEditor >> select: aBlock [

	self assert: (aBlock isNil or: [aBlock isSandblock]).
	
	SBPreferences useNewCursor ifTrue: [self cursor select: aBlock].
	(currentInput ~= nil and: [currentInput ~= aBlock]) ifTrue: [self endInput].
	
	self internalSelect: aBlock
]

{ #category : #selection }
SBEditor >> selectClick: aBlock at: aPoint [

	SBPreferences useNewCursor ifTrue: [self cursor moveCursorClick: aBlock at: aPoint].
	aBlock select.
	self maybeStartInputNear: aPoint.
	self updateVerticalSelectionPosition
]

{ #category : #artefacts }
SBEditor >> selectedArtefact [

	^ (self selection ifNotNil: #containingArtefact) ifNil: [self methods ifNotEmpty: #first ifEmpty: [nil]]
]

{ #category : #selection }
SBEditor >> selection [

	^ SBPreferences useNewCursor
		ifTrue: [self cursor selectedBlock]
		ifFalse: [selection]
]

{ #category : #accessing }
SBEditor >> selectionDownHistory [

	^ selectionDownHistory
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
	
	aMorph = self currentInput ifTrue: [^ aMorph currentTextMorph moveCursorTo: aNumber].
	
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

{ #category : #accessing }
SBEditor >> suggestAlways [

	^ suggestAlways
]

{ #category : #accessing }
SBEditor >> suggestAlways: aBoolean [

	suggestAlways := aBoolean
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

	paletteContainer owner
		ifNotNil: [
			paletteContainer delete.
			self removeActionsWithReceiver: paletteContainer]
		ifNil: [
			self submorphs third addMorphFront: paletteContainer.
			self when: #selectionChanged send: #selectionChanged: to: paletteContainer.
			paletteContainer selectionChanged: self selection]
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

{ #category : #'event handling' }
SBEditor >> updateMouseCursorFor: anEvent [

	| event |
	self hasChildSandblocks ifFalse: [^ self].
	
	event := anEvent transformedBy: (self childSandblocks first transformedFrom: self).
	
	(self morphsAt: anEvent position)
		detect: [:morph | morph isSandblock]
		ifFound: [:block |
			hoverHighlight ifNil: [hoverHighlight := SBHoverDecorator new].
			hoverHighlight detach.
			block attachDecorator: hoverHighlight].
	
	(self morphsAt: anEvent position) do: [:morph | morph isSandblock ifTrue: [(morph mouseCursorAt: event) ifNotNil: [:cursor | ^ cursor show]]].
	Cursor currentCursor ~= Cursor normal ifTrue: [Cursor normal show]
]

{ #category : #actions }
SBEditor >> updateSandblocks [
	<globalAction>
	
	(UIManager default confirm: 'Proceed to install the latest unstable version?') ifTrue: [
		(Smalltalk at: #Metacello) new
			baseline: 'Sandblocks';
			repository: 'github://tom95/Sandblocks:master/packages';
			get; load: #tutorial]
]

{ #category : #selection }
SBEditor >> updateSelectionLabel [

	| text maxLength |
	selectionLabel ifNil: [^ self].
	
	maxLength := 30.
	text := mode = #selection
		ifTrue: [multiSelection size asString, (' element' asPluralBasedOn: multiSelection)]
		ifFalse: [
			(self selection notNil and: [self selection isInWorld])
				ifTrue: [self selection selectionLabel]
				ifFalse: ['']].
	text size > maxLength ifTrue: [text := (text first: maxLength - 3), '...'].
	selectionLabel contents: text
]

{ #category : #selection }
SBEditor >> updateVerticalSelectionPosition [

	" we need to defer one step because we will frequently have morphs that are not fully layed-out just yet "
	Project current addDeferredUIMessage: [
		(selection notNil and: [selection containingFloat notNil]) ifTrue: [ | reference |
			reference := self mode = #input
				ifTrue: [self currentInput currentTextMorph cursorPosition x]
				ifFalse: [selection center x].
			verticalSelectionPosition := reference - selection containingFloat left].
		
		" debug visualization "
		false ifTrue: [
			Display getCanvas fillRectangle: (selection containingFloat positionInWorld + (0 @ -10) extent: 10 @ 10) color: Color random.
			Display getCanvas fillRectangle: (selection containingFloat positionInWorld + (verticalSelectionPosition @ -10) extent: 10 @ 10) color: Color random]]
]

{ #category : #input }
SBEditor >> useTextInput [

	inputMapping := SBTextInputMapping new
]

{ #category : #input }
SBEditor >> useVimInput [

	inputMapping := SBVimInputMapping new
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

{ #category : #drawing }
SBEditor >> wantsExtraSpace [

	^ false
]

{ #category : #events }
SBEditor >> wantsKeyboardFocus [

	^ true
]

{ #category : #ui }
SBEditor >> wantsMinimalLayout [

	^ false
]

{ #category : #'as yet unclassified' }
SBEditor >> windowColorToUse [

	^ self colorPolicy colorForEditor: self
]
