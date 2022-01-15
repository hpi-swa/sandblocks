Class {
	#name : #SBStLivePreview,
	#superclass : #SBPopup,
	#instVars : [
		'scheduler',
		'editor',
		'errorDecorator'
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
	target ifNotNil: [self valueForBlock: target ifFound: [:res | res explore] onTimeout: [] onError: [:err | err explore]]
]

{ #category : #'as yet unclassified' }
SBStLivePreview >> editor: anEditor [

	editor := anEditor.
	anEditor when: #selectionChanged send: #selection: to: self
]

{ #category : #'as yet unclassified' }
SBStLivePreview >> executeCurrentExampleIfFound: foundBlock onTimeout: timeoutBlock onError: errorBlock [

	| env |
	env := (SBExecutionEnvironment getAllIn: editor) first.
	^ [[env execute] valueWithin: self timeout onTimeout: [timeoutBlock value]]
		on: SBStRunUntilValue
		do: [:val | foundBlock value: val value]
		on: Error, Halt, TestFailure
		do: [:ex | errorBlock value: ex]
]

{ #category : #presentation }
SBStLivePreview >> icon [

	^ self submorphs first
]

{ #category : #presentation }
SBStLivePreview >> initialize [

	super initialize.
	
	self
		addMorphBack: SBIcon iconInfoCircle;
		addMorphBack: SBStringMorph new
]

{ #category : #presentation }
SBStLivePreview >> isSelectable [

	^ false
]

{ #category : #presentation }
SBStLivePreview >> label [

	^ self submorphs second
]

{ #category : #presentation }
SBStLivePreview >> mouseCursorAt: anEvent [

	^ Cursor execute
]

{ #category : #'as yet unclassified' }
SBStLivePreview >> selection: aBlock [

	| target |
	scheduler ifNotNil: [scheduler removeAlarm: #show for: self].
	self owner ifNotNil: [self owner removeMorph: self].
	errorDecorator ifNotNil: [:d | d detach].
	
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

	| target show hadError |
	target := self blockForLookup: editor selection.
	target ifNil: [^ self].
	show := false.
	hadError := false.
	
	self
		valueForBlock: target
		ifFound: [:result |
			show := true.
			self label contents: ([result printString]
				on: Error
				do: [:err | '<error ({1})>' format: {result className}]).
			self icon changeIconName: #iconInfoCircle.
			target containingArtefact ifNotNil: [:a | a cacheType: result class for: target]]
		onTimeout: [
			show := true.
			self label contents: '<timeout>'.
			self icon changeIconName: #iconClockO]
		onError: [:err |
			hadError := true.
			show := true.
			self label contents: (err printStringLimitedTo: 40).
			self icon changeIconName: #iconBolt].
	
	hadError ifTrue: [
		" need to re-execute because the previous run was instrumented, so the PCs are off "
		self
			executeCurrentExampleIfFound: [:v | ]
			onTimeout: []
			onError: [:f | (SBSmallError findOpenContextFrom: f signalerContext in: editor) ifNotNil: [:b | b attachDecorator: (errorDecorator := SBErrorDecorator new subtle: true)]]].
	
	show ifTrue: [self showBelow: target]
]

{ #category : #'as yet unclassified' }
SBStLivePreview >> showDelay [

	^ 500
]

{ #category : #'as yet unclassified' }
SBStLivePreview >> timeout [

	^ 100 milliSeconds
]

{ #category : #'as yet unclassified' }
SBStLivePreview >> valueForBlock: aBlock ifFound: foundBlock onTimeout: timeoutBlock onError: errorBlock [

	aBlock containingArtefact exists ifFalse: [^ self].
	
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
				self executeCurrentExampleIfFound: foundBlock onTimeout: timeoutBlock onError: errorBlock] ensure: [
				currentMethod methodClass
					addSelectorSilently: currentMethod selector
					withMethod: currentMethod]].
		[env executeForBlock: aBlock ifFound: [:result | aClosure value: result]]}
]
