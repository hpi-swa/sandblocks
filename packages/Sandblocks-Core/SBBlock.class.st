"
A SBBlock is the central element of Sandblocks.

It is an abstract superclass offering sensible default behavior for most interactions with other blocks.
"
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

	^ Navigation ifNil: [Navigation := SBSmalltalkNavigation new]
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

	self sandblockEditor containingWindow ifNotNil: #beKeyWindow.
	self allOwnersDo: #resetHighlightForDrop.
	self resetHighlightForDrop.
	self handleDroppedBlock: aMorph event: anEvent
]

{ #category : #'as yet unclassified' }
SBBlock >> acceptedRepresentation [
	" return what representations may replace you "

	^ self parentSandblock ifNotNil: [
		self parentSandblock contextAcceptedRepresentationAt: self childIndex] ifNil: [nil]
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

{ #category : #converting }
SBBlock >> asSandblock [

	^ self
]

{ #category : #decorators }
SBBlock >> attachDecorator: aDecorator [

	decorators add: aDecorator.
	aDecorator attached: self.
	self changed.
	self updateSteppingDecorators
]

{ #category : #testing }
SBBlock >> binding: aString for: block class: aClass ifPresent: aBlock [

	^ self parentSandblock binding: aString for: block class: aClass ifPresent: aBlock
]

{ #category : #'as yet unclassified' }
SBBlock >> browse [
	<action>
	" you were asked to be browsed. you may ignore this "
	
	self relatedClass browse
]

{ #category : #'artefact protocol' }
SBBlock >> cacheType: aClass for: aBlock [
]

{ #category : #testing }
SBBlock >> canAppearInBlockBody [

	^ false
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

{ #category : #actions }
SBBlock >> canJumpTo: aBlock [

	^ aBlock parentSandblock containingArtefact = self containingArtefact or: [self containingArtefact notNil and: [self containingArtefact floating not]]
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
SBBlock >> childHierarchyComplexity [

	^ self childSandblocks size < 2 ifTrue: [0] ifFalse: [ | c |
		c := 0.
		self allBlocksDo: [:b | c := c + 1].
		c]
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

	" FIXME: at this point I believe we should assume leaf blocks by default, but I'm not sure "
	"^ self subclassResponsibility"
]

{ #category : #'as yet unclassified' }
SBBlock >> clearCache [

	" this block may have just been duplicated or moved somewhere else, ensure to clear all caches and present yourself neatly "
	self allMorphsDo: [:morph | morph layoutChanged].
	self allBlocksDo: [:morph | morph removeProperty: #sandblockBlockColor]
]

{ #category : #'as yet unclassified' }
SBBlock >> click: anEvent [

	self sandblockEditor selectClick: self at: anEvent position
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
		ifTrue: [ | baseClass |
			baseClass := self guessClassExpensive.
			baseClass isNil
				ifFalse: [
					Array streamContents: [:stream |
						baseClass withAllSuperclassesDo: [:class |
							class methodsDo: [:m | | sel |
								sel := m selector asString.
								(sel sandblockMatch: aString) ifTrue: [stream nextPut: sel]]]]]
				ifTrue: [Symbol allSymbols select: [:sym | sym asString sandblockMatch: aString]]]
		ifFalse: [#()]
]

{ #category : #'as yet unclassified' }
SBBlock >> containingArtefact [

	^ self isArtefact
		ifTrue: [self]
		ifFalse: [self parentSandblock ifNotNil: [:b | b containingArtefact]]
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
SBBlock >> containingFullBlock [

	| next |
	next := self.
	[next := next parentSandblock ifNil: [^ nil]] doWhileFalse: [next isBlockBody and: [next startPC notNil]].
	^ next
]

{ #category : #'as yet unclassified' }
SBBlock >> containingSandblock [

	^ self
]

{ #category : #'as yet unclassified' }
SBBlock >> containingStatement [

	| current |
	current := self.
	[current parentSandblock ifNil: [^ nil] ifNotNil: #isBlockBody] whileFalse: [current := current parentSandblock].
	^ current
]

{ #category : #actions }
SBBlock >> containingToplevel [
	" first parent that is floating "
	
	^ self floating ifTrue: [self] ifFalse: [self parentSandblock containingToplevel]
]

{ #category : #'as yet unclassified' }
SBBlock >> contextAcceptedRepresentationAt: aNumber [
	" return any constraints on the representation of your child block at aNumber "

	^ nil
]

{ #category : #actions }
SBBlock >> copyAround [
	<action>

	| replacer editor target |
	" create a copy of our surroundings with ourselves replaced "
	editor := self sandblockEditor.
	target := self parentSandblock.
	editor countModifier - 1 timesRepeat: [target := target parentSandblock].
	
	replacer := SBPastePlaceholder new.
	self replaceBy: replacer.
	editor copyBuffer: target.
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

{ #category : #accessing }
SBBlock >> currentTextMorph [

	^ nil
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
SBBlock >> deleteAdjacent [
	<action>

	| count startIndex endIndex targets |
	count := self sandblockEditor countModifier.
	
	startIndex := self childIndex.
	endIndex := count = 0
		ifTrue: [self parentSandblock childSandblocks size]
		ifFalse: [
			startIndex + (count - 1) min: self parentSandblock childSandblocks size].
	
	targets := (startIndex to: endIndex) collect: [:index | self parentSandblock childSandblocks at: index].
	
	self sandblockEditor
		copyBuffer: targets;
		do: (SBCombinedCommand newWith: (targets
			collect: [:target |
				(SBDeleteCommand newFor: self containingArtefact)
					target: target]))
]

{ #category : #actions }
SBBlock >> deleteAround [
	<action>

	| replacer around editor target |
	editor := self sandblockEditor.
	target := self parentSandblock.
	editor countModifier - 1 timesRepeat: [target := target parentSandblock].
		
	(self hasRepresentationThat: (target parentSandblock contextAcceptedRepresentationAt: target childIndex)) ifTrue: [
		replacer := SBPastePlaceholder new.
		around := self.
		around replaceBy: replacer.
		editor copyBuffer: target.
		replacer replaceBy: around.
		
		replacer := self veryDeepCopy.
		editor do: ((SBReplaceCommand newFor: self containingArtefact)
			target: target;
			replacer: replacer).
		replacer postDuplicate]
]

{ #category : #actions }
SBBlock >> deleteBlock [
	<multiSelectAction>

	self assert: self isSelected.
	self sandblockEditor
		copyBuffer: self sandblockEditor multiSelection;
		doMultiSelectionEach: [:selected |
			selected parentSandblock deleteCommandFor: selected];
		maybeStartInputFromEnd
]

{ #category : #'as yet unclassified' }
SBBlock >> deleteCommandFor: aBlock [

	^ (self canDeleteChild: aBlock)
		ifTrue: [(SBDeleteCommand newFor: aBlock containingArtefact) target: aBlock]
		ifFalse: [
			((self contextAcceptedRepresentationAt: aBlock childIndex) includesRepresentation: #isSmalltalkExpression) ifTrue: [
				(SBReplaceCommand newFor: aBlock containingArtefact) target: aBlock; replacer: SBUnknown new]]
]

{ #category : #decorators }
SBBlock >> detachDecorator: aDecorator [

	decorators remove: aDecorator ifAbsent: [].
	self world ifNotNil: [:w | w stopStepping: aDecorator selector: #step].
	aDecorator detached: self.
	self changed
]

{ #category : #decorators }
SBBlock >> detachDecorators: aDecoratorClass [

	decorators do: [:d | d class = aDecoratorClass ifTrue: [d detached: self]].
	decorators := decorators reject: [:d | d class = aDecoratorClass].
	self changed.
	self updateSteppingDecorators
]

{ #category : #actions }
SBBlock >> dismiss [
	<action>
]

{ #category : #actions }
SBBlock >> doExpression [
	<action>

	| result |
	result := self evaluate.
	self containingArtefact ifNotNil: [
		self containingArtefact cacheType: result class for: self]
]

{ #category : #'as yet unclassified' }
SBBlock >> drawDropHighlightOn: aCanvas [

	self highlightedForDrop ifTrue: [
		self fixedNumberOfChildren
			ifTrue: [
				aCanvas frameRectangle: self bounds width: 3 color: Color red]
			ifFalse: [ | dropLocation |
				dropLocation := self dropLocationDo: [:position :morph :horizontal |
					aCanvas
						frameRectangle: self bounds width: 3 color: (Color red alpha: 0.3);
						
						line: position
						to: position + (horizontal ifTrue: [morph width @ 0] ifFalse: [0 @ morph height])
						width: 6
						color: Color red]]]
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
			color: (fg alpha: 0.7)].
	symbols second ifNotNil: [
		aCanvas
			drawString: symbols second
			at: self layoutBounds topRight + (0 @ (centerAlign ifTrue: [y] ifFalse: [self layoutBounds height - font height]))
			font: font
			color: (fg alpha: 0.7)]
]

{ #category : #colors }
SBBlock >> drawnColor [

	^ self color
]

{ #category : #'as yet unclassified' }
SBBlock >> dropLocationDo: aBlock [

	| mousePosition closestDist closestMorph |
	mousePosition := self valueOfProperty: #dropLocation.
	closestDist := 900000000.
	closestMorph := nil.
	self childSandblocksDo: [:block | | dist |
		dist := block topLeft squaredDistanceTo: mousePosition.
		dist < closestDist ifTrue: [
			closestDist := dist.
			closestMorph := block]].
	^ closestMorph ifNotNil: [ | delta |
		delta := (((closestMorph adjacentBlock: 1) ifNil: [closestMorph adjacentBlock: -1]) ifNotNil: [:next | next topLeft - closestMorph topLeft] ifNil: [1 @ 0]) abs.
		aBlock value: closestMorph topLeft - (0 @ 4) value: closestMorph value: delta x < delta y]
]

{ #category : #decorators }
SBBlock >> ensureDecorator: aClass do: aBlock [

	decorators detect: [:d | d class = aClass] ifFound: aBlock ifNone: [| d |
		d := aClass new.
		self attachDecorator: d.
		aBlock value: d]
]

{ #category : #'artefact protocol' }
SBBlock >> ensureExpanded [
]

{ #category : #actions }
SBBlock >> ensureVisible [
	<action>

	| method |
	method := self containingArtefact.
	(method ~= self and: [method notNil and: [self visibleInWorld not]]) ifTrue: [method ensureExpanded].
	
	Project current addDeferredUIMessage: [
		self isInWorld ifTrue: [self sandblockEditor ifNotNil: [:e | e scrollToShow: self]]]
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
	<actionValidIf: #isExpression>

	| result explorer |
	result := self evaluate.
	self containingArtefact ifNotNil: [
		self containingArtefact cacheType: result class for: self].
	
	explorer := result representIn: self sandblockEditor as: #isToplevelMorph near: self.
	explorer focusAfterDelete: self.
	self sandblockEditor connectFrom: self to: explorer
]

{ #category : #'as yet unclassified' }
SBBlock >> evaluateWith: aRequestor for: aContext [

	^ Compiler new evaluate: self sourceString readStream in: aContext to: (aContext ifNotNil: #receiver ifNil: [self containingArtefact relatedClass]) notifying: aRequestor ifFail: nil
]

{ #category : #'artefact protocol' }
SBBlock >> evaluationContext [

	^ nil
]

{ #category : #'artefact protocol' }
SBBlock >> evaluationReceiver [

	^ nil
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

{ #category : #actions }
SBBlock >> fixedNumberOfChildren [
	" return whether you may only take a fixed number of children "

	^ true
]

{ #category : #actions }
SBBlock >> floating [

	^ self owner layoutPolicy isNil
]

{ #category : #accessing }
SBBlock >> focusAfterDelete: aBlock [

	" set a hint to focus aBlock when this block is deleted "
	self setProperty: #focusAfterDelete toValue: aBlock
]

{ #category : #accessing }
SBBlock >> focusAfterDeleteIfNone: aBlock [

	| block |
	block := self valueOfProperty: #focusAfterDelete ifAbsent: aBlock.
	^ block isInWorld ifTrue: [block] ifFalse: [aBlock value]
]

{ #category : #actions }
SBBlock >> focusNextSuggestion [
	<inputAction>
	<actionValidIf: #hasCurrentTextMorph>
	
	self suggestionMenuDo: #next
]

{ #category : #actions }
SBBlock >> focusPreviousSuggestion [
	<inputAction>
	<actionValidIf: #hasCurrentTextMorph>
	
	self suggestionMenuDo: #previous
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

{ #category : #'event handling' }
SBBlock >> handleDropMorph: anEvent [

	self highlightForDrop: false.
	^ super handleDropMorph: anEvent
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

	^ anEvent redButtonPressed
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

{ #category : #testing }
SBBlock >> hasCurrentTextMorph [

	^ self currentTextMorph notNil
]

{ #category : #decorators }
SBBlock >> hasDecorator: aClass [

	^ decorators anySatisfy: [:d | d class = aClass]
]

{ #category : #'as yet unclassified' }
SBBlock >> hasInput [

	^ self sandblockEditor currentInput = self
]

{ #category : #suggestions }
SBBlock >> hasSuggestions [

	^ (self valueOfProperty: #sandblockSuggestionMenu ifAbsent: [^ false]) isInWorld
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

	(self nextBlockThat: [:m | m isUnknown])
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
	<inputAction>

	self insertElement: true
]

{ #category : #actions }
SBBlock >> insertElementBefore [
	<action>
	<inputAction>

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
SBBlock >> isMessagePart [

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

	^ self sandblockEditor ifNil: [false] ifNotNil: [:editor | editor selection = self]
]

{ #category : #testing }
SBBlock >> isSelection [

	^ false
]

{ #category : #testing }
SBBlock >> isStringBlock [

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
SBBlock >> layoutCommands [

	^ SBAlgebraCommand morph data: self
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

	self hasChildSandblocks ifFalse: [^ self].
	(self isFirstChild or: [self isLastChild]) ifFalse: [^ self].
	
	self sandblockEditor do: ((SBSubtreeRotateCommand newFor: self containingArtefact)
		target: self;
		yourself)
]

{ #category : #testing }
SBBlock >> listensToExamples [

	^ false
]

{ #category : #'as yet unclassified' }
SBBlock >> localColorPolicy: aPolicy [

	self setProperty: #localColorPolicy toValue: aPolicy new;
			clearCache;
			changed
]

{ #category : #hierarchy }
SBBlock >> localNestingDepth [

	^ 1 + (self parentSandblock ifNotNil: [:p | p localNestingDepth] ifNil: [0])
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

	(anEvent hand firstSubmorph respondsTo: #noteDragEnter:) ifTrue: [anEvent hand firstSubmorph noteDragEnter: self].
	
	self allOwnersDo: #resetHighlightForDrop.
	self highlightForDrop: true
]

{ #category : #'event handling' }
SBBlock >> mouseLeaveDragging: anEvent [

	(anEvent hand firstSubmorph respondsTo: #noteDragLeave:) ifTrue: [anEvent hand firstSubmorph noteDragLeave: self].
	
	self highlightForDrop: false
]

{ #category : #'event handling' }
SBBlock >> mouseMove: anEvent [

	super mouseMove: anEvent.
	(anEvent isDraggingEvent and: [self handlesMouseOverDragging: anEvent]) ifTrue: [
		self setProperty: #dropLocation toValue: anEvent position.
		self highlightForDrop]
]

{ #category : #actions }
SBBlock >> multiSelectChildren [
	<multiSelectAction>

	self sandblockEditor mode = #select ifFalse: [self sandblockEditor mode: #selection].
	self childSandblocks do: #startOrAddToMultiSelection
]

{ #category : #hierarchy }
SBBlock >> nestingDepth [

	| d node |
	d := 1.
	node := self.
	
	[node isArtefact not and: [node parentSandblock notNil]] whileTrue: [
		node := node parentSandblock.
		d := d + 1].
	
	^ d
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

{ #category : #'as yet unclassified' }
SBBlock >> nextVerticalNear: aNumber [

	| allCandidates candidates candidatesBestDistance tolerance |
	^ self
		nextVerticalNear: aNumber
		calcDistance: [:candidate | candidate top - self bottom]
		validBlock: [:candidate | candidate top > self bottom]
]

{ #category : #'as yet unclassified' }
SBBlock >> nextVerticalNear: aNumber calcDistance: aDistBlock validBlock: aValidBlock [

	| allCandidates candidates candidatesBestDistance tolerance artefact |
	artefact := self parentSandblock containingArtefact ifNil: [self containingArtefact].
	tolerance := 10.
	
	allCandidates := Array streamContents: [:stream |
		artefact allBlocksDo: [:candidate |
			(candidate hasChildSandblocks not and: [aValidBlock value: candidate]) ifTrue: [stream nextPut: candidate]]].
	
	candidates := OrderedCollection new.
	candidatesBestDistance := 900000000.
	allCandidates do: [:candidate | | distance |
		distance := aDistBlock value: candidate.
		distance < candidatesBestDistance
			ifTrue: [
				(candidatesBestDistance between: distance and: distance + tolerance) ifTrue: [candidates add: candidate] ifFalse: [candidates := OrderedCollection with: candidate].
				candidatesBestDistance := distance]
			ifFalse: [
				(distance between: candidatesBestDistance and: candidatesBestDistance + tolerance) ifTrue: [candidates add: candidate]]].
	
	^ candidates detectMin: [:candidate |
		((candidate center x - artefact left) - aNumber) abs]
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

	"Should be self subclassResponsibility but often causes non-recoverable errors with drag and drop"
	^ nil
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

{ #category : #'as yet unclassified' }
SBBlock >> parentThatAccepts: target ifNone: aBlock [

	| adjacent |
	adjacent := self.
	[
		(adjacent parentSandblock ifNil: [^ aBlock value]) acceptChild: target] whileFalse: [adjacent := adjacent parentSandblock].
	^ adjacent
]

{ #category : #actions }
SBBlock >> pasteAbove [
	<action>

	self pasteAboveOrBelow: true
]

{ #category : #actions }
SBBlock >> pasteAboveOrBelow: anAboveBoolean [

	| copyBuffer |
	copyBuffer := self sandblockEditor copyBuffer ifNil: [^ self].
	copyBuffer wrapsAround ifTrue: [^ self wrapSelectionWith: copyBuffer].
	SBToggledCode
		comment: ''
		active: 2
		do: {
			[
				self sandblockEditor do: (SBCombinedCommand newWith: (copyBuffer submorphs reversed collect: [:target | | index adjacent morph actualTarget |
					actualTarget := self parentThatAccepts: target ifNone: [^ self].
					index := adjacent getIndexInOwner.
					morph := actualTarget veryDeepCopy
						topCenter: self bottomCenter;
						postDuplicate;
						yourself.
					(adjacent parentSandblock containingArtefact ifNil: [SBInsertCommand newNonEdit] ifNotNil: [:artefact | SBInsertCommand newFor: artefact])
						index: (anAboveBoolean ifTrue: [index] ifFalse: [index + 1]);
						container: adjacent owner;
						morph: morph;
						yourself]))].
			[
				copyBuffer submorphs withIndexDo: [:target :index |
					target object
						safeRepresentationThat: (self parentSandblock contextAcceptedRepresentationAt: (anAboveBoolean ifTrue: [self childIndex] ifFalse: [self childIndex + index]))
						do: [:repr |
							self sandblockEditor do: ((self containingArtefact = self ifFalse: [SBInsertCommand newFor: self containingArtefact] ifTrue: [SBInsertCommand newNonEdit])
								morph: (repr center: self center);
								container: self owner;
								index: (anAboveBoolean ifTrue: [self submorphIndex] ifFalse: [self submorphIndex + index]);
								shouldMergeWithNext: index < copyBuffer submorphCount).
							repr postDuplicateSelf]
						ifNone: [SBLabel text: ['undo last command?']].
					anAboveBoolean ifTrue: [self submorphBefore select] ifFalse: [self submorphAfter select]]]
		}
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

{ #category : #accessing }
SBBlock >> pc [

	^ 0
]

{ #category : #accessing }
SBBlock >> pc: aNumber [
]

{ #category : #'as yet unclassified' }
SBBlock >> performAction: aSymbol [

	self perform: aSymbol
]

{ #category : #'as yet unclassified' }
SBBlock >> pickUp: anEvent [

	| editor |
	editor := self sandblockEditor.
	anEvent shiftPressed ifFalse: [
		editor do: ((self parentSandblock deleteCommandFor: self) shouldMergeWithNext: true)].
	
	anEvent hand grabMorph: (SBSelection new
		homeArtefact: self containingArtefact;
		methodClass: (self containingArtefact ifNotNil: #relatedClass);
		colorPolicy: self colorPolicy;
		addMorphBack: self veryDeepCopy;
		sourceBlock: self;
		onAbortUndoIn: editor;
		yourself)
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

	self allBlocksDo: [:morph | morph postDuplicateSelf].
	self detachDecorators: SBMultiSelectionDecorator.
	self clearCache
]

{ #category : #'as yet unclassified' }
SBBlock >> postDuplicateSelf [

	" this block has been duplicated, adjust any identifiers if need be "
	
]

{ #category : #colors }
SBBlock >> prefersNoBorder [

	^ false
]

{ #category : #'as yet unclassified' }
SBBlock >> prefix [

	^ self symbols first
]

{ #category : #testing }
SBBlock >> preventOcclusion [

	^ true
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

{ #category : #'as yet unclassified' }
SBBlock >> previousVerticalNear: aNumber [

	^ self
		nextVerticalNear: aNumber
		calcDistance: [:candidate | self top - candidate bottom]
		validBlock: [:candidate | self top > candidate bottom]
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

{ #category : #'artefact protocol' }
SBBlock >> relatedClass [

	^ self object class
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
		
		new safeRepresentationThat: self acceptedRepresentation do: [:repr |
			self sandblockEditor do: ((SBReplaceCommand newFor: self containingArtefact)
				target: self;
				replacer: repr).
			repr postDuplicate] ifNone: []]
]

{ #category : #'as yet unclassified' }
SBBlock >> representAs [
	<action>

	| options prompt |
	options := self object representationsThat: self acceptedRepresentation.
	options ifEmpty: [^ self].
	
	prompt := SBRepresentationPrompt new options: options target: self object current: self.
	self sandblockEditor openMorphInView: prompt.
	prompt position: self topRight
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
	<inputAction>

	(self containingArtefact = self
		ifTrue: [self parentSandblock containingArtefact]
		ifFalse: [self containingArtefact]) ifNotNil: #select.
		
	self sandblockEditor maybeStartInputFromStart
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
	
	next
		ifNotNil: #select
		ifNil: [
			self sandblockEditor startInput: self at: 0 replacingContents: false]
]

{ #category : #actions }
SBBlock >> selectLast [
	<multiSelectAction>
	<inputAction>

	self containingArtefact lastDeepChild select.
	
	self sandblockEditor maybeStartInputFromEnd
]

{ #category : #actions }
SBBlock >> selectLeftToplevel [
	<multiSelectAction>
	
	self selectToplevelTowards: #left
]

{ #category : #actions }
SBBlock >> selectNext [
	<multiSelectAction>
	<inputAction>

	self sandblockEditor selectionDownHistory removeAll.
	self class navigation nextFrom: self do: [:b | (self canJumpTo: b) ifTrue: [b select]].
	
	self sandblockEditor maybeStartInputFromStart
]

{ #category : #actions }
SBBlock >> selectNextGroup [
	<multiSelectAction>

	| oldCursorPos |
	oldCursorPos := self currentTextMorph ifNotNil: [:m | m cursorPosition] ifNil: [self center].
	
	self sandblockEditor keepVerticalSelectionPositionDuring: [
		(self nextVerticalNear: self sandblockEditor verticalSelectionPosition)
			ifNotNil: #select
			ifNil: [
				SBLabel text: [
					'Artefacts typically contain all their nodes, so none are below them'].
				self isArtefact ifTrue: [self selectNext]]].
	self sandblockEditor maybeStartInputNear: oldCursorPos
]

{ #category : #actions }
SBBlock >> selectPrevious [
	<multiSelectAction>
	<inputAction>

	self sandblockEditor selectionDownHistory removeAll.
	self class navigation previousFrom: self do: [:b | (self canJumpTo: b) ifTrue: [b select]].
	
	self sandblockEditor maybeStartInputFromEnd
]

{ #category : #actions }
SBBlock >> selectPreviousGroup [
	<multiSelectAction>

	| oldCursorPos |
	oldCursorPos := self currentTextMorph ifNotNil: [:m | m cursorPosition] ifNil: [self center].
	
	self sandblockEditor keepVerticalSelectionPositionDuring: [
		(self previousVerticalNear: self sandblockEditor verticalSelectionPosition) ifNotNil: #select].
	oldCursorPos ifNil: [self sandblockEditor maybeStartInputFromStart] ifNotNil: [self sandblockEditor maybeStartInputNear: oldCursorPos]
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
	(self containingToplevel closestAdjacentFrom: (aSideSymbol, 'Center') asSymbol to: (opposite, 'Center') asSymbol) select
]

{ #category : #actions }
SBBlock >> selectUp [
	<multiSelectAction>
	<inputAction>

	self sandblockEditor mode = #input ifTrue: [^ self sandblockEditor endInput].
	
	self parentSandblock ifNotNil: [:b |
		self sandblockEditor selectionDownHistory addLast: self.
		b select]
]

{ #category : #printing }
SBBlock >> selectionLabel [

	^ self printString
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
SBBlock >> spaceForSymbols [

	| symbols |
	symbols := self symbols.
	^ {
		(symbols first ifNil: [0] ifNotNil: [self fontToUse widthOfString: symbols first]).
		(symbols second ifNil: [0] ifNotNil: [self fontToUse widthOfString: symbols second])
	}
]

{ #category : #actions }
SBBlock >> startContinuousMultiSelection [
	<action>

	self sandblockEditor
		mode: #continuousSelection;
		addToMultiSelection: self
]

{ #category : #'as yet unclassified' }
SBBlock >> startDrag: anEvent [

	super startDrag: anEvent.
	
	(self hasDecorator: SBMoveDecorator) ifFalse: [
		(self nearestOwnerThat: [:o | o isSandblock and: [o isSelected]])
			ifNotNil: [:o | ^ o pickUp: anEvent].
		^ self select; pickUp: anEvent].
	
	self sandblockEditor select: self
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

{ #category : #hierarchy }
SBBlock >> submorphIndex [

	^ self owner submorphs indexOf: self
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
	children := self parentSandblock childSandblocks select: #canSwap.
	children ifEmpty: [^ self].
	
	next := children atWrap: (children indexOf: self) + aNumber.
	next ifNotNil: [
		self sandblockEditor do: ((SBSwapCommand newFor: self containingArtefact)
			a: self;
			b: next)]
]

{ #category : #actions }
SBBlock >> swapLeft [
	<action>
	<inputAction>

	self swap: -1
]

{ #category : #actions }
SBBlock >> swapRight [
	<action>
	<inputAction>

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

{ #category : #'event handling' }
SBBlock >> update [
]

{ #category : #testing }
SBBlock >> updateSteppingDecorators [

	| anyStepping |
	anyStepping := false.
	self decorators do: [:d |
		d stepTime >= 0 ifTrue: [
			anyStepping := true.
			self world ifNotNil: [:w | w startStepping: d at: Time millisecondClockValue selector: #step arguments: {} stepTime: d stepTime]]]
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

{ #category : #layout }
SBBlock >> useAlgebraLayout [

	self
		vResizing: #shrinkWrap;
		hResizing: #rigid;
		layoutPolicy: SBAlgebraLayout new
]

{ #category : #actions }
SBBlock >> useSuggestion [
	<inputAction>
	<actionValidIf: #hasSuggestions>
	" try to apply a suggestion, return whether anything was applied "

	self suggestionMenuDo: [:menu | | editor |
		editor := self sandblockEditor.
		menu activeSuggestion ifNotNil: [:s | s useSuggestionOn: self].
		editor maybeStartInputFromEnd.
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
				(mode = #selection or: [mode = #continuousSelection]) and: [action keyword = #multiSelectAction]]]) and: [
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

	^ (aMorph respondsTo: #object)" rather performance heavy, not sure yet: and: [aMorph object hasRepresentationThat: self acceptedRepresentation]"
]

{ #category : #'artefact protocol' }
SBBlock >> wantsInteractiveErrorCorrection [

	^ false
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
SBBlock >> withParentChainDo: aBlock [

	| p |
	p := aBlock.
	[aBlock] whileNotNil: [
		aBlock value: p.
		p := aBlock parentSandblock]
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
	
	self parentSandblock postDuplicate
]
