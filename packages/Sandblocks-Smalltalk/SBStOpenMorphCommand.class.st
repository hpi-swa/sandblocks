Class {
	#name : #SBStOpenMorphCommand,
	#superclass : #SBCommand,
	#instVars : [
		'editor',
		'morph',
		'window',
		'isUnsaved',
		'priorChildren'
	],
	#category : #'Sandblocks-Smalltalk'
}

{ #category : #'as yet unclassified' }
SBStOpenMorphCommand >> applyLayoutProperties: aMorph [

	editor isSingleArtefactView ifTrue: [
		aMorph
			hResizing: #spaceFill;
			vResizing: #shrinkWrap;
			position: 0 @ 0]
]

{ #category : #'as yet unclassified' }
SBStOpenMorphCommand >> do [

	self applyLayoutProperties: morph.
	
	self shouldOpenNewWindow
		ifTrue: [ | browser |
			browser := Browser fullOnClass: morph relatedClass category: morph category.
			browser contentsSymbol ~= #blockEditor ifTrue: [browser model toggleBlockEditor].
			window := browser containingWindow.
			Project current addDeferredUIMessage: [
				browser blockEditor openMorphInView: morph.
				isUnsaved ifTrue: [browser blockEditor do: (SBDoItCommand newFor: morph)].
				browser blockEditor startInput: morph at: 1 replacingContents: false]]
		ifFalse: [
			editor isSingleArtefactView ifTrue: [
				priorChildren := editor childSandblocks.
				priorChildren do: #delete].
			(self editor openMorphInViewCommand: morph) do].
	^ nil
]

{ #category : #'as yet unclassified' }
SBStOpenMorphCommand >> editor [

	^ editor
]

{ #category : #'as yet unclassified' }
SBStOpenMorphCommand >> editor: anEditor [

	editor := anEditor
]

{ #category : #'as yet unclassified' }
SBStOpenMorphCommand >> isUnsaved: aBoolean [

	isUnsaved := aBoolean
]

{ #category : #'as yet unclassified' }
SBStOpenMorphCommand >> morph: aMorph [

	morph := aMorph
]

{ #category : #'as yet unclassified' }
SBStOpenMorphCommand >> postDo [

	(morph hasOwner: self editor) ifTrue: [self editor startInput: morph at: 1 replacingContents: false]
]

{ #category : #'as yet unclassified' }
SBStOpenMorphCommand >> shouldOpenNewWindow [

	^ editor isSingleArtefactView and: [(editor artefacts ifNotEmpty: [:a | a first hasUnsavedChanges] ifEmpty: [false]) and: [morph isSmalltalk and: [morph isMethod]]]
]

{ #category : #'as yet unclassified' }
SBStOpenMorphCommand >> undo [

	window ifNotNil: #delete.
	priorChildren ifNotNil: [priorChildren do: [:c | editor openMorph: c]].
	morph delete.
	^ nil
]
