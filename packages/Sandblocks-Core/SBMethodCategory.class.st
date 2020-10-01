Class {
	#name : #SBMethodCategory,
	#superclass : #SBBlock,
	#instVars : [
		'class',
		'hasUnsavedChanges',
		'savedCategoryName'
	],
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBMethodCategory >> acceptedRepresentation [

	^ self firstSubmorph contents = 'as yet unclassified' ifTrue: [nil] ifFalse: [#isMethod]
]

{ #category : #'as yet unclassified' }
SBMethodCategory >> addMethods [

	(class organization listAtCategoryNamed: savedCategoryName) do: [:method |
			self addMorphBack: ((class lookupSelector: method) asSandblock
				toggleCollapsed;
				hResizing: #spaceFill)]
]

{ #category : #'as yet unclassified' }
SBMethodCategory >> category [

	^ savedCategoryName
]

{ #category : #'as yet unclassified' }
SBMethodCategory >> childSandblocksDo: aBlock [

	self submorphsDo: aBlock
]

{ #category : #'as yet unclassified' }
SBMethodCategory >> class: aClass category: aString collapsed: aBoolean [

	self firstSubmorph contents: aString.
	class := aClass.
	savedCategoryName := aString.
	
	aBoolean ifFalse: [self addMethods]
]

{ #category : #'as yet unclassified' }
SBMethodCategory >> drawSubmorphsOn: aCanvas [

	super drawSubmorphsOn: aCanvas.
	self hasUnsavedChanges ifTrue: [ | adornment |
		adornment := PluggableTextMorph adornmentWithColor: Color orange.
		aCanvas image: adornment at: self position + ((self width - adornment width) @ 0)]
]

{ #category : #'as yet unclassified' }
SBMethodCategory >> handleDroppedBlock: aBlock event: anEvent [

	| insertCommand changeCategoryCommand |
	SBExample
		self: [
			SBMethodCategory new class: FrameRateMorph category: 'stepping and presenter' collapsed: false]
		args: [{(FrameRateMorph >> #step) asSandblock. nil}]
		label: 'example'.
	insertCommand := (SBInsertCommand newFor: self)
		index: 2;
		morph: ((aBlock object representationThat: #isMethodBlock)
			toggleCollapsed;
			hResizing: #spaceFill;
			yourself);
		container: self.
	changeCategoryCommand := (SBChangeMethodCategoryCommand newFor: self)
		method: aBlock object;
		category: self firstSubmorph contents;
		class: class.
	self sandblockEditor do: (SBCombinedCommand newWith: (aBlock isSelection
		ifTrue: [
			{
				changeCategoryCommand.
				((SBDeleteCommand newFor: self) target: aBlock sourceBlock).
				insertCommand
			}]
		ifFalse: [{changeCategoryCommand. insertCommand}]))
]

{ #category : #'as yet unclassified' }
SBMethodCategory >> hasUnsavedChanges [

	^ hasUnsavedChanges
]

{ #category : #'as yet unclassified' }
SBMethodCategory >> hasUnsavedChanges: aBoolean [

	hasUnsavedChanges := aBoolean.
	self changed
]

{ #category : #'as yet unclassified' }
SBMethodCategory >> initialize [

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
SBMethodCategory >> isArtefact [

	^ true
]

{ #category : #'as yet unclassified' }
SBMethodCategory >> object [

	^ self firstSubmorph contents
]

{ #category : #'as yet unclassified' }
SBMethodCategory >> prefersNoBorder [

	^ false
]

{ #category : #'as yet unclassified' }
SBMethodCategory >> printOn: aStream [

	aStream
		nextPutAll: 'method category ';
		nextPutAll: self firstSubmorph contents
]

{ #category : #'as yet unclassified' }
SBMethodCategory >> saveTryFixing: aFixBoolean quick: aQuickBoolean [

	| currentName |
	currentName := self firstSubmorph contents.
	savedCategoryName ~= currentName ifTrue: [
		class organization renameCategory: savedCategoryName toBe: currentName.
		savedCategoryName := currentName].
	^ true
]

{ #category : #'as yet unclassified' }
SBMethodCategory >> toggleCollapsed [
	<action>
	
	self submorphCount > 1
		ifTrue: [(self submorphs copyFrom: 2 to: self submorphCount) do: #delete]
		ifFalse: [self addMethods]
]
