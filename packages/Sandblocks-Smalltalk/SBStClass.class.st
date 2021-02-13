Class {
	#name : #SBStClass,
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
	#category : #'Sandblocks-Smalltalk'
}

{ #category : #'as yet unclassified' }
SBStClass class >> newFor: aClass at: aPoint [

	^ self new class: aClass; position: aPoint; yourself
]

{ #category : #'as yet unclassified' }
SBStClass >> addRow: aLabelString with: aBlock [

	self addMorphBack: (SBRow new
		cellGap: 4 withScalingFactor;
		addMorphBack: (SBStringMorph new contents: aLabelString);
		addMorphBack: aBlock)
]

{ #category : #'as yet unclassified' }
SBStClass >> artefact [

	^ self shownClass
]

{ #category : #'as yet unclassified' }
SBStClass >> category [

	^ category contents
]

{ #category : #'as yet unclassified' }
SBStClass >> category: aString [

	category contents: aString
]

{ #category : #'as yet unclassified' }
SBStClass >> childSandblocksDo: aBlock [

	aBlock value: className.
	aBlock value: superClassName.
	aBlock value: instanceVariables.
	aBlock value: classVariables.
	aBlock value: poolDictionaries.
	aBlock value: category
]

{ #category : #'as yet unclassified' }
SBStClass >> class: aClass [

	className contents: aClass name.
	superClassName contents: (aClass superclass ifNil: ['ProtoObject'] ifNotNil: #name).
	instanceVariables contents: (aClass instVarNames collect: [:name | SBStName contents: name]).
	classVariables contents: (aClass classVarNames collect: [:name | SBStName contents: name]).
	poolDictionaries contents: (aClass sharedPools collect: [:pool | SBTextBubble new contents: (aClass environment keyAtIdentityValue: pool ifAbsent: ['private'])]).
	category contents: (aClass environment organization categoryOfElement: aClass theNonMetaClass name).
	class := aClass
]

{ #category : #'as yet unclassified' }
SBStClass >> className: aString [

	className contents: aString
]

{ #category : #'as yet unclassified' }
SBStClass >> classVariables [

	^ classVariables
]

{ #category : #'as yet unclassified' }
SBStClass >> containingArtefact [

	^ self
]

{ #category : #'as yet unclassified' }
SBStClass >> createInitialize [
	<action>

	self sandblockEditor openMorphInView: (SBStMethod new
		selector: 'initialize' arguments: #() class: self shownClass;
		hasUnsavedChanges: true;
		body: (SBStBlockBody new statements: {
			(SBStMessageSend new receiver: (SBStName contents: 'super') selector: 'initialize' arguments: #())
		}))
]

{ #category : #'as yet unclassified' }
SBStClass >> createSubclass [
	<action>

	self sandblockEditor openMorphInView: (SBStClass new
		hasUnsavedChanges: true;
		category: self category;
		superClassName: className contents;
		yourself)
]

{ #category : #'as yet unclassified' }
SBStClass >> definitionString [

	SBExample self: [SBStClass new class: SBStClass] args: [{}] label: 'simple'.
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
SBStClass >> deleteClass [
	<action>
	
	| classToRemove |
	classToRemove := self relatedClass theNonMetaClass.
	(self confirm: 'Are you certain that you want to DELETE the class ', classToRemove name, ' (no easy undo)?') ifTrue: [
		classToRemove subclasses notEmpty ifTrue: [
			(self confirm: 'class has subclasses: still delete?') ifFalse: [^ self]].
		classToRemove removeFromSystem.
		self delete].
]

{ #category : #'as yet unclassified' }
SBStClass >> drawSubmorphsOn: aCanvas [

	super drawSubmorphsOn: aCanvas.
	
	self hasUnsavedChanges ifTrue: [ | adornment |
		adornment  := PluggableTextMorph adornmentWithColor: Color orange.
		aCanvas translucentImage: adornment at: self position + (self width - adornment width @ 0)]
]

{ #category : #'as yet unclassified' }
SBStClass >> drawnColor [

	^ class sandblockColor
]

{ #category : #'as yet unclassified' }
SBStClass >> ensureExpanded [
]

{ #category : #'as yet unclassified' }
SBStClass >> hasUnsavedChanges [

	^ hasUnsavedChanges
]

{ #category : #'as yet unclassified' }
SBStClass >> hasUnsavedChanges: aBoolean [

	hasUnsavedChanges ~= aBoolean ifTrue: [
		hasUnsavedChanges := aBoolean.
		self changed]
]

{ #category : #'as yet unclassified' }
SBStClass >> initialize [

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
		addRow: 'SuperClass' with: (superClassName := SBStClassNameInput new contents: 'Object');
		addRow: 'Instance Variables:' with: (instanceVariables := SBStNameList new);
		addRow: 'Class Variables:' with: (classVariables := SBStNameList new);
		addRow: 'Pool Dictionaries:' with: (poolDictionaries := SBStArray new);
		addRow: 'Category:' with: (category := SBTextBubble new);
		attachDecorator: SBMoveDecorator new
]

{ #category : #'as yet unclassified' }
SBStClass >> instanceVariables [

	^ instanceVariables
]

{ #category : #'as yet unclassified' }
SBStClass >> isArtefact [

	^ true
]

{ #category : #'as yet unclassified' }
SBStClass >> isClassContainer [

	^ true
]

{ #category : #'as yet unclassified' }
SBStClass >> isEditor [

	^ true
]

{ #category : #'as yet unclassified' }
SBStClass >> isTopLevel [

	^ true
]

{ #category : #'as yet unclassified' }
SBStClass >> object [

	^ self relatedClass
]

{ #category : #'as yet unclassified' }
SBStClass >> preventOcclusion [

	^ true
]

{ #category : #'as yet unclassified' }
SBStClass >> relatedClass [

	^ class
]

{ #category : #'as yet unclassified' }
SBStClass >> renameClass [
	<action>
	
	| name |
	name := (UIManager default request: 'New Name?') ifNotNil: #asSymbol ifNil: [^ self].
	Smalltalk at: name ifPresent: [^ UIManager default inform: 'Binding with this name already exists. Aborting.'].
	
	
]

{ #category : #'as yet unclassified' }
SBStClass >> saveTryFixing: aBoolean quick: aQuickBoolean [

	| oldClass environment newClassName oldName references |
	self valid ifFalse: [^ false].
	
	oldClass := self shownClass.
	oldName := oldClass ifNil: [nil] ifNotNil: [:o | o theNonMetaClass name asString].
	newClassName := self shownClassName.
	environment := oldClass ifNotNil: #environment ifNil: [self environment].
	
	((oldClass isNil or: [oldName ~= newClassName])
		and: [environment includesKey: newClassName asSymbol]) ifTrue:
			[(self confirm: ((newClassName , ' is an existing class in this system.
Redefining it might cause serious problems.
Is this really what you want to do?') asText makeBoldFrom: 1 to: newClassName size))
				ifFalse: [^ false]].
	
	self flag: #fixme. " also hits comments??? "
	references := (self systemNavigation allCallsOn: oldName asSymbol)
		collect: [:m | m actualClass -> (m sourceString copyReplaceTokens: oldName with: newClassName)].
	oldClass ifNotNil: [oldClass rename: newClassName].
	
	class := environment beCurrentDuring: [
		self superclass subclassDefinerClass
			evaluate: self definitionString
			in: environment
			notifying: nil
			logged: false].
	
	references do: [:pair | (pair key = oldClass ifTrue: [class] ifFalse: [pair key]) compile: pair value].
	
	^ true
]

{ #category : #'as yet unclassified' }
SBStClass >> shownClass [

	^ class
]

{ #category : #'as yet unclassified' }
SBStClass >> shownClassName [

	^ className contents
]

{ #category : #'as yet unclassified' }
SBStClass >> storeOn: aStream [

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
SBStClass >> superClassName [

	^ superClassName contents
]

{ #category : #'as yet unclassified' }
SBStClass >> superClassName: aString [

	superClassName contents: aString
]

{ #category : #'as yet unclassified' }
SBStClass >> superclass [

	^ Smalltalk at: self superClassName asSymbol
]

{ #category : #'as yet unclassified' }
SBStClass >> textContents [

	^ self shownClass name
]

{ #category : #'as yet unclassified' }
SBStClass >> valid [

	^ className contents notEmpty and: [superClassName contents notEmpty]
]

{ #category : #'as yet unclassified' }
SBStClass >> wantsInteractiveErrorCorrection [

	^ false
]