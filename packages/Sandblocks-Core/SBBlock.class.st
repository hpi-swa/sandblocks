"
A SBBlock is the central element of Sandblocks.

It is an abstract superclass offering sensible default behavior for most interactions with other blocks.
"
Class {
	#name : #SBBlock,
	#superclass : #Morph,
	#instVars : [
		'decorators',
		'colorPolicyCache'
	],
	#classVars : [
		'Navigation'
	],
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBBlock class >> attractionStrengthMultiplier [

	^ 0.6
]

{ #category : #'as yet unclassified' }
SBBlock class >> defaultRepelStrength [

	^ 5000.0
]

{ #category : #'as yet unclassified' }
SBBlock class >> implicitAttractionStrength [

	^ 0.25
]

{ #category : #'as yet unclassified' }
SBBlock class >> maxRepelDistance [

	^ 100
]

{ #category : #'as yet unclassified' }
SBBlock class >> maximumNonOverlappingForce [

	^ 10
]

{ #category : #'as yet unclassified' }
SBBlock class >> navigation [

	^ Navigation ifNil: [Navigation := SBSmalltalkNavigation new]
]

{ #category : #'as yet unclassified' }
SBBlock class >> navigation: aNavigation [

	Navigation := aNavigation
]

{ #category : #input }
SBBlock >> absorbsInput: anEvent [
	" a chance for you to block this event from being dispatched as shortcut "

	^ false
]

{ #category : #'action helpers' }
SBBlock >> actionProviders [

	^ {self}, self decorators
]

{ #category : #'action helpers' }
SBBlock >> actions [

	^ (Array streamContents: [:stream |
		self actionProviders do: [:obj |
			obj class withAllSuperclassesDo: [:class |
				Pragma
					withPragmasIn: class
					do: [:pragma | (#(#action #multiSelectAction #inputAction) includes: pragma keyword) ifTrue: [stream nextPut: pragma]]]]]) asIdentitySet asArray
]

{ #category : #hierarchy }
SBBlock >> addBlock: aBlock [

	(self insertCommandRequest: aBlock near: nil before: false) do
]

{ #category : #'as yet unclassified' }
SBBlock >> allBlocksDetect: aBlock [

	self allBlocksDetect: aBlock ifFound: [:b | b] ifNone: [self error: 'no such block']
]

{ #category : #hierarchy }
SBBlock >> allBlocksDetect: aBlock ifFound: aSuccessBlock ifNone: aFailureBlock [

	self allBlocksDo: [:b | (aBlock value: b) ifTrue: [^ aSuccessBlock value: b]].
	^ aFailureBlock value
]

{ #category : #hierarchy }
SBBlock >> allBlocksDo: aBlock [

	self childSandblocksDo: [:m | m allBlocksDo: aBlock].
	aBlock value: self
]

{ #category : #hierarchy }
SBBlock >> allBlocksFor: anObject withInterfaces: aCollection [

	^ Array streamContents: [:stream |
		self allBlocksDo: [:morph |
			(morph isSandblock and: [morph object = anObject and: [morph satisfies: aCollection]]) ifTrue: [stream nextPut: morph]]]
]

{ #category : #'as yet unclassified' }
SBBlock >> allBlocksSatisfy: aBlock [

	self allBlocksDo: [:b | (aBlock value: b) ifFalse: [^ false]].
	^ true
]

{ #category : #hierarchy }
SBBlock >> allBlocksSelect: aBlock [

	^ Array streamContents: [:stream | self allBlocksDo: [:b | (aBlock value: b) ifTrue: [stream nextPut: b]]]
]

{ #category : #'as yet unclassified' }
SBBlock >> allChildBlocksSatisfy: aBlock [

	self allBlocksDo: [:b | (b ~= self and: [(aBlock value: b) not]) ifTrue: [^ false]].
	^ true
]

{ #category : #hierarchy }
SBBlock >> andAllParentSandblocksDo: aBlock [

	aBlock value: self.
	self parentSandblock ifNotNil: [:p | p andAllParentSandblocksDo: aBlock]
]

{ #category : #'as yet unclassified' }
SBBlock >> appendElement [
	<action>

	| cmd |
	cmd := (self
		insertEmptyCommandRequestNear: nil
		before: false) ifNil: [^ self].
	
	self sandblockEditor do: cmd.
	
	cmd shouldMergeWithNext ifTrue: [
		self sandblockEditor
			startInput: self sandblockEditor selection
			at: 0
			replacingContents: false]
]

{ #category : #callbacks }
SBBlock >> artefactChanged: aMethodBlock [
	" callback fired after each change to a method "

	
]

{ #category : #suggestions }
SBBlock >> artefactCompletionSelectorsFor: aBlock class: aClass [
	"May be overridden by subclasses."
	
	aClass ifNil: [^ Symbol allSymbols].
	
	^ aClass sandblocksSuggestionsFor: self
]

{ #category : #suggestions }
SBBlock >> artefactCompletionSuggestionsFor: aBlock matching: aString [

	| exactMatches fuzzyMatches selectors list |
	selectors := OrderedCollection withAll: (self artefactCompletionSelectorsFor: aBlock class: aBlock guessClassExpensive).
	exactMatches := (Array streamContents: [:stream |
		selectors removeAllSuchThat: [:sel |
			(sel sandblockBeginsWith: aString)
				ifTrue: [stream nextPut: sel];
				yourself]]) sort: #size ascending.
	fuzzyMatches := (Array streamContents: [:stream |
		selectors removeAllSuchThat: [:sel |
			(sel sandblockMatch: aString)
				ifTrue: [stream nextPut: sel];
				yourself]]) sort: #size ascending.
	list := exactMatches, fuzzyMatches, (self sandblockEditor suggestAlways ifTrue: [selectors] ifFalse: [#()]).
	
	"add outer artefact's selector, if any, to support recursion of not-yet-saved methods"
	self ifNotNil: [:artefact | artefact selector ifNotNil: [:sel | (sel sandblockMatch: aString) ifTrue: [list := (list copyWithout: sel) copyWithFirst: sel]]].
	
	^ list
]

{ #category : #accessing }
SBBlock >> artefactForPersisting [

	| candidate |
	candidate := self containingArtefact.
	[candidate isNil or: [candidate canPersist]] whileFalse: [candidate := candidate parentSandblock ifNotNil: #containingArtefact].
	^ candidate
]

{ #category : #callbacks }
SBBlock >> artefactSaved: aMethodBlock [

	" callback fired after each save of a method/artefact "
]

{ #category : #converting }
SBBlock >> asSandblock [

	^ self
]

{ #category : #converting }
SBBlock >> asThumbnail: converter [
	<convert>
	
	converter
		if: [self sandblockEditor notNil]
		do: [self thumbnail]
]

{ #category : #decorators }
SBBlock >> attachDecorator: aDecorator [

	decorators add: aDecorator.
	aDecorator attached: self.
	self changed.
	self updateSteppingDecorators
]

{ #category : #'as yet unclassified' }
SBBlock >> attractionStrengthTo: aMorph [

	^ (self isAttractedTo: aMorph)
		ifTrue: [self class implicitAttractionStrength]
		ifFalse: [0.0]
]

{ #category : #'as yet unclassified' }
SBBlock >> attractionTo: aMorph [

	^ (self attractionStrengthTo: aMorph) + (aMorph attractionStrengthTo: self)
	
	
]

{ #category : #actions }
SBBlock >> barf [
	<action>
	<actionValidIf: #parentHasDynamicNumberOfChildren>

	
	self hasChildSandblocks ifFalse: [^ self].
	
	self sandblockEditor do: (self parentSandblock insertCommandRequest: self childSandblocks last near: self before: false).
	self select
]

{ #category : #actions }
SBBlock >> barfFront [
	<action>
	<actionValidIf: #parentHasDynamicNumberOfChildren>

	
	self hasChildSandblocks ifFalse: [^ self].
	
	self sandblockEditor do: (self parentSandblock insertCommandRequest: self childSandblocks first near: self before: true).
	self select
]

{ #category : #'event handling' }
SBBlock >> batchedChangeStep [

	self sandblockEditor ifNotNil: [:e | e batchedChangeStep: self]
]

{ #category : #'ast helpers' }
SBBlock >> binding: aString for: block class: aClass ifPresent: aBlock [

	^ self parentSandblock ifNotNil: [:p | p binding: aString for: block class: aClass ifPresent: aBlock]
]

{ #category : #'ast helpers' }
SBBlock >> bindingOf: aString [

	^ self parentSandblock ifNotNil: [:p | p bindingOf: aString]
]

{ #category : #hierarchy }
SBBlock >> blockFor: anObject withInterfaces: aCollection ifOpen: aBlock ifClosed: anotherBlock [

	^ self
		allBlocksDetect: [:morph | morph isSandblock and: [morph object == anObject and: [morph satisfies: aCollection]]]
		ifFound: aBlock
		ifNone: anotherBlock
]

{ #category : #actions }
SBBlock >> browse [
	<action>
	" you were asked to be browsed. you may ignore this "

	self relatedClass browse
]

{ #category : #testing }
SBBlock >> canAppearInBlockBody [

	^ self isExpression
]

{ #category : #testing }
SBBlock >> canCopy [

	^ true
]

{ #category : #'actions tests' }
SBBlock >> canDelete [

	^ (self parentSandblock deleteCommandFor: self) notNil
]

{ #category : #'insert/delete' }
SBBlock >> canDeleteChild: aBlock [

	^ self fixedNumberOfChildren not
]

{ #category : #accessing }
SBBlock >> canDrag [

	^ self valueOfProperty: #canDrag ifAbsent: [true]
]

{ #category : #accessing }
SBBlock >> canDrag: aBoolean [

	self setProperty: #canDrag toValue: aBoolean
]

{ #category : #testing }
SBBlock >> canEvaluate [

	^ false
]

{ #category : #'actions tests' }
SBBlock >> canInput [

	self flag: #fixme.
	" see if we specialize startInput. FIXME: we can currently not just call startInput and
	see what we get back because some classes cause side-effects, which they shouldn't "
	"(self class lookupSelector: #startInputAt:replacingContents:) methodClass ~= SBBlock"
	
	^ self currentTextMorph notNil
]

{ #category : #'actions tests' }
SBBlock >> canInsertAfter [

	^ (self parentSandblock insertEmptyCommandRequestNear: self before: false) notNil
]

{ #category : #'actions tests' }
SBBlock >> canInsertBefore [

	^ (self parentSandblock insertEmptyCommandRequestNear: self before: true) notNil
]

{ #category : #'actions tests' }
SBBlock >> canJumpTo: aBlock [

	aBlock parentSandblock ifNil: [^ false].
	
	^ aBlock parentSandblock containingArtefact = self containingArtefact or: [self containingArtefact notNil and: [self containingArtefact floating not]]
]

{ #category : #testing }
SBBlock >> canPersist [

	^ true
]

{ #category : #'actions tests' }
SBBlock >> canSelectPreviousSuggestion [

	^ self hasMultipleSuggestions and: [self suggestionMenuDo: [:menu | menu activeIndex > 1]]
]

{ #category : #'colors and color policies' }
SBBlock >> centerAlignSymbols [

	^ true
]

{ #category : #actions }
SBBlock >> changeLocalColorPolicy [
	<action>

	^ (UIManager default chooseFrom: (SBColorPolicy withAllSubclasses collect: #asString) values: SBColorPolicy withAllSubclasses) ifNotNil: [:policy |
		self localColorPolicy: policy]
]

{ #category : #actions }
SBBlock >> changeToUnknown [
	<action>

	self newNullBlock convertedFor: self objectInterface do: [:new |
		new ifNotNil: [
			self sandblockEditor
				do: (SBReplaceCommand new
					target: self;
					replacer: new;
					shouldMergeWithNext: true;
					yourself);
				startInput: new at: 0 replacingContents: false]]
]

{ #category : #hierarchy }
SBBlock >> childClosestTo: aPoint that: aBlock [

	| closestDistance closestMorph |
	closestDistance := 900000000.
	closestMorph := nil.
	self childSandblocksDo: [:block | | distance |
		(aBlock value: block) ifTrue: [
			distance := block topLeft squaredDistanceTo: aPoint.
			distance < closestDistance ifTrue: [
				closestDistance := distance.
				closestMorph := block]]].
	^ closestMorph
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

{ #category : #caching }
SBBlock >> clearCache [
	" this block may have just been duplicated or moved somewhere else, ensure to clear all caches and present yourself neatly "

	self layoutChanged.
	self clearCacheSelf.
	self childSandblocksDo: [:m | m clearCache]
]

{ #category : #caching }
SBBlock >> clearCacheSelf [

	colorPolicyCache := nil.
	self removeProperty: #sandblockBlockColor
]

{ #category : #actions }
SBBlock >> clearInput [
	<action>

	self hasCurrentTextMorph
		ifTrue: [
			self hasInput
				ifTrue: [self contents: '']
				ifFalse: [self sandblockEditor startInput: self at: 1 replacingContents: true]]
		ifFalse: [self changeToUnknown]
]

{ #category : #'event handling' }
SBBlock >> click: anEvent [

	(anEvent redButtonPressed and: [anEvent shiftPressed]) ifTrue: [^ self startOrAddToMultiSelection].
	
	self sandblockEditor selectClick: self at: anEvent position.
	(anEvent yellowButtonPressed and: [SBPreferences rightClickContextMenu]) ifTrue: [self promptAction].
	(self isInWorld and: [self suggestAlways and: [anEvent redButtonPressed]]) ifTrue: [self toggleSuggestions]
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

{ #category : #'colors and color policies' }
SBBlock >> color [

	^ self colorPolicy ifNotNil: [:p | p colorForBlock: self] ifNil: [Color white]
]

{ #category : #'colors and color policies' }
SBBlock >> colorPolicy [

	^ colorPolicyCache ifNil: [
		self valueOfProperty: #localColorPolicy ifPresentDo: [:c | ^ colorPolicyCache := c].
		self parentSandblock ifNotNil: [:p | colorPolicyCache := p colorPolicy] ifNil: [SBDefaultColorPolicy new]]
]

{ #category : #testing }
SBBlock >> completeSubtree [

	self allBlocksDo: [:b | b isUnknown ifTrue: [^ false]].
	^ true
]

{ #category : #suggestions }
SBBlock >> completionSuggestionsFor: aString [

	(self suggestAlways or: [aString size > 2]) ifFalse: [^ #()].
	
	^ self containingArtefact
		ifNotNil: [:a | a artefactCompletionSuggestionsFor: self matching: aString]
		ifNil: [#()]
]

{ #category : #accessing }
SBBlock >> containingArtefact [

	^ self isArtefact
		ifTrue: [self]
		ifFalse: [self parentSandblock ifNotNil: [:b | b containingArtefact]]
]

{ #category : #hierarchy }
SBBlock >> containingBlock [

	| next |
	next := self.
	[next := next parentSandblock ifNil: [^ nil]] doWhileFalse: [next isBlockBody].
	^ next
]

{ #category : #hierarchy }
SBBlock >> containingBlocksDo: aBlock [

	| current |
	current := self containingBlock.
	[current] whileNotNil: [
		aBlock value: current.
		current := current containingBlock]
]

{ #category : #hierarchy }
SBBlock >> containingFloat [

	self floating ifTrue: [^ self].
	
	^ (self ownerSatisfying: [:o | o isSandblock and: [o floating]]) ifNil: [self sandblockEditor]
]

{ #category : #hierarchy }
SBBlock >> containingSandblock [

	^ self
]

{ #category : #hierarchy }
SBBlock >> containingStatement [

	| parent |
	parent := self parentSandblock.
	parent ifNil: [^ nil].
	
	(parent isBlockBody and: [parent statements includes: self]) ifTrue: [^ self].
	^ parent containingStatement
]

{ #category : #hierarchy }
SBBlock >> containingToplevel [
	" first parent that is floating "
	
	^ self floating ifTrue: [self] ifFalse: [self parentSandblock containingToplevel]
]

{ #category : #accessing }
SBBlock >> contents [

	^ self currentTextMorph ifNotNil: [:t | t contents]
]

{ #category : #accessing }
SBBlock >> contents: aString [

	self currentTextMorph ifNotNil: [:t | t contents: aString]
]

{ #category : #'as yet unclassified' }
SBBlock >> continueInput [

	(self startInputCommand
		ifNotNil: [self]
		ifNil: [self nextBlockThat: [:m | m startInputCommand notNil]]) ifNotNil: [:m | ((m hasOwner: self) or: [m = self]) ifTrue: [self sandblockEditor startInput: m at: 900000000 replacingContents: false]]
]

{ #category : #actions }
SBBlock >> convertTo [
	<action>

	| options index |
	options := Array streamContents: [:stream | self object allConversionsFor: self objectInterface do: [:pair | stream nextPut: pair]].
	options ifEmpty: [^ self].
	
	index := UIManager default chooseFrom: (options collect: #first).
	index > 0 ifTrue: [
		self sandblockEditor do: (SBReplaceCommand new
			target: self;
			replacer: (options at: index) second)]
]

{ #category : #actions }
SBBlock >> copyAround [
	<action>

	| editor target |
	" create a copy of our surroundings with ourselves replaced "
	editor := self sandblockEditor.
	target := self parentSandblock.
	editor countModifier - 1 timesRepeat: [target := target parentSandblock].
	
	self setProperty: #copyPlaceholder toValue: true.
	editor copyBuffer: target.
	self removeProperty: #copyPlaceholder
]

{ #category : #'ast helpers' }
SBBlock >> copyFindSelection: aBlock in: aParentBlock [

	| index |
	"assume we are an exact copy of aParentBlock and aBlock is a child of aParentBlock
this method returns our child that corresponds to aBlock"
	index := 0.
	aParentBlock allBlocksDo: [:b |
		b = aBlock ifTrue: [
			self allBlocksDo: [:b2 |
				index = 0 ifTrue: [^ b2].
				index := index - 1]].
		index := index + 1].
	self error: 'block could not be found again'
]

{ #category : #testing }
SBBlock >> copyOnDrag [
	" return true if you always want to copy when drags are started "

	^ false
]

{ #category : #'insert/delete' }
SBBlock >> copyPlaceholder [

	self allMorphsDo: [:m | (m valueOfProperty: #copyPlaceholder ifAbsent: [false]) ifTrue: [^ m]].
	^ nil
]

{ #category : #actions }
SBBlock >> copyString [
	<action>

	Clipboard clipboardText: (self grammarHandler
		ifNotNil: [:g |
			g
				block: self;
				textContentsForCopy]
		ifNil: [self textContentsForCopy])
]

{ #category : #actions }
SBBlock >> copyToBuffer [
	<multiSelectAction>

	self sandblockEditor copyBuffer: self sandblockEditor multiSelection.
	self performAction: #copyString.
	self sandblockEditor endMultiSelection
]

{ #category : #accessing }
SBBlock >> currentTextMorph [

	^ nil
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
		ifFalse: [startIndex + (count - 1) min: self parentSandblock childSandblocks size].
	
	targets := (startIndex to: endIndex) collect: [:index | self parentSandblock childSandblocks at: index].
	
	self sandblockEditor do: (SBCombinedCommand newWith: (targets collect: [:target | SBDeleteCommand new target: target]))
]

{ #category : #actions }
SBBlock >> deleteAfterCursor [
	<inputAction>
	<actionValidIf: #hasCurrentTextMorph>
	
	self currentTextMorph deleteAfterCursor
]

{ #category : #actions }
SBBlock >> deleteAround [
	<action>

	| editor |
	self example: ['3 squared' parseInMethod receiver] args: [{}] label: 'example'.
	editor := self sandblockEditor.
	self
		deleteAroundTargetDo: [:target :replacer |
			self setProperty: #copyPlaceholder toValue: true.
			editor copyBuffer: target.
			self removeProperty: #copyPlaceholder.
			editor do: (SBReplaceCommand new
				target: target;
				replacer: replacer).
			replacer postDuplicate.
			^ self]
		ifNone: []
]

{ #category : #'action helpers' }
SBBlock >> deleteAroundTargetDo: aBlock ifNone: anotherBlock [

	| target |
	target := self parentSandblock.
	[
		self convertedFor: target objectInterface do: [:replacer | aBlock value: target value: replacer].
		target := target parentSandblock.
		(target isNil or: [target floating and: [target isArtefact]]) ifTrue: [^ anotherBlock value]] repeat
]

{ #category : #actions }
SBBlock >> deleteBeforeCursor [
	<inputAction>
	<actionValidIf: #hasCurrentTextMorph>

	| editor adjacent parent |
	self currentTextMorph cursor ~= 1 ifTrue: [
		self currentTextMorph deleteBeforeCursor.
		^ self batchedChangeStep].
	self symbols first notNil ifTrue: [^ self changeToUnknown].
	
	editor := self sandblockEditor.
	parent := self parentSandblock.
	
	adjacent := self currentTextMorph previousMorphThat: [:b | b isTextMorph].
	
	(adjacent notNil and: [adjacent hasOwner: parent])
		ifTrue: [ | target |
			target := adjacent containingSandblock.
			self currentTextMorph contents isEmpty ifTrue: [
				self hasChildSandblocks not
					ifTrue: [self deleteBlock]
					ifFalse: [(target = self childSandblocks first or: [target hasOwner: self childSandblocks first]) ifTrue: [self childSandblocks first deleteAround]]].
			target sandblockEditor ifNotNil: [editor startInput: target at: 900000000 replacingContents: false]]
		ifFalse: [
			(self parentHasDynamicNumberOfChildren and: [parent childSandblocks size > 1])
				ifTrue: [
					self deleteBlock.
					editor startInput: parent childSandblocks first at: 900000000 replacingContents: false]
				ifFalse: [
					self
						deleteAroundTargetDo: [:target :replacer |
							target floating ifFalse: [
								self deleteAround.
								editor startInput: self at: 900000000 replacingContents: false]]
						ifNone: []]]
]

{ #category : #actions }
SBBlock >> deleteBlock [
	<multiSelectAction>
	<actionValidIf: #canDelete>

	self isSelected ifFalse: [^ self sandblockEditor do: (self parentSandblock deleteCommandFor: self)].
	
	self sandblockEditor doMultiSelectionEach: [:selected | selected parentSandblock deleteCommandFor: selected]
]

{ #category : #actions }
SBBlock >> deleteBlockWithCopy [
	<multiSelectAction>
	<actionValidIf: #canDelete>

	| blocks editor |
	blocks := self sandblockEditor multiSelection.
	editor := self sandblockEditor.
	self deleteBlock.
	editor copyBuffer: blocks
]

{ #category : #'insert/delete' }
SBBlock >> deleteCommandFor: aBlock [

	^ (self canDeleteChild: aBlock)
		ifTrue: [SBDeleteCommand new target: aBlock]
		ifFalse: [
			self newNullBlock ifNotNil: [:nullBlock |
				SBReplaceCommand new
					target: aBlock;
					replacer: nullBlock]]
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

{ #category : #decorators }
SBBlock >> detachDecoratorsThat: aBlock [

	decorators do: [:d | (aBlock value: d) ifTrue: [d detached: self]].
	decorators := decorators reject: [:d | aBlock value: d].
	self changed.
	self updateSteppingDecorators
]

{ #category : #actions }
SBBlock >> dismiss [
	<action>

	self removeSuggestionMenu
]

{ #category : #'dropping/grabbing' }
SBBlock >> dragTarget [

	^ self veryDeepCopy
]

{ #category : #drawing }
SBBlock >> drawBackgroundOn: aCanvas [

	| policy |
	policy := self colorPolicy.
	^ aCanvas
		frameAndFillRoundRect: self bounds
		radius: policy cornerRadius
		fillStyle: self drawnColor
		borderWidth: (policy borderWidthForBlock: self)
		borderColor: (policy borderColorForBlock: self)
]

{ #category : #drawing }
SBBlock >> drawChangedMarker: aCanvas [

	^ self hasUnsavedChanges ifTrue: [ | adornment |
		adornment := PluggableTextMorph adornmentWithColor: Color orange.
		aCanvas translucentImage: adornment at: self position + (self width - adornment width @ 0)]
]

{ #category : #drawing }
SBBlock >> drawDecoratorsOn: aCanvas during: aBlock [

	self decorators do: [:d | d preDrawOn: aCanvas].
	
	aBlock value.
	
	self decorators do: [:d | d postDrawSelfOn: aCanvas]
]

{ #category : #drawing }
SBBlock >> drawDropHighlightOn: aCanvas [

	
]

{ #category : #drawing }
SBBlock >> drawFrame: aColor on: aCanvas [

	aCanvas
		frameRectangle: (self bounds expandBy: 2) width: self frameSize
		color: aColor
]

{ #category : #drawing }
SBBlock >> drawInvalidBorderOn: aCanvas [

	aCanvas frameRoundRect: self bounds radius: self colorPolicy cornerRadius width: 2 color: Color red
]

{ #category : #drawing }
SBBlock >> drawOn: aCanvas [

	self drawDecoratorsOn: (self drawBackgroundOn: aCanvas) during: [self drawSymbolsOn: aCanvas]
]

{ #category : #drawing }
SBBlock >> drawSubmorphsOn: aCanvas [

	self valid ifFalse: [self drawInvalidBorderOn: aCanvas].
	super drawSubmorphsOn: aCanvas.
	
	self drawChangedMarker: aCanvas.
	
	self decorators do: [:d | d postDrawOn: aCanvas]
]

{ #category : #drawing }
SBBlock >> drawSymbolsOn: aCanvas [

	| symbols fg font space y centerAlign |
	centerAlign := self colorPolicy centerAlignSymbols and: [self centerAlignSymbols].
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

{ #category : #'colors and color policies' }
SBBlock >> drawnColor [

	^ self color
]

{ #category : #'testing hierarchy' }
SBBlock >> dynamicNumberOfChildren [

	^ self fixedNumberOfChildren not
]

{ #category : #actions }
SBBlock >> endInput [
	<inputAction>

	self sandblockEditor endInput
]

{ #category : #actions }
SBBlock >> endMultiSelection [
	<action>
	<actionValidIf: #hasMultiSelection>

	self select
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

{ #category : #layout }
SBBlock >> ensureLayouted [

	SBToggledCode comment: '' active: 1 do: {
		[self allOwnersDo: #fullBounds].
		[self owner ifNotNil: [:o | o layoutPolicy ifNotNil: [:l | l ensureLayouted: self]]]}
]

{ #category : #actions }
SBBlock >> ensureVisible [
	<action>

	| method |
	method := self containingArtefact.
	(method ~= self and: [method notNil and: [self visibleInWorld not]]) ifTrue: [method ensureExpanded].
	
	self isInWorld ifTrue: [self sandblockEditor ifNotNil: [:e | e scrollToShow: self]]
]

{ #category : #actions }
SBBlock >> exploreSelf [
	<action>
	
	self sandblockEditor openMorphInView: (SBExplorer on: self)
]

{ #category : #hierarchy }
SBBlock >> firstDeepChild [

	| current |
	current := self.
	[current childSandblocks isEmpty] whileFalse: [current := current childSandblocks first].
	^ current
]

{ #category : #'ast helpers' }
SBBlock >> fixActions [

	^ #()
]

{ #category : #'testing hierarchy' }
SBBlock >> fixedNumberOfChildren [
	" return whether you may only take a fixed number of children "

	^ true
]

{ #category : #hierarchy }
SBBlock >> flattenChildren [

	self childSandblocks reverseDo: [:b | self parentSandblock addMorph: b after: self].
	self delete
]

{ #category : #testing }
SBBlock >> floating [

	^ self owner isNil or: [self owner layoutPolicy isNil or: [self disableLayout]]
]

{ #category : #accessing }
SBBlock >> focusAfterDelete: aBlock [

	" set a hint to focus aBlock when this block is deleted "
	self setProperty: #focusAfterDelete toValue: aBlock
]

{ #category : #accessing }
SBBlock >> focusAfterDeleteIfNone: aBlock [

	| block |
	block := self valueOfProperty: #focusAfterDelete ifAbsent: [^ aBlock value].
	^ block isInWorld ifTrue: [block] ifFalse: [aBlock value]
]

{ #category : #actions }
SBBlock >> focusNextSuggestion [
	<inputAction>
	<actionValidIf: #hasMultipleSuggestions>
	
	self suggestionMenuDo: #next
]

{ #category : #actions }
SBBlock >> focusPreviousSuggestion [
	<inputAction>
	<actionValidIf: #canSelectPreviousSuggestion>

	self suggestionMenuDo: #previous
]

{ #category : #'as yet unclassified' }
SBBlock >> forceAgainst: aMorph [

	| direction |
	direction := self center - aMorph center.
	^ (direction closeTo: 0 @ 0)
		ifTrue: [(ThreadSafeRandom next @ ThreadSafeRandom next) * 10]
		ifFalse: [ 
			direction normalized * ((self repelStrengthTo: aMorph) + (aMorph repelStrengthTo: self))]
]

{ #category : #'colors and color policies' }
SBBlock >> foregroundColor [

	^ self colorPolicy foregroundColorForBlock: self
]

{ #category : #decorators }
SBBlock >> forwardAlarm: aSelector to: anObject [

	anObject perform: aSelector
]

{ #category : #drawing }
SBBlock >> frameSize [

	^ self colorPolicy ifNotNil: [:c | c selectionBorderWidth] ifNil: [0]
]

{ #category : #accessing }
SBBlock >> grammarHandler [

	^ nil
]

{ #category : #'as yet unclassified' }
SBBlock >> group [ 
	
	^ self withDecorator: SBForceMoveDecorator do: [:decorator | decorator group] ifAbsent: [nil]
]

{ #category : #'event handling' }
SBBlock >> handlesMouseDown: anEvent [

	^ anEvent redButtonPressed or: [SBPreferences rightClickContextMenu and: [anEvent yellowButtonPressed]]
]

{ #category : #'testing hierarchy' }
SBBlock >> hasChildSandblocks [

	self childSandblocksDo: [:b | ^ true].
	^ false
]

{ #category : #'actions tests' }
SBBlock >> hasCommandPalette [

	^ SBPalette allSubclasses anySatisfy: [:palette | (self satisfies: palette context) and: [palette matchesBlock: self]]
]

{ #category : #'actions tests' }
SBBlock >> hasCurrentTextMorph [

	^ self currentTextMorph notNil
]

{ #category : #decorators }
SBBlock >> hasDecorator: aClass [

	^ decorators anySatisfy: [:d | d isKindOf: aClass]
]

{ #category : #'as yet unclassified' }
SBBlock >> hasGroup [ 
	
	^ self group notNil
]

{ #category : #layout }
SBBlock >> hasHorizontalLayout [

	^ self submorphs size < 2 or: [ | delta |
		delta := self submorphs first topLeft - self submorphs second topLeft.
		delta x < delta y]
]

{ #category : #testing }
SBBlock >> hasInput [

	^ self isSelected and: [self sandblockEditor mode = #input]
]

{ #category : #'actions tests' }
SBBlock >> hasMultiSelection [

	^ self sandblockEditor cursor cursorPosition isKindOf: SBCursorMultiSelect
]

{ #category : #'actions tests' }
SBBlock >> hasMultipleSuggestions [

	^ self hasSuggestions and: [(self valueOfProperty: #sandblockSuggestionMenu) itemCount > 1]
]

{ #category : #'actions tests' }
SBBlock >> hasNoSuggestions [

	^ self hasSuggestions not
]

{ #category : #'actions tests' }
SBBlock >> hasSuggestions [

	^ (self valueOfProperty: #sandblockSuggestionMenu ifAbsent: [^ false]) isInWorld
]

{ #category : #testing }
SBBlock >> hasUnsavedChanges [

	^ self sandblockEditor ifNotNil: [:e | e hasUnsavedChanges: self] ifNil: [false]
]

{ #category : #initialization }
SBBlock >> initialize [

	super initialize.
	
	decorators := OrderedCollection new.
	
	color := Color transparent.
	self
		cellPositioning: #topLeft;
		layoutInset: 0;
		cellGap: 1;
		extent: 0 @ 0
]

{ #category : #actions }
SBBlock >> inputContainedUnknown [
	<action>
	<inputAction>

	(self wantsInput ifTrue: [self] ifFalse: [self nextBlockThat: [:m | m wantsInput]]) ifNotNil: [:m | ((m hasOwner: self) or: [m = self]) ifTrue: [self sandblockEditor startInput: m at: 1 replacingContents: false]]
]

{ #category : #actions }
SBBlock >> inputNextUnknown [
	<action>
	<inputAction>

	(self nextBlockThat: [:m | m wantsInput]) ifNotNil: [:m | self containingFloat = m containingFloat ifTrue: [self sandblockEditor startInput: m at: 1 replacingContents: false]]
]

{ #category : #actions }
SBBlock >> inputPreviousUnknown [
	<action>
	<inputAction>

	(self previousMorphThat: [:m | m isSandblock and: [m wantsInput]])
		ifNotNil: [:m |
			self containingFloat = m containingFloat ifTrue: [
				self sandblockEditor startInput: m at: 1 replacingContents: false]]
]

{ #category : #'insert/delete' }
SBBlock >> insertCommandRequest: aMorph near: aBlock before: aBoolean [
	" the user tries to add a block to us, do we want to do something now? "

	self fixedNumberOfChildren ifTrue: [^ nil].
	
	^ SBRelInsertCommand new
		near: aBlock before: aBoolean in: self morph: aMorph;
		yourself
]

{ #category : #'action helpers' }
SBBlock >> insertElement: aBeforeBoolean [

	| cmd |
	cmd := (self parentSandblock
		insertEmptyCommandRequestNear: self
		before: aBeforeBoolean) ifNil: [^ self].
	
	self sandblockEditor do: cmd.
	
	cmd shouldMergeWithNext ifTrue: [self sandblockEditor selection inputContainedUnknown].
	
	^ self sandblockEditor selection
]

{ #category : #actions }
SBBlock >> insertElementAfter [
	<action>
	<inputAction>
	<actionValidIf: #canInsertAfter>

	^ self insertElement: false
]

{ #category : #actions }
SBBlock >> insertElementBefore [
	<action>
	<inputAction>
	<actionValidIf: #canInsertBefore>

	^ self insertElement: true
]

{ #category : #'as yet unclassified' }
SBBlock >> insertEmptyCommandRequestNear: aBlock before: aBoolean [

	| child |
	child := self newEmptyChildNear: aBlock before: aBoolean.
	child ifNil: [^ nil].
	
	^ (self
		insertCommandRequest: child
		near: aBlock
		before: aBoolean) ifNotNil: [:cmd |
		cmd
			shouldMergeWithNext: true;
			yourself]
]

{ #category : #actions }
SBBlock >> insertStatementAbove [
	<action>
	<actionValidIf: #insertStatementHasCandidate>

	self insertStatementAboveOrBelow: true
]

{ #category : #'action helpers' }
SBBlock >> insertStatementAboveOrBelow: anAboveBoolean [

	| candidate |
	" default behavior is to find the first parent that can take multiple children "
	candidate := self.
	[candidate parentSandblock fixedNumberOfChildren and: [candidate isArtefact not]] whileTrue: [candidate := candidate parentSandblock].
	candidate isArtefact ifFalse: [candidate insertElement: anAboveBoolean]
]

{ #category : #actions }
SBBlock >> insertStatementBelow [
	<action>
	<actionValidIf: #insertStatementHasCandidate>

	self insertStatementAboveOrBelow: false
]

{ #category : #'action helpers' }
SBBlock >> insertStatementFindCandidate [

	| candidate |
	" default behavior is to find the first parent that can take multiple children "
	candidate := self.
	[candidate parentSandblock fixedNumberOfChildren and: [candidate isArtefact not]] whileTrue: [candidate := candidate parentSandblock].
	candidate isArtefact ifFalse: [^ candidate].
	^ nil
]

{ #category : #'as yet unclassified' }
SBBlock >> insertStatementHasCandidate [

	^ self insertStatementFindCandidate
		ifNotNil: [:c | (c parentSandblock insertEmptyCommandRequestNear: c before: false) notNil]
		ifNil: [false]
]

{ #category : #initialization }
SBBlock >> intoWorld: aWorld [

	super intoWorld: aWorld.
	self triggerEvent: #insert.	
	self updateSteppingDecorators
]

{ #category : #'dropping/grabbing' }
SBBlock >> invokeMetaMenu: anEvent [
	"self pickUp: anEvent"
	" We hijack this event because it's the only way to cleanly access ctrl+click "

	anEvent
		transformBy: (self transformFrom: nil);
		instVarNamed: #buttons
			put: ((anEvent buttons bitClear: MouseEvent anyButton) bitOr: MouseEvent redButton);
		instVarNamed: #whichButton
			put: ((anEvent whichButton bitClear: MouseEvent anyButton) bitOr: MouseEvent redButton).
	" for some reason, this event gets modified buttons assignments (yellow instead of red) "
	
	anEvent sentTo: self
]

{ #category : #testing }
SBBlock >> isArtefact [
	" we define an artefact in this context as a node that is in some way persisting information of its children such as a method or a class would "

	^ false
]

{ #category : #layout }
SBBlock >> isAttractedTo: aMorph [
	
	^ aMorph object class = self object class
]

{ #category : #testing }
SBBlock >> isBlockBody [

	^ false
]

{ #category : #testing }
SBBlock >> isClassContainer [

	^ false
]

{ #category : #testing }
SBBlock >> isDeclaration [

	^ false
]

{ #category : #'as yet unclassified' }
SBBlock >> isDragging [ 
	
	^ self withDecorator: SBMoveDecorator do: [:decorator | decorator isDragging] ifAbsent: [false]
]

{ #category : #testing }
SBBlock >> isEditor [

	^ false
]

{ #category : #testing }
SBBlock >> isExpression [

	^ false
]

{ #category : #'testing hierarchy' }
SBBlock >> isFirstChild [

	^ self parentSandblock childSandblocks first = self
]

{ #category : #'testing hierarchy' }
SBBlock >> isInEditor [

	| editor |
	editor := self sandblockEditor.
	^ editor notNil and: [editor isSelection not or: [editor parentSandblock ifNotNil: #isInEditor ifNil: [false]]]
]

{ #category : #'Sandblocks-TreeSitter' }
SBBlock >> isInlineBlock [

	^ false
]

{ #category : #'testing hierarchy' }
SBBlock >> isLastChild [

	^ self parentSandblock childSandblocks last = self
]

{ #category : #'testing hierarchy' }
SBBlock >> isLastDeepChild [

	^ self = self lastDeepChild
]

{ #category : #testing }
SBBlock >> isLiteralBlock [

	^ false
]

{ #category : #testing }
SBBlock >> isMethod [

	^ false
]

{ #category : #testing }
SBBlock >> isMethodBody [

	^ false
]

{ #category : #testing }
SBBlock >> isMultiSelected [

	^ self sandblockEditor ifNil: [false] ifNotNil: [:editor | editor multiSelection includes: self]
]

{ #category : #testing }
SBBlock >> isNumberBlock [

	^ false
]

{ #category : #testing }
SBBlock >> isSandblock [

	^ true
]

{ #category : #testing }
SBBlock >> isSelectable [

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
SBBlock >> isStatement [

	^ self owner isBlockBody
]

{ #category : #testing }
SBBlock >> isTopLevel [

	^ false
]

{ #category : #testing }
SBBlock >> isUnknown [

	^ false
]

{ #category : #'action helpers' }
SBBlock >> isValidAction: aPragmaOrMethod [

	| mode validInvocation validMode allPragmas method |
	allPragmas := #(#action #inputAction #multiSelectAction).
	
	aPragmaOrMethod isCompiledMethod
		ifTrue: [method := aPragmaOrMethod]
		ifFalse: [method := aPragmaOrMethod method].
	
	mode := self sandblockEditor mode.
	validMode := (mode = #input ifTrue: [allPragmas] ifFalse: [#(#action #multiSelectAction)]) anySatisfy: [:s | (method pragmaAt: s) notNil].
	validInvocation := (method pragmaAt: #actionValidIf:) ifNotNil: [:p | self perform: p arguments first] ifNil: [true].
	
	^ validMode and: [validInvocation]
]

{ #category : #'as yet unclassified' }
SBBlock >> isWaypoint [

	^ false
]

{ #category : #'event handling' }
SBBlock >> keyStroke: anEvent [

	self currentTextMorph ifNotNil: [:t |
		t keyStroke: anEvent.
		self batchedChangeStep]
]

{ #category : #hierarchy }
SBBlock >> lastDeepChild [

	| current |
	current := self.
	[current childSandblocks isEmpty] whileFalse: [current := current childSandblocks last].
	^ current
]

{ #category : #layout }
SBBlock >> layoutCommands [

	^ SBAlgebraCommand morph data: self
]

{ #category : #layout }
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

{ #category : #hierarchy }
SBBlock >> leftMostBlock [

	^ self childSandblocks ifEmpty: [self] ifNotEmpty: [:c | c first leftMostBlock]
]

{ #category : #actions }
SBBlock >> leftRotate [
	<action>
	<actionValidIf: #hasChildSandblocks>

	(self hasChildSandblocks not or: [self parentSandblock isNil]) ifTrue: [^ self].
	(self isFirstChild or: [self isLastChild]) ifFalse: [^ self].
	
	self sandblockEditor do: (SBSubtreeRotateCommand new
		target: self;
		yourself)
]

{ #category : #'colors and color policies' }
SBBlock >> localColorPolicy: aPolicy [

	self setProperty: #localColorPolicy toValue: aPolicy new;
			clearCache;
			changed
]

{ #category : #hierarchy }
SBBlock >> localNestingDepth [

	^ 1 + (self parentSandblock ifNotNil: [:p | p localNestingDepth] ifNil: [0])
]

{ #category : #'action helpers' }
SBBlock >> lookupAction: aSymbol [

	self actionProviders do: [:provider |
		((provider class lookupSelector: aSymbol)
			ifNotNil: [:m | self isValidAction: m]
			ifNil: [false]) ifTrue: [^ provider]].
	^ nil
]

{ #category : #'action helpers' }
SBBlock >> lookupGlobalAction: aSymbol [

	^ (self class lookupSelector: aSymbol) ifNotNil: [:m | ((m pragmaAt: #globalAction) notNil and: [(m pragmaAt: #actionValidIf:) ifNotNil: [:p | self perform: p arguments first] ifNil: [true]]) ifTrue: [m] ifFalse: [nil]]
]

{ #category : #'as yet unclassified' }
SBBlock >> maximumNonOverlappingForce [

	^ 10
]

{ #category : #layout }
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

{ #category : #accessing }
SBBlock >> morphicLayerNumber [

	^ 100
]

{ #category : #accessing }
SBBlock >> mouseCursorAt: anEvent [

	| cursor priority |
	" return your preferred cursor here "
	cursor := nil.
	priority := -1.
	self decorators do: [:decorator |
		(decorator mouseCursorAt: anEvent) ifNotNil: [:pair |
			pair second > priority ifTrue: [
				cursor := pair first.
				priority := pair second]]].
	^ cursor
]

{ #category : #'event handling' }
SBBlock >> mouseDown: anEvent [

	self eventHandler ifNotNil: [self eventHandler mouseDown: anEvent fromMorph: self].
	
	anEvent hand
		waitForClicksOrDrag: self
		event: anEvent
		selectors: #(#click: #doubleClick: #doubleClickTimeout: #startDrag:)
		threshold: 30
]

{ #category : #actions }
SBBlock >> moveCursorToEnd [
	<inputAction>
	<actionValidIf: #hasCurrentTextMorph>

	self currentTextMorph moveCursorTo: 9e8
]

{ #category : #actions }
SBBlock >> moveCursorToStart [
	<inputAction>
	<actionValidIf: #hasCurrentTextMorph>

	self currentTextMorph moveCursorTo: 1
]

{ #category : #actions }
SBBlock >> multiSelectChildren [
	<action>
	<actionValidIf: #hasChildSandblocks>

	self sandblockEditor multiSelection: self childSandblocks
]

{ #category : #'as yet unclassified' }
SBBlock >> newEmptyChildNear: aBlock before: aBoolean [

	^ self newNullBlock
]

{ #category : #'ast helpers' }
SBBlock >> newNullBlock [

	^ self grammarHandler ifNotNil: [:g | g newNullBlock] ifNil: [nil]
]

{ #category : #hierarchy }
SBBlock >> nextDeletableBlock [

	^ ((self parentSandblock ifNil: [^ nil]) deleteCommandFor: self)
		ifNotNil: [self]
		ifNil: [self parentSandblock nextDeletableBlock]
]

{ #category : #hierarchy }
SBBlock >> nextVerticalNear: aNumber [

	^ self
		nextVerticalNear: aNumber
		calcDistance: [:candidate | candidate top - self bottom]
		validBlock: [:candidate | candidate top >= self bottom]
]

{ #category : #hierarchy }
SBBlock >> nextVerticalNear: aNumber calcDistance: aDistBlock validBlock: aValidBlock [

	| allCandidates candidates candidatesBestDistance tolerance artefact |
	artefact := self containingFloat.
	tolerance := 10.
	
	allCandidates := Array streamContents: [:stream | artefact allMorphsDo: [:candidate | ((candidate isTextMorph or: [candidate isSandblock and: [candidate hasChildSandblocks not]]) and: [aValidBlock value: candidate]) ifTrue: [stream nextPut: candidate]]].
	
	candidates := OrderedCollection new.
	candidatesBestDistance := 900000000.
	allCandidates do: [:candidate | | distance |
		distance := aDistBlock value: candidate.
		distance < candidatesBestDistance
			ifTrue: [
				(candidatesBestDistance between: distance and: distance + tolerance)
					ifTrue: [candidates add: candidate]
					ifFalse: [candidates := OrderedCollection with: candidate].
				candidatesBestDistance := distance]
			ifFalse: [(distance between: candidatesBestDistance and: candidatesBestDistance + tolerance) ifTrue: [candidates add: candidate]]].
	
	^ (candidates detectMin: [:candidate | (candidate left - artefact left to: candidate right - artefact left) distanceTo: aNumber]) ifNotNil: #containingSandblock
]

{ #category : #callbacks }
SBBlock >> noteNewOwner: aMorph [

	super noteNewOwner: aMorph.
	self decorators do: [:decorator |
		decorator noteNewOwner: aMorph.
		
		].
	self clearCache.
	" recheck name blocks "
	self allBlocksDo: [:block | block isName ifTrue: [block noteNewOwner: block owner]]
]

{ #category : #'object interface' }
SBBlock >> object [

	"Should be self subclassResponsibility but often causes non-recoverable errors with drag and drop"
	^ self
]

{ #category : #'object interface' }
SBBlock >> objectInterface [

	^ self parentSandblock objectInterfaceNear: self at: #replace
]

{ #category : #'object interface' }
SBBlock >> objectInterfaceNear: aBlock at: aSymbol [

	^ SBInterfaces never
]

{ #category : #hierarchy }
SBBlock >> open [
	" tries to find the current SBEditor and open our block in it "

	SBExecutionEnvironment value sandblockEditor
		ifNotNil: [:editor | editor openMorphInView: self]
		ifNil: [self error: 'No editor found in execution context']
]

{ #category : #actions }
SBBlock >> openLocalPalette [
	<action>
	<actionValidIf: #hasCommandPalette>

	| palettes |
	self sandblockEditor isSingleArtefactView ifTrue: [
		^ self sandblockEditor togglePalette].

	palettes := SBPalette allSubclasses select: [:palette | (self satisfies: palette context) and: [palette matchesBlock: self]].
	palettes ifNotEmpty: [ | container |
		container := SBPaletteContainer new.
		palettes do: [:class | class buildOn: container].
		self sandblockEditor openMorphInView: container]
]

{ #category : #initialization }
SBBlock >> outOfWorld: aWorld [

	super outOfWorld: aWorld.
	
	self removeSuggestionMenu.
	self triggerEvent: #outOfWorld
]

{ #category : #'as yet unclassified' }
SBBlock >> outerArtefact [

	| a |
	a := self containingArtefact.
	^ a = self ifTrue: [self parentSandblock ifNotNil: #containingArtefact] ifFalse: [a]
]

{ #category : #layout }
SBBlock >> outerBounds [

	^ super outerBounds expandBy: self frameSize
]

{ #category : #'as yet unclassified' }
SBBlock >> outerMostArtefact [

	| a |
	a := self containingArtefact.
	a ownerChain do: [:morph | (morph isSandblock and: [morph isArtefact]) ifTrue: [a := morph]].
	^ a
]

{ #category : #hierarchy }
SBBlock >> ownerWithColor [

	^ self
]

{ #category : #accessing }
SBBlock >> palettes [

	" return SBPalette subclasses you'd like to have displayed here "
	^ #()
]

{ #category : #hierarchy }
SBBlock >> parentAdjacentBlock: aNumber [

	^ (self adjacentBlock: aNumber)
		ifNil: [self parentSandblock ifNotNil: [:p | p parentAdjacentBlock: aNumber]]
]

{ #category : #'testing hierarchy' }
SBBlock >> parentHasDynamicNumberOfChildren [

	^ self parentSandblock fixedNumberOfChildren not
]

{ #category : #actions }
SBBlock >> pasteAfter [
	<action>

	self pasteBeforeOrAfter: false
]

{ #category : #actions }
SBBlock >> pasteBefore [
	<action>

	self pasteBeforeOrAfter: true
]

{ #category : #'action helpers' }
SBBlock >> pasteBeforeOrAfter: aBeforeBoolean [

	self sandblockEditor
		copyBufferForContext: (self parentSandblock
			objectInterfaceNear: self
			at: (aBeforeBoolean ifTrue: [#before] ifFalse: [#after]))
		reversed: true
		do: [:repr :index :isLast | self sandblockEditor do: ((self parentSandblock insertCommandRequest: repr near: self before: aBeforeBoolean) shouldMergeWithNext: isLast not)]
		ifWrappingDo: [:block | self wrapSelectionWith: block unpackSelection veryDeepCopy]
]

{ #category : #actions }
SBBlock >> pasteReplace [
	<action>

	| position editor |
	editor := self sandblockEditor.
	position := editor cursor cursorPosition.
	editor
		copyBufferForContext: ((position isKindOf: SBCursorInsert)
			ifTrue: [position objectInterface]
			ifFalse: [self objectInterface])
		reversed: ((position isKindOf: SBCursorInsert) and: [position adjacent notNil])
		do: [:block :index :isLast |
			(position isKindOf: SBCursorInsert)
				ifTrue: [
					editor do: ((position container
						insertCommandRequest: block
						near: position adjacent
						before: position before) shouldMergeWithNext: isLast not)]
				ifFalse: [
					index = 1 ifTrue: [
						editor do: (SBReplaceCommand new
							target: self;
							replacer: block)]]]
		ifWrappingDo: [:block | self wrapSelectionWith: block]
]

{ #category : #'action helpers' }
SBBlock >> performAction: aSymbol [

	(self lookupAction: aSymbol) ifNotNil: [:obj |
		(obj ~= self and: [obj respondsTo: #block:]) ifTrue: [obj block: self].
		obj perform: aSymbol.
		^ true].
	^ false
	"self actionProviders do: [:obj |
		(obj class lookupSelector: aSymbol) ifNotNil: [:m |
			(self isValidAction: m) ifTrue: [
				obj ~= self ifTrue: [obj block: self].
				^ obj perform: aSymbol]]]"
]

{ #category : #'dropping/grabbing' }
SBBlock >> pickUp: anEvent [

	| editor s |
	self canDrag ifFalse: [^ self].
	
	editor := self sandblockEditor.
	s := SBSelection new
		homeArtefact: self containingArtefact;
		methodClass: (self containingArtefact ifNotNil: #relatedClass);
		colorPolicy: self colorPolicy;
		sourceBlock: self;
		onAbortUndoIn: editor;
		yourself.
	
	self containingBlock ifNotNil: [:b | (b sandblockBlockColorIfAbsent: [nil]) ifNotNil: [:c | s color: c]].
	
	s addMorphBack: self dragTarget.
	anEvent hand grabMorph: s.
	
	(anEvent shiftPressed not and: [self copyOnDrag not]) ifTrue: [
		(self parentSandblock deleteCommandFor: self) ifNotNil: [:cmd |
			editor do: (cmd
				shouldMergeWithNext: true;
				selectAfter: #none;
				yourself)]]
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

{ #category : #caching }
SBBlock >> postDuplicate [

	self allBlocksDo: [:morph | morph postDuplicateSelf].
	self detachDecorators: SBMultiSelectionDecorator.
	self clearCache
]

{ #category : #caching }
SBBlock >> postDuplicateSelf [

	" this block has been duplicated, adjust any identifiers if need be "
	
]

{ #category : #accessing }
SBBlock >> precedence [
	" some edit systems may support automatic reshuffling based on operator precedence. override this selector to return the specific precedence "

	^ 0
]

{ #category : #'colors and color policies' }
SBBlock >> preferredColor [

	^ nil
]

{ #category : #'colors and color policies' }
SBBlock >> preferredColorIn: aColorPolicy [

	^ aColorPolicy default
]

{ #category : #'colors and color policies' }
SBBlock >> prefersNoBorder [

	^ false
]

{ #category : #actions }
SBBlock >> prependElement [
	<action>

	| cmd |
	cmd := (self
		insertEmptyCommandRequestNear: (self childSandblocks ifNotEmpty: #first ifEmpty: [nil])
		before: true) ifNil: [^ self].
	
	self sandblockEditor do: cmd.
	
	cmd shouldMergeWithNext ifTrue: [
		self sandblockEditor
			startInput: self sandblockEditor selection
			at: 0
			replacingContents: false]
]

{ #category : #testing }
SBBlock >> preventOcclusion [

	^ true
]

{ #category : #hierarchy }
SBBlock >> previousVerticalNear: aNumber [

	^ self
		nextVerticalNear: aNumber
		calcDistance: [:candidate | self top - candidate bottom]
		validBlock: [:candidate | self top >= candidate bottom]
]

{ #category : #'as yet unclassified' }
SBBlock >> printIdentityStringOn: aStream [

	aStream
		nextPutAll: self className;
		print: self identityHash
]

{ #category : #saving }
SBBlock >> printSaveStringPreambleOn: aStream [

	self printIdentityStringOn: aStream.
	aStream nextPutAll: ' := '
]

{ #category : #initialization }
SBBlock >> privateOwner: aMorph [

	super privateOwner: aMorph.
	aMorph ifNil: [self triggerEvent: #delete]
]

{ #category : #actions }
SBBlock >> promptAction [
	<multiSelectAction>
	<inputAction>

	| options index |
	options := self validActions.
	index := UIManager default chooseFrom: (options collect: [:option |
		option method selector, (' ', (SBEditor shortcutStringForAction: option selector))]).
	index > 0 ifTrue: [self performAction: (options at: index) method selector]
]

{ #category : #'ast helpers' }
SBBlock >> proposeCodeActions: aCollection for: aBlock [

	| index |
	index := UIManager default chooseFrom: (aCollection collect: #label).
	index > 0 ifTrue: [(aCollection at: index) do]
]

{ #category : #testing }
SBBlock >> providesExecutionEnvironment [

	^ false
]

{ #category : #actions }
SBBlock >> refocus [
	<multiSelectAction>

	self ensureVisible
]

{ #category : #'artefact protocol' }
SBBlock >> relatedClass [

	^ self object class
]

{ #category : #actions }
SBBlock >> reloadArtefact [
	<action>

	
	self isArtefact ifFalse: [self containingArtefact ifNotNil: #reloadArtefact]
]

{ #category : #'colors and color policies' }
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

{ #category : #'as yet unclassified' }
SBBlock >> repelStrengthTo: aMorph [

	| distance |
	distance := (self bounds vectorToRectangle: aMorph bounds) r.
	^ distance > self class maxRepelDistance ifTrue: [0] ifFalse: [
		(distance closeTo: 0)
			ifTrue: [self class maximumNonOverlappingForce + ((self bounds intersect: aMorph bounds) area sqrt / 10)]
			ifFalse: [self class defaultRepelStrength / distance / distance min: self class maximumNonOverlappingForce]]
]

{ #category : #hierarchy }
SBBlock >> rightMostBlock [

	^ self childSandblocks ifEmpty: [self] ifNotEmpty: [:c | c last rightMostBlock]
]

{ #category : #'colors and color policies' }
SBBlock >> sandblockBlockColorIfAbsent: aBlock [

	^ self valueOfProperty: #sandblockBlockColor ifAbsent: aBlock
]

{ #category : #'colors and color policies' }
SBBlock >> sandblockBlockColorIfAbsentPut: aBlock [

	^ self sandblockBlockColorIfAbsent: [ | newColor |
		newColor := aBlock value.
		self setProperty: #sandblockBlockColor toValue: newColor. newColor]
]

{ #category : #'colors and color policies' }
SBBlock >> sandblockForegroundColor [

	^ self foregroundColor
]

{ #category : #'artefact protocol' }
SBBlock >> save [

	(self saveTryFixing: false quick: false) ifFalse: [self error: 'failed to save block']
]

{ #category : #saving }
SBBlock >> saveString [

	^ String streamContents: [:stream |
		self printSaveStringPreambleOn: stream.
		stream
			nextPutAll: self className;
			nextPutAll: ' new position: ';
			nextPutAll: self position asString.
		self childSandblocks do: [:each |
			stream
				nextPutAll: ';';
				cr;
				nextPutAll: 'addMorphBack: (';
				nextPutAll: each saveString;
				nextPutAll: ')']]
]

{ #category : #'artefact protocol' }
SBBlock >> saveTryFixing: aFixBoolean quick: aQuickBoolean [
	" only needed if this block is an artefact "

	^ self subclassResponsibility
]

{ #category : #actions }
SBBlock >> screenshot [
	<action>

	| name path |
	
	name := self name, '.png'.
	path := FileDirectory default fullName, '/', name.
	self imageForm writePNGfileNamed: name.
	Smalltalk
		at: #ExternalWebBrowser
		ifPresent: [:e | e openOnUrl: 'file://', path]
		ifAbsent: [self inform: 'Saved under ', path]
]

{ #category : #actions }
SBBlock >> select [
	<action>

	self sandblockEditor select: self
]

{ #category : #actions }
SBBlock >> selectAdjacent [
	<action>

	self sandblockEditor multiSelection: self parentSandblock childSandblocks
]

{ #category : #actions }
SBBlock >> selectAdjacentAfter [
	<action>

	self sandblockEditor multiSelection: (self parentSandblock childSandblocks allButFirst: self childIndex - 1)
]

{ #category : #actions }
SBBlock >> selectAdjacentBefore [
	<action>

	self sandblockEditor multiSelection: (self parentSandblock childSandblocks first: self childIndex)
]

{ #category : #actions }
SBBlock >> selectArtefact [
	<multiSelectAction>
	<inputAction>

	(self containingArtefact = self
		ifTrue: [self parentSandblock containingArtefact]
		ifFalse: [self containingArtefact])
		ifNotNil: #select
		ifNil: [self containingFloat ifNotNil: #select]
]

{ #category : #actions }
SBBlock >> selectBottomToplevel [
	<multiSelectAction>
	
	self selectToplevelTowards: #bottom
]

{ #category : #actions }
SBBlock >> selectLast [
	<multiSelectAction>
	<inputAction>

	self containingFloat lastDeepChild
		select;
		startInputAtEnd
]

{ #category : #actions }
SBBlock >> selectLeftToplevel [
	<multiSelectAction>
	
	self selectToplevelTowards: #left
]

{ #category : #actions }
SBBlock >> selectRightMostBlock [
	<multiSelectAction>
	<inputAction>

	self containingStatement ifNil: [self rightMostBlock select] ifNotNil: [:statement |
		statement rightMostBlock
			select;
			startInputAtEnd]
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

{ #category : #'action helpers' }
SBBlock >> selectToplevelTowards: aSideSymbol [

	| opposite |
	self sandblockEditor = self containingToplevel ifTrue: [^ self].
	
	opposite := aSideSymbol caseOf: {
		[#left] -> [#right].
		[#right] -> [#left].
		[#top] -> [#bottom].
		[#bottom] -> [#top]}.
	(self containingToplevel
		closestAdjacentFrom: (aSideSymbol, 'Center') asSymbol
		to: (opposite, 'Center') asSymbol) select
]

{ #category : #printing }
SBBlock >> selectionLabel [

	^ self printString
]

{ #category : #'actions tests' }
SBBlock >> shouldAutocomplete [

	^ self hasSuggestions and: [self suggestionsMenu activeSuggestion wouldChange: self]
]

{ #category : #'as yet unclassified' }
SBBlock >> shownColor [

	| ref col |
	ref := self.
	[(col := ref drawnColor) alpha < 0.7 and: [ref parentSandblock notNil]] whileTrue: [ref := ref parentSandblock].
	^ col
]

{ #category : #testing }
SBBlock >> skipLeftRightNavigation [

	^ false
]

{ #category : #actions }
SBBlock >> slurp [
	<action>
	<actionValidIf: #dynamicNumberOfChildren>

	(self adjacentBlock: 1) ifNotNil: [:block | 
		self sandblockEditor do: (self insertCommandRequest: block near: self childSandblocks last before: false).
		self select]
]

{ #category : #actions }
SBBlock >> slurpFront [
	<action>
	<actionValidIf: #dynamicNumberOfChildren>

	(self adjacentBlock: -1) ifNotNil: [:block | 
		self sandblockEditor do: (self insertCommandRequest: block near: self childSandblocks last before: true).
		self select]
]

{ #category : #'ast helpers' }
SBBlock >> sourceString [

	^ String streamContents: [:s | self writeSourceOn: s]
]

{ #category : #layout }
SBBlock >> spaceForSymbols [

	| symbols |
	symbols := self symbols.
	^ {
		(symbols first ifNil: [0] ifNotNil: [self fontToUse widthOfString: symbols first]).
		(symbols second ifNil: [0] ifNotNil: [self fontToUse widthOfString: symbols second])
	}
]

{ #category : #'dropping/grabbing' }
SBBlock >> specialDropCommand: aBlock [

	^ nil
]

{ #category : #'event handling' }
SBBlock >> startDrag: anEvent [

	(SBToggledCode
		comment: 'if the preference is on, we absorb the startDrag events'
		active: 1
		do: {[anEvent yellowButtonPressed and: [SBPreferences rightClickContextMenu]]}) ifTrue: [ | canvas |
		canvas := self sandblockEditor canvas scroller.
		anEvent hand newMouseFocus: canvas.
		^ canvas startDrag: (anEvent transformBy: self transformFromWorld asMatrixTransform2x3 inverseTransformation)].
	
	((self hasDecorator: SBMoveDecorator) not or: [anEvent controlKeyPressed or: [anEvent commandKeyPressed]]) ifTrue: [
		"(self nearestOwnerThat: [:o | o isSandblock and: [o isSelected]]) ifNotNil: [:o | ^ o pickUp: anEvent]."
		^ self
			select;
			pickUp: anEvent].
	
	super startDrag: anEvent.
	self sandblockEditor select: self
]

{ #category : #'as yet unclassified' }
SBBlock >> startInput [

	(self startInputCommand
		ifNotNil: [self]
		ifNil: [self nextBlockThat: [:m | m startInputCommand notNil]]) ifNotNil: [:m | ((m hasOwner: self) or: [m = self]) ifTrue: [self sandblockEditor startInput: m at: 1 replacingContents: false]]
]

{ #category : #input }
SBBlock >> startInputAt: aNumber replacingContents: aBoolean [

	self currentTextMorph ifNotNil: [ | cmd |
		cmd := SBInputCommand new
			oldMorph: self;
			previousText: self contents;
			yourself.
		aBoolean
			ifTrue: [
				self currentTextMorph
					contents: '';
					moveCursorTo: 0]
			ifFalse: [self currentTextMorph moveCursorTo: aNumber].
		^ cmd].
	
	^ nil
]

{ #category : #actions }
SBBlock >> startInputAtEnd [
	<action>

	(self startInputCommand
		ifNotNil: [self]
		ifNil: [self lastMorphThat: [:b | b isSandblock and: [b startInputCommand notNil]]])
		ifNotNil: [:b | self sandblockEditor startInput: b at: 900000000 replacingContents: false]
		ifNil: [
			self lastDeepChild select.
			" try and move into an insert position "
			self sandblockEditor performForSelection: #moveCursorSmaller]
]

{ #category : #actions }
SBBlock >> startInputAtStart [
	<action>

	self sandblockEditor startInput: self at: 1 replacingContents: false
]

{ #category : #input }
SBBlock >> startInputCommand [

	^ self currentTextMorph
		ifNotNil: [
			SBInputCommand new
				oldMorph: self;
				previousText: self contents;
				yourself]
]

{ #category : #actions }
SBBlock >> startInputSubstituting [
	<action>

	self sandblockEditor startInput: self at: 1 replacingContents: true
]

{ #category : #'as yet unclassified' }
SBBlock >> startNextInput [

	((self wantsInput ifTrue: [self] ifFalse: [self nextBlockThat: [:m | m wantsInput]]) ifNil: [
		self startInputCommand
			ifNotNil: [self]
			ifNil: [self nextBlockThat: [:m | m startInputCommand notNil]]]) ifNotNil: [:m | ((m hasOwner: self) or: [m = self]) ifTrue: [self sandblockEditor startInput: m at: 900000000 replacingContents: false]]
]

{ #category : #actions }
SBBlock >> startOrAddToMultiSelection [
	<multiSelectAction>

	self sandblockEditor cursor startOrAddToMultiSelection: self
]

{ #category : #input }
SBBlock >> stopEditing [
]

{ #category : #input }
SBBlock >> stopEditing: aCommand [

	aCommand
		newText: self contents;
		newMorph: self.
	
	self currentTextMorph stopEditing.
	self removeSuggestionMenu
]

{ #category : #hierarchy }
SBBlock >> submorphIndex [

	^ self owner submorphs indexOf: self
]

{ #category : #accessing }
SBBlock >> suggestAlways [

	^ self sandblockEditor suggestAlways
]

{ #category : #suggestions }
SBBlock >> suggestionMenuDo: aBlock [

	^ self valueOfProperty: #sandblockSuggestionMenu ifPresentDo: aBlock
]

{ #category : #suggestions }
SBBlock >> suggestionsMenu [

	^ self valueOfProperty: #sandblockSuggestionMenu ifAbsentPut: [SBSuggestionMenu new]
]

{ #category : #'action helpers' }
SBBlock >> swap: aNumber [

	| next children offset canSwap |
	SBExample
		self: ['3 + 4' parseInMethod receiver]
		args: [{1}]
		label: 'example'
		assert: [[:o | o parentSandblock receiver contents = '4']].
	children := self parentSandblock childSandblocks.
	offset := aNumber.
	
	canSwap := [:a :b | (a satisfies: b objectInterface) and: [b satisfies: a objectInterface]].
	[offset abs <= children size and: [(canSwap value: self value: (next := children atWrap: (children indexOf: self) + offset)) not]] whileTrue: [offset := offset + aNumber].
	offset = children size ifTrue: [^ self].
	
	self sandblockEditor do: (SBSwapCommand new
		a: self;
		b: next)
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

{ #category : #'colors and color policies' }
SBBlock >> symbols [

	^ #(nil nil)
]

{ #category : #accessing }
SBBlock >> textContents [

	^ self currentTextMorph ifNotNil: [:t | t contents] ifNil: ['']
]

{ #category : #accessing }
SBBlock >> textContentsForCopy [

	^ self grammarHandler
		ifNotNil: [:g | g block: self; textContentsForCopy]
		ifNil: [self textContents]
]

{ #category : #actions }
SBBlock >> toggleCollapsed [
	<action>

	self isArtefact ifFalse: [
		self containingArtefact ifNotNil: #toggleCollapsed]
]

{ #category : #decorators }
SBBlock >> toggleDecorator: aDecorator [

	^ decorators
		detect: [:d | d class = aDecorator class]
		ifFound: [:d | self detachDecorator: d]
		ifNone: [self attachDecorator: aDecorator]
]

{ #category : #suggestions }
SBBlock >> toggleSuggestions [

	self suggestionsMenu isInWorld
		ifTrue: [self removeSuggestionMenu]
		ifFalse: [(self respondsTo: #updateSuggestions) ifTrue: [self updateSuggestions]].
]

{ #category : #'ast helpers' }
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

{ #category : #decorators }
SBBlock >> updateSteppingDecorators [

	self decorators do: [:d | d stepTime >= 0 ifTrue: [self world ifNotNil: [:w | (w isStepping: d) ifFalse: [w startStepping: d at: Time millisecondClockValue selector: #step arguments: {} stepTime: d stepTime]]]]
]

{ #category : #suggestions }
SBBlock >> updateSuggestions: aCollection showNear: aMorph [

	(aCollection isEmpty or: [self hasInput not]) ifTrue: [^ self removeSuggestionMenu].
	
	self sandblockEditor ifNil: [^ self].
	
	self suggestionsMenu
		editor: self sandblockEditor;
		suggestions: (aCollection take: 30);
		topLeft: aMorph position + (0 @ aMorph height).
	
	self sandblockEditor openMorph: self suggestionsMenu.
	self suggestionsMenu resize
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
	" try to apply a suggestion, return whether anything was applied "
	<inputAction>
	<actionValidIf: #hasSuggestions>

	self suggestionMenuDo: [:menu | | editor |
		editor := self sandblockEditor.
		menu activeSuggestion ifNotNil: [:s |
			(s wouldChange: self)
				ifTrue: [
					s useSuggestionOn: self.
					editor selection startInputAtEnd]
				ifFalse: [self inputNextUnknown]].
		self removeSuggestionMenu.
		^ true].
	^ false
]

{ #category : #testing }
SBBlock >> valid [

	^ true
]

{ #category : #'action helpers' }
SBBlock >> validActions [

	| mode |
	mode := self sandblockEditor mode.
	^ self actions select: [:action | self isValidAction: action]
]

{ #category : #testing }
SBBlock >> validSubtree [

	self allBlocksDo: [:b | b valid ifFalse: [^ false]].
	^ true
]

{ #category : #copying }
SBBlock >> veryDeepCopyWith: aCopier [

	| new previousDecorators m oldActions |
	m := self valueOfProperty: #sandblockSuggestionMenu.
	self removeProperty: #sandblockSuggestionMenu.
	oldActions := self valueOfProperty: #actionMap.
	self removeProperty: #actionMap.
	new := super veryDeepCopyWith: aCopier.
	m ifNotNil: [self setProperty: #sandblockSuggestionMenu toValue: m].
	
	self setProperty: #actionMap toValue: oldActions.
	previousDecorators := new decorators copy.
	previousDecorators do: #detach.
	previousDecorators do: [:decorator | new attachDecorator: decorator].
	^ new
]

{ #category : #'colors and color policies' }
SBBlock >> wantsExtraSpace [

	^ true
]

{ #category : #testing }
SBBlock >> wantsInput [

	^ false
]

{ #category : #'artefact protocol' }
SBBlock >> wantsInteractiveErrorCorrection [

	^ false
]

{ #category : #'as yet unclassified' }
SBBlock >> wantsMethodBody [

	^ self isArtefact
]

{ #category : #callbacks }
SBBlock >> wasDeselected [

	" may be overriden "
]

{ #category : #callbacks }
SBBlock >> wasSelected [

	" may be overriden "
	self triggerEvent: #selected
]

{ #category : #decorators }
SBBlock >> withDecorator: aClass do: aBlock [

	^ self withDecorator: aClass do: aBlock ifAbsent: []
]

{ #category : #decorators }
SBBlock >> withDecorator: aClass do: aBlock ifAbsent: anotherBlock [

	^ decorators detect: [:d | d isKindOf: aClass] ifFound: aBlock ifNone: anotherBlock
]

{ #category : #utilities }
SBBlock >> wrapEditor [
	" provide an editor around the object, for use during testing "
	
	SBTest editorFor: self.
	^ self
]

{ #category : #'action helpers' }
SBBlock >> wrapSelectionWith: aSelection [

	SBToggledCode
		comment: 'TODO: this is not quite correct yet'
		active: 1
		do: {[(aSelection unpackSelection satisfies: self objectInterface) ifFalse: [^ self]]}.
	
	self sandblockEditor doMultiSelection: [:selected |
		SBRecordedCommand new record: [:recorder | | new placeholder |
			new := aSelection.
			placeholder := new copyPlaceholder.
			recorder replace: selected first with: new.
			recorder replace: placeholder with: selected first.
			recorder moveAll: selected allButFirst after: selected first]].
	
	self parentSandblock postDuplicate
]

{ #category : #'insert/delete' }
SBBlock >> wrapsAround [

	^ self copyPlaceholder notNil
]
