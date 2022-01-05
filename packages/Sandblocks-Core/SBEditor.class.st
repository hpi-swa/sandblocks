Class {
	#name : #SBEditor,
	#superclass : #SBBlock,
	#instVars : [
		'copyBuffer',
		'copyBufferPreview',
		'modeLabel',
		'selectionLabel',
		'scroll',
		'colorPolicy',
		'bottomPanel',
		'compileTime',
		'errors',
		'searchInput',
		'helpOverlay',
		'globalShortcutListeners',
		'inputMapping',
		'ignoreNext',
		'paletteContainer',
		'history',
		'dragHelper',
		'cursor',
		'hoverHighlight',
		'suggestAlways',
		'activePlugins'
	],
	#classVars : [
		'ActivatedPluginClasses',
		'DefaultColorPolicy',
		'InputMappingClass'
	],
	#category : #'Sandblocks-Core'
}

{ #category : #plugins }
SBEditor class >> activatedPluginClasses [

	^ ActivatedPluginClasses ifNil: [ActivatedPluginClasses := Set new]
]

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

	^ DefaultColorPolicy ifNil: [DefaultColorPolicy := SBLightPlusTheme]
]

{ #category : #configuration }
SBEditor class >> defaultColorPolicy: aColorPolicyClass [

	DefaultColorPolicy := aColorPolicyClass
]

{ #category : #'initialize-release' }
SBEditor class >> initialize [

	self registerInWorldMenu
]

{ #category : #plugins }
SBEditor class >> isPluginActive: aPluginClass [

	^ self activatedPluginClasses includes: aPluginClass
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

{ #category : #'initialize-release' }
SBEditor class >> registerInWorldMenu [

	TheWorldMenu registerOpenCommand: {'Sandblocks'. {self. #open}}
]

{ #category : #plugins }
SBEditor class >> removeActivatedPlugin: aPluginClass [

	self activatedPluginClasses remove: aPluginClass
]

{ #category : #plugins }
SBEditor class >> saveActivatedPlugin: aPluginClass [

	self activatedPluginClasses add: aPluginClass
]

{ #category : #plugins }
SBEditor class >> setPlugin: aPluginClass active: aBoolean [

	aBoolean
		ifTrue: [self activatedPluginClasses add: aPluginClass]
		ifFalse: [self activatedPluginClasses remove: aPluginClass ifAbsent: []]
]

{ #category : #shortcuts }
SBEditor class >> shortcutStringForAction: anAction [

	^ String streamContents: [:stream |
		stream nextPut: $(.
		(self shortcutsForAction: anAction) do: [:shortcut | (shortcut isCollection ifTrue: [shortcut first] ifFalse: [shortcut]) printDisplayOn: stream automaticShift: true] separatedBy: [stream nextPutAll: ' -or- '].
		stream nextPut: $)]
]

{ #category : #shortcuts }
SBEditor class >> shortcutsForAction: anAction [

	^ self newInputMapping shortcuts select: [:assoc | assoc value = anAction] thenCollect: [:assoc | assoc key]
]

{ #category : #'initialize-release' }
SBEditor class >> unload [

	self unregisterFromWorldMenu
]

{ #category : #'initialize-release' }
SBEditor class >> unregisterFromWorldMenu [

	TheWorldMenu unregisterOpenCommand: 'Sandblocks'
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

{ #category : #plugins }
SBEditor >> activatePlugin: aPluginClass [

	self activePlugins add: (aPluginClass activatePluginIn: self)
]

{ #category : #plugins }
SBEditor >> activePlugins [

	^ activePlugins ifNil: [activePlugins := OrderedCollection new]
]

{ #category : #shortcuts }
SBEditor >> addShortcuts: aCollection [

	inputMapping addShortcuts: aCollection
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
	self history markChanged: {artefact} redraw: false.
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
		addMorphBack: (Smalltalk
			at: #SBErrorPanel
			ifPresent: [:cl | errors := cl new]
			ifAbsent: [Morph new extent: 0 @ 0]);
		addMorphBack: (Morph new
			extent: 0 @ 0;
			hResizing: #spaceFill;
			color: Color transparent);
		addMorphBack: (SBButton new
			balloonText: 'Wrap with watch';
			icon: SBIcon iconEye
				shortcut: (self class anyShortcutForAction: #wrapWithWatch)
				do: [self performForSelection: #wrapWithWatch]);
		addMorphBack: (SBButton new
			balloonText: 'Convert to ...';
			icon: SBIcon iconRetweet
				shortcut: (self class anyShortcutForAction: #convertTo)
				do: [self performForSelection: #convertTo]);
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
		addMorphBack: (SBButton new
			icon: SBIcon iconColumns shortcut: nil do: [self togglePalette];
			balloonText: 'Toggle Block Palette');
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
		addMorphBack: (Morph new
			height: 0;
			color: Color transparent;
			hResizing: #spaceFill);
		addMorphBack: (SBButton new
			icon: SBIcon iconCog
			shortcut: nil
			do: [self openMorphInView: SBPreferencesEditor new]);
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

{ #category : #accessing }
SBEditor >> canvas [

	^ scroll
]

{ #category : #hierarchy }
SBEditor >> childSandblocksDo: aBlock [

	scroll scroller submorphsDo: [:b | b isSandblock ifTrue: [aBlock value: b]]
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
	aPolicy enlarge: SBPreferences largeInsets.
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

	^ (self errors notNil and: [self errors hasSubmorphs])
		ifTrue: [#compileOnSave]
		ifFalse: [compileTime]
]

{ #category : #accessing }
SBEditor >> compileTime: aSymbol [

	compileTime := aSymbol
]

{ #category : #'as yet unclassified' }
SBEditor >> configurationString [

	^ 'anEditor scrollToPosition:', scroll targetPosition


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
SBEditor >> copyBuffer: aMorphOrCollection [

	| form list |
	list := (aMorphOrCollection isCollection
		ifTrue: [aMorphOrCollection]
		ifFalse: [{aMorphOrCollection}]) select: #canCopy.
	list ifEmpty: [^ self].
	
	copyBuffer := SBSelection new
		methodClass: (list first containingArtefact ifNotNil: #relatedClass);
		colorPolicy: self colorPolicy.
	
	list do: [:m | copyBuffer addMorphBack: m veryDeepCopy].
	Clipboard clipboardText: copyBuffer firstSubmorph textContentsForCopy.
	form := copyBuffer imageForm.
	copyBufferPreview ifNotNil: [copyBufferPreview image: (form scaledToFit: self copyBufferPreviewSize)]
]

{ #category : #accessing }
SBEditor >> copyBufferForContext: anInterface reversed: aBoolean do: aBlock ifWrappingDo: aWrapBlock [

	^ (copyBuffer notNil and: [copyBuffer unpackSelection textContentsForCopy = Clipboard clipboardText string])
		ifTrue: [
			copyBuffer wrapsAround
				ifTrue: [aWrapBlock value: copyBuffer unpackSelection veryDeepCopy]
				ifFalse: [ | list |
					list := copyBuffer submorphs veryDeepCopy.
					aBoolean ifTrue: [list := list reversed].
					list withIndexDo: [:morph :index |
						morph
							convertedFor: anInterface
							do: [:repr | aBlock cull: repr cull: index cull: index = copyBuffer submorphCount]]]]
		ifFalse: [
			Clipboard clipboardText string
				convertedFor: anInterface
				do: [:repr | aBlock cull: repr cull: 1 cull: true]]
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
		position: scroll scroller offset + (self extent // 2) - (aMorph fullBounds extent // 2);
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
	method inputContainedUnknown.
	
	^ method
]

{ #category : #accessing }
SBEditor >> currentInputCommand [

	^ self cursor currentCommand
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

{ #category : #plugins }
SBEditor >> deactivatePlugin: aPluginClass [

	self activePlugins detect: [:p | p class = aPluginClass] ifFound: [:plugin |
		aPluginClass deactivatePlugin: plugin in: self.
		self activePlugins remove: plugin]
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

	cursor prepareForNextCommand.

	history do: aCommand previousSelection: self selection selectDo: [:block :artefacts |
		self select: block.
		self markChangesAfterCommand: artefacts]
]

{ #category : #'action helpers' }
SBEditor >> doMultiSelection: aBlock [

	| command |
	command := aBlock value: self sortedMultiSelection.
	(command notNil and: [command valid]) ifTrue: [
		self do: command.
		self mode = #selection ifTrue: [self endMultiSelection]]
]

{ #category : #'action helpers' }
SBEditor >> doMultiSelectionEach: aBlock [

	self doMultiSelection: [:sel | SBCombinedCommand newWith: (sel collect: aBlock thenSelect: #notNil)]
]

{ #category : #'event handling' }
SBEditor >> dragCopyBuffer: anEvent [

	anEvent hand grabMorph: copyBuffer veryDeepCopy
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

	self selection ifNotNil: [
		cursor selectNoInput: self selection]
	"| command |
	(currentInput isNil or: [currentInputCommand isNil]) ifTrue: [^ self].
	command := currentInputCommand.
	self cancelInput.
	
	command hasChange
		ifTrue: [self do: command]
		ifFalse: [history noMoreMerge]"
]

{ #category : #'action helpers' }
SBEditor >> endInputWith: aString [

	self selection contents: aString.
	self endInput
]

{ #category : #actions }
SBEditor >> endMultiSelection [
	<action>

	self selection select
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
	
	self handle: anEvent.
	
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

{ #category : #events }
SBEditor >> handle: anEvent [

	(self performShortcutFor: anEvent)
		ifTrue: [
			inputMapping handledEvent: anEvent in: self.
			^ anEvent ignore]
		ifFalse: [self cursor unhandledEvent: anEvent in: self didHandle: [^ anEvent ignore]]
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

{ #category : #accessing }
SBEditor >> history [

	^ history
]

{ #category : #initialization }
SBEditor >> initialize [

	super initialize.
	
	history := SBHistoryStack new.
	colorPolicy := self class defaultColorPolicy new enlarge: SBPreferences largeInsets.
	compileTime := #compileOnSave.
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
		listDirection: #topToBottom.
	
	self wantsMinimalLayout
		ifTrue: [ | row |
			row := SBRow new addMorphBack: searchInput toggleCollapsed.
			Smalltalk
				at: #SBErrorPanel
				ifPresent: [:errorPanelClass | row addMorphBack: (errors := errorPanelClass new)].
			self addMorphBack: row]
		ifFalse: [self addMorphBack: self buildCommandBar].
	self addMorphBack: (SBRow new
		changeTableLayout;
		hResizing: #spaceFill;
		vResizing: #spaceFill;
		addMorphBack: (scroll := self scrollerClass new)).
	self wantsMinimalLayout ifFalse: [self addMorphBack: (bottomPanel := self buildBottomPanel)].
	
	self
		registerGlobalShortcutListener: self;
		registerGlobalShortcutListener: searchInput;
		registerGlobalShortcutListener: cursor;
		resetState;
		openMorph: cursor;
		updateSelectionLabel.
	
	errors ifNotNil: [self registerGlobalShortcutListener: errors].
	
	self class activatedPluginClasses do: [:pluginClass | self activatePlugin: pluginClass]
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
		position: (scroll scroller offset + (self extent // 2) - (aMorph fullBounds extent // 2));
		isUnsaved: false;
		yourself
]

{ #category : #input }
SBEditor >> interruptInputDuring: aBlock [

	| cursor selected |
	self selection ifNil: [^ aBlock value].
	
	selected := self selection.
	cursor := selected currentTextMorph ifNotNil: #cursor.
	
	self endInput.
	aBlock value.
	
	(cursor notNil and: [self selection = selected]) ifTrue: [self startInput: selected at: cursor replacingContents: false]
]

{ #category : #testing }
SBEditor >> isSingleArtefactView [

	^ false
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

	^ 'Editor'
]

{ #category : #actions }
SBEditor >> loadBlocks [
	<globalAction>

	scroll scroller submorphs copy do: [:each | each abandon].
	self class loadSaveInto: self
]

{ #category : #'do/undo/redo' }
SBEditor >> markChangesAfterCommand: artefacts [

	artefacts do: [:candidate | | artefact |
		artefact := candidate canPersist
			ifTrue: [candidate]
			ifFalse: [candidate artefactForPersisting ifNil: [candidate]].
		
		(self compileTime = #compileOnChange and: [self save: artefact tryFixing: false quick: false]) ifTrue: [self markSaved: true].
		
		artefact triggerEvent: #changed.
		self allBlocksDo: [:block | block artefactChanged: artefact]]
]

{ #category : #'as yet unclassified' }
SBEditor >> markSaved: anArtefact [

	^ history markSaved: anArtefact
]

{ #category : #accessing }
SBEditor >> methods [

	^ self allBlocksSelect: [:block | block object isCompiledMethod]
]

{ #category : #accessing }
SBEditor >> mode [

	^ cursor mode
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

	^ self cursor multiSelection
]

{ #category : #'action helpers' }
SBEditor >> multiSelection: aCollectionOfBlocks [

	self cursor multiSelection: aCollectionOfBlocks
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

	^ scroll scroller submorphs select: [:s | s isArtefact]
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
		anObject convertedFor: (self objectInterfaceNear: nil at: #after), aCollection do: [:repr |
			self openMorphInView: repr.
			repr]]
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
	
	window := window openInWorldExtent: self fullBounds extent + window layoutInset asEdgeInsets horizontal.
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
SBEditor >> openMorphInOverlay: aMorph [

	scroll addMorphToOverlay: aMorph
]

{ #category : #'submorphs-add/remove' }
SBEditor >> openMorphInView: aMorph [

	self do: (self insertCommandRequest: aMorph near: nil before: false).
	^ aMorph
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

	(self mode = #input and: [self selection absorbsInput: anEvent]) ifTrue: [
		self selection keyStroke: anEvent.
		self cursor updateHorizontalOffset.
		^ true].
	
	^ inputMapping
		actionFor: anEvent
		mode: self mode
		do: [:action | self performForSelection: action]
		ifNone: [
			self mode = #input
				ifTrue: [
					self selection keyStroke: anEvent.
					self cursor updateHorizontalOffset.
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
	
	self compileTime: (index = 1 ifTrue: [#compileOnSave] ifFalse: [#compileOnChange])
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

{ #category : #input }
SBEditor >> replaceInput: aMorph [
	" inform the editor that the current input morph has been replaced by another where input should continue "

	self cursor replaceSelected: aMorph.
	self updateSelectionLabel
]

{ #category : #'as yet unclassified' }
SBEditor >> reportError: anError process: aProcess source: anExecutableEnvironment [

	^ errors ifNotNil: [errors addError: anError process: aProcess source: anExecutableEnvironment]
]

{ #category : #errors }
SBEditor >> reportErrorWithProcessCopy: anError source: anExecutableEnvironment [

	| stack priority |
	stack := anError signalerContext copyStack.
	priority := Processor activeProcess priority.
	^ self
		reportError: anError
		process: ((Process forContext: stack priority: priority)
			shouldResumeFromDebugger: false;
			yourself)
		source: anExecutableEnvironment
]

{ #category : #initialization }
SBEditor >> resetState [

	history clearUndoStack.
	cursor resetState.
	colorPolicy := colorPolicy class new enlarge: SBPreferences largeInsets
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
			self markSaved: anArtefact.
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

	| saveString methodVariables |
	methodVariables := '| '.
	(self objectsToSave select: [:object | object isSandblock]) do: [:aBlock |
		methodVariables := methodVariables, aBlock className, aBlock identityHash, ' '.
		
		].
	methodVariables := methodVariables, '|'.
	
"	saveString := self objectsToSave
		inject: ''
		into: [:string :artefact | string, 'anEditor openMorph: (', artefact saveString, ').', Character cr]."
		
	saveString := String streamContents: [:stream |
		stream nextPutAll: 'loadSaveInto: anEditor';
			cr;
			nextPutAll: methodVariables;
			cr.
		self objectsToSave do: [:artefact |
			stream 
				nextPutAll: 'anEditor openMorph: (';
				nextPutAll: artefact saveString;
				nextPutAll: ').';
				cr
			].
		stream
			nextPutAll: self configurationString
		].
	
	"saveString := 'loadSaveInto: anEditor', Character cr, methodVariables, Character cr, '^ {', saveString, '}'."
	self class class compile: saveString classified: '*generated'.
	"self class class compile: self configurationString classified: '*generated'"
]

{ #category : #selection }
SBEditor >> scrollToPosition: aPoint [

	scroll viewportPosition: aPoint.
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
	
	self cursor select: aBlock
]

{ #category : #selection }
SBEditor >> selectClick: aBlock at: aPoint [

	self cursor moveCursorClick: aBlock at: aPoint
]

{ #category : #artefacts }
SBEditor >> selectedArtefact [

	^ (self selection ifNotNil: #containingArtefact) ifNil: [self methods ifNotEmpty: #first ifEmpty: [nil]]
]

{ #category : #selection }
SBEditor >> selection [

	^ self cursor selectedBlock
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

	self cursor startInput: aMorph at: aNumber replacingContents: aBoolean
]

{ #category : #'action helpers' }
SBEditor >> startOrAddToMultiSelection: aBlock [

	self cursor startOrAddToMultiSelection: aBlock
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

	^ suggestAlways ifNil: [SBPreferences suggestionsOnClick]
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
			self submorphs second addMorphFront: paletteContainer.
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
	
	self firstBlockAt: anEvent position do: [:block |
		hoverHighlight ifNil: [hoverHighlight := SBHoverDecorator new].
		block ~= hoverHighlight morph ifTrue: [
			hoverHighlight morph ifNotNil: [:p | p detachDecorators: SBHoverDecorator].
			(block decorators noneSatisfy: [:d | d isKindOf: SBHoverDecorator]) ifTrue: [block attachDecorator: hoverHighlight]]].
	
	self
		blocksAt: anEvent position
		do: [:morph | morph isSandblock ifTrue: [(morph mouseCursorAt: event) ifNotNil: [:cursor | ^ cursor show]]].
	
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

	| text maxLength defaultModeColor specialModeColor |
	selectionLabel ifNil: [^ self].
	
	maxLength := 30.
	text := self mode = #selection
		ifTrue: [self multiSelection size asString, (' element' asPluralBasedOn: self multiSelection)]
		ifFalse: [
			(self selection notNil and: [self selection isInWorld])
				ifTrue: [self selection selectionLabel]
				ifFalse: ['']].
	text size > maxLength ifTrue: [text := (text first: maxLength - 3), '...'].
	selectionLabel contents: text.
	
	modeLabel ifNotNil: [
		modeLabel contents: (self mode caseOf: {
			[#input] -> ['INPUT'].
			[#selection] -> ['SELECTION'].
			[#continuousSelection] -> ['CONT. SELECTION'].
			[#insert] -> ['INSERT'].
			[#command] -> ['COMMAND'].
			[#none] -> ['']})].
	
	defaultModeColor := Color transparent.
	specialModeColor := (Color r: 1 g: 0.0 b: 0.0) alpha: 0.2.
	
	bottomPanel ifNotNil: [
		bottomPanel color: (self mode caseOf: {
			[#insert] -> [defaultModeColor].
			[#input] -> [
				inputMapping defaultState = #input
					ifTrue: [defaultModeColor]
					ifFalse: [specialModeColor]].
			[#selection] -> [(Color r: 0.0 g: 0.0 b: 1) alpha: 0.2].
			[#continuousSelection] -> [(Color r: 0.0 g: 0.0 b: 1) alpha: 0.2].
			[#command] -> [defaultModeColor].
			[#none] -> [defaultModeColor]})]
]

{ #category : #input }
SBEditor >> useTextInput [

	inputMapping := SBTextInputMapping new
]

{ #category : #input }
SBEditor >> useVimInput [

	inputMapping := SBVimInputMapping new
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
