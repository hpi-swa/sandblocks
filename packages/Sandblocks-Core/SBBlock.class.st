Class {
	#name : #SBBlock,
	#superclass : #Morph,
	#instVars : [
		'decorators'
	],
	#category : 'Sandblocks-Core'
}

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

{ #category : #testing }
SBBlock >> activeMorph [
	" provides the opportunity to advertise a different morph that self to be considered as the current holder of focus "

	^ self
]

{ #category : #accessing }
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

{ #category : #converting }
SBBlock >> asObject [

	^ SBConvertResult unsupported
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

{ #category : #'as yet unclassified' }
SBBlock >> browseImplementors [

	| list |
	self selector ifNotNil: [:sel |
		list := self systemNavigation allImplementorsOf: sel asSymbol.
		list size = 1
			ifTrue: [self sandblockEditor open: list first compiledMethod]
			ifFalse: [self sandblockEditor openMorphInView: (SBCodeAccordion newFor: (list collect: #compiledMethod))]]
]

{ #category : #'as yet unclassified' }
SBBlock >> browseSenders [

	self selector ifNotNil: [:sel | | calls container |
		calls := self systemNavigation allCallsOn: sel asSymbol.
		container := SBCodeAccordion new.
		calls do: [:call |
			container  addMorphBack: (SBCodeLens forMethod: call compiledMethod selector: sel)].
		container openNear: self]
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

{ #category : #testing }
SBBlock >> canSwap [

	^ self isExpression
]

{ #category : #accessing }
SBBlock >> childSandblocks [

	^ Array streamContents: [:stream | self childSandblocksDo: [:block | stream nextPut: block]]
]

{ #category : #accessing }
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

{ #category : #testing }
SBBlock >> closestAdjacentFrom: mySide to: theirSide [

	| myPoint |
	myPoint := self perform: mySide.
	^ (self parentSandblock childSandblocks copyWithout: self) fold: [:a :b |
			((a perform: theirSide) squaredDistanceTo: myPoint) < ((b perform: theirSide) squaredDistanceTo: myPoint)
				ifTrue: [a] ifFalse: [b]]
]

{ #category : #accessing }
SBBlock >> codeActions [

	^ #()
	
	
	" from active-expressions experiment - not sure how to best place this now:
	
	self isExpression ifTrue: [
		{SBCodeAction labeled: 'Wrap in Marker' for: self do: [:node |
			node sandblockEditor do: ((SBWrapCommand newFor: node containingArtefact)
				outer: SBActiveExpressionSyncEvent new;
				inner: node;
				wrap: [:outer :inner | outer expression: inner])]}] ifFalse: [#()]"
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

	^ self sandblockEditor ifNotNil: #colorPolicy ifNil: [SBDefaultColorPolicy new]
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

{ #category : #'artefact protocol' }
SBBlock >> declarations [
	" return any SBName declarations you may know "

	^ #()
]

{ #category : #decorators }
SBBlock >> decorators [

	^ decorators
]

{ #category : #'as yet unclassified' }
SBBlock >> deleteCommandFor: aBlock [

	^ (self canDeleteChild: aBlock)
		ifTrue: [(SBDeleteCommand newFor: aBlock containingArtefact) target: aBlock]
		ifFalse: [(SBReplaceCommand newFor: aBlock containingArtefact) target: aBlock; replacer: SBUnknown new]
]

{ #category : #decorators }
SBBlock >> detachDecorator: aDecorator [

	decorators remove: aDecorator.
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
	
	self prefix ifNotNil: [:p | self drawPrefix: p on: aCanvas]
]

{ #category : #'as yet unclassified' }
SBBlock >> drawPrefix: aString on: aCanvas [

	| font width fg |
	font := self fontToUse.
	width := font widthOfString: aString.
	fg := self sandblockForegroundColor.
	aCanvas
		drawString: aString
		at: self layoutBounds origin + (self spaceForPrefix negated + ((self spaceForPrefix / 2) - (width / 2)) rounded @ ((self layoutBounds height / 2) - (font height / 2)) rounded)
		font: font
		color: ("fg = Color white ifTrue: [Color veryLightGray] ifFalse: ["fg alpha: 0.5)
]

{ #category : #'as yet unclassified' }
SBBlock >> drawSubmorphsOn: aCanvas [

	super drawSubmorphsOn: aCanvas.
	
	self valid ifFalse: [aCanvas frameRectangle: self bounds width: 2 * self scalingFactor color: Color red].
	
	self decorators do: [:d | d postDrawOn: aCanvas]
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

{ #category : #testing }
SBBlock >> ensureVisible [

	| method |
	method := self containingArtefact.
	(method ~= self and: [method notNil]) ifTrue: [method ensureExpanded].
	
	Project current addDeferredUIMessage: [self sandblockEditor ifNotNil: [:e | e scrollToShow: self]]
]

{ #category : #'as yet unclassified' }
SBBlock >> evaluate [

	^ Compiler evaluate: self sourceString
]

{ #category : #'as yet unclassified' }
SBBlock >> evaluateWith: aRequestor for: aContext [

	^ Compiler new evaluate: self sourceString readStream in: aContext to: (aContext ifNotNil: #receiver ifNil: [self containingArtefact relatedClass]) notifying: aRequestor ifFail: nil
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

	^ 3 withScalingFactor
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

{ #category : #accessing }
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

{ #category : #'as yet unclassified' }
SBBlock >> insertCommandRequest: anAfterBoolean near: aBlock [

	" the user pressed + on us, do we want to do something now? "
	^ nil
]

{ #category : #testing }
SBBlock >> intoWorld: aWorld [

	super intoWorld: aWorld.
	
	self updateSteppingDecorators
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

{ #category : #testing }
SBBlock >> isFirstChild [

	^ self parentSandblock childSandblocks first = self
]

{ #category : #testing }
SBBlock >> isGlobalWatch [

	^ false
]

{ #category : #testing }
SBBlock >> isLastChild [

	^ self parentSandblock childSandblocks last = self
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
SBBlock >> isRepl [

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

{ #category : #testing }
SBBlock >> lastDeepChild [

	| current |
	current := self.
	[current childSandblocks isEmpty] whileFalse: [current := current childSandblocks last].
	^ current
]

{ #category : #'as yet unclassified' }
SBBlock >> layoutInset [

	| space inset |
	space := self spaceForPrefix.
	inset := self colorPolicy layoutInset + super layoutInset.
	^ space > 0
		ifTrue: [inset isPoint
				ifTrue: [Rectangle left: space + inset x right: inset x top: inset y bottom: inset y]
				ifFalse: [Rectangle left: space + inset right: inset top: inset bottom: inset]]
		ifFalse: [inset]
]

{ #category : #'as yet unclassified' }
SBBlock >> leftMostBlock [

	^ self childSandblocks ifEmpty: [self] ifNotEmpty: [:c | c first leftMostBlock]
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

{ #category : #'as yet unclassified' }
SBBlock >> nextBlock [

	self childSandblocksDo: [:first | ^ first].
	
	^ (self adjacentBlock: 1) ifNil: [
		self parentSandblock parentAdjacentBlock: 1]
]

{ #category : #'as yet unclassified' }
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
SBBlock >> outOfWorld: aWorld [

	super outOfWorld: aWorld.
	
	self removeSuggestionMenu.
	self triggerEvent: #outOfWorld
]

{ #category : #testing }
SBBlock >> outerBounds [

	^ super outerBounds expandBy: self frameSize
]

{ #category : #'as yet unclassified' }
SBBlock >> parentAdjacentBlock: aNumber [

	^ (self adjacentBlock: aNumber)
		ifNil: [self parentSandblock ifNotNil: [:p | p parentAdjacentBlock: aNumber]]
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
SBBlock >> pickUp: anEvent [

	anEvent hand attachMorph: (SBSelection new 
		methodClass: self containingArtefact;
		colorPolicy: self colorPolicy;
		addMorphBack: self veryDeepCopy)
]

{ #category : #'as yet unclassified' }
SBBlock >> postDuplicate [

	" this block has been duplicated, adjuts any identifiers if need be "
	self clearCache.
	
	self allBlocksDo: [:morph | morph ~= self ifTrue: [morph postDuplicate]].
]

{ #category : #'as yet unclassified' }
SBBlock >> prefix [

	^ nil
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
SBBlock >> proposeCodeActions: aCollection for: aBlock [

	| index |
	index := UIManager default chooseFrom: (aCollection collect: #label).
	index > 0 ifTrue: [(aCollection at: index) do]
]

{ #category : #suggestions }
SBBlock >> removeSuggestionMenu [

	self valueOfProperty: #sandblockSuggestionMenu ifPresentDo: #delete.
	self removeProperty: #sandblockSuggestionMenu
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

	self sandblockEditor selectClick: self
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
SBBlock >> spaceForPrefix [

	^ self prefix ifNil: [0] ifNotNil: [:p | self fontToUse widthOfString: p]
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

{ #category : #accessing }
SBBlock >> textContents [

	^ ''
]

{ #category : #'as yet unclassified' }
SBBlock >> toggleCollapsed [

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

	self fixActions
		ifEmpty: [self sandblockEditor select: self]
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

{ #category : #suggestions }
SBBlock >> useSuggestion [
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
SBBlock >> wantsDroppedMorph: aMorph event: evt [

	^ aMorph isSandblock
]

{ #category : #testing }
SBBlock >> wasDeselected [

	" may be overriden "
]

{ #category : #testing }
SBBlock >> wasSelected [

	" may be overriden "
]

{ #category : #decorators }
SBBlock >> withDecorator: aClass do: aBlock [

	decorators detect: [:d | d class = aClass] ifFound: aBlock ifNone: []
]

{ #category : #decorators }
SBBlock >> withDecorator: aClass do: aBlock ifAbsent: anotherBlock [

	^ decorators detect: [:d | d class = aClass] ifFound: aBlock ifNone: anotherBlock
]
