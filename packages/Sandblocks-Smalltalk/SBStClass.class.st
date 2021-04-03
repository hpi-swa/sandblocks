Class {
	#name : #SBStClass,
	#superclass : #SBBlock,
	#instVars : [
		'className',
		'superClassName',
		'instanceVariables',
		'class',
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

{ #category : #'class protocol' }
SBStClass >> canUnderstand: aSymbol [
	" we may not have been saved yet "
	
	^ class ifNotNil: [:c | c canUnderstand: aSymbol] ifNil: [false]
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

{ #category : #'class protocol' }
SBStClass >> compiledMethodAt: aSymbol ifAbsent: aBlock [
	" we may not have been saved yet "
	
	^ class ifNotNil: [:c | c compiledMethodAt: aSymbol ifAbsent: aBlock] ifNil: [aBlock value]
]

{ #category : #'as yet unclassified' }
SBStClass >> containingArtefact [

	^ self
]

{ #category : #'as yet unclassified' }
SBStClass >> createInitialize [
	<action>

	self sandblockEditor createArtefactInView: (SBStMethod new
		selector: 'initialize' arguments: #() class: self shownClass;
		body: (SBStBlockBody new statements: {
			(SBStMessageSend new receiver: (SBStName contents: 'super') selector: 'initialize' arguments: #())
		}))
]

{ #category : #'as yet unclassified' }
SBStClass >> createSubclass [
	<action>

	self sandblockEditor createArtefactInView: (SBStClass new
		category: self category;
		superClassName: className contents;
		yourself)
]

{ #category : #'as yet unclassified' }
SBStClass >> declarations [

	^ #()
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

	^ SBStASTNode preferredColor
]

{ #category : #'as yet unclassified' }
SBStClass >> ensureExpanded [
]

{ #category : #'as yet unclassified' }
SBStClass >> example [

	SBMorphExample
		setUp: [UndefinedObject new]
		cases: {SBMorphExampleCase name: 'example 1' caseBlock: [:m | m]}
		extent: 300 @ 200
]

{ #category : #'class protocol' }
SBStClass >> inheritsFrom: aClass [

	| superclass |
	superclass := Smalltalk at: self superClassName asSymbol.
	^ superclass = aClass or: [superclass inheritsFrom: aClass]
]

{ #category : #'as yet unclassified' }
SBStClass >> initialize [

	super initialize.
	
	self
		changeTableLayout;
		listDirection: #topToBottom;
		cellGap: 4 withScalingFactor;
		hResizing: #shrinkWrap;
		vResizing: #shrinkWrap;
		layoutInset: 6 withScalingFactor;
		addMorphBack: (className := SBTextBubble new
			emphasis: TextEmphasis bold;
			placeholderText: 'Class Name';
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
SBStClass >> name [

	^ self shownClassName
]

{ #category : #'as yet unclassified' }
SBStClass >> object [

	^ self relatedClass ifNil: [self]
]

{ #category : #'as yet unclassified' }
SBStClass >> preventOcclusion [

	^ true
]

{ #category : #'as yet unclassified' }
SBStClass >> printOn: aStream [

	aStream nextPutAll: self shownClassName
]

{ #category : #'as yet unclassified' }
SBStClass >> references [

	^ Array streamContents: [:stream |
		self sandblockEditor allBlocksDo: [:block |
			(block object = self object and: [block ~= self]) ifTrue: [stream nextPut: block]]]
]

{ #category : #'as yet unclassified' }
SBStClass >> relatedClass [

	^ class ifNil: [self]
]

{ #category : #'class protocol' }
SBStClass >> removeSelector: aSymbol [
	" we may not have been saved yet "
	
	class ifNotNil: [:c | c removeSelector: aSymbol]
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

	| oldClass environment newClassName oldName references blockReferences |
	self valid ifFalse: [^ false].
	
	oldClass := self shownClass.
	oldName := oldClass ifNil: [nil] ifNotNil: [:o | o theNonMetaClass name asString].
	newClassName := self shownClassName.
	environment := oldClass ifNotNil: #environment ifNil: [self environment].
	
	((oldClass isNil or: [oldName ~= newClassName]) and: [environment includesKey: newClassName asSymbol]) ifTrue: [
		(self confirm: ((newClassName, ' is an existing class in this system.
Redefining it might cause serious problems.
Is this really what you want to do?') asText
			makeBoldFrom: 1
			to: newClassName size)) ifFalse: [^ false]].
	
	self flag: #fixme.
	" also hits comments??? "
	
	oldClass ifNotNil: [
		blockReferences := self references.
		references := (self systemNavigation allCallsOn: oldName asSymbol) collect: [:m | m actualClass -> (m sourceString copyReplaceTokens: oldName with: newClassName)].
		oldClass rename: newClassName].
	
	class := environment beCurrentDuring: [
		self superclass subclassDefinerClass
			evaluate: self definitionString
			in: environment
			notifying: nil
			logged: false].
	
	oldClass ifNotNil: [
		blockReferences do: [:b | b class: oldClass].
		references do: [:pair | (pair key = oldClass ifTrue: [class] ifFalse: [pair key]) compile: pair value]].
	
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
SBStClass >> wantsInteractiveErrorCorrection [

	^ false
]
