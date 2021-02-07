Class {
	#name : #SBClass,
	#superclass : #SBBlock,
	#instVars : [
		'className',
		'superClassName',
		'instanceVariables',
		'class',
		'hasUnsavedChanges',
		'classVariables',
		'poolDictionaries',
		'category'
	],
	#category : 'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBClass class >> newFor: aClass at: aPoint [

	^ self new class: aClass; position: aPoint; yourself
]

{ #category : #'as yet unclassified' }
SBClass >> addRow: aLabelString with: aBlock [

	self addMorphBack: (SBRow new
		cellGap: 4 withScalingFactor;
		addMorphBack: (SBStringMorph new contents: aLabelString);
		addMorphBack: aBlock)
]

{ #category : #'as yet unclassified' }
SBClass >> artefact [

	^ self shownClass
]

{ #category : #'as yet unclassified' }
SBClass >> category [

	^ category contents
]

{ #category : #'as yet unclassified' }
SBClass >> category: aString [

	category contents: aString
]

{ #category : #'as yet unclassified' }
SBClass >> childSandblocksDo: aBlock [

	aBlock value: className.
	aBlock value: superClassName.
	aBlock value: instanceVariables.
	aBlock value: classVariables.
	aBlock value: poolDictionaries.
	aBlock value: category
]

{ #category : #'as yet unclassified' }
SBClass >> class: aClass [

	className contents: aClass name.
	superClassName contents: (aClass superclass ifNil: ['ProtoObject'] ifNotNil: #name).
	instanceVariables contents: (aClass instVarNames collect: [:name | SBName contents: name]).
	classVariables contents: (aClass classVarNames collect: [:name | SBName contents: name]).
	poolDictionaries contents: (aClass sharedPools collect: [:pool | SBTextBubble new contents: (aClass environment keyAtIdentityValue: pool ifAbsent: ['private'])]).
	category contents: (aClass environment organization categoryOfElement: aClass theNonMetaClass name).
	class := aClass
]

{ #category : #'as yet unclassified' }
SBClass >> className: aString [

	className contents: aString
]

{ #category : #'as yet unclassified' }
SBClass >> classVariables [

	^ classVariables
]

{ #category : #'as yet unclassified' }
SBClass >> containingArtefact [

	^ self
]

{ #category : #'as yet unclassified' }
SBClass >> createInitialize [
	<action>

	self sandblockEditor openMorphInView: (SBMethod new
		selector: 'initialize' arguments: #() class: self shownClass;
		hasUnsavedChanges: true;
		body: (SBBlockBody new statements: {
			(SBMessageSend new receiver: (SBName contents: 'super') selector: 'initialize' arguments: #())
		}))
]

{ #category : #'as yet unclassified' }
SBClass >> createSubclass [
	<action>

	self sandblockEditor openMorphInView: (SBClass new
		hasUnsavedChanges: true;
		category: self category;
		superClassName: className contents;
		yourself)
]

{ #category : #'as yet unclassified' }
SBClass >> definitionString [

	SBExample self: [SBClass new class: SBClass] args: [{}] label: 'simple'.
	^ '{1} subclass: #{2}
	instanceVariableNames: ''{3}''
	classVariableNames: ''{4}''
	poolDictionaries: ''{5}''
	category: ''{6}''' format: {
		superClassName contents.
		className contents.
		((instanceVariables childSandblocks collect: #contents) joinSeparatedBy: ' ').
		((classVariables childSandblocks collect: #contents) joinSeparatedBy: ' ').
		((poolDictionaries childSandblocks collect: #contents) joinSeparatedBy: ' ').
		category contents
	}
]

{ #category : #'as yet unclassified' }
SBClass >> deleteClass [
	<action>
	
	| classToRemove |
	classToRemove := self relatedClass theNonMetaClass.
	(self confirm: 'Are you certain that you want to DELETE the class ', classToRemove name, ' (no easy undo)?') ifTrue: [
		classToRemove subclasses notEmpty ifTrue: [
			(self confirm: 'class has subclasses: still delete?') ifFalse: [^ self]].
		classToRemove removeFromSystem].
	self delete
]

{ #category : #'as yet unclassified' }
SBClass >> drawSubmorphsOn: aCanvas [

	super drawSubmorphsOn: aCanvas.
	
	self hasUnsavedChanges ifTrue: [ | adornment |
		adornment  := PluggableTextMorph adornmentWithColor: Color orange.
		aCanvas translucentImage: adornment at: self position + (self width - adornment width @ 0)]
]

{ #category : #'as yet unclassified' }
SBClass >> drawnColor [

	^ class sandblockColor
]

{ #category : #'as yet unclassified' }
SBClass >> ensureExpanded [
]

{ #category : #'as yet unclassified' }
SBClass >> hasUnsavedChanges [

	^ hasUnsavedChanges
]

{ #category : #'as yet unclassified' }
SBClass >> hasUnsavedChanges: aBoolean [

	hasUnsavedChanges ~= aBoolean ifTrue: [
		hasUnsavedChanges := aBoolean.
		self changed]
]

{ #category : #'as yet unclassified' }
SBClass >> initialize [

	super initialize.
	
	hasUnsavedChanges := false.
	
	self
		changeTableLayout;
		listDirection: #topToBottom;
		cellGap: 4 withScalingFactor;
		hResizing: #shrinkWrap;
		vResizing: #shrinkWrap;
		layoutInset: 6 withScalingFactor;
		addMorphBack: (className := SBTextBubble new
			emphasis: TextEmphasis bold;
			layoutInset: 6 withScalingFactor;
			font: (TextStyle default fontOfPointSize: 12));
		addRow: 'SuperClass' with: (superClassName := SBClassNameInput new contents: 'Object');
		addRow: 'Instance Variables:' with: (instanceVariables := SBNameList new);
		addRow: 'Class Variables:' with: (classVariables := SBNameList new);
		addRow: 'Pool Dictionaries:' with: (poolDictionaries := SBArray new);
		addRow: 'Category:' with: (category := SBTextBubble new);
		attachDecorator: SBMoveDecorator new
]

{ #category : #'as yet unclassified' }
SBClass >> instanceVariables [

	^ instanceVariables
]

{ #category : #'as yet unclassified' }
SBClass >> isArtefact [

	^ true
]

{ #category : #'as yet unclassified' }
SBClass >> isClassContainer [

	^ true
]

{ #category : #'as yet unclassified' }
SBClass >> isEditor [

	^ true
]

{ #category : #'as yet unclassified' }
SBClass >> isTopLevel [

	^ true
]

{ #category : #'as yet unclassified' }
SBClass >> object [

	^ self relatedClass
]

{ #category : #'as yet unclassified' }
SBClass >> preventOcclusion [

	^ true
]

{ #category : #'as yet unclassified' }
SBClass >> relatedClass [

	^ class
]

{ #category : #'as yet unclassified' }
SBClass >> saveTryFixing: aBoolean quick: aQuickBoolean [

	| oldClass environment newClassName |
	self valid ifFalse: [^ false].
	
	oldClass := self shownClass.
	newClassName := self shownClassName.
	environment := oldClass ifNotNil: #environment ifNil: [self environment].
	
	((oldClass isNil or: [oldClass theNonMetaClass name asString ~= newClassName])
		and: [environment includesKey: newClassName asSymbol]) ifTrue:
			[(self confirm: ((newClassName , ' is an existing class in this system.
Redefining it might cause serious problems.
Is this really what you want to do?') asText makeBoldFrom: 1 to: newClassName size))
				ifFalse: [^ false]].
	
	oldClass ifNotNil: [oldClass := oldClass superclass].
	class := environment beCurrentDuring: [
		oldClass subclassDefinerClass
			evaluate: self definitionString
			in: environment
			notifying: nil
			logged: false].
	
	^ true
]

{ #category : #'as yet unclassified' }
SBClass >> shownClass [

	^ class
]

{ #category : #'as yet unclassified' }
SBClass >> shownClassName [

	^ className contents
]

{ #category : #'as yet unclassified' }
SBClass >> storeOn: aStream [

	aStream
		nextPut: $(;
		nextPutAll: self className;
		nextPutAll: ' newFor: ';
		nextPutAll: self shownClass name;
		nextPutAll: ' at: '.
	self position storeOn: aStream.
	aStream nextPut: $)
]

{ #category : #'as yet unclassified' }
SBClass >> superClassName: aString [

	superClassName contents: aString
]

{ #category : #'as yet unclassified' }
SBClass >> textContents [

	^ self shownClass name
]

{ #category : #'as yet unclassified' }
SBClass >> valid [

	^ className contents notEmpty and: [superClassName contents notEmpty]
]

{ #category : #'as yet unclassified' }
SBClass >> wantsInteractiveErrorCorrection [

	^ false
]
