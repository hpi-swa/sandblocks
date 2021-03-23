Class {
	#name : #SBStSignature,
	#superclass : #Morph,
	#category : #'Sandblocks-Smalltalk'
}

{ #category : #'as yet unclassified' }
SBStSignature >> addArgumentAndEditAfter: aMorph focusKeyword: aTextMorph [

	| new |
	new := self containingSandblock newNullBlock.
	self addMorph: new after: aMorph.
	
	aTextMorph
		ifNil: [
			self containingSandblock sandblockEditor
				endInput;
				startInput: new at: 0 replacingContents: false]
		ifNotNil: [
			self moveFocusToPart: aTextMorph]
]

{ #category : #'as yet unclassified' }
SBStSignature >> addedMorph: aMorph [

	self messageParts do: #layoutChanged
]

{ #category : #'as yet unclassified' }
SBStSignature >> arguments [

	^ Array streamContents: [:s | 2 to: self submorphCount by: 2 do: [:i | s nextPut: (self submorphs at: i)]]
]

{ #category : #'as yet unclassified' }
SBStSignature >> argumentsDo: aBlock [

	2 to: self submorphCount by: 2 do: [:i | aBlock value: (self submorphs at: i)]
]

{ #category : #'as yet unclassified' }
SBStSignature >> cellGap [

	^ self containingSandblock colorPolicy messageCellGap
]

{ #category : #'as yet unclassified' }
SBStSignature >> color [

	^ self owner color
]

{ #category : #'as yet unclassified' }
SBStSignature >> deleteCommandFor: aBlock [

	| index |
	(self isUnary or: [self isBinary]) ifTrue: [
		^ (SBReplaceCommand newFor: aBlock containingArtefact)
			target: aBlock;
			replacer: self containingSandblock newNullBlock].
	
	(self isKeyword and: self submorphCount = 2) ifTrue: [
		^ aBlock submorphIndex = 1 ifTrue: [nil] ifFalse: [
			(SBDeleteCommand newFor: aBlock containingArtefact) target: aBlock]].
	
	index := ((((self submorphs indexOf: aBlock) - 1) / 2) floor * 2) + 1.
	^ SBCombinedCommand newWith: {
		((SBDeleteCommand newFor: aBlock containingArtefact) target: (self submorphs at: index)).
		((SBDeleteCommand newFor: aBlock containingArtefact) target: (self submorphs at: index + 1))
	}
]

{ #category : #'as yet unclassified' }
SBStSignature >> extractKeywords: aString [

	| parts |
	parts := aString splitBy: ':'.
	parts size = 1 ifTrue: [^ parts].
	
	^ parts allButLast collect: [:p | p, ':']
]

{ #category : #'as yet unclassified' }
SBStSignature >> initialize [

	super initialize.
	
	self
		color: Color transparent;
		layoutPolicy: SBAlgebraLayout new;
		hResizing: #shrinkWrap;
		vResizing: #shrinkWrap
]

{ #category : #'as yet unclassified' }
SBStSignature >> insertCommandRequest: anAfterBoolean near: aBlock [

	| part index insertArg insertPart |
	self isBinary ifTrue: [^ nil].
	self isUnary ifTrue: [
		^ (SBInsertCommand newFor: self containingSandblock containingArtefact)
			container: self;
			index: self submorphCount + 1;
			morph: self containingSandblock newNullBlock;
			shouldMergeWithNext: true;
			yourself].
	
	index := aBlock owner = self
		ifTrue: [
			anAfterBoolean ifTrue: [aBlock submorphIndex + 1] ifFalse: [aBlock submorphIndex]]
		ifFalse: [1].
	part := SBStMessagePart new contents: ':'.
	
	insertPart := (SBInsertCommand newFor: self containingSandblock containingArtefact)
		container: self;
		index: index;
		morph: part;
		shouldMergeWithNext: true;
		yourself.
	insertArg := (SBInsertCommand newFor: self containingSandblock containingArtefact)
		container: self;
		index: index;
		morph: self containingSandblock newNullBlock;
		yourself.
	^ SBCombinedCommand newWith: (index odd ifTrue: [{insertArg. insertPart}] ifFalse: [{insertPart. insertArg}])
]

{ #category : #'as yet unclassified' }
SBStSignature >> isBinary [

	^ self selector ifNotEmpty: [:s | s allSatisfy: #isSpecial] ifEmpty: [false]
]

{ #category : #'as yet unclassified' }
SBStSignature >> isCascade [

	^ false
]

{ #category : #'as yet unclassified' }
SBStSignature >> isKeyword [

	^ self selector asSymbol isKeyword
]

{ #category : #'as yet unclassified' }
SBStSignature >> isUnary [

	^ self selector isEmpty or: [self selector asSymbol isUnary]
]

{ #category : #'as yet unclassified' }
SBStSignature >> layoutCommands [

	^ SBAlgebraCommand container
		morph: self;
		data: (self isUnary
			ifTrue: [{self firstSubmorph layoutCommands}]
			ifFalse: [
				(Array new: self submorphCount streamContents: [:stream |
					self submorphs pairsDo: [:messagePart :argument |
						stream nextPut: (SBAlgebraCommand indent data: {messagePart layoutCommands. SBAlgebraCommand softLineOrGap. argument layoutCommands}).
						argument ~= self lastSubmorph ifTrue: [stream nextPut: SBAlgebraCommand softLineOrGap]]])])
]

{ #category : #'as yet unclassified' }
SBStSignature >> messageParts [

	^ Array streamContents: [:s | 1 to: self submorphCount  by: 2 do: [:i | s nextPut: (self submorphs at: i)]]
]

{ #category : #'as yet unclassified' }
SBStSignature >> minExtent [
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

{ #category : #'as yet unclassified' }
SBStSignature >> numArguments [

	self selector ifEmpty: [^ 1].
	self selector last = $: ifTrue: [^ (self extractKeywords: self selector) size].
	self selector first isSpecial ifTrue: [^ 1].
	^ 0
]

{ #category : #'as yet unclassified' }
SBStSignature >> numArguments: aString [

	aString ifEmpty: [^ 1].
	aString last = $: ifTrue: [^ (self extractKeywords: aString) size].
	aString first isSpecial ifTrue: [^ 1].
	^ 0
]

{ #category : #'as yet unclassified' }
SBStSignature >> objectInterfaceAt: aNumber adding: aBoolean argumentInterface: anInterfaceCollection [

	aBoolean ifTrue: [^ SBInterfaces never].
	
	aNumber odd
		ifTrue: [^ SBInterfaces stMessagePart]
		ifFalse: [^ anInterfaceCollection]
]

{ #category : #'as yet unclassified' }
SBStSignature >> possibleArgumentNamesFor: aString [

	(self systemNavigation allImplementorsOf: aString asSymbol) do: [:impl | ^ impl compiledMethod asSandblock arguments collect: #contents].
	^ #()
]

{ #category : #'as yet unclassified' }
SBStSignature >> removedMorph: aMorph [

	self messageParts do: #layoutChanged
]

{ #category : #'as yet unclassified' }
SBStSignature >> selector [

	^ String streamContents: [:stream |
		self submorphs
			withIndexDo: [:m :i | i odd ifTrue: [stream nextPutAll: m contents]]]
]

{ #category : #'as yet unclassified' }
SBStSignature >> selector: aString [

	| currentNum newNum arguments |
	currentNum := self numArguments: aString.
	newNum := aString numArgs.
	
	arguments := (self arguments copyFrom: 1 to: (newNum min: currentNum)), (Array streamContents: [:s |
		currentNum + 1 to: newNum do: [:i | s nextPut: self containingSandblock newNullBlock]]).
	
	self selector: aString arguments: arguments
]

{ #category : #'as yet unclassified' }
SBStSignature >> selector: aString arguments: aCollection [

	| messageParts |
	messageParts := self messageParts.
	(self extractKeywords: aString) withIndexDo: [:keyword :index |
		messageParts
			at: index
			ifPresent: [:p |
				p contents ~= keyword ifTrue: [p replaceBy: (self textMorphFor: keyword)]]
			ifAbsent: [
				self addMorph: (self textMorphFor: keyword) asElementNumber: (index * 2) - 1].
		((keyword endsWith: ':') or: [
			keyword isEmpty or: [keyword allSatisfy: #isSpecial]]) ifTrue: [
			self arguments
				at: index
				ifPresent: [:a | a replaceBy: (aCollection at: index)]
				ifAbsent: [
					aCollection at: index ifPresent: [:arg |
						self addMorph: arg asElementNumber: index * 2] ifAbsent: [self assert: aString isEmpty]]]].
	[
		self submorphs size > (aCollection size * 2 max: 1)] whileTrue: [self lastSubmorph delete]
]

{ #category : #'as yet unclassified' }
SBStSignature >> selectorAndEdit: aString [

	| current possibleArgumentNames |
	current := self containingSandblock sandblockEditor currentInputCommand.
	current oldMorph contents: current previousText.
	self containingSandblock sandblockEditor endInput.
	
	possibleArgumentNames := self possibleArgumentNamesFor: aString.
	
	self sandblockEditor do: ((SBInputMessageCommand newFor: self containingSandblock containingArtefact)
		messageSend: self containingSandblock;
		previousArguments: self arguments;
		previousSelector: self selector;
		newSelector: aString;
		newArguments: ((1 to: (self numArguments: aString)) collect: [:index |
			self arguments
				at: index
				ifAbsent: [
					self containingSandblock newNullBlock label: (possibleArgumentNames at: index ifAbsent: [''])]]);
		shouldMergeWithNext: true;
		yourself).
	
	self arguments
		detect: #isUnknown
		ifFound: [:u | self sandblockEditor startInput: u at: 0 replacingContents: false]
		ifNone: [
			self sandblockEditor do: ((SBDoItCommand newFor: self containingSandblock containingArtefact) do: [self messageParts last select])]
]

{ #category : #'as yet unclassified' }
SBStSignature >> selectorAndEdit: aString withFilledArgs: aBoolean [

	| current possibleArgumentNames |
	current := self containingSandblock sandblockEditor currentInputCommand.
	current oldMorph contents: current previousText.
	self containingSandblock sandblockEditor endInput.
	
	possibleArgumentNames := self possibleArgumentNamesFor: aString.
	
	self sandblockEditor do: ((SBInputMessageCommand newFor: self containingSandblock containingArtefact)
		messageSend: self containingSandblock;
		previousArguments: self arguments;
		previousSelector: self selector;
		newSelector: aString;
		newArguments: ((1 to: (self numArguments: aString)) collect: [:index |
			self arguments
				at: index
				ifAbsent: [
					aBoolean ifTrue: [possibleArgumentNames at: index ifPresent: [:n | SBStName new contents: n] ifAbsent: [self containingSandblock newNullBlock]] ifFalse: [self containingSandblock newNullBlock label: (possibleArgumentNames at: index ifAbsent: [''])]]]);
		shouldMergeWithNext: true;
		yourself).
	
	self arguments
		detect: #isUnknown
		ifFound: [:u | self sandblockEditor startInput: u at: 0 replacingContents: false]
		ifNone: [
			self sandblockEditor do: ((SBDoItCommand newFor: self containingSandblock containingArtefact) do: [self messageParts last select])]
]

{ #category : #'as yet unclassified' }
SBStSignature >> startInputAt: aNumber replacingContents: aBoolean [

	self sandblockEditor replaceInput: self firstSubmorph.
	^ self firstSubmorph startInputAt: aNumber replacingContents: aBoolean
]

{ #category : #'as yet unclassified' }
SBStSignature >> textMorphFor: aString [

	| text |
	text := SBStMessagePart new contents: aString.
	"SBColorPolicy boldMessageSends ifTrue: [text emphasis: TextEmphasis bold]."
	^ text
]

{ #category : #'as yet unclassified' }
SBStSignature >> valid [

	^ self submorphCount // 2 = self numArguments
]

{ #category : #'as yet unclassified' }
SBStSignature >> wantsMetaMenu [

	^ false
]

{ #category : #'as yet unclassified' }
SBStSignature >> writeSourceOn: aStream [

	| i |
	i :=  0.
	self submorphs
		do: [:m |
			i even
				ifTrue: [aStream nextPutAll: m contents]
				ifFalse: [m writeSourceOn: aStream].
			i := i + 1]
		separatedBy: [aStream space]
]
