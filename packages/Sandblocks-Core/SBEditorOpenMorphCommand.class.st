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
		ifTrue: [editor applyLayoutProperties: aMorph]
		ifFalse: [self applyPositionTo: aMorph in: nil]
]

{ #category : #'as yet unclassified' }
SBEditorOpenMorphCommand >> do [

	self applyLayoutProperties: morph.
	
	self shouldOpenNewWindow
		ifTrue: [ | browser |
			browser := Browser fullOnClass: morph relatedClass category: morph category.
			browser contentsSymbol ~= #blockEditor ifTrue: [browser toggleBlockEditor].
			window := browser containingWindow.
			Project current addDeferredUIMessage: [
				browser blockEditor openOnlyMorph: morph.
				isUnsaved ifTrue: [browser blockEditor do: (SBDoItCommand new artefact: morph)].
				morph startInput.
				(morph isSmalltalk and: [morph isMethod and: [morph exists]]) ifTrue: [browser selectMessageNamed: morph selector]]]
		ifFalse: [
			editor isSingleArtefactView ifTrue: [
				priorChildren := editor childSandblocks.
				priorChildren do: #delete].
			self editor openMorph: morph.
			self applyPositionTo: morph in: nil.
			isUnsaved ifTrue: [self editor do: (SBDoItCommand new artefact: morph)]].
	
	morph isSandblock ifTrue: [morph withDecorator: SBForceMoveDecorator do: [:d | d createImplicitForces]].
	
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
SBEditorOpenMorphCommand >> hintBounds [

	^ 10 @ 10 center: morph center
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

	((morph hasOwner: self editor) and: [morph isSandblock]) ifTrue: [self editor startInput: morph at: 1 replacingContents: false]
]

{ #category : #'as yet unclassified' }
SBEditorOpenMorphCommand >> setArtefactFrom [

	^ nil
]

{ #category : #'as yet unclassified' }
SBEditorOpenMorphCommand >> shouldOpenNewWindow [

	^ editor isSingleArtefactView and: [(editor artefacts ifNotEmpty: [:a | a first hasUnsavedChanges] ifEmpty: [false]) and: [morph isSmalltalk and: [morph isMethod or: [morph isClassContainer]]]]
]

{ #category : #'as yet unclassified' }
SBEditorOpenMorphCommand >> undo [

	window ifNotNil: #delete.
	priorChildren ifNotNil: [priorChildren do: [:c | editor openMorph: c]].
	morph delete.
	^ nil
]
