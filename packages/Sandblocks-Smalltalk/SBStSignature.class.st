Class {
	#name : #SBStSignature,
	#superclass : #Morph,
	#category : #'Sandblocks-Smalltalk'
}

{ #category : #'as yet unclassified' }
SBStSignature >> addArgument: aString block: aBlock [

	self sandblockEditor do: (SBCombinedCommand newWith: {
		SBInsertCommand new
			container: self;
			morph: (SBStMessagePart new contents: aString);
			index: self submorphCount + 1.
		SBInsertCommand new
			container: self;
			morph: aBlock;
			index: self submorphCount + 2})
]

{ #category : #'change reporting' }
SBStSignature >> addedMorph: aMorph [

	self messageParts do: #layoutChanged
]

{ #category : #accessing }
SBStSignature >> arguments [

	^ Array streamContents: [:s | 2 to: self submorphCount by: 2 do: [:i | s nextPut: (self submorphs at: i)]]
]

{ #category : #'as yet unclassified' }
SBStSignature >> argumentsDo: aBlock [

	self submorphsDo: [:morph | morph isMessagePart ifFalse: [aBlock value: morph]]
]

{ #category : #'layout properties - table' }
SBStSignature >> cellGap [

	^ self containingSandblock colorPolicy messageCellGap
]

{ #category : #'event handling' }
SBStSignature >> click: anEvent [

	anEvent redButtonPressed ifTrue: [self updateSuggestions].
]

{ #category : #accessing }
SBStSignature >> color [

	^ self owner color
]

{ #category : #'as yet unclassified' }
SBStSignature >> deleteCommandFor: aBlock [

	| index |
	(self isUnary or: [self isBinary or: [self isAssignment]]) ifTrue: [
		^ SBReplaceCommand new
			target: aBlock;
			replacer: self containingSandblock newNullBlock].
	
	(self isKeyword and: self submorphCount = 2) ifTrue: [
		^ aBlock submorphIndex = 1
			ifTrue: [nil]
			ifFalse: [SBDeleteCommand new target: aBlock]].
	
	index := ((self submorphs indexOf: aBlock) - 1 / 2) floor * 2 + 1.
	^ (SBCombinedCommand newWith: {
		SBDeleteCommand new target: (self submorphs at: index).
		SBDeleteCommand new target: (self submorphs at: index + 1)})
			selectAfter: (self submorphs at: index - 1 ifAbsent: [self messageSend])
]

{ #category : #'as yet unclassified' }
SBStSignature >> extractKeywords: aString [

	| parts |
	parts := aString splitBy: ':'.
	parts size = 1 ifTrue: [^ parts].
	
	^ parts allButLast collect: [:p | p, ':']
]

{ #category : #initialization }
SBStSignature >> initialize [

	super initialize.
	
	self
		color: Color transparent;
		layoutPolicy: SBAlgebraLayout new;
		hResizing: #shrinkWrap;
		vResizing: #shrinkWrap
]

{ #category : #'as yet unclassified' }
SBStSignature >> insertCommandRequest: aMorph near: aBlock before: aBoolean [

	| part index insertArg insertPart reference |
	(self isBinary or: [self isAssignment]) ifTrue: [^ nil].
	self isUnary ifTrue: [
		aBoolean ifTrue: [^ nil].
		^ SBRelInsertCommand new near: self messageParts first before: false in: self morph: aMorph].
	
	" only allow inserting before message parts and after arguments "
	(aBlock notNil and: [(aBlock isMessagePart and: [aBoolean not]) or: [aBlock isMessagePart not and: [aBoolean]]]) ifTrue: [^ nil].
	
	reference := aBlock ifNil: [aBoolean ifTrue: [self firstSubmorph] ifFalse: [self lastSubmorph]].
	
	index := reference owner = self
		ifTrue: [(reference submorphIndex / 2) ceiling * 2 + (aBoolean ifTrue: [-1] ifFalse: [1])]
		ifFalse: [1].
	part := SBStMessagePart new contents: ':'.
	
	insertPart := SBInsertCommand new
		container: self;
		index: index;
		morph: part;
		shouldMergeWithNext: true;
		yourself.
	insertArg := SBInsertCommand new
		container: self;
		index: index;
		morph: aMorph;
		yourself.
	^ SBCombinedCommand newWith: {insertArg. insertPart}
]

{ #category : #'as yet unclassified' }
SBStSignature >> isAssignment [

	^ self messageParts size = 1 and: [self messageParts first isAssignment]
]

{ #category : #testing }
SBStSignature >> isBinary [

	^ self selector ifNotEmpty: [:s | s allSatisfy: #isSpecial] ifEmpty: [false]
]

{ #category : #testing }
SBStSignature >> isCascade [

	^ false
]

{ #category : #testing }
SBStSignature >> isKeyword [

	^ self selector includes: $:
]

{ #category : #testing }
SBStSignature >> isUnary [

	^ self selector isEmpty or: [self selector asSymbol isUnary]
]

{ #category : #'as yet unclassified' }
SBStSignature >> layoutCommands [

	^ SBAlgebraCommand container
		morph: self;
		data: (self isUnary ifTrue: [{self firstSubmorph layoutCommands}] ifFalse: [
			Array new: self submorphCount streamContents: [:stream |
				self submorphs pairsDo: [:messagePart :argument |
					stream nextPut: (SBAlgebraCommand indent data: {
						messagePart layoutCommands.
						messagePart contents size > 8
							ifTrue: [SBAlgebraCommand softLineOrGap]
							ifFalse: [SBAlgebraCommand gap].
						argument layoutCommands}).
					argument ~= self lastSubmorph ifTrue: [stream nextPut: (SBAlgebraCommand softLineOrGap withGap: true)]]]])
]

{ #category : #accessing }
SBStSignature >> messageParts [

	^ Array streamContents: [:s | 1 to: self submorphCount  by: 2 do: [:i | s nextPut: (self submorphs at: i)]]
]

{ #category : #layout }
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

{ #category : #accessing }
SBStSignature >> numArguments [

	self selector ifEmpty: [^ self submorphCount // 2].
	self selector last = $: ifTrue: [^ (self extractKeywords: self selector) size].
	self selector first isSpecial ifTrue: [^ 1].
	^ 0
]

{ #category : #accessing }
SBStSignature >> numArguments: aString [

	aString ifEmpty: [^ 1].
	aString = ':' ifTrue: [^ 1].
	aString last = $: ifTrue: [^ (self extractKeywords: aString) size].
	aString first isSpecial ifTrue: [^ 1].
	^ 0
]

{ #category : #'as yet unclassified' }
SBStSignature >> objectInterfaceNear: aBlock at: aSymbol argumentInterface: anInterfaceCollection [

	aSymbol = #replace ifFalse: [^ SBInterfaces never].
	
	^ aBlock submorphIndex odd
		ifTrue: [SBInterfaces stMessagePart]
		ifFalse: [anInterfaceCollection]
]

{ #category : #'as yet unclassified' }
SBStSignature >> possibleArgumentNamesFor: aString [

	(self systemNavigation allImplementorsOf: aString asSymbol) do: [:impl | ^ impl compiledMethod asSandblock arguments collect: #contents].
	^ #()
]

{ #category : #'submorphs - callbacks' }
SBStSignature >> removedMorph: aMorph [

	self messageParts do: #layoutChanged
]

{ #category : #accessing }
SBStSignature >> selector [

	^ String streamContents: [:stream |
		self submorphs
			withIndexDo: [:m :i | i odd ifTrue: [stream nextPutAll: m contents]]]
]

{ #category : #accessing }
SBStSignature >> selector: aString [

	| currentNum newNum arguments |
	currentNum := self numArguments: aString.
	newNum := aString numArgs.
	
	arguments := (self arguments copyFrom: 1 to: (newNum min: currentNum)), (Array streamContents: [:s | currentNum + 1 to: newNum do: [:i | s nextPut: self containingSandblock newNullBlock]]).
	
	self selector: aString arguments: arguments
]

{ #category : #accessing }
SBStSignature >> selector: aString arguments: aCollection [

	| messageParts |
	aString = ':='
		ifTrue: [
			self assert: aCollection size = 1.
			self addMorphBack: (self textMorphFor: ':=').
			self addMorphBack: aCollection first]
		ifFalse: [
			messageParts := self messageParts.
			(self extractKeywords: aString) withIndexDo: [:keyword :index |
				messageParts
					at: index
					ifPresent: [:p | p contents ~= keyword ifTrue: [p replaceBy: (self textMorphFor: keyword)]]
					ifAbsent: [self addMorph: (self textMorphFor: keyword) asElementNumber: index * 2 - 1].
				(((keyword endsWith: ':') or: [keyword isEmpty or: [keyword allSatisfy: #isSpecial]]) and: [aCollection size >= 1]) ifTrue: [
					self arguments at: index ifPresent: [:a | a replaceBy: (aCollection at: index)] ifAbsent: [
						aCollection
							at: index
							ifPresent: [:arg | self addMorph: arg asElementNumber: index * 2]
							ifAbsent: [self assert: aString isEmpty]]]]].
	
	[self submorphs size > (aCollection size * 2 max: 1)] whileTrue: [self lastSubmorph delete]
]

{ #category : #'as yet unclassified' }
SBStSignature >> selectorAndEdit: aString [

	| current possibleArgumentNames |
	current := self containingSandblock sandblockEditor currentInputCommand.
	current oldMorph contents: current previousText.
	self containingSandblock sandblockEditor endInput.
	
	possibleArgumentNames := self possibleArgumentNamesFor: aString.
	
	self sandblockEditor do: (SBInputMessageCommand new
		messageSend: self containingSandblock;
		previousArguments: self arguments;
		previousSelector: self selector;
		newSelector: aString;
		newArguments: ((1 to: (self numArguments: aString)) collect: [:index |
			self arguments
				at: index
				ifAbsent: [self containingSandblock newNullBlock label: (possibleArgumentNames at: index ifAbsent: [''])]]);
		shouldMergeWithNext: true;
		yourself).
	
	self arguments
		detect: #isUnknown
		ifFound: [:u | self sandblockEditor startInput: u at: 0 replacingContents: false]
		ifNone: [
			self sandblockEditor do: (SBDoItCommand new
				artefactFrom: self;
				do: [self messageParts last select])]
]

{ #category : #'as yet unclassified' }
SBStSignature >> selectorAndEdit: aString withFilledArgs: aBoolean [

	| possibleArgumentNames |
	"current := self containingSandblock sandblockEditor currentInputCommand.
	current oldMorph contents: previousText.
	self containingSandblock sandblockEditor endInput."
	
	possibleArgumentNames := self possibleArgumentNamesFor: aString.
	
	self sandblockEditor do: (SBInputMessageCommand new
		messageSend: self containingSandblock;
		previousArguments: self arguments;
		previousSelector: self selector;
		newSelector: aString;
		newArguments: ((1 to: (self numArguments: aString)) collect: [:index |
			self arguments at: index ifAbsent: [
				aBoolean
					ifTrue: [
						possibleArgumentNames
							at: index
							ifPresent: [:n | SBStName new contents: n]
							ifAbsent: [self containingSandblock newNullBlock]]
					ifFalse: [self containingSandblock grammarHandler newNullBlock label: (possibleArgumentNames at: index ifAbsent: [''])]]]);
		shouldMergeWithNext: true;
		yourself).
	
	self arguments
		detect: #isUnknown
		ifFound: [:u | self sandblockEditor startInput: u at: 0 replacingContents: false]
		ifNone: [
			self sandblockEditor do: (SBDoItCommand new
				artefactFrom: self;
				do: [self messageParts last select])]
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

{ #category : #testing }
SBStSignature >> valid [

	^ self submorphCount // 2 = self numArguments
]

{ #category : #menu }
SBStSignature >> wantsMetaMenu [

	^ false
]

{ #category : #printing }
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
