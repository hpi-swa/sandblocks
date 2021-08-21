Class {
	#name : #SBStCodeOpener,
	#superclass : #Morph,
	#instVars : [
		'categories',
		'selectedCategoryIndex',
		'selectedClassIndex',
		'selectedMethodIndex',
		'classes',
		'messages',
		'currentPanelIndex',
		'result',
		'showingClassSide',
		'preview',
		'colorPolicy'
	],
	#category : #'Sandblocks-Smalltalk'
}

{ #category : #'as yet unclassified' }
SBStCodeOpener >> arrowKey: aChar from: view [

	" ignored "
]

{ #category : #'as yet unclassified' }
SBStCodeOpener >> categories [

	^ self systemOrganizer categories
]

{ #category : #'as yet unclassified' }
SBStCodeOpener >> classIconAt: anIndex [

	^ self toolIconForm: (ToolIcons iconForClass: (Smalltalk at: (self classes at: anIndex)))
]

{ #category : #'as yet unclassified' }
SBStCodeOpener >> classes [

	^ self systemOrganizer listAtCategoryNamed: (self categories at: self selectedCategoryIndex)
]

{ #category : #'as yet unclassified' }
SBStCodeOpener >> colorPolicy: aColorPolicy [

	colorPolicy := aColorPolicy
]

{ #category : #'as yet unclassified' }
SBStCodeOpener >> currentPanel [

	^ self submorphs at: currentPanelIndex
]

{ #category : #'as yet unclassified' }
SBStCodeOpener >> delete [

	super delete.
	
	preview ifNotNil: #delete
]

{ #category : #'as yet unclassified' }
SBStCodeOpener >> filterEvent: anEvent for: anObject [

	(anEvent isMouse and: [anEvent isMouseDown and: [(self containsPoint: anEvent position) not]]) ifTrue: [
		self delete.
		^ anEvent ignore].
	^ anEvent
]

{ #category : #'as yet unclassified' }
SBStCodeOpener >> focus: aMethodOrClass [

	aMethodOrClass ifNil: [^ self].
	
	aMethodOrClass isBehavior
		ifTrue: [
			self showingClassSide: aMethodOrClass isClassSide.
			self selectedCategoryIndex: (self categories indexOf: aMethodOrClass category).
			self selectedClassIndex: (self classes indexOf: aMethodOrClass theNonMetaClass name) moved: false.
			self selectedMethodIndex: 1.
			self focusPanel: 3]
		ifFalse: [
			self showingClassSide: aMethodOrClass methodClass isClassSide.
			self selectedCategoryIndex: (self categories indexOf: aMethodOrClass methodClass category).
			self selectedClassIndex: (self classes indexOf: aMethodOrClass methodClass theNonMetaClass name).
			self selectedMethodIndex: (self methods indexOf: aMethodOrClass selector) moved: false.
			self focusPanel: 3]
]

{ #category : #'as yet unclassified' }
SBStCodeOpener >> focusPanel: aNumber [

	currentPanelIndex := aNumber clampLow: 1 high: self submorphCount.
	self methods ifEmpty: [currentPanelIndex := currentPanelIndex min: 2].
	
	(currentPanelIndex = 2 and: [self selectedClassIndex = 0]) ifTrue: [self selectedClassIndex: 1 moved: false].
	currentPanelIndex < 2 ifTrue: [self selectedClassIndex: 0 moved: false].
	
	(currentPanelIndex = 3 and: [self selectedMethodIndex = 0]) ifTrue: [self selectedMethodIndex: 1 moved: false].
	currentPanelIndex < 3 ifTrue: [self selectedMethodIndex: 0 moved: false]
]

{ #category : #'as yet unclassified' }
SBStCodeOpener >> handlesKeyboard: anEvent [

	^ true
]

{ #category : #'as yet unclassified' }
SBStCodeOpener >> initialize [

	super initialize.
	
	selectedCategoryIndex := 1.
	selectedClassIndex := 0.
	selectedMethodIndex := 0.
	currentPanelIndex := 1.
	showingClassSide := false.
	
	self
		addMouseCaptureFilter: self;
		height: 200;
		changeTableLayout;
		addDropShadow;
		vResizing: #rigid;
		hResizing: #shrinkWrap;
		listDirection: #leftToRight;
		addMorphBack: (categories := (PluggableListMorphPlus
			on: self
			list: #categories
			selected: #selectedCategoryIndex
			changeSelected: #selectedCategoryIndex:
			menu: #menu:evaluate:)
			vResizing: #spaceFill;
			autoDeselect: false;
			keystrokePreviewSelector: #keyStroke:;
			width: 200;
			yourself);
		addMorphBack: (classes := (PluggableListMorphPlus
			on: self
			list: #classes
			selected: #selectedClassIndex
			changeSelected: #selectedClassIndex:
			menu: #menu:evaluate:)
			getIconSelector: #classIconAt:;
			doubleClickSelector: #openSelectedMethod;
			autoDeselect: false;
			keystrokePreviewSelector: #keyStroke:;
			vResizing: #spaceFill;
			width: 200;
			yourself);
		addMorphBack: (messages := (PluggableListMorphPlus
			on: self
			list: #methods
			selected: #selectedMethodIndex
			changeSelected: #selectedMethodIndex:
			menu: #menu:evaluate:)
			getIconSelector: #messageIconAt:;
			doubleClickSelector: #openSelectedMethod;
			autoDeselect: false;
			vResizing: #spaceFill;
			keystrokePreviewSelector: #keyStroke:;
			width: 200;
			yourself)
]

{ #category : #'as yet unclassified' }
SBStCodeOpener >> keyStroke: anEvent [

	anEvent keyCharacter = Character escape ifTrue: [self delete. ^ true].
	(anEvent keyCharacter = Character arrowRight or: [anEvent keyCharacter = $l and: [anEvent commandKeyPressed]]) ifTrue: [self focusPanel: currentPanelIndex + 1. ^ true].
	(anEvent keyCharacter = Character arrowLeft or: [anEvent keyCharacter = $h and: [anEvent commandKeyPressed]]) ifTrue: [self focusPanel: currentPanelIndex - 1. ^ true].
	anEvent keyCharacter = Character cr ifTrue: [result := self selectedClassOrMethod. self delete. ^ true].
	anEvent keyCharacter = Character tab ifTrue: [self showingClassSide: self showingClassSide not. ^ true].
	(anEvent keyCharacter = $j and: [anEvent commandKeyPressed]) ifTrue: [self select: 1. ^ true].
	(anEvent keyCharacter = $k and: [anEvent commandKeyPressed]) ifTrue: [self select: -1. ^ true].
	((anEvent keyCharacter = $f or: [anEvent keyCharacter = $x]) and: [anEvent commandKeyPressed]) ifTrue: [self focus: UIManager default chooseClassOrTrait. ^ true].
	self performKeystroke: anEvent withForwardDisabled: self currentPanel.
	^ true
]

{ #category : #'as yet unclassified' }
SBStCodeOpener >> menu: aMenu evaluate: anObject [
	" escape has been pressed - we ignore this and close instead "
	
	self delete.
	^ nil
]

{ #category : #'as yet unclassified' }
SBStCodeOpener >> messageIconAt: aNumber [

	^ self toolIconForm: (ToolIcons
		iconForClass: (Smalltalk at: (self classes at: self selectedClassIndex))
		selector: (self methods at: aNumber))
]

{ #category : #'as yet unclassified' }
SBStCodeOpener >> methods [

	^ self selectedClassIndex > 0 ifTrue: [
		(showingClassSide
			ifTrue: [(Smalltalk at: (self classes at: self selectedClassIndex)) class methodDict keys]
			ifFalse: [(Smalltalk at: (self classes at: self selectedClassIndex)) methodDict keys])
				sorted: [:a :b | a selector < b selector]] ifFalse: [#()]
]

{ #category : #'as yet unclassified' }
SBStCodeOpener >> morphicLayerNumber [

	^ 60
]

{ #category : #'as yet unclassified' }
SBStCodeOpener >> open [

	| hand world |
	" from DialogWindow>>getUserResponse "
	self openInWorld.
	hand := self currentHand.
	world := self currentWorld.
	
	hand showTemporaryCursor: nil.
	
	hand keyboardFocus in: [:priorKeyboardFocus |
		hand mouseFocus in: [:priorMouseFocus |
			hand newMouseFocus: nil.
			hand newKeyboardFocus: self currentPanel.
			
			[[self isInWorld] whileTrue: [world doOneSubCycle]] ifCurtailed: [self delete].
			
			hand newKeyboardFocus: priorKeyboardFocus
			"hand newMouseFocus: priorMouseFocus"]].
	
	^ result
]

{ #category : #'as yet unclassified' }
SBStCodeOpener >> openFor: aMethodOrClass [

	self focus: aMethodOrClass.
	^ self open
]

{ #category : #'as yet unclassified' }
SBStCodeOpener >> openSelectedMethod [

	result := self selectedClassOrMethod.
	self delete
]

{ #category : #'as yet unclassified' }
SBStCodeOpener >> performKeystroke: anEvent withForwardDisabled: aPanel [
	aPanel keystrokePreviewSelector: nil.
	aPanel keyStroke: anEvent.
	aPanel keystrokePreviewSelector: #keyStroke:.
]

{ #category : #'as yet unclassified' }
SBStCodeOpener >> positionNear: aMorph [

	self position: (aMorph center x - (self fullBounds width / 2)) @ aMorph top
]

{ #category : #'as yet unclassified' }
SBStCodeOpener >> select: aNumber [

	currentPanelIndex caseOf: {
		[1] -> [self selectedCategoryIndex: selectedCategoryIndex + aNumber].
		[2] -> [self selectedClassIndex: selectedClassIndex + aNumber moved: true].
		[3] -> [self selectedMethodIndex: selectedMethodIndex + aNumber moved: true]
	}
]

{ #category : #'as yet unclassified' }
SBStCodeOpener >> selectedCategory [

	^ self categories at: self selectedCategoryIndex
]

{ #category : #'as yet unclassified' }
SBStCodeOpener >> selectedCategoryIndex [

	^ selectedCategoryIndex
]

{ #category : #'as yet unclassified' }
SBStCodeOpener >> selectedCategoryIndex: aNumber [

	aNumber < 1 ifTrue: [selectedCategoryIndex := self categories size] ifFalse: [
		aNumber > self categories size
			ifTrue: [selectedCategoryIndex := 1]
			ifFalse: [selectedCategoryIndex := aNumber]].
	
	selectedMethodIndex := 0.
	selectedClassIndex := 0.
	self changed: #selectedCategoryIndex.
	self changed: #classes.
	self changed: #methods.
	self selectedClassIndex: 0 moved: false
]

{ #category : #'as yet unclassified' }
SBStCodeOpener >> selectedClass [

	^ self classes at: self selectedClassIndex
]

{ #category : #'as yet unclassified' }
SBStCodeOpener >> selectedClassIndex [

	^ selectedClassIndex
]

{ #category : #'as yet unclassified' }
SBStCodeOpener >> selectedClassIndex: aNumber [

	self selectedClassIndex: aNumber moved: true
]

{ #category : #'as yet unclassified' }
SBStCodeOpener >> selectedClassIndex: aNumber moved: aBoolean [

	(aNumber < 1 and: [aBoolean])
		ifTrue: [selectedClassIndex := self classes size]
		ifFalse: [
			aNumber > self classes size
				ifTrue: [selectedClassIndex := 1]
				ifFalse: [selectedClassIndex := aNumber]].
	
	self changed: #selectedClassIndex.
	self changed: #methods.
	self selectedMethodIndex: 0 moved: false
]

{ #category : #'as yet unclassified' }
SBStCodeOpener >> selectedClassOrMethod [

	^ (self selectedMethodIndex > 0 and: [self methods notEmpty])
		ifTrue: [self selectedMethod]
		ifFalse: [self selectedClassIndex > 0 ifTrue: [Smalltalk at: self selectedClass] ifFalse: [nil]]
]

{ #category : #'as yet unclassified' }
SBStCodeOpener >> selectedMethod [

	| class |
	class := (Smalltalk at: self selectedClass).
	showingClassSide ifTrue: [class := class class].
	^  class >> (self methods at: self selectedMethodIndex)
]

{ #category : #'as yet unclassified' }
SBStCodeOpener >> selectedMethodIndex [

	^ selectedMethodIndex
]

{ #category : #'as yet unclassified' }
SBStCodeOpener >> selectedMethodIndex: aNumber [

	self selectedMethodIndex: aNumber moved: true
]

{ #category : #'as yet unclassified' }
SBStCodeOpener >> selectedMethodIndex: aNumber moved: aBoolean [
	
	(aNumber < 1 and: [aBoolean])
		ifTrue: [selectedMethodIndex := self methods size]
		ifFalse: [
			aNumber > self methods size
				ifTrue: [selectedMethodIndex := 1]
				ifFalse: [selectedMethodIndex := aNumber]].
	
	self changed: #selectedMethodIndex.
	
	preview ifNotNil: #delete.
	
	(selectedMethodIndex > 0 and: [selectedClassIndex > 0 and: [self methods notEmpty]]) ifTrue: [
		preview := SBSelection new
			methodClass: self selectedClass;
			colorPolicy: (colorPolicy ifNil: [SBEditor defaultColorPolicy new]);
			addMorphBack: self selectedMethod asSandblock.
		preview openInWorld.
		preview topCenter: self bottomCenter]
]

{ #category : #'as yet unclassified' }
SBStCodeOpener >> showingClassSide [

	^ showingClassSide
]

{ #category : #'as yet unclassified' }
SBStCodeOpener >> showingClassSide: aBoolean [

	showingClassSide := aBoolean.
	self changed: #methods.
	self selectedMethodIndex: (self methods notEmpty ifTrue: [1] ifFalse: [0]) moved: false
]

{ #category : #'as yet unclassified' }
SBStCodeOpener >> systemOrganizer [

	^ SystemOrganizer default
]

{ #category : #'as yet unclassified' }
SBStCodeOpener >> toolIconForm: aSymbolOrForm [

	" there appears to be an API change here that we need to catch "
	^ aSymbolOrForm isForm ifTrue: [aSymbolOrForm] ifFalse: [ToolIcons  iconNamed:aSymbolOrForm]
]
