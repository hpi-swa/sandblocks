Class {
	#name : #SBBrowserEditor,
	#superclass : #SBEditor,
	#instVars : [
		'model'
	],
	#category : #'Sandblocks-Core'
}

{ #category : #'dependents access' }
SBBrowserEditor >> canDiscardEdits [

	^ self artefacts ifEmpty: [true] ifNotEmpty: [:m | m first hasUnsavedChanges not]
]

{ #category : #'as yet unclassified' }
SBBrowserEditor >> ensureOpened: aMethod [

	| found |
	found := false.
	self childSandblocks do: [:block | block isSandblock and: [block object = aMethod ifTrue: [found := true] ifFalse: [block delete]]].
	
	found ifFalse: [
		aMethod
			convertedFor: self objectInterfaceForDrop
			do: [:repr | self openMorphInView: repr]]
]

{ #category : #initialization }
SBBrowserEditor >> initialize [

	super initialize.
	scroll
		vResizing: #spaceFill;
		hResizing: #spaceFill;
		hScrollBarPolicy: #never.
	scroll scroller layoutPolicy: SBSimpleLayout new
]

{ #category : #testing }
SBBrowserEditor >> isSingleArtefactView [

	^ true
]

{ #category : #'model access' }
SBBrowserEditor >> model [

	^ model
]

{ #category : #'as yet unclassified' }
SBBrowserEditor >> model: aModel [

	model ifNotNil: [model removeDependent: self].
	model := aModel.
	model ifNotNil: [model addDependent: self]
]

{ #category : #'model access' }
SBBrowserEditor >> modelSelection [

	^ model selectedMessageName
		ifNotNil: [:msg | model selectedClassOrMetaClass compiledMethodAt: msg]
		ifNil: [model selectedClassOrMetaClass]
]

{ #category : #'model access' }
SBBrowserEditor >> modelSelection: anObject [

	anObject isBehavior ifTrue: [^ model selectClass: anObject].
	anObject isCompiledMethod ifTrue: [
		model selectedClass ~= anObject methodClass ifTrue: [model selectClass: anObject methodClass].
		^ model selectMessageNamed: anObject selector]
]

{ #category : #'submorphs-add/remove' }
SBBrowserEditor >> openMorphInView: aMorph [

	"| valid |
	valid := false.
	aMorph object isBehavior ifTrue: [
		valid := true.
		self model selectClass: aMorph object].
	aMorph object isCompiledMethod ifTrue: [
		valid := true.
		self model selectClass: aMorph object methodClass.
		self model selectMessageNamed: aMorph object selector].
	
	valid ifFalse: [^ self]."
	
	self childSandblocks do: [:block | block isSandblock ifTrue: [block delete]].
	super openMorphInView: (aMorph
					hResizing: #spaceFill;
					vResizing: #shrinkWrap).
	aMorph position: 0 @ 0
]

{ #category : #artefacts }
SBBrowserEditor >> save: anArtefact tryFixing: aFixBoolean quick: aQuickBoolean [

	| ret |
	ret := super save: anArtefact tryFixing: aFixBoolean quick: aQuickBoolean.
	((anArtefact object isBehavior or: [anArtefact object isCompiledMethod]) and: [self modelSelection ~= anArtefact object]) ifTrue: [self modelSelection: anArtefact object].
	^ ret
]

{ #category : #selection }
SBBrowserEditor >> scrollToShow: aRectangle [

	" if we're larger than the total size and intersect already, don't move "
	aRectangle height > scroll height ifTrue: [^ super scrollToShow: (aRectangle topLeft extent: 0 @ 0)].
	super scrollToShow: aRectangle
]

{ #category : #'as yet unclassified' }
SBBrowserEditor >> scrollerClass [

	^ ScrollPane
]

{ #category : #updating }
SBBrowserEditor >> update: aSymbol [

	aSymbol
		caseOf: {
			[#contents] -> [SBToggledCode comment: '' active: 0 do: {[self ensureOpened: self modelSelection]}].
			[#wantToChange] -> [
				self canDiscardEdits ifFalse: [
					(self confirm: 'Changes have not been saved.
Is it OK to cancel those changes?' translated) ifTrue: [history markSaved: self artefacts first]]].
			[#accept] -> [self save].
			[#editSelection] -> [self updateArtefact]
		}
		otherwise: [nil]
]

{ #category : #'model access' }
SBBrowserEditor >> updateArtefact [

	(model respondsTo: #editSelection) ifFalse: [
		^ self ensureOpened: (model selectedMessageName
			ifNotNil: [:msg | model selectedClassOrMetaClass compiledMethodAt: msg]
			ifNil: [model selectedClassOrMetaClass])].
	
	({#editClass. #editMessage} includes: model editSelection) ifTrue: [
		^ self ensureOpened: (model selectedMessageName
			ifNotNil: [:msg | model selectedClassOrMetaClass compiledMethodAt: msg]
			ifNil: [model selectedClassOrMetaClass])].
	
	#newClass = model editSelection ifTrue: [ | class |
		class := SBStClass new category: model selectedSystemCategoryName.
		self openMorphInView: class.
		class inputContainedUnknown].
	#newMessage = model editSelection ifTrue: [ | method |
		self openMorphInView: (method := SBStMethod new
			selector: '' arguments: #() class: model selectedClassOrMetaClass;
			body: (SBStBlockBody new in: [:b | b statements: {b newNullBlock}]);
			category: model selectedMessageCategoryName).
		^ self startInput: method at: 1 replacingContents: true]
]
