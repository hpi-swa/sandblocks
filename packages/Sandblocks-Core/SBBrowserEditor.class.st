Class {
	#name : #SBBrowserEditor,
	#superclass : #SBEditor,
	#instVars : [
		'model'
	],
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBBrowserEditor >> canDiscardEdits [

	^ self artefacts ifEmpty: [true] ifNotEmpty: [:m | m first hasUnsavedChanges not]
]

{ #category : #'as yet unclassified' }
SBBrowserEditor >> ensureOpened: aMethod [

	| found |
	found := false.
	self childSandblocks do: [:block | block isSandblock and: [block object = aMethod ifTrue: [found := true] ifFalse: [block delete]]].
	found ifFalse: [
		aMethod
			convertedFor: self objectInterfaceForDrop
			do: [:repr |
				self openMorphInView: (repr
					hResizing: #spaceFill;
					vResizing: #shrinkWrap).
				repr position: 0 @ 0]]
]

{ #category : #'as yet unclassified' }
SBBrowserEditor >> initialize [

	super initialize.
	scroll
		vResizing: #spaceFill;
		hResizing: #spaceFill;
		hScrollBarPolicy: #never.
	scroll scroller layoutPolicy: SBSimpleLayout new
]

{ #category : #'as yet unclassified' }
SBBrowserEditor >> model: aModel [

	model ifNotNil: [model removeDependent: self].
	model := aModel.
	model ifNotNil: [model addDependent: self]
]

{ #category : #'as yet unclassified' }
SBBrowserEditor >> scrollToShow: aRectangle [

	SBLabel text: ['if we''re larger than the total size and intersect already, don''t move'].
	aRectangle height > scroll height ifTrue: [^ super scrollToShow: (aRectangle topLeft extent: 0 @ 0)].
	super scrollToShow: aRectangle
]

{ #category : #'as yet unclassified' }
SBBrowserEditor >> scrollerClass [

	^ ScrollPane
]

{ #category : #'as yet unclassified' }
SBBrowserEditor >> update: aSymbol [

	aSymbol
		caseOf: {
			[#contents] -> [
				self ensureOpened: (model selectedMessageName
					ifNotNil: [:msg | model selectedClassOrMetaClass compiledMethodAt: msg]
					ifNil: [model selectedClassOrMetaClass])].
			[#wantToChange] -> [
				self canDiscardEdits ifFalse: [
					(self confirm: 'Changes have not been saved.
Is it OK to cancel those changes?' translated) ifTrue: [self artefacts first hasUnsavedChanges: false]]].
			[#accept] -> [self save]
		}
		otherwise: [nil]
]
