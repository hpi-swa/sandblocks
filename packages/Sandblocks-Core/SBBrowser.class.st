Class {
	#name : #SBBrowser,
	#superclass : #Browser,
	#instVars : [
		'textEditor',
		'blockEditor'
	],
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBBrowser >> codeTextMorph [

	^ (blockEditor notNil and: [blockEditor owner notNil]) ifTrue: [blockEditor] ifFalse: [textEditor ifNil: [self someTextPaneWithSelector: #contents]]
]

{ #category : #'as yet unclassified' }
SBBrowser >> contentsChanged [

	self contentsSymbol ~= #blockEditor ifTrue: [self restoreTextualCodingPane].
	super contentsChanged
]

{ #category : #'as yet unclassified' }
SBBrowser >> contentsSymbolQuints [

	^ super contentsSymbolQuints, {
		{#blockEditor. #toggleBlockEditor. #showingBlockEditorString. 'block editor'. 'edit with the block editor'}
	}
]

{ #category : #'as yet unclassified' }
SBBrowser >> installBlockEditor [

	(textEditor notNil and: [textEditor owner isNil]) ifTrue: [^ self].
	
	self containingWindow
		replacePane: (textEditor ifNil: (textEditor := self codeTextMorph))
		with: (blockEditor := SBBrowserEditor new
			model: self;
			hResizing: #spaceFill;
			vResizing: #spaceFill;
			yourself)
]

{ #category : #'as yet unclassified' }
SBBrowser >> installTextEditor [

	(textEditor isNil or: [textEditor owner notNil]) ifTrue: [^ self].
	
	self contentsSymbol: self contentsSymbolQuints first first.
	^ self containingWindow replacePane: blockEditor with: textEditor
]

{ #category : #'as yet unclassified' }
SBBrowser >> restoreTextualCodingPane [

	(blockEditor notNil and: [blockEditor owner notNil]) ifTrue: [self installTextEditor]
]

{ #category : #'as yet unclassified' }
SBBrowser >> showingBlockEditorString [

	^ (self contentsSymbol = #blockEditor ifTrue: ['<yes>'] ifFalse: ['<no>']), 'block editor'
]

{ #category : #'as yet unclassified' }
SBBrowser >> toggleBlockEditor [

	self okToChange ifTrue: [
		self contentsSymbol = #blockEditor
			ifTrue: [self installTextEditor]
			ifFalse: [
				self contentsSymbol: #blockEditor.
				self installBlockEditor].
		self setContentsToForceRefetch.
		self contentsChanged]
]
