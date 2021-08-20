Extension { #name : #CodeHolder }

{ #category : #'*Sandblocks-Core' }
CodeHolder class >> addSandblocksDefault: aBoolean [

	| quint |
	" self addSandblocksDefault: true "
	quint := #(#blockEditor #toggleBlockEditor #showingBlockEditorString 'blocks' 'edit with the block editor').
	
	ContentsSymbolQuints removeAllSuchThat: [:q | q first = #blockEditor].
	
	aBoolean
		ifTrue: [ContentsSymbolQuints addFirst: quint]
		ifFalse: [self addContentsSymbolQuint: quint afterEntry: ContentsSymbolQuints last first]
]

{ #category : #'*Sandblocks-Core' }
CodeHolder >> blockEditor [

	^ self containingWindow valueOfProperty: #blockEditor
]

{ #category : #'*Sandblocks-Core-contents-override' }
CodeHolder >> contentsSymbol [
	"Answer a symbol indicating what kind of content should be shown for the method; for normal showing of source code, this symbol is #source.  A nil value in the contentsSymbol slot will be set to #source by this method"

	^ contentsSymbol ifNil: [
		contentsSymbol := SystemBrowser browseWithPrettyPrint
			ifTrue: [#prettyPrint]
			ifFalse: [
				(self isKindOf: Debugger)
					ifTrue: [#source]
					ifFalse: [self contentsSymbolQuints first first]].
		
		" FIXME tobe: seriously, I have not found any other way to inform the browser to change its widget.
		 Underlying problems is that the block editor installation depends on the finished morph hierarchy and
		 there appear to be no callbacks back from Morphic back to ToolBuilder/the model when it is finished. "
		Project current addDeferredUIMessage: [self contentsSymbol = #blockEditor ifTrue: [self installBlockEditor]].
		contentsSymbol]
]

{ #category : #'*Sandblocks-Core' }
CodeHolder >> installBlockEditor [

	" already installed? "
	self containingWindow ifNil: [^ self].
	
	self containingWindow valueOfProperty: #blockEditor ifPresentDo: [:b | b owner notNil ifTrue: [^ self]].
	
	self containingWindow setProperty: #textEditor toValue: self codeTextMorph.
	self containingWindow setProperty: #blockEditor toValue: (SBBrowserEditor new
			model: self;
			hResizing: #spaceFill;
			vResizing: #spaceFill;
			updateArtefact;
			yourself).
	
	self containingWindow
		replacePane: (self containingWindow valueOfProperty: #textEditor)
		with: (self containingWindow valueOfProperty: #blockEditor)
]

{ #category : #'*Sandblocks-Core-diffs-override' }
CodeHolder >> restoreTextualCodingPane [
	"If the receiver is showing tiles, restore the textual coding pane"

	contentsSymbol == #tiles ifTrue: [
		contentsSymbol := #source.
		self installTextualCodingPane].
	
	contentsSymbol == #blockEditor ifTrue: [
		contentsSymbol := #source.
		(self containingWindow valueOfProperty: #blockEditor) ifNotNil: [:blockEditor |
			self containingWindow
				replacePane: blockEditor
				with: (self containingWindow valueOfProperty: #textEditor).
			blockEditor model: nil]]
]

{ #category : #'*Sandblocks-Core' }
CodeHolder >> showingBlockEditorString [

	^ (self contentsSymbol = #blockEditor ifTrue: ['<yes>'] ifFalse: ['<no>']), 'block editor'
]

{ #category : #'*Sandblocks-Core' }
CodeHolder >> toggleBlockEditor [

	self okToChange ifTrue: [
		self contentsSymbol = #blockEditor
			ifTrue: [self restoreTextualCodingPane]
			ifFalse: [
				self contentsSymbol: #blockEditor.
				self installBlockEditor].
		self setContentsToForceRefetch.
		self contentsChanged]
]
