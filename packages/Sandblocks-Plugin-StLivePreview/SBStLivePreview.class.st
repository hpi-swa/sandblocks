Class {
	#name : #SBStLivePreview,
	#superclass : #SBBlock,
	#instVars : [
		'scheduler',
		'editor'
	],
	#category : #'Sandblocks-Plugin-StLivePreview'
}

{ #category : #'as yet unclassified' }
SBStLivePreview class >> activatePluginIn: anEditor [
	<plugin: 'Show a live preview of values in methods where there is an executable environment'>
	<language: #smalltalk>

	^ self new editor: anEditor
]

{ #category : #'as yet unclassified' }
SBStLivePreview class >> deactivatePlugin: aBlock in: anEditor [

	anEditor removeActionsWithReceiver: aBlock.
	aBlock delete
]

{ #category : #'as yet unclassified' }
SBStLivePreview >> blockForLookup: aBlock [

	| target |
	aBlock ifNil: [^ nil].
	aBlock containingArtefact ifNil: [^ nil].
	aBlock containingArtefact isMethod ifFalse: [^ nil].
	aBlock isInWorld ifFalse: [^ nil].
	
	target := aBlock.
	[target notNil and: [target isExpression not]] whileTrue: [target := target parentSandblock].
	
	^ target
]

{ #category : #presentation }
SBStLivePreview >> click: anEvent [

	| target |
	target := self blockForLookup: editor selection.
	target ifNotNil: [self valueForBlock: target ifFound: [:res | res explore]]
]

{ #category : #'as yet unclassified' }
SBStLivePreview >> editor: anEditor [

	editor := anEditor.
	anEditor when: #selectionChanged send: #selection: to: self
]

{ #category : #presentation }
SBStLivePreview >> initialize [

	super initialize.
	
	self
		addMorphBack: SBStringMorph new;
		changeTableLayout;
		hResizing: #shrinkWrap;
		vResizing: #shrinkWrap;
		color: (Color r: 1 g: 1 b: 1);
		layoutInset: 4;
		disableLayout: true;
		addDropShadow
]

{ #category : #presentation }
SBStLivePreview >> isSelectable [

	^ false
]

{ #category : #presentation }
SBStLivePreview >> morphicLayerNumber [

	^ 99
]

{ #category : #presentation }
SBStLivePreview >> mouseCursorAt: anEvent [

	^ Cursor execute
]

{ #category : #presentation }
SBStLivePreview >> preventOcclusion [

	^ false
]

{ #category : #'as yet unclassified' }
SBStLivePreview >> selection: aBlock [

	| target |
	scheduler ifNotNil: [scheduler removeAlarm: #show for: self].
	self owner ifNotNil: [self owner removeMorph: self].
	
	target := self blockForLookup: aBlock.
	target ifNil: [^ self].
	
	(SBExecutionEnvironment getAllIn: editor) ifNotEmpty: [
		scheduler := target alarmScheduler.
		scheduler
			addAlarm: #show
			withArguments: {}
			for: self
			at: Time millisecondClockValue + self showDelay]
]

{ #category : #'as yet unclassified' }
SBStLivePreview >> show [

	| target |
	target := self blockForLookup: editor selection.
	target ifNil: [^ self].
	self valueForBlock: target ifFound: [:result |
		editor openMorph: self.
		target ensureLayouted.
		self position: target bottomLeft.
		self firstSubmorph contents: ([result printString]
			on: Error
			do: [:err | '<error ({1})>' format: {result className}])]
]

{ #category : #'as yet unclassified' }
SBStLivePreview >> showDelay [

	^ 500
]

{ #category : #'as yet unclassified' }
SBStLivePreview >> valueForBlock: aBlock ifFound: aClosure [

	| env |
	env := (SBExecutionEnvironment getAllIn: editor) first.
	^ SBToggledCode comment: '' active: 1 do: {
		[ | cmd currentMethod methodBlock selection newMethod |
			methodBlock := aBlock containingArtefact veryDeepCopy.
			selection := methodBlock copyFindSelection: aBlock in: aBlock containingArtefact.
			
			cmd := SBWrapCommand new
				outer: SBStMessageSend new;
				inner: selection;
				wrap: [:outer :inner | outer receiver: inner selector: #sbLivePreview].
			
			currentMethod := methodBlock compiledMethod.
			
			cmd do.
			newMethod := methodBlock compileMethodObject.
			newMethod ifNil: [^ nil].
			
			[
				currentMethod methodClass
					addSelectorSilently: currentMethod selector
					withMethod: newMethod.
				[env execute]
					on: SBStRunUntilValue
					do: [:val | aClosure value: val value]
					on: Exception
					do: [:ex | ex]] ensure: [
				currentMethod methodClass
					addSelectorSilently: currentMethod selector
					withMethod: currentMethod]].
		[env executeForBlock: aBlock ifFound: [:result | aClosure value: result]]}
]
