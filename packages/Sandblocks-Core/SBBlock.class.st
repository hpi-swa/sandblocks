Class {
	#name : #SBBlock,
	#superclass : #Morph,
	#instVars : [
		'decorators'
	],
	#classVars : [
		'Navigation'
	],
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBBlock class >> navigation [

	^ Navigation ifNil: [Navigation := SBDepthFirstPreOrderNavigation new]
]

{ #category : #'as yet unclassified' }
SBBlock class >> navigation: aNavigation [

	Navigation := aNavigation
]

{ #category : #testing }
SBBlock >> acceptChild: aMorph [

	^ false
]

{ #category : #'as yet unclassified' }
SBBlock >> acceptDroppingMorph: aMorph event: anEvent [

	self allOwnersDo: #resetHighlightForDrop.
	self resetHighlightForDrop.
	self handleDroppedBlock: aMorph event: anEvent
]

{ #category : #'as yet unclassified' }
SBBlock >> acceptedRepresentation [
	" return what representations may replace you "

	^ #()
]

{ #category : #'as yet unclassified' }
SBBlock >> actions [

	^ Array streamContents: [:stream |
		self class withAllSuperclassesDo: [:class |
			Pragma
				withPragmasIn: class
				do: [:pragma |
					(#(#action #multiSelectAction #inputAction) includes: pragma keyword) ifTrue: [stream nextPut: pragma]].
			SBBlock = class ifTrue: [^ stream contents]]]
]

{ #category : #testing }
SBBlock >> activeMorph [
	" provides the opportunity to advertise a different morph that self to be considered as the current holder of focus "

	^ self
]

{ #category : #actions }
SBBlock >> addElement [
	<action>

	| cmd |
	cmd := (self insertCommandRequest: true near: (self childSandblocks ifNotEmpty: #last ifEmpty: [nil])) ifNil: [^ self].
	
	self sandblockEditor do: cmd.
	
	cmd shouldMergeWithNext ifTrue: [
		self sandblockEditor startInput: self sandblockEditor selection at: 0 replacingContents: false]
]

{ #category : #hierarchy }
SBBlock >> adjacentBlock: aNumber [

	| adjacent index |
	adjacent := (self parentSandblock ifNil: [^ nil]) childSandblocks.
	index := adjacent indexOf: self.
	^ adjacent at: index + aNumber ifAbsent: [nil]
]

{ #category : #accessing }
SBBlock >> allBlocks [

	^ Array streamContents: [:stream | self allBlocksDo: [:block | stream nextPut: block]]
]

{ #category : #accessing }
SBBlock >> allBlocksDo: aBlock [

	self childSandblocksDo: [:m | m allBlocksDo: aBlock].
	aBlock value: self
]

{ #category : #'as yet unclassified' }
SBBlock >> artefactChanged: aMethodBlock [

	" callback fired after each change to a method "
]

{ #category : #'as yet unclassified' }
SBBlock >> artefactSaved: aMethodBlock [

	" callback fired after each save of a method/artefact "
]

{ #category : #decorators }
SBBlock >> attachDecorator: aDecorator [

	decorators add: aDecorator.
	aDecorator attached: self.
	self changed.
	self updateSteppingDecorators
]

{ #category : #testing }
SBBlock >> bindingFor: aString class: aClass ifPresent: aBlock [

	^ self parentSandblock bindingFor: aString class: aClass ifPresent: aBlock
]

{ #category : #'as yet unclassified' }
SBBlock >> browse [
	" you were asked to be browsed. you may ignore this "
	
]

{ #category : #'artefact protocol' }
SBBlock >> cacheType: aClass for: aBlock [
]

{ #category : #testing }
SBBlock >> canCopy [

	^ true
]

{ #category : #testing }
SBBlock >> canDeleteChild: aBlock [

	^ false
]

{ #category : #actions }
SBBlock >> canInput [

	self flag: #fixme.
	" see if we specialize startInput. FIXME: we can currently not just call startInput and
	see what we get back because some classes cause side-effects, which they shouldn't "
	^ (self class lookupSelector: #startInputAt:replacingContents:) methodClass ~= SBBlock
]

{ #category : #testing }
SBBlock >> canSwap [

	^ self isExpression
]

{ #category : #'as yet unclassified' }
SBBlock >> changeLocalColorPolicy [
	<action>

	^ (UIManager default chooseFrom: SBColorPolicy withAllSubclasses values: SBColorPolicy withAllSubclasses) ifNotNil: [:policy |
		self localColorPolicy: policy]
]

{ #category : #hierarchy }
SBBlock >> childIndex [

	^ self parentSandblock childSandblocks indexOf: self
]

{ #category : #hierarchy }
SBBlock >> childSandblocks [

	^ Array streamContents: [:stream | self childSandblocksDo: [:block | stream nextPut: block]]
]

{ #category : #hierarchy }
SBBlock >> childSandblocksDo: aBlock [

	^ self subclassResponsibility
]

{ #category : #'as yet unclassified' }
SBBlock >> clearCache [

	" this block may have just been duplicated or moved somewhere else, ensure to clear all caches and present yourself neatly "
	self allMorphsDo: [:morph | morph layoutChanged].
	self allBlocksDo: [:morph | morph ~= self ifTrue: [morph clearCache]].
	self removeProperty: #sandblockBlockColor
]

{ #category : #'as yet unclassified' }
SBBlock >> click: anEvent [

	self select
]

{ #category : #hierarchy }
SBBlock >> closestAdjacentFrom: mySide to: theirSide [

	| myPoint direction component candidates |
	SBToggledCode
		comment: 'center is likely more permissive, but mySide might be more accurate'
		active: 1
		do: {[myPoint := self perform: mySide]. [myPoint := self center]}.
	direction := ({#leftCenter. #topCenter} includes: mySide) ifTrue: [#<] ifFalse: [#>].
	component := ({#leftCenter. #rightCenter} includes: mySide) ifTrue: [#x] ifFalse: [#y].
	candidates := self parentSandblock childSandblocks select: [:block |
		block ~= self and: [
			((block perform: mySide) perform: component) perform: direction with: (myPoint perform: component)]].
	^ candidates
		ifEmpty: [self]
		ifNotEmpty: [
			candidates fold: [:a :b |
				((a perform: theirSide) squaredDistanceTo: myPoint) < ((b perform: theirSide) squaredDistanceTo: myPoint) ifTrue: [a] ifFalse: [b]]]
]

{ #category : #testing }
SBBlock >> codeContainer [

	^ self parentSandblock ifNotNil: #codeContainer
]

{ #category : #'as yet unclassified' }
SBBlock >> color [

	^ self colorPolicy ifNotNil: [:p | p colorForBlock: self] ifNil: [Color white]
]

{ #category : #'as yet unclassified' }
SBBlock >> colorPolicy [

	^ self valueOfProperty: #localColorPolicy ifAbsent: [self parentSandblock ifNotNil: #colorPolicy ifNil: [SBDefaultColorPolicy new]]
]

{ #category : #'as yet unclassified' }
SBBlock >> compilationCueWith: aRequestor for: aContext [

	| receiver class |
	receiver := aContext ifNotNil: #receiver.
	class := Compiler new classForReceiver: receiver context: aContext.
	^ CompilationCue
		source: self sourceString readStream
		context: aContext
		receiver: receiver
		class: class
		environment: class environment
		requestor: aRequestor
]

{ #category : #suggestions }
SBBlock >> completionSuggestionsFor: aString [

	^ aString size > 2
		ifTrue: [
			self guessClassExpensive
				ifNotNil: [:baseClass | 
					Array streamContents: [:stream | 
						baseClass withAllSuperclassesDo: [:class | 
							class methodsDo: [:m |  | sel |
								sel := m selector asString.
								(sel sandblockMatch: aString) ifTrue: [stream nextPut: sel]]]]]
				ifNil: [Symbol allSymbols select: [:sym | sym asString sandblockMatch: aString]]]
		ifFalse: [#()]
]

{ #category : #'as yet unclassified' }
SBBlock >> containingArtefact [

	^ self parentSandblock ifNotNil: #containingArtefact
]

{ #category : #'as yet unclassified' }
SBBlock >> containingBlock [

	| next |
	next := self.
	[next := next parentSandblock ifNil: [^ nil]] doWhileFalse: [next isBlockBody].
	^ next
]

{ #category : #'as yet unclassified' }
SBBlock >> containingBlocksDo: aBlock [

	| current |
	current := self containingBlock.
	[current] whileNotNil: [
		aBlock value: current.
		current := current containingBlock]
]

{ #category : #'as yet unclassified' }
SBBlock >> containingSandblock [

	^ self
]

{ #category : #'as yet unclassified' }
SBBlock >> containingStatement [

	| current |
	current := self.
	[current owner ifNil: [^ nil] ifNotNil: #isBlockBody] whileFalse: [current := current owner].
	^ current
]

{ #category : #'as yet unclassified' }
SBBlock >> contextAcceptedRepresentationAt: aNumber [
	" return any constraints on the representation of your child block at aNumber "

	^ nil
]

{ #category : #actions }
SBBlock >> copyAround [
	<action>

	| replacer |
	" create a copy of our surroundings with ourselves replaced "
	replacer := SBPastePlaceholder new.
	self replaceBy: replacer.
	self sandblockEditor copyBuffer: replacer parentSandblock.
	replacer replaceBy: self
]

{ #category : #actions }
SBBlock >> copyString [
	<action>

	Clipboard clipboardText: self textContents
]

{ #category : #actions }
SBBlock >> copyToBuffer [
	<multiSelectAction>

	self sandblockEditor copyBuffer: self sandblockEditor multiSelection
]

{ #category : #'artefact protocol' }
SBBlock >> declarations [
	" return any SBName declarations you may know "

	^ #()
]

{ #category : #decorators }
SBBlock >> decorators [

	^ decorators
]

{ #category : #actions }
SBBlock >> deleteAround [
	<action>

	| replacer around editor |
	editor := self sandblockEditor.
	(self hasRepresentationThat: (self parentSandblock parentSandblock contextAcceptedRepresentationAt: self parentSandblock childIndex)) ifTrue: [
		" create a copy of our surroundings with ourselves replaced "
		replacer := SBPastePlaceholder new.
		around := self.
		around replaceBy: replacer.
		editor copyBuffer: replacer parentSandblock.
		replacer replaceBy: around.
		
		replacer := self veryDeepCopy.
		editor do: ((SBReplaceCommand newFor: self containingArtefact)
			target: self parentSandblock;
			replacer: replacer).
		replacer postDuplicate]
]

{ #category : #actions }
SBBlock >> deleteBlock [
	<multiSelectAction>

	self sandblockEditor
		copyBuffer: self sandblockEditor multiSelection;
		doMultiSelectionEach: [:selected | selected parentSandblock deleteCommandFor: selected]
]

{ #category : #'as yet unclassified' }
SBBlock >> deleteCommandFor: aBlock [

	^ (self canDeleteChild: aBlock)
		ifTrue: [(SBDeleteCommand newFor: aBlock containingArtefact) target: aBlock]
		ifFalse: [
			(self acceptedRepresentation includesRepresentation: #isSmalltalkExpression) ifTrue: [
				(SBReplaceCommand newFor: aBlock containingArtefact) target: aBlock; replacer: SBUnknown new]]
]

{ #category : #decorators }
SBBlock >> detachDecorator: aDecorator [

	decorators remove: aDecorator ifAbsent: [].
	aDecorator detached: self.
	self changed.
	self updateSteppingDecorators
]

{ #category : #decorators }
SBBlock >> detachDecorators: aDecoratorClass [

	decorators do: [:d | d class = aDecoratorClass ifTrue: [d detached: self]].
	decorators := decorators reject: [:d | d class = aDecoratorClass].
	self changed.
	self updateSteppingDecorators
]

{ #category : #'as yet unclassified' }
SBBlock >> drawDropHighlightOn: aCanvas [

	self highlightedForDrop ifTrue: [
		aCanvas frameRectangle: self bounds width: 3 color: Color red]
]

{ #category : #'as yet unclassified' }
SBBlock >> drawFrame: aColor on: aCanvas [

	aCanvas
		frameRectangle: (self bounds expandBy: 2) width: self frameSize
		color: aColor
]

{ #category : #'as yet unclassified' }
SBBlock >> drawOn: aCanvas [

	self decorators do: [:d | d preDrawOn: aCanvas].
	
	aCanvas
		frameAndFillRectangle: self bounds
		fillColor: self drawnColor
		borderWidth: (self colorPolicy borderWidthForBlock: self) 
		borderColor: (self colorPolicy borderColorForBlock: self).
	
	self drawSymbolsOn: aCanvas
]

{ #category : #'as yet unclassified' }
SBBlock >> drawSubmorphsOn: aCanvas [

	super drawSubmorphsOn: aCanvas.
	
	self valid ifFalse: [aCanvas frameRectangle: self bounds width: 2 * self scalingFactor color: Color red].
	
	self decorators do: [:d | d postDrawOn: aCanvas]
]

{ #category : #'as yet unclassified' }
SBBlock >> drawSymbolsOn: aCanvas [

	| symbols fg font space y centerAlign |
	centerAlign := self colorPolicy centerAlignSymbols.
	symbols := self symbols.
	space := self spaceForSymbols.
	font := self fontToUse.
	fg := self sandblockForegroundColor.
	y := centerAlign ifTrue: [
		((self layoutBounds height / 2) - (font height / 2)) rounded] ifFalse: [0].
	symbols first ifNotNil: [
		aCanvas
			drawString: symbols first
			at: self layoutBounds origin + (space first negated rounded @ y)
			font: font
			color: (fg alpha: 0.5)].
	symbols second ifNotNil: [
		aCanvas
			drawString: symbols second
			at: self layoutBounds topRight + (0 @ (centerAlign ifTrue: [y] ifFalse: [self layoutBounds height - font height]))
			font: font
			color: (fg alpha: 0.5)]
]

{ #category : #colors }
SBBlock >> drawnColor [

	^ self color
]

{ #category : #decorators }
SBBlock >> ensureDecorator: aClass do: aBlock [

	decorators detect: [:d | d class = aClass] ifFound: aBlock ifNone: [| d |
		d := aClass new.
		self attachDecorator: d.
		aBlock value: d]
]

{ #category : #actions }
SBBlock >> ensureVisible [
	<action>

	| method |
	method := self containingArtefact.
	(method ~= self and: [method notNil]) ifTrue: [method ensureExpanded].
	
	Project current addDeferredUIMessage: [self sandblockEditor ifNotNil: [:e | e scrollToShow: self]]
]

{ #category : #'as yet unclassified' }
SBBlock >> evaluate [

	^ self containingArtefact
		ifNotNil: [:artefact | | context |
			context := artefact evaluationContext.
			Compiler new
				evaluate: self sourceString
				in: context
				to: (context ifNil: [artefact evaluationReceiver] ifNotNil: #receiver)
				notifying: artefact
				ifFail: nil]
		ifNil: [Compiler evaluate: self sourceString]
]

{ #category : #actions }
SBBlock >> evaluateExpression [
	<action>

	| result |
	result := self evaluate.
	self containingArtefact ifNotNil: [
		self containingArtefact cacheType: result class for: self].
	result
		representationThat: #isToplevelMorph
		do: [:explorer |
			explorer focusAfterDelete: self.
			self sandblockEditor
				openMorphInView: explorer;
				connectFrom: self to: explorer]
		ifNone: [nil]
		near: self
]

{ #category : #'as yet unclassified' }
SBBlock >> evaluateWith: aRequestor for: aContext [

	^ Compiler new evaluate: self sourceString readStream in: aContext to: (aContext ifNotNil: #receiver ifNil: [self containingArtefact relatedClass]) notifying: aRequestor ifFail: nil
]

{ #category : #'as yet unclassified' }
SBBlock >> exploreAs [

	^ self object
		representationThat: #isToplevelMorph
		do: [:type | self sandblockEditor openMorphInView: type]
		ifNone: [nil]
]

{ #category : #hierarchy }
SBBlock >> firstDeepChild [

	| current |
	current := self.
	[current childSandblocks isEmpty] whileFalse: [current := current childSandblocks first].
	^ current
]

{ #category : #'as yet unclassified' }
SBBlock >> firstInput [

	self allMorphsDo: [:m | (m isKindOf: SBOwnTextMorph) ifTrue: [^ m]].
	^ nil
]

{ #category : #'as yet unclassified' }
SBBlock >> fixActions [

	^ #()
]

{ #category : #accessing }
SBBlock >> focusAfterDelete: aBlock [

	" set a hint to focus aBlock when this block is deleted "
	self setProperty: #focusAfterDelete toValue: aBlock
]

{ #category : #accessing }
SBBlock >> focusAfterDeleteifNone: aBlock [

	| block |
	block := self valueOfProperty: #focusAfterDelete ifAbsent: aBlock.
	^ block isInWorld ifTrue: [block] ifFalse: [aBlock value]
]

{ #category : #'as yet unclassified' }
SBBlock >> foregroundColor [

	^ self colorPolicy foregroundColorForBlock: self
]

{ #category : #testing }
SBBlock >> forwardAlarm: aSelector to: anObject [

	anObject perform: aSelector
]

{ #category : #'as yet unclassified' }
SBBlock >> frameSize [

	^ self colorPolicy ifNotNil: [:c | c selectionBorderWidth] ifNil: [0]
]

{ #category : #'as yet unclassified' }
SBBlock >> guessClassExpensive [

	^ self guessedClass ifNil: [[(SBSandboxSimulator new simulate: [self evaluate]) ifNotNil: #class] on: Error do: [nil]]
]

{ #category : #suggestions }
SBBlock >> guessedClass [

	" return a non-nil value to help services like autocompletion do their job "
	^ nil
]

{ #category : #'as yet unclassified' }
SBBlock >> handleDroppedBlock: aBlock event: anEvent [

	aBlock isSelection ifTrue: [ | replacer |
		replacer := aBlock childSandblocks first.
		self isExpression ifTrue: [
			replacer isExpression
				ifTrue: [
					self sandblockEditor do: ((SBReplaceCommand newFor: self containingArtefact)
						replacer: replacer;
						target: self)]
				ifFalse: [ | index |
					index := UIManager default chooseFrom: {'Store into new Class Variable'}.
					index > 0 ifTrue: [ | class name |
						name := UIManager default request: 'Name for class variable?'.
						class := self containingArtefact relatedClass.
						self sandblockEditor declareClassVariable: name for: class.
						((self sandblockEditor openClass: class) saveTryFixing: false quick: false) ifTrue: [
							(class classBindingOf: name) value: replacer object.
							self sandblockEditor do: ((SBReplaceCommand newFor: self containingArtefact)
								replacer: (SBName contents: name);
								target: self)]]]]]
]

{ #category : #'event handling' }
SBBlock >> handlesMouseDown: anEvent [

	^ true
]

{ #category : #'event handling' }
SBBlock >> handlesMouseMove: anEvent [

	^ (super handlesMouseMove: anEvent) or: [anEvent isDraggingEvent]
]

{ #category : #'event handling' }
SBBlock >> handlesMouseOverDragging: anEvent [

	^ anEvent hand hasSubmorphs and: [self wantsDroppedMorph: anEvent hand firstSubmorph event: anEvent]
]

{ #category : #hierarchy }
SBBlock >> hasChildSandblocks [

	self childSandblocksDo: [:b | ^ true].
	^ false
]

{ #category : #decorators }
SBBlock >> hasDecorator: aClass [

	^ decorators anySatisfy: [:d | d class = aClass]
]

{ #category : #'as yet unclassified' }
SBBlock >> hasInput [

	^ self sandblockEditor currentInput = self
]

{ #category : #'as yet unclassified' }
SBBlock >> initialize [

	super initialize.
	
	decorators := OrderedCollection new.
	
	self
		color: Color transparent;
		cellPositioning: #topLeft;
		layoutInset: 0;
		cellGap: 1 withScalingFactor;
		extent: 0 @ 0
]

{ #category : #actions }
SBBlock >> inputNextUnknown [
	<action>
	<inputAction>

	(self activeMorph nextMorphThat: [:m | m isSandblock and: [m isUnknown]])
		ifNotNil: [:m | self sandblockEditor startInput: m at: 1 replacingContents: true]
]

{ #category : #actions }
SBBlock >> inputPreviousUnknown [
	<action>
	<inputAction>

	(self previousMorphThat: [:m | m isSandblock and: [m isUnknown]])
		ifNotNil: [:m | self sandblockEditor startInput: m at: 1 replacingContents: true]
]

{ #category : #'as yet unclassified' }
SBBlock >> insertCommandRequest: anAfterBoolean near: aBlock [

	" the user pressed + on us, do we want to do something now? "
	^ nil
]

{ #category : #'as yet unclassified' }
SBBlock >> insertElement: aBoolean [

	| cmd |
	cmd := (self parentSandblock insertCommandRequest: aBoolean near: self) ifNil: [^ self].
	
	self sandblockEditor do: cmd.
	
	cmd shouldMergeWithNext ifTrue: [
		self sandblockEditor startInput: self sandblockEditor selection at: 0 replacingContents: false]
]

{ #category : #actions }
SBBlock >> insertElementAfter [
	<action>

	self insertElement: true
]

{ #category : #actions }
SBBlock >> insertElementBefore [
	<action>

	self insertElement: false
]

{ #category : #testing }
SBBlock >> intoWorld: aWorld [

	super intoWorld: aWorld.
	
	self updateSteppingDecorators
]

{ #category : #'as yet unclassified' }
SBBlock >> invokeMetaMenu: anEvent [

	SBLabel text: [
		'We hijack this event because it''s the only way to cleanly access ctrl+click'].
	self pickUp: anEvent
]

{ #category : #testing }
SBBlock >> isASTNode [

	^ false
]

{ #category : #testing }
SBBlock >> isArrayBlock [

	^ false
]

{ #category : #testing }
SBBlock >> isArtefact [
	" we define an artefact in this context as a node that is in some way persisting information of its children such as a method or a class would "

	^ false
]

{ #category : #testing }
SBBlock >> isAssignment [

	^ false
]

{ #category : #testing }
SBBlock >> isBinding [

	^ false
]

{ #category : #'as yet unclassified' }
SBBlock >> isBlockBindings [

	^ false
]

{ #category : #testing }
SBBlock >> isBlockBody [

	^ false
]

{ #category : #testing }
SBBlock >> isCascade [

	^ false
]

{ #category : #testing }
SBBlock >> isClassContainer [

	^ false
]

{ #category : #testing }
SBBlock >> isCodeContainer [

	^ false
]

{ #category : #testing }
SBBlock >> isExample [

	^ false
]

{ #category : #testing }
SBBlock >> isExampleWatch [

	^ false
]

{ #category : #testing }
SBBlock >> isExpression [

	^ false
]

{ #category : #hierarchy }
SBBlock >> isFirstChild [

	^ self parentSandblock childSandblocks first = self
]

{ #category : #testing }
SBBlock >> isGlobalWatch [

	^ false
]

{ #category : #hierarchy }
SBBlock >> isLastChild [

	^ self parentSandblock childSandblocks last = self
]

{ #category : #hierarchy }
SBBlock >> isLastDeepChild [

	^ self = self lastDeepChild
]

{ #category : #testing }
SBBlock >> isLiteralBlock [

	^ false
]

{ #category : #testing }
SBBlock >> isMessageSend [

	^ false
]

{ #category : #testing }
SBBlock >> isMethod [

	^ false
]

{ #category : #testing }
SBBlock >> isMorphExample [

	^ false
]

{ #category : #testing }
SBBlock >> isName [

	^ false
]

{ #category : #testing }
SBBlock >> isNumber [

	^ false
]

{ #category : #testing }
SBBlock >> isNumberBlock [

	^ false
]

{ #category : #testing }
SBBlock >> isPragma [

	^ false
]

{ #category : #testing }
SBBlock >> isRepl [

	^ false
]

{ #category : #testing }
SBBlock >> isReturn [

	^ false
]

{ #category : #testing }
SBBlock >> isSandblock [

	^ true
]

{ #category : #testing }
SBBlock >> isSelected [

	^ self sandblockEditor selection = self
]

{ #category : #testing }
SBBlock >> isSelection [

	^ false
]

{ #category : #testing }
SBBlock >> isStatement [

	^ self owner isBlockBody
]

{ #category : #testing }
SBBlock >> isStringBubble [

	^ false
]

{ #category : #testing }
SBBlock >> isSymbolBlock [

	^ false
]

{ #category : #testing }
SBBlock >> isTemporaries [

	^ false
]

{ #category : #testing }
SBBlock >> isUnknown [

	^ false
]

{ #category : #testing }
SBBlock >> isWatch [

	^ false
]

{ #category : #hierarchy }
SBBlock >> lastDeepChild [

	| current |
	current := self.
	[current childSandblocks isEmpty] whileFalse: [current := current childSandblocks last].
	^ current
]

{ #category : #'as yet unclassified' }
SBBlock >> layoutInset [

	| space inset |
	space := self spaceForSymbols.
	inset := (self colorPolicy layoutInsetFor: self) + super layoutInset.
	^ (space first > 0 or: [space second > 0])
		ifTrue: [inset isPoint
				ifTrue: [SBEdgeInsets left: space first + inset x right: inset x + space second top: inset y bottom: inset y]
				ifFalse: [SBEdgeInsets left: space first + inset right: inset + space second top: inset bottom: inset]]
		ifFalse: [inset]
]

{ #category : #'as yet unclassified' }
SBBlock >> leftMostBlock [

	^ self childSandblocks ifEmpty: [self] ifNotEmpty: [:c | c first leftMostBlock]
]

{ #category : #actions }
SBBlock >> leftRotate [
	<action>

	(self isFirstChild or: [self isLastChild]) ifFalse: [^ self].
	self sandblockEditor do: ((SBSubtreeRotateCommand newFor: self containingArtefact)
		 target: self;
		 yourself)
]

{ #category : #'as yet unclassified' }
SBBlock >> localColorPolicy: aPolicy [

	self setProperty: #localColorPolicy toValue: aPolicy new;
			clearCache;
			changed
]

{ #category : #accessing }
SBBlock >> lookupAction: aSymbol [

	^ self class lookupSelector: aSymbol
]

{ #category : #'as yet unclassified' }
SBBlock >> minExtent [
	"Layout specific. Return the minimum size the receiver can be represented in.
	Implementation note: When this message is sent from an owner trying to lay out its children it will traverse down the morph tree and recompute the minimal arrangement of the morphs based on which the minimal extent is returned. When a morph with some layout strategy is encountered, the morph will ask its strategy to compute the new arrangement. However, since the final size given to the receiver is unknown at the point of the query, the assumption is made that the current bounds of the receiver are the base on which the layout should be computed. This scheme prevents strange layout changes when for instance, a table is contained in another table. Unless the inner table has been resized manually (which means its bounds are already enlarged) the arrangement of the inner table will not change here. Thus the entire layout computation is basically an iterative process which may have different results depending on the incremental changes applied."

	| layout minExtent extra hFit vFit |
	hFit := self hResizing.
	vFit := self vResizing.

	"An exception -- a receiver with #shrinkWrap constraints but no children is being treated #rigid (the equivalent to a #spaceFill receiver in a non-layouting owner)"
	self hasSubmorphs 
		ifFalse: 
			[hFit == #shrinkWrap ifTrue: [hFit := #rigid].
			vFit == #shrinkWrap ifTrue: [vFit := #rigid]].
	layout := self layoutPolicy.
	layout isNil 
		ifTrue: [minExtent := 0@0]
		ifFalse: [minExtent := layout minExtentOf: self in: self layoutBounds].

	hFit == #rigid 
		ifTrue: [minExtent := self fullBounds extent x @ minExtent y]
		ifFalse: 
			[extra := self bounds width - self layoutBounds width.
			minExtent := (minExtent x + extra) @ minExtent y].
	vFit == #rigid 
		ifTrue: [minExtent := minExtent x @ self fullBounds extent y]
		ifFalse: 
			[extra := self bounds height - self layoutBounds height.
			minExtent := minExtent x @ (minExtent y + extra)].

	^ minExtent max: self minWidth @ self minHeight
]

{ #category : #'event handling' }
SBBlock >> mouseDown: anEvent [

	self eventHandler
		ifNotNil: [self eventHandler mouseDown: anEvent fromMorph: self].
	
	anEvent hand waitForClicksOrDrag: self event: anEvent
]

{ #category : #'event handling' }
SBBlock >> mouseEnterDragging: anEvent [

	self allOwnersDo: #resetHighlightForDrop.
	self highlightForDrop: true
]

{ #category : #'event handling' }
SBBlock >> mouseLeaveDragging: anEvent [

	self highlightForDrop: false
]

{ #category : #'event handling' }
SBBlock >> mouseMove: anEvent [

	super mouseMove: anEvent.
	(anEvent isDraggingEvent and: [self handlesMouseOverDragging: anEvent]) ifTrue: [self highlightForDrop]
]

{ #category : #actions }
SBBlock >> multiSelectChildren [
	<multiSelectAction>

	self sandblockEditor mode = #select ifFalse: [self sandblockEditor mode: #selection].
	self childSandblocks do: #startOrAddToMultiSelection
]

{ #category : #hierarchy }
SBBlock >> nextBlock [

	self childSandblocksDo: [:first | ^ first].
	
	^ (self adjacentBlock: 1) ifNil: [
		self parentSandblock parentAdjacentBlock: 1]
]

{ #category : #hierarchy }
SBBlock >> nextBlockThat: aBlock [

	| n |
	n := self nextBlock.
	n ifNil: [^ nil].
	(aBlock value: n) ifTrue: [^ n].
	^ n nextBlockThat: aBlock
]

{ #category : #testing }
SBBlock >> noteNewOwner: aMorph [

	super noteNewOwner: aMorph.
	
	self allBlocksDo: [:block | block layoutChanged].
	" recheck name blocks "
	self allBlocksDo: [:block | block isName ifTrue: [block noteNewOwner: block owner]]
]

{ #category : #'as yet unclassified' }
SBBlock >> object [

	^ self subclassResponsibility
]

{ #category : #'as yet unclassified' }
SBBlock >> outOfWorld: aWorld [

	super outOfWorld: aWorld.
	
	self removeSuggestionMenu.
	self triggerEvent: #outOfWorld
]

{ #category : #testing }
SBBlock >> outerBounds [

	^ super outerBounds expandBy: self frameSize
]

{ #category : #hierarchy }
SBBlock >> parentAdjacentBlock: aNumber [

	^ (self adjacentBlock: aNumber)
		ifNil: [self parentSandblock ifNotNil: [:p | p parentAdjacentBlock: aNumber]]
]

{ #category : #actions }
SBBlock >> pasteAbove [
	<action>

	self pasteAboveOrBelow: true
]

{ #category : #actions }
SBBlock >> pasteAboveOrBelow: anAboveBoolean [

	
	| index target adjacent morph copyBuffer |
	copyBuffer := self sandblockEditor copyBuffer.
	copyBuffer ifNil: [^ self].
	
	copyBuffer wrapsAround ifTrue: [^ self wrapSelectionWith: copyBuffer].
	
	target := copyBuffer isSelection ifTrue: [copyBuffer firstSubmorph] ifFalse: [copyBuffer].
	
	adjacent := self.
	[adjacent parentSandblock acceptChild: target] whileFalse: [adjacent := adjacent parentSandblock].
	
	index := adjacent owner submorphIndexOf: adjacent.
	morph := target veryDeepCopy.
	morph topCenter: self bottomCenter.
	
	self sandblockEditor do: ((adjacent parentSandblock containingArtefact ifNil: [SBInsertCommand newNonEdit] ifNotNil: [:artefact | SBInsertCommand newFor: artefact])
		index: (anAboveBoolean
			ifTrue: [index] ifFalse: [index + 1]);
		container: adjacent owner;
		morph: morph;
		yourself).
	
	morph postDuplicate
]

{ #category : #actions }
SBBlock >> pasteBelow [
	<action>

	self pasteAboveOrBelow: false
]

{ #category : #actions }
SBBlock >> pasteString [
	<action>

	^ self subclassResponsibility
]

{ #category : #'as yet unclassified' }
SBBlock >> pc [

	^ 0
]

{ #category : #'as yet unclassified' }
SBBlock >> pc: aNumber [

	" save a pc if you are an accessible point during execution "
]

{ #category : #'as yet unclassified' }
SBBlock >> performAction: aSymbol [

	self perform: aSymbol
]

{ #category : #'as yet unclassified' }
SBBlock >> pickUp: anEvent [

	anEvent hand attachMorph: (SBSelection new 
		methodClass: self containingArtefact relatedClass;
		colorPolicy: self colorPolicy;
		addMorphBack: self veryDeepCopy)
]

{ #category : #actions }
SBBlock >> placeMark [
	<action>

	(self hasDecorator: SBMarkedDecorator)
		ifTrue: [self detachDecorators: SBMarkedDecorator]
		ifFalse: [
			self sandblockEditor waitForLetterDo: [:letter |
				self attachDecorator: (SBMarkedDecorator new letter: letter)]]
]

{ #category : #'as yet unclassified' }
SBBlock >> postDuplicate [

	" this block has been duplicated, adjuts any identifiers if need be "
	self clearCache.
	
	self allBlocksDo: [:morph | morph ~= self ifTrue: [morph postDuplicate]].
]

{ #category : #'as yet unclassified' }
SBBlock >> prefix [

	^ self symbols first
]

{ #category : #'as yet unclassified' }
SBBlock >> prettySourceString [

	^ SBFormatter formatString: self sourceString class: self containingArtefact methodClass noPattern: self ~= self containingArtefact
	
	"false
		ifTrue: [[Smalltalk at: #PPPPrinter ifPresent: [:p | text := p format: text]] on: Error do: []]
		ifFalse: [text := self class prettyPrinterClass format: text in: self containingArtefact methodClass notifying: nil]."
]

{ #category : #testing }
SBBlock >> preventOcclusion [

	^ self withDecorator: SBMoveDecorator do: [:d | d preventOcclusion] ifAbsent: [false]
]

{ #category : #'as yet unclassified' }
SBBlock >> previousBlock [

	^ (self adjacentBlock: -1)
			ifNil: [self parentSandblock]
			ifNotNil: [:adj | adj rightMostBlock]
]

{ #category : #'as yet unclassified' }
SBBlock >> previousBlockThat: aBlock [

	| n |
	n := self previousBlock.
	n ifNil: [^ nil].
	(aBlock value: n) ifTrue: [^ n].
	^ n previousBlockThat: aBlock
]

{ #category : #actions }
SBBlock >> promptAction [
	<multiSelectAction>

	| options index |
	options := self validActions.
	index := UIManager default chooseFrom: (options collect: [:option |
		option method selector, (' ', (SBEditor shortcutStringForAction: option selector))]).
	index > 0 ifTrue: [self performAction: (options at: index) method selector]
]

{ #category : #'as yet unclassified' }
SBBlock >> proposeCodeActions: aCollection for: aBlock [

	| index |
	index := UIManager default chooseFrom: (aCollection collect: #label).
	index > 0 ifTrue: [(aCollection at: index) do]
]

{ #category : #'as yet unclassified' }
SBBlock >> removeLocalColorPolicy [

	self
		removeProperty: #localColorPolicy;
		clearCache;
		changed
]

{ #category : #suggestions }
SBBlock >> removeSuggestionMenu [

	self valueOfProperty: #sandblockSuggestionMenu ifPresentDo: #delete.
	self removeProperty: #sandblockSuggestionMenu
]

{ #category : #actions }
SBBlock >> replaceWithCopyBuffer [
	<action>

	| copyBuffer |
	copyBuffer := self sandblockEditor copyBuffer.
	
	copyBuffer ifNotNil: [ | new |
		new := (copyBuffer isSelection ifTrue: [copyBuffer firstSubmorph] ifFalse: [copyBuffer]) veryDeepCopy.
		self sandblockEditor do: ((SBReplaceCommand newFor: self containingArtefact)
			target: self;
			replacer: new).
		new postDuplicate]
]

{ #category : #'as yet unclassified' }
SBBlock >> representAs [
	<action>

	^ self object
		representationThat: self parentSandblock acceptedRepresentation
		do: [:type |
			self sandblockEditor do: (SBReplaceCommand newNonEdit
				target: self;
				replacer: type)]
		ifNone: [nil]
]

{ #category : #'as yet unclassified' }
SBBlock >> resolveLocalBindings [

	| bindings |
	bindings := Array streamContents: [:stream |
		self allBlocksDo: [:block |
			block isBinding ifTrue: [ | binding |
				binding := block resolveBinding.
				
				(binding notNil and: [binding isDeclaration] and: [binding isMethodLocal] and: [(binding hasOwner: self) not]) ifTrue: [
					stream nextPut: binding]]]].
	
	^ (KeyedSet keyBlock: #name) addAll: bindings
]

{ #category : #'as yet unclassified' }
SBBlock >> rightMostBlock [

	^ self childSandblocks ifEmpty: [self] ifNotEmpty: [:c | c last rightMostBlock]
]

{ #category : #'as yet unclassified' }
SBBlock >> sandblockForegroundColor [

	^ self foregroundColor
]

{ #category : #'as yet unclassified' }
SBBlock >> select [

	self sandblockEditor select: self
]

{ #category : #actions }
SBBlock >> selectArtefact [
	<multiSelectAction>

	(self containingArtefact = self
		ifTrue: [self parentSandblock containingArtefact]
		ifFalse: [self containingArtefact]) ifNotNil: #select
]

{ #category : #actions }
SBBlock >> selectBottomToplevel [
	<multiSelectAction>
	
	self selectToplevelTowards: #bottom
]

{ #category : #actions }
SBBlock >> selectDown [
	<multiSelectAction>

	| next selectionDownHistory |
	selectionDownHistory := self sandblockEditor selectionDownHistory.
	
	" try to follow our steps back down "
	next := selectionDownHistory ifEmpty: [] ifNotEmpty: #removeLast.
	(self childSandblocks includes: next) ifFalse: [
		selectionDownHistory removeAll.
		next := self hasChildSandblocks ifTrue: [self childSandblocks first] ifFalse: [nil]].
	
	next ifNotNil: #select
]

{ #category : #actions }
SBBlock >> selectLast [
	<multiSelectAction>

	self containingArtefact lastDeepChild select
]

{ #category : #actions }
SBBlock >> selectLeftToplevel [
	<multiSelectAction>
	
	self selectToplevelTowards: #left
]

{ #category : #actions }
SBBlock >> selectNext [
	<multiSelectAction>

	self sandblockEditor selectionDownHistory removeAll.
	self class navigation nextFrom: self do: #select
]

{ #category : #actions }
SBBlock >> selectPrevious [
	<multiSelectAction>

	self sandblockEditor selectionDownHistory removeAll.
	self class navigation previousFrom: self do: #select
]

{ #category : #actions }
SBBlock >> selectRightMostBlock [
	<action>

	self rightMostBlock select
]

{ #category : #actions }
SBBlock >> selectRightToplevel [
	<multiSelectAction>
	
	self selectToplevelTowards: #right
]

{ #category : #actions }
SBBlock >> selectTopToplevel [
	<multiSelectAction>
	
	self selectToplevelTowards: #top
]

{ #category : #'as yet unclassified' }
SBBlock >> selectToplevelTowards: aSideSymbol [

	| opposite |
	opposite := aSideSymbol caseOf: {([#left] -> [#right]). ([#right] -> [#left]). ([#top] -> [#bottom]). ([#bottom] -> [#top])}.
	(self containingArtefact closestAdjacentFrom: (aSideSymbol, 'Center') asSymbol to: (opposite, 'Center') asSymbol) select
]

{ #category : #actions }
SBBlock >> selectUp [
	<multiSelectAction>

	self parentSandblock ifNotNil: [:b |
		self sandblockEditor selectionDownHistory addLast: self.
		b select]
]

{ #category : #'as yet unclassified' }
SBBlock >> selector [
	" if this node represents any selector, return it here "

	^ nil
]

{ #category : #'as yet unclassified' }
SBBlock >> showOverlayFor: anEvent [

	| overlay |
	overlay := SBOverlay new
		openInWorld;
		sandblockEditor: self sandblockEditor;
		center: (self localPointToGlobal: anEvent position).
	
	anEvent hand newMouseFocus: overlay
]

{ #category : #testing }
SBBlock >> showUsageInfo [
]

{ #category : #'as yet unclassified' }
SBBlock >> sourceString [

	^ String streamContents: [:s | self writeSourceOn: s]
]

{ #category : #'as yet unclassified' }
SBBlock >> spaceForSymbols [

	| symbols |
	symbols := self symbols.
	^ {
		(symbols first ifNil: [0] ifNotNil: [self fontToUse widthOfString: symbols first]).
		(symbols second ifNil: [0] ifNotNil: [self fontToUse widthOfString: symbols second])
	}
]

{ #category : #'as yet unclassified' }
SBBlock >> startDrag: anEvent [

	super startDrag: anEvent.
	
	self sandblockEditor select: self.
	
	self flag: #fixme. " this should be made better "
	(self hasDecorator: SBMoveDecorator) ifFalse: [
		self pickUp: anEvent].
	
	"self showOverlayFor: anEvent"
]

{ #category : #'as yet unclassified' }
SBBlock >> startInputAt: aNumber replacingContents: aBoolean [

	^ nil
]

{ #category : #actions }
SBBlock >> startInputAtEnd [
	<action>
	<actionValidIf: #canInput>

	self sandblockEditor startInput: self at: 9e8 replacingContents: false
]

{ #category : #actions }
SBBlock >> startInputAtStart [
	<action>
	<actionValidIf: #canInput>

	self sandblockEditor startInput: self at: 1 replacingContents: false
]

{ #category : #actions }
SBBlock >> startInputSubstituting [
	<action>
	<actionValidIf: #canInput>

	self sandblockEditor startInput: self at: 1 replacingContents: true
]

{ #category : #actions }
SBBlock >> startOrAddToMultiSelection [
	<multiSelectAction>

	self sandblockEditor startOrAddToMultiSelection: self
]

{ #category : #testing }
SBBlock >> stepDecorator: aDecorator [

	aDecorator step
]

{ #category : #accessing }
SBBlock >> stopEditing: aCommand [
]

{ #category : #suggestions }
SBBlock >> suggestionMenuDo: aBlock [

	^ self valueOfProperty: #sandblockSuggestionMenu ifPresentDo: aBlock
]

{ #category : #suggestions }
SBBlock >> suggestionsMenu [

	^ self valueOfProperty: #sandblockSuggestionMenu ifAbsentPut: [SBSuggestionMenu new]
]

{ #category : #'as yet unclassified' }
SBBlock >> swap: aNumber [

	| next children |
	children := self parentSandblock childSandblocks.
	next := children atWrap: (children indexOf: self) + aNumber.
	(next notNil and: [self canSwap and: [next canSwap]]) ifTrue: [
		self sandblockEditor do: ((SBSwapCommand newFor: self containingArtefact)
			a: self;
			b: next)]
]

{ #category : #actions }
SBBlock >> swapLeft [
	<action>

	self swap: -1
]

{ #category : #actions }
SBBlock >> swapRight [
	<action>

	self swap: 1
]

{ #category : #testing }
SBBlock >> symbols [

	^ #(nil nil)
]

{ #category : #accessing }
SBBlock >> textContents [

	^ ''
]

{ #category : #actions }
SBBlock >> toggleCollapsed [
	<action>

	self containingArtefact ifNotNil: #toggleCollapsed
]

{ #category : #decorators }
SBBlock >> toggleDecorator: aDecorator [

	^ decorators
		detect: [:d | d class = aDecorator class]
		ifFound: [:d | self detachDecorator: d]
		ifNone: [self attachDecorator: aDecorator]
]

{ #category : #'as yet unclassified' }
SBBlock >> tryFixIfFail: aBlock [

	self sandblockEditor select: self.
	self fixActions
		ifNotEmpty: [:actions | self proposeCodeActions: actions for: self].
	^ self valid ifTrue: [true] ifFalse: aBlock
]

{ #category : #'artefact protocol' }
SBBlock >> typeFor: aBlock [

	^ nil
]

{ #category : #testing }
SBBlock >> updateSteppingDecorators [

	| anyStepping |
	anyStepping := false.
	self decorators do: [:d |
		d stepTime >= 0 ifTrue: [
			anyStepping := true.
			self startStepping: #stepDecorator: at: Time millisecondClockValue arguments: {d} stepTime: d stepTime]].
	
	anyStepping ifFalse: [self stopSteppingSelector: #stepDecorator:]
]

{ #category : #suggestions }
SBBlock >> updateSuggestions: aCollection showNear: aMorph [

	(aCollection isEmpty or: [self hasInput not]) ifTrue: [^ self removeSuggestionMenu].
	
	self suggestionsMenu
		editor: self sandblockEditor;
		suggestions: ((aCollection sort: [:a :b | a selector size < b selector size]) first: (20 min: aCollection size));
		topLeft: aMorph positionInWorld + (0 @ aMorph height);
		openInWorld;
		resize
]

{ #category : #actions }
SBBlock >> useSuggestion [
	<inputAction>
	" try to apply a suggestion, return whether anything was applied "

	self suggestionMenuDo: [:menu |
		menu activeSuggestion ifNotNil: [:s | s useSuggestionOn: self].
		^ true].
	^ false
]

{ #category : #'as yet unclassified' }
SBBlock >> valid [

	^ true
]

{ #category : #'as yet unclassified' }
SBBlock >> validActions [

	| mode |
	mode := self sandblockEditor mode.
	^ self actions select: [:action |
		((mode = #input and: [action keyword = #inputAction]) or: [
			(mode = #command and: [
				#(#action #multiSelectAction) includes: action keyword]) or: [
				mode = #selection and: [action keyword = #multiSelectAction]]]) and: [
			(action method pragmaAt: #actionValidIf:) ifNotNil: [:validPragma | self perform: validPragma arguments first] ifNil: [true]]]
]

{ #category : #'event handling' }
SBBlock >> veryDeepCopyWith: aCopier [

	| new previousDecorators |
	new := super veryDeepCopyWith: aCopier.
	previousDecorators := new decorators copy.
	previousDecorators do: #detach.
	previousDecorators do: [:decorator | new attachDecorator: decorator].
	^ new
]

{ #category : #'as yet unclassified' }
SBBlock >> wantsDroppedMorph: aMorph event: evt [

	^ (aMorph respondsTo: #object) and: [aMorph object hasRepresentationThat: self acceptedRepresentation]
]

{ #category : #testing }
SBBlock >> wasDeselected [

	" may be overriden "
]

{ #category : #testing }
SBBlock >> wasSelected [

	" may be overriden "
	self triggerEvent: #selected
]

{ #category : #decorators }
SBBlock >> withDecorator: aClass do: aBlock [

	decorators detect: [:d | d class = aClass] ifFound: aBlock ifNone: []
]

{ #category : #decorators }
SBBlock >> withDecorator: aClass do: aBlock ifAbsent: anotherBlock [

	^ decorators detect: [:d | d class = aClass] ifFound: aBlock ifNone: anotherBlock
]

{ #category : #'as yet unclassified' }
SBBlock >> wrapSelectionWith: aSelection [

	| new |
	new := aSelection veryDeepCopy.
	
	self sandblockEditor do: (SBCombinedCommand newWith: {
		(SBReplaceCommand newFor: self containingArtefact)
			target: self;
			replacer: new firstSubmorph.
		(SBReplaceCommand newFor: self containingArtefact)
			target: new placeholder;
			replacer: self.
	}).
	
	new postDuplicate
]
