Class {
	#name : #SBStMethodCategory,
	#superclass : #SBBlock,
	#instVars : [
		'class',
		'savedCategoryName'
	],
	#category : #'Sandblocks-Smalltalk'
}

{ #category : #'as yet unclassified' }
SBStMethodCategory >> addMethods [

	(self relatedClass organization listAtCategoryNamed: savedCategoryName) sorted do: [:method |
		self addMorphBack: ((class lookupSelector: method) asSandblock
			toggleCollapsed;
			hResizing: #spaceFill)]
]

{ #category : #'as yet unclassified' }
SBStMethodCategory >> category [

	^ savedCategoryName
]

{ #category : #'as yet unclassified' }
SBStMethodCategory >> class: aClass category: aString collapsed: aBoolean [

	self firstSubmorph contents: aString.
	class := aClass.
	savedCategoryName := aString.
	
	aBoolean ifFalse: [self addMethods]
]

{ #category : #'as yet unclassified' }
SBStMethodCategory >> deleteCommandFor: aBlock [

	^ aBlock isMethod ifTrue: [(SBStDeleteMethodCommand newFor: self) target: aBlock] ifFalse: [nil]
]

{ #category : #'as yet unclassified' }
SBStMethodCategory >> drawSubmorphsOn: aCanvas [

	super drawSubmorphsOn: aCanvas.
	self hasUnsavedChanges ifTrue: [ | adornment |
		adornment := PluggableTextMorph adornmentWithColor: Color orange.
		aCanvas translucentImage: adornment at: self position + ((self width - adornment width) @ 0)]
]

{ #category : #'as yet unclassified' }
SBStMethodCategory >> expandAll [

	self submorphs allButFirstDo: #ensureExpanded
]

{ #category : #'as yet unclassified' }
SBStMethodCategory >> handleDroppedBlock: aBlock event: anEvent adding: aBoolean near: aMorph [

	| insertCommand changeCategoryCommand |
	SBExample
		self: [
			(SBStMethodCategory new class: FrameRateMorph category: 'stepping and presenter' collapsed: false) wrapEditor]
		args: [{(FrameRateMorph >> #step) asSandblock. nil. false. nil}]
		label: 'example'.
	insertCommand := aBlock convertedFor: SBInterfaces stMethod do: [:m |
		(SBInsertCommand newFor: self)
			index: 2;
			morph: (m
				toggleCollapsed;
				hResizing: #spaceFill;
				yourself);
			container: self].
	changeCategoryCommand := (SBStChangeMethodCategoryCommand newFor: self)
		method: aBlock object;
		category: self firstSubmorph contents;
		class: self relatedClass.
	self sandblockEditor do: (SBCombinedCommand newWith: (aBlock isSelection
		ifTrue: [
			{changeCategoryCommand. (SBDeleteCommand newFor: self) target: aBlock sourceBlock. insertCommand}]
		ifFalse: [{changeCategoryCommand. insertCommand}]))
]

{ #category : #'as yet unclassified' }
SBStMethodCategory >> initialize [

	super initialize.
	
	self
		changeTableLayout;
		hResizing: #spaceFill;
		vResizing: #shrinkWrap;
		addMorphBack: (SBTextBubble new
			colorAlpha: 0.6;
			bordered: false;
			yourself)
]

{ #category : #'as yet unclassified' }
SBStMethodCategory >> isArtefact [

	^ true
]

{ #category : #'as yet unclassified' }
SBStMethodCategory >> newNullBlock [

	^ SBStMethod new
		selector: '' arguments: #() class: self relatedClass;
		hResizing: #spaceFill;
		body: (SBStBlockBody new in: [:b | b statements: {b newNullBlock}])
]

{ #category : #'as yet unclassified' }
SBStMethodCategory >> object [

	^ self firstSubmorph contents
]

{ #category : #'as yet unclassified' }
SBStMethodCategory >> objectInterface [

	^ self firstSubmorph contents = 'as yet unclassified' ifTrue: [SBInterfaces never] ifFalse: [SBInterfaces stMethod]
]

{ #category : #'as yet unclassified' }
SBStMethodCategory >> prefersNoBorder [

	^ false
]

{ #category : #'as yet unclassified' }
SBStMethodCategory >> printOn: aStream [

	aStream
		nextPutAll: 'method category ';
		nextPutAll: self firstSubmorph contents
]

{ #category : #'as yet unclassified' }
SBStMethodCategory >> relatedClass [

	^ class ifNil: [self parentSandblock ifNotNil: #relatedClass]
]

{ #category : #'as yet unclassified' }
SBStMethodCategory >> saveTryFixing: aFixBoolean quick: aQuickBoolean [

	| currentName |
	currentName := self firstSubmorph contents.
	savedCategoryName ~= currentName ifTrue: [
		self relatedClass organization renameCategory: savedCategoryName toBe: currentName.
		savedCategoryName := currentName].
	^ true
]

{ #category : #'as yet unclassified' }
SBStMethodCategory >> toggleCollapsed [
	<action>
	
	self submorphCount > 1
		ifTrue: [(self submorphs copyFrom: 2 to: self submorphCount) do: #delete]
		ifFalse: [self addMethods]
]
