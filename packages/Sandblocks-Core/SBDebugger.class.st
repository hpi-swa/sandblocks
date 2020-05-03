Class {
	#name : #SBDebugger,
	#superclass : #Morph,
	#instVars : [
		'editor',
		'process',
		'context',
		'frames',
		'blockValues',
		'currentStack',
		'pcLabel'
	],
	#category : 'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBDebugger class >> example [

	| method guineaPig context debugger |
	method := (Compiler new compileNoPattern: 'Random new next' in: UndefinedObject notifying: nil ifFail: []) generateWithTempNames.
	guineaPig := [method
			valueWithReceiver: nil
			 arguments: (#()).
		 guineaPig := nil "spot the return from aCompiledMethod"] newProcess.
	context := guineaPig suspendedContext.
	
	debugger := self new
		process: guineaPig
		context: context;
		openInWindow;
		yourself.
	
	"Now step into the expression.  But if it is quick (is implemented as a primtiive, e.g. `0')
	 it will return immediately back to the block that is sent newProcess above.  Guard
	 against that with the check for home being thisContext."
	[debugger interruptedContext method == method]
		whileFalse:
			[(guineaPig isNil
			  and: [debugger interruptedContext home == thisContext]) ifTrue:
				[UIManager default inform: 'Nothing to debug; expression is optimized'. ^ self].
			debugger send]
]

{ #category : #'as yet unclassified' }
SBDebugger >> context: aContext [

	aContext method ~= (context ifNotNil: #method) ifTrue: [
		editor compiledMethod: aContext method.
		self flag: #fixme. "ideally we do not want to reset here, but then we have to cache the compiled methods of our stack so the morph identity stays the same"
		blockValues := Dictionary new].
	context := aContext.
	
	self currentBlockForPC ifNotNil: [:block | editor select: block].
	pcLabel contents: context pc asString.
	
	currentStack := aContext contextStack.
	frames labels: (currentStack collect: [:ctx | ctx printString]).
	frames selectionIndex: 1
]

{ #category : #'as yet unclassified' }
SBDebugger >> currentBlockForPC [

	^ editor method blockForPC: context pc
]

{ #category : #'as yet unclassified' }
SBDebugger >> drawBlockValuesOn: aCanvas [

	| font |
	font := self fontToUse.
	blockValues keysAndValuesDo: [:block :value | | str |
		str := value printString.
		aCanvas fillRectangle: (block topRight extent: (font widthOfString: str) @ font height) color: Color black.
		aCanvas drawString: str at: block topRight font: font color: Color white]
]

{ #category : #'as yet unclassified' }
SBDebugger >> initialize [

	super initialize.
	
	blockValues := Dictionary new.
	
	self
		color: Color white;
		addMorphBack: (editor := SBEditor new
			addOverlayDraw: [:canvas | self drawBlockValuesOn: canvas];
			minHeight: 400 withScalingFactor;
			vResizing: #spaceFill;
			hResizing: #spaceFill;
			addCommandShortcut: $q command do: [:editor | self send];
			addCommandShortcut: $w command do: [:editor | self stepThrough];
			addCommandShortcut: $e command do: [:editor | self stepOver];
			addCommandShortcut: $r command do: [:editor | self restart];
			addCommandShortcut: $z command do: [:editor | self where]);
		changeTableLayout;
		addMorphBack: (SBRow new
			changeTableLayout;
			layoutInset: 4 withScalingFactor;
			cellGap: 12 withScalingFactor;
			addMorphBack: (self shortcut: 'ctrl+q' label: 'step into');
			addMorphBack: (self shortcut: 'ctrl+w' label: 'step through');
			addMorphBack: (self shortcut: 'ctrl+e' label: 'step over');
			addMorphBack: (self shortcut: 'ctrl+r' label: 'restart');
			addMorphBack: (self shortcut: 'ctrl+a' label: 'where');
			addMorphBack: (pcLabel := StringMorph new));
		addMorphBack: (frames := ECSTextList new
			minHeight: 200 withScalingFactor)
]

{ #category : #'as yet unclassified' }
SBDebugger >> interruptedContext [

	^ currentStack first
]

{ #category : #'as yet unclassified' }
SBDebugger >> process: aProcess context: aContext [

	process := aProcess.
	self context: aContext
]

{ #category : #'as yet unclassified' }
SBDebugger >> restart [

	| ctx |
	ctx := process popTo: context.
	process restartTop; stepToSendOrReturn.
	self context: ctx
]

{ #category : #'as yet unclassified' }
SBDebugger >> send [

	| currentBlock |
	currentBlock := self currentBlockForPC.
	process step: context.
	self context: process stepToSendOrReturn.
	currentBlock ifNotNil: [:b | blockValues at: currentBlock put: context top].
	self updateTempVariableValues
]

{ #category : #'as yet unclassified' }
SBDebugger >> shortcut: aString label: anotherString [

	^ SBRow new
		cellGap: 6 * self scalingFactor;
		addMorphBack: (StringMorph new contents: aString; emphasis: TextEmphasis bold emphasisCode);
		addMorphBack: (StringMorph new contents: anotherString);
		yourself
]

{ #category : #'as yet unclassified' }
SBDebugger >> stepOver [

	| newContext currentBlock |
	currentBlock := self currentBlockForPC.
	newContext := process completeStep: context.
	newContext == context ifTrue: [newContext := process stepToSendOrReturn].
	currentBlock ifNotNil: [:b | blockValues at: currentBlock put: newContext top].
	self updateTempVariableValues.
	
	self context: newContext
]

{ #category : #'as yet unclassified' }
SBDebugger >> stepThrough [

	process stepToHome: context.
	self context: process stepToSendOrReturn
]

{ #category : #'as yet unclassified' }
SBDebugger >> updateTempVariableValues [

	| names |
	names := context tempNames.
	names withIndexDo: [:name :index | | value |
		value := context debuggerMap namedTempAt: index in: context.
		editor method blocksForVariableNamed: name do: [:block |
			blockValues at: block put: value]].
	self changed
]

{ #category : #'as yet unclassified' }
SBDebugger >> where [

	self currentBlockForPC ifNotNil: [:b | editor select: b]
]
