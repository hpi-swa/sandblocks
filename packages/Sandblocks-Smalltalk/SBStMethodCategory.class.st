Class {
	#name : #SBStMethodCategory,
	#superclass : #SBBlock,
	#instVars : [
		'class',
		'hasUnsavedChanges',
		'savedCategoryName'
	],
	#category : #'Sandblocks-Smalltalk'
}

{ #category : #'as yet unclassified' }
SBStMethodCategory >> addMethods [

	(class organization listAtCategoryNamed: savedCategoryName) do: [:method |
			self addMorphBack: ((class lookupSelector: method) asSandblock
				toggleCollapsed;
				hResizing: #spaceFill)]
]

{ #category : #'as yet unclassified' }
SBStMethodCategory >> category [

	^ savedCategoryName
]

{ #category : #'as yet unclassified' }
SBStMethodCategory >> childSandblocksDo: aBlock [

	self submorphsDo: aBlock
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
		class: class.
	self sandblockEditor do: (SBCombinedCommand newWith: (aBlock isSelection
		ifTrue: [
			{changeCategoryCommand. (SBDeleteCommand newFor: self) target: aBlock sourceBlock. insertCommand}]
		ifFalse: [{changeCategoryCommand. insertCommand}]))
]

{ #category : #'as yet unclassified' }
SBStMethodCategory >> hasUnsavedChanges [

	^ hasUnsavedChanges
]

{ #category : #'as yet unclassified' }
SBStMethodCategory >> hasUnsavedChanges: aBoolean [

	hasUnsavedChanges := aBoolean.
	self changed
]

{ #category : #'as yet unclassified' }
SBStMethodCategory >> initialize [

	super initialize.
	hasUnsavedChanges := false.
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
SBStMethodCategory >> insertCommandRequest: anAfterBoolean near: aBlock [

	^ (SBInsertCommand newFor: self containingArtefact)
		index: (self childSandblocks indexOf: aBlock) + (anAfterBoolean ifTrue: [1] ifFalse: [0]);
		container: self;
		morph: (SBStMethod new
			selector: ''
			arguments: #()
			class: class;
			hResizing: #spaceFill;
			body: (SBStBlockBody new in: [:b | b statements: {b newNullBlock}]));
		shouldMergeWithNext: true;
		yourself
]

{ #category : #'as yet unclassified' }
SBStMethodCategory >> isArtefact [

	^ true
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
SBStMethodCategory >> saveTryFixing: aFixBoolean quick: aQuickBoolean [

	| currentName |
	currentName := self firstSubmorph contents.
	savedCategoryName ~= currentName ifTrue: [
		class organization renameCategory: savedCategoryName toBe: currentName.
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