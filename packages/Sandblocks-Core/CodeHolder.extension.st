Extension { #name : #CodeHolder }

{ #category : #'*Sandblocks-Core' }
CodeHolder class >> addSandblocks [
	" self addSandblocks "

	self
		addContentsSymbolQuint: #(#blockEditor #toggleBlockEditor #showingBlockEditorString 'blocks' 'edit with the block editor')
		afterEntry: ContentsSymbolQuints last first
]

{ #category : #'*Sandblocks-Core' }
CodeHolder >> installBlockEditor [

	self containingWindow setProperty: #textEditor toValue: self codeTextMorph.
	self containingWindow setProperty: #blockEditor toValue: (SBBrowserEditor new
			model: self;
			hResizing: #spaceFill;
			vResizing: #spaceFill;
			yourself).
	
	self containingWindow
		replacePane: (self containingWindow valueOfProperty: #textEditor)
		with: (self containingWindow valueOfProperty: #blockEditor)
]

{ #category : #'*Sandblocks-Core' }
CodeHolder >> restoreTextualCodingPane [
	"If the receiver is showing tiles, restore the textual coding pane"

	contentsSymbol == #tiles ifTrue:
		[contentsSymbol := #source.
		self installTextualCodingPane].
	
	contentsSymbol == #blockEditor ifTrue:
		[contentsSymbol := #source.
		self containingWindow
			replacePane: (self containingWindow valueOfProperty: #blockEditor)
			with: (self containingWindow valueOfProperty: #textEditor)]
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
