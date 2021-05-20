Class {
	#name : #SBEditorOpenMorphCommand,
	#superclass : #SBCommand,
	#instVars : [
		'editor',
		'morph',
		'window',
		'isUnsaved',
		'priorChildren'
	],
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBEditorOpenMorphCommand >> applyLayoutProperties: aMorph [

	editor isSingleArtefactView
		ifTrue: [
			aMorph
				hResizing: #spaceFill;
				vResizing: #shrinkWrap;
				position: 0 @ 0]
		ifFalse: [self applyPositionTo: aMorph in: nil]
]

{ #category : #'as yet unclassified' }
SBEditorOpenMorphCommand >> do [

	self applyLayoutProperties: morph.
	
	self shouldOpenNewWindow
		ifTrue: [ | browser |
			browser := Browser fullOnClass: morph relatedClass category: morph category.
			browser contentsSymbol ~= #blockEditor ifTrue: [browser model toggleBlockEditor].
			window := browser containingWindow.
			Project current addDeferredUIMessage: [
				browser blockEditor openMorphInView: morph.
				isUnsaved ifTrue: [browser blockEditor do: (SBDoItCommand new artefact: morph)].
				browser blockEditor startInput: morph at: 1 replacingContents: false]]
		ifFalse: [
			editor isSingleArtefactView ifTrue: [
				priorChildren := editor childSandblocks.
				priorChildren do: #delete].
			(self editor openMorphInViewCommand: morph) do.
			self applyPositionTo: morph in: nil].
	^ nil
]

{ #category : #'as yet unclassified' }
SBEditorOpenMorphCommand >> editor [

	^ editor
]

{ #category : #'as yet unclassified' }
SBEditorOpenMorphCommand >> editor: anEditor [

	editor := anEditor
]

{ #category : #'as yet unclassified' }
SBEditorOpenMorphCommand >> isUnsaved: aBoolean [

	isUnsaved := aBoolean
]

{ #category : #'as yet unclassified' }
SBEditorOpenMorphCommand >> morph: aMorph [

	morph := aMorph
]

{ #category : #'as yet unclassified' }
SBEditorOpenMorphCommand >> postDo [

	(morph hasOwner: self editor) ifTrue: [self editor startInput: morph at: 1 replacingContents: false]
]

{ #category : #'as yet unclassified' }
SBEditorOpenMorphCommand >> setArtefactFrom [

	^ nil
]

{ #category : #'as yet unclassified' }
SBEditorOpenMorphCommand >> shouldOpenNewWindow [

	^ editor isSingleArtefactView and: [(editor artefacts ifNotEmpty: [:a | a first hasUnsavedChanges] ifEmpty: [false]) and: [morph isSmalltalk and: [morph isMethod]]]
]

{ #category : #'as yet unclassified' }
SBEditorOpenMorphCommand >> undo [

	window ifNotNil: #delete.
	priorChildren ifNotNil: [priorChildren do: [:c | editor openMorph: c]].
	morph delete.
	^ nil
]