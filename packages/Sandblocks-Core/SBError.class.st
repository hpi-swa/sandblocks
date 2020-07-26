Class {
	#name : #SBError,
	#superclass : #SBBlock,
	#instVars : [
		'error',
		'process',
		'currentStackFrame',
		'frames',
		'explorer',
		'temporaries'
	],
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBError >> balloonText [

	^ error asString
]

{ #category : #'as yet unclassified' }
SBError >> canCopy [

	^ false
]

{ #category : #'as yet unclassified' }
SBError >> childSandblocksDo: aBlock [

	frames submorphsDo: aBlock
]

{ #category : #'as yet unclassified' }
SBError >> createFrameForContext: aContext [

	| frame |
	frame := SBErrorStackFrame new context: aContext.
	frame when: #selected send: #currentStackFrame: to: self with: frame.
	
	^ frame
]

{ #category : #'as yet unclassified' }
SBError >> currentBlockForPC [

	| method |
	method := self sandblockEditor open: (self currentStackFrame context method).
	^ method blockForPC: self currentStackFrame context pc
]

{ #category : #'as yet unclassified' }
SBError >> currentStackFrame [

	^ currentStackFrame
]

{ #category : #'as yet unclassified' }
SBError >> currentStackFrame: aFrameBlock [

	(currentStackFrame notNil and: [currentStackFrame ~= aFrameBlock]) ifTrue: [currentStackFrame closed].
	currentStackFrame := aFrameBlock.
	
	self updateExplorers
]

{ #category : #'as yet unclassified' }
SBError >> drawnColor [

	^ Color white
]

{ #category : #'as yet unclassified' }
SBError >> error: anError process: aProcess [

	error := anError.
	process := aProcess.
	self addMorphFront: (SBRow new
		addMorphBack: (SBIcon iconFlash color: Color red);
		addMorphBack: (SBStringMorph new bold; contents: (anError asString truncateMiddleTo: 30));
		yourself)
]

{ #category : #'as yet unclassified' }
SBError >> expanded [

	^ frames submorphCount > 1
]

{ #category : #'as yet unclassified' }
SBError >> focus [

	| stack |
	self expanded ifTrue: [^ self focusNextFrame].
	
	self addMorphBack: frames.
	stack := self rootContext stack.
	stack from: 1 to: (self maxFrames min: stack size) do: [:context | frames addMorphBack: (self createFrameForContext: context)].
	
	frames sandblockEditor select: (frames submorphs detect: [:frame | self sandblockEditor isMethodOpen: frame context method] ifNone: [frames firstSubmorph])
]

{ #category : #'as yet unclassified' }
SBError >> focusNextFrame [

	self currentStackFrame nextBlock select
]

{ #category : #'as yet unclassified' }
SBError >> focusPreviousFrame [

	self currentStackFrame previousBlock select
]

{ #category : #'as yet unclassified' }
SBError >> initialize [

	super initialize.
	self
		vResizing: #shrinkWrap;
		hResizing: #shrinkWrap;
		changeTableLayout;
		layoutInset: 6 withScalingFactor;
		cellGap: 8 withScalingFactor.
	
	frames := SBColumn new
]

{ #category : #'as yet unclassified' }
SBError >> maxFrames [

	^ 10
]

{ #category : #'as yet unclassified' }
SBError >> outOfWorld: aWorld [

	super outOfWorld: aWorld.
	
	process ifNotNil: #terminate
]

{ #category : #'as yet unclassified' }
SBError >> resetContext: aContext [

	aContext ~= frames firstSubmorph context ifTrue: [ | stack dropToIndex addFromIndex |
		" find the minimal update required to reconcile our UI with the stack by looking if we can just drop or add elements "
		stack := aContext contextStack.
		dropToIndex := frames submorphs findFirst: [:frame | frame context = aContext].
		
		dropToIndex ~= 0
			ifTrue: [frames removeAllMorphsIn: (frames submorphs viewFrom: 1 to: dropToIndex - 1)]
			ifFalse: [
				addFromIndex := stack findFirst: [:contex | frames firstSubmorph context = aContext].
				addFromIndex ~= 0
					ifTrue: [frames addAllMorphsFront: ((stack viewFrom: 1 to: addFromIndex - 1) collect: [:context | self createFrameForContext: context])]
					ifFalse: [frames removeAllMorphs; addAllMorphsFront: (stack collect: [:context | self createFrameForContext: context])]]].
	
	frames firstSubmorph setActive.
	self updateExplorers
]

{ #category : #'as yet unclassified' }
SBError >> restart [

	| actualContext targetContext |
	targetContext := self currentStackFrame context.
	actualContext := process popTo: targetContext.
	
	actualContext = targetContext ifTrue: [
		process
			restartTop;
			stepToSendOrReturn].
	
	self resetContext: actualContext
]

{ #category : #'as yet unclassified' }
SBError >> rootContext [

	^ SBToggledCode
		comment: ''
		active: 2
		do: {[process suspendedContext]. [(error ifNotNil: #signalerContext) ifNil: [process suspendedContext]]}
]

{ #category : #'as yet unclassified' }
SBError >> stack: aCollection matchesFrom: aNumber [

	(self submorphs viewFrom: aNumber to: self submorphCount)
		with: aCollection
		do: [:frame :context | frame context = context ifFalse: [^ false]].
	^ true
]

{ #category : #'as yet unclassified' }
SBError >> stepInto [

	| newContext |
	process step: self currentStackFrame context.
	newContext := process stepToSendOrReturn.
	self resetContext: newContext
]

{ #category : #'as yet unclassified' }
SBError >> stepOver [

	| newContext currentBlock |
	currentBlock := self currentStackFrame currentBlock.
	newContext := process completeStep: self currentStackFrame context.
	
	newContext = self currentStackFrame context
		ifTrue: [
			self currentStackFrame recordTopValueFor: currentBlock.
			newContext := process stepToSendOrReturn].
	
	self resetContext: newContext
]

{ #category : #'as yet unclassified' }
SBError >> stepThrough [

	| newContext currentBlock |
	currentBlock := self currentStackFrame currentBlock.
	process stepToHome: self currentStackFrame context.
	newContext := process stepToSendOrReturn.
	
	newContext = self currentStackFrame context
		ifTrue: [
			self currentStackFrame recordTopValueFor: currentBlock.
			newContext := process stepToSendOrReturn].
	
	self resetContext: newContext
]

{ #category : #'as yet unclassified' }
SBError >> textContents [

	^ error asString
]

{ #category : #'as yet unclassified' }
SBError >> toggleCollapsed [

	self expanded
		ifTrue: [
			frames submorphsDo: #closed.
			frames removeAllMorphs.
			frames delete.
			explorer ifNotNil: #delete]
		ifFalse: [self focus]
]

{ #category : #'as yet unclassified' }
SBError >> updateExplorers [

	| context |
	context := self currentStackFrame context.
	temporaries ifNotNil: #delete.
	self addMorphBack: (temporaries := (SBExplorer on: (Array streamContents: [:stream |
		context tempNames doWithIndex: [:name :index |
			stream nextPut: name -> (context debuggerMap namedTempAt: index in: context)]])) toggleCollapsed).
	explorer ifNotNil: #delete.
	self addMorphBack: (explorer := SBExplorer on: context receiver) toggleCollapsed
]
