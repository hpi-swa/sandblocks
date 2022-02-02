Class {
	#name : #SBBrowserEditor,
	#superclass : #SBEditor,
	#instVars : [
		'model',
		'fillHorizontal',
		'fillVertical'
	],
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBBrowserEditor class >> openInWindow: aBlock [

	^ SBBrowserEditor new
		fillVertical: true;
		fillHorizontal: true;
		openMorphInView: aBlock;
		openInWindow
]

{ #category : #'as yet unclassified' }
SBBrowserEditor >> applyLayoutProperties: aMorph [

	aMorph
		hResizing: (self fillHorizontal ifTrue: [#spaceFill] ifFalse: [#shrinkWrap]);
		vResizing: (self fillVertical ifTrue: [#spaceFill] ifFalse: [#shrinkWrap]);
		position: 0 @ 0
]

{ #category : #'dependents access' }
SBBrowserEditor >> canDiscardEdits [

	^ self artefacts ifEmpty: [true] ifNotEmpty: [:m | m first hasUnsavedChanges not]
]

{ #category : #'as yet unclassified' }
SBBrowserEditor >> createEmptySmalltalkMethod [
	<addAction>
	<globalAction>

	^ super createEmptySmalltalkMethod category: model selectedMessageCategoryName
]

{ #category : #'as yet unclassified' }
SBBrowserEditor >> ensureOpened: aMethod [

	| found |
	found := false.
	self childSandblocks do: [:block | block isSandblock and: [block object = aMethod ifTrue: [found := true] ifFalse: [block delete]]].
	
	found ifFalse: [
		aMethod
			convertedFor: (self objectInterfaceNear: nil at: #after)
			do: [:repr |
				self openMorphInView: repr.
				repr startInput]].
	
	((model respondsTo: #autoSelectString) and: [model autoSelectString notNil]) ifTrue: [self search search: model autoSelectString]
]

{ #category : #accessing }
SBBrowserEditor >> fillHorizontal [

	^ fillHorizontal ifNil: [true]
]

{ #category : #accessing }
SBBrowserEditor >> fillHorizontal: aBoolean [

	fillHorizontal := aBoolean
]

{ #category : #accessing }
SBBrowserEditor >> fillVertical [

	^ fillVertical ifNil: [false]
]

{ #category : #accessing }
SBBrowserEditor >> fillVertical: aBoolean [

	fillVertical := aBoolean
]

{ #category : #'dependents access' }
SBBrowserEditor >> hasUnacceptedEdits [

	^ self artefacts ifEmpty: [false] ifNotEmpty: [:m | m first hasUnsavedChanges]
]

{ #category : #initialization }
SBBrowserEditor >> initialize [

	super initialize.
	
	fillHorizontal := true.
	fillVertical := false.
	
	scroll
		vResizing: #spaceFill;
		hResizing: #spaceFill;
		hScrollBarPolicy: #never;
		color: Color transparent.
	scroll scroller
		layoutPolicy: SBSimpleLayout new;
		on: #click send: #click: to: self
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
		ifNotNil: [:msg | model selectedClassOrMetaClass compiledMethodAt: msg ifAbsent: [nil]]
		ifNil: [model selectedClassOrMetaClass]
]

{ #category : #'model access' }
SBBrowserEditor >> modelSelection: anObject [

	anObject isBehavior ifTrue: [
		model selectClass: anObject.
		model
			changed: #systemCategoryList;
			changed: #classList.
		^ self].
	
	anObject isCompiledMethod ifTrue: [
		((model respondsTo: #selectClass:) and: [model selectedClass ~= anObject methodClass]) ifTrue: [model selectClass: anObject methodClass theNonMetaClass].
		((model respondsTo: #selectMessageCategoryNamed:) and: [model messageCategoryListSelection ~= anObject methodReference category]) ifTrue: [model selectMessageCategoryNamed: anObject methodReference category].
		((model respondsTo: #selectMessageNamed:) and: [model selectedMessage ~= anObject selector]) ifTrue: [model selectMessageNamed: anObject selector].
		model
			changed: #classList;
			changed: #messageCategoryList;
			changed: #messageList]
]

{ #category : #'as yet unclassified' }
SBBrowserEditor >> openOnlyMorph: aBlock [

	self childSandblocks do: [:block | block delete].
	self openMorph: aBlock
]

{ #category : #artefacts }
SBBrowserEditor >> save: anArtefact tryFixing: aFixBoolean quick: aQuickBoolean [

	| ret |
	ret := super save: anArtefact tryFixing: aFixBoolean quick: aQuickBoolean.
	
	model ifNotNil: [((anArtefact object isBehavior or: [anArtefact object isCompiledMethod]) and: [self modelSelection ~~ anArtefact object and: [anArtefact containingFloat = self]]) ifTrue: [self modelSelection: anArtefact object]].
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

	^ SBEditorScrollPane
]

{ #category : #'as yet unclassified' }
SBBrowserEditor >> tryOpenInNewWindow: anArtefact ifSuccess: aBlock [

	(anArtefact isSmalltalk and: [anArtefact isMethod]) ifTrue: [ | browser |
		browser := Browser fullOnClass: anArtefact relatedClass category: anArtefact category.
		browser contentsSymbol ~= #blockEditor ifTrue: [browser model toggleBlockEditor].
		Project current addDeferredUIMessage: [browser blockEditor openMorphInView: anArtefact].
		aBlock value]
]

{ #category : #updating }
SBBrowserEditor >> update: aSymbol [

	aSymbol
		caseOf: {
			[#contents] -> [SBToggledCode comment: '' active: 0 do: {[self ensureOpened: self modelSelection]}].
			[#wantToChange] -> [self canDiscardEdits ifFalse: [(self confirm: 'Changes have not been saved.
Is it OK to cancel those changes?' translated) ifTrue: [history markSaved: self artefacts first]]].
			[#accept] -> [self save].
			[#editSelection] -> [self updateArtefact].
			[#autoSelect] -> [self search search: model autoSelectString]}
		otherwise: [nil]
]

{ #category : #'model access' }
SBBrowserEditor >> updateArtefact [

	(model respondsTo: #editSelection) ifFalse: [
		^ self ensureOpened: (model selectedMessageName
			ifNotNil: [:msg | model selectedClassOrMetaClass ifNotNil: [:c | c compiledMethodAt: msg ifAbsent: [nil]]]
			ifNil: [model selectedClassOrMetaClass])].
	
	({#editClass. #editMessage} includes: model editSelection) ifTrue: [
		^ self ensureOpened: (model selectedMessageName
			ifNotNil: [:msg |
				model selectedClassOrMetaClass
					compiledMethodAt: msg
					ifAbsent: [model selectedClassOrMetaClass]]
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
		method inputContainedUnknown]
]

{ #category : #initialization }
SBBrowserEditor >> wantsMinimalLayout [

	^ true
]
