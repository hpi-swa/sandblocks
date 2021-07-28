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

	self flag: #fixme. " if we are as yet unsaved, don't try and read methods "
	(self relatedClass isKindOf: SBStClass) ifTrue: [^ self].

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

	^ aBlock isMethod ifTrue: [SBStDeleteMethodCommand new target: aBlock] ifFalse: [nil]
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
			(SBStMethodCategory new
				class: FrameRateMorph
				category: 'stepping and presenter'
				collapsed: false) wrapEditor]
		args: [{(FrameRateMorph >> #step) asSandblock. nil. false. nil}]
		label: 'example'.
	insertCommand := aBlock convertedFor: SBInterfaces stMethod do: [:m |
		SBInsertCommand new
			index: 2;
			morph: (m
				toggleCollapsed;
				hResizing: #spaceFill;
				yourself);
			container: self].
	changeCategoryCommand := SBStChangeMethodCategoryCommand new
		method: aBlock object;
		category: self firstSubmorph contents;
		class: self relatedClass.
	self sandblockEditor do: (SBCombinedCommand newWith: (aBlock isSelection
		ifTrue: [{changeCategoryCommand. SBDeleteCommand new target: aBlock sourceBlock. insertCommand}]
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
SBStMethodCategory >> isCollapsed [
	
	^ self submorphCount <= 1
]

{ #category : #'as yet unclassified' }
SBStMethodCategory >> newEmptyChildNear: aBlock before: aBoolean [

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
SBStMethodCategory >> saveString [
	
	^ String streamContents: [:stream |
		self printSaveStringPreambleOn: stream.
		stream
			nextPutAll: self className;
			nextPutAll: ' new class: ';
			nextPutAll:  class asString;
			nextPutAll: ' category: ';
			nextPut: $';
			nextPutAll:  savedCategoryName;
			nextPut: $';
			nextPutAll: ' collapsed: ';
			nextPutAll:  self isCollapsed asString
		]
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
	
	self isCollapsed 
		ifTrue: [self addMethods]
		ifFalse: [(self submorphs copyFrom: 2 to: self submorphCount) do: #delete]
]
