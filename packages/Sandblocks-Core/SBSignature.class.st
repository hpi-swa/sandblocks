Class {
	#name : #SBSignature,
	#superclass : #Morph,
	#instVars : [
		'currentInputMessagePart'
	],
	#category : 'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBSignature >> activeMorph [

	^ currentInputMessagePart
]

{ #category : #'as yet unclassified' }
SBSignature >> addArgumentAndEditAfter: aMorph focusKeyword: aTextMorph [

	| new |
	new := SBUnknown new.
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
SBSignature >> addMessagePart [

	self isUnary
		ifTrue: [
			currentInputMessagePart contents: currentInputMessagePart contents, $:.
			self submorphCount = 2 ifFalse: [self addArgumentAndEditAfter: currentInputMessagePart focusKeyword: nil].
			^ self].
	(self isKeyword and: [(currentInputMessagePart contents occurrencesOf: $:) > 0])
		ifTrue: [ | msg |
			msg := currentInputMessagePart contentsBeforeCursor.
			(msg isEmpty or: [msg last ~= $:]) ifTrue: [msg := msg, $:].
			currentInputMessagePart contents: (currentInputMessagePart contentsAfterCursor withFirstCharacterDownshifted ifEmpty: [':']).
			^ self
				addMessagePart: msg
				after: currentInputMessagePart submorphBefore
				focusKeyword: (currentInputMessagePart contents = ':' ifTrue: [currentInputMessagePart])]
]

{ #category : #'as yet unclassified' }
SBSignature >> addMessagePart: aString after: aMorph focusKeyword: aKeywordMorphOrNil [

	| new |
	new := self textMorphFor: aString.
	self addMorph: new behind: aMorph.
	^ self addArgumentAndEditAfter: new focusKeyword: (aKeywordMorphOrNil ifNil: [aString = ':' ifTrue: [new] ifFalse: [nil]])
]

{ #category : #'as yet unclassified' }
SBSignature >> arguments [

	^ Array streamContents: [:s | 2 to: self submorphCount by: 2 do: [:i | s nextPut: (self submorphs at: i)]]
]

{ #category : #'as yet unclassified' }
SBSignature >> argumentsDo: aBlock [

	2 to: self submorphCount by: 2 do: [:i | aBlock value: (self submorphs at: i)]
]

{ #category : #'as yet unclassified' }
SBSignature >> childSandblocksDo: aBlock [

	self argumentsDo: aBlock
]

{ #category : #'as yet unclassified' }
SBSignature >> color [

	^ self owner color
]

{ #category : #'as yet unclassified' }
SBSignature >> currentTextMorph [

	^ currentInputMessagePart
]

{ #category : #'as yet unclassified' }
SBSignature >> extractKeywords: aString [

	| parts |
	parts := aString splitBy: ':'.
	parts size = 1 ifTrue: [^ parts].
	
	^ parts allButLast collect: [:p | p, ':']
]

{ #category : #'as yet unclassified' }
SBSignature >> focusPartAt: aNumber [

	self moveFocusToPart: (self submorphs at: (aNumber - 1 * 2 + 1))
]

{ #category : #'as yet unclassified' }
SBSignature >> initialize [

	super initialize.
	
	self
		layoutPolicy: SBKeywordMessageLayout new;
		vResizing: #shrinkWrap;
		hResizing: #shrinkWrap;
		listDirection: #leftToRight;
		cellGap: 4 * self scalingFactor;
		color: Color transparent
]

{ #category : #'as yet unclassified' }
SBSignature >> insertCommandRequest: anAfterBoolean near: aBlock [

	| cmd index |
	self isBinary ifTrue: [^ nil].
	index := (self arguments indexOf: aBlock) + (anAfterBoolean ifTrue: [1] ifFalse: [0]).
	index < 1 ifTrue: [^ nil].
	cmd := (SBInputMessageCommand newFor: self containingSandblock containingArtefact)
		 previousSelector: self selector;
		 previousArguments: self arguments;
		 newArguments: (self arguments withInsert: SBUnknown new at: index);
		 messageSend: self;
		 select: self parentSandblock;
		 editInputIndex: index;
		 newSelector: (self selector keywords withInsert: ':' at: index) join;
		 yourself.
	^ cmd
]

{ #category : #'as yet unclassified' }
SBSignature >> isBinary [

	^ self selector ifNotEmpty: [:s | s allSatisfy: #isSpecial] ifEmpty: [false]
]

{ #category : #'as yet unclassified' }
SBSignature >> isCascade [

	^ false
]

{ #category : #'as yet unclassified' }
SBSignature >> isKeyword [

	^ self selector asSymbol isKeyword
]

{ #category : #'as yet unclassified' }
SBSignature >> isUnary [

	^ self selector asSymbol isUnary
]

{ #category : #'as yet unclassified' }
SBSignature >> keyStroke: anEvent [

	| char |
	char := anEvent keyCharacter.
	
	self flag: #fixme. " !!! this is most certainly an OS-dependent key mapping mess "
	(char asLowercase = $i and: [anEvent commandKeyPressed]) ifTrue: [^ self moveFocusToNextPart: (anEvent shiftPressed ifTrue: [-1] ifFalse: [1])].
	
	char = $: ifTrue: [^ self addMessagePart].
	(char isSpecial and: [currentInputMessagePart contents isEmpty])
		ifTrue: [^ self setBinaryMessage: char asString].
	
	(char = $+ and: [anEvent controlKeyPressed] and: [self isKeyword]) ifTrue: [
		^ self addMessagePart: ':' after: currentInputMessagePart submorphAfter focusKeyword: nil].
	
	self isBinary
		ifTrue: [
			char isSpecial
				ifTrue: [currentInputMessagePart keyStroke: anEvent]
				ifFalse: [
					self moveFocusToNextPart: 1.
					self sandblockEditor selection keyStroke: anEvent]]
		ifFalse: [currentInputMessagePart keyStroke: anEvent]
]

{ #category : #'as yet unclassified' }
SBSignature >> minExtent [
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
SBSignature >> moveCursorTo: aNumber [

	| index |
	index := 0.
	self submorphs pairsDo: [:message :argument |
		index := index + message contents size.
		index >= aNumber
			ifTrue: [
				currentInputMessagePart := message.
				currentInputMessagePart moveCursorTo: aNumber - index - message contents size.
				^ self]].
	
	currentInputMessagePart := self submorphs at: (self submorphCount - 1 max: 1).
	currentInputMessagePart moveCursorTo: aNumber
]

{ #category : #'as yet unclassified' }
SBSignature >> moveFocusToNextPart: aNumber [

	((self arguments notEmpty and: [self submorphCount <= 2]) or: [currentInputMessagePart submorphAfter ifNotNil: #isUnknown ifNil: [false]])
		ifTrue: [ | arg |
			arg := currentInputMessagePart submorphAfter.
			self containingSandblock sandblockEditor
				endInput;
				startInput: arg at: 0 replacingContents: false]
		ifFalse: [self moveFocusToPart: (self submorphs atWrap: (self submorphIndexOf: currentInputMessagePart) + (2 * aNumber))]
]

{ #category : #'as yet unclassified' }
SBSignature >> moveFocusToPart: aMorph [

	currentInputMessagePart stopEditing.
	currentInputMessagePart := aMorph.
	
	" place cursor in front of colon (behind doesn't make sense) or append "
	currentInputMessagePart moveCursorTo: (currentInputMessagePart contents = ':' ifTrue: [0] ifFalse: [9e8])
]

{ #category : #'as yet unclassified' }
SBSignature >> numArgs [

	^ self submorphCount // 2
]

{ #category : #'as yet unclassified' }
SBSignature >> selector [

	^ String streamContents: [:stream |
		self submorphs
			withIndexDo: [:m :i | i odd ifTrue: [stream nextPutAll: m contents]]]
]

{ #category : #'as yet unclassified' }
SBSignature >> selector: aString [

	| currentNum newNum arguments |
	currentNum := self numArgs.
	newNum := aString numArgs.
	
	arguments := (self arguments copyFrom: 1 to: (newNum min: currentNum)), (Array streamContents: [:s |
		currentNum + 1 to: newNum do: [:i | s nextPut: SBUnknown new]]).
	
	self selector: aString arguments: arguments
]

{ #category : #'as yet unclassified' }
SBSignature >> selector: aString arguments: aCollection [

	self removeAllMorphs.
	(self extractKeywords: aString) withIndexDo: [:keyword :index |
		self addMorphBack: (self textMorphFor: keyword).
		((keyword endsWith: ':') or: [keyword notEmpty and: [keyword allSatisfy: #isSpecial]]) ifTrue: [
			self addMorphBack: (aCollection at: index)]]
]

{ #category : #'as yet unclassified' }
SBSignature >> selectorAndEdit: aString [

	self selector: aString.
	
	self containingSandblock sandblockEditor endInput.
	self arguments detect: #isUnknown ifFound: [:u | self sandblockEditor startInput: u at: 0 replacingContents: false] ifNone: []
]

{ #category : #'as yet unclassified' }
SBSignature >> setBinaryMessage: aString [

	currentInputMessagePart contents: aString.
	self flag: #fixme. " gonna be very annoying typing <= "
	
	self submorphCount = 1
		ifTrue: [self addArgumentAndEditAfter: currentInputMessagePart focusKeyword: currentInputMessagePart]
		ifFalse: [self moveCursorTo: 9e8]
]

{ #category : #'as yet unclassified' }
SBSignature >> startInputAt: aNumber replacingContents: aBoolean [

	| cmd |
	currentInputMessagePart := self firstSubmorph.
	
	cmd := (SBInputMessageCommand newFor: self containingSandblock containingArtefact)
		messageSend: self containingSandblock;
		previousSelector: self selector;
		previousArguments: self arguments;
		yourself.
	
	currentInputMessagePart moveCursorTo: aNumber.
	(aBoolean or: [currentInputMessagePart contents = SBMessageSend placeholderSelector]) ifTrue: [currentInputMessagePart contents: ((currentInputMessagePart contents includes: $:) ifTrue: [':'] ifFalse: [''])].
	
	^ cmd
]

{ #category : #'as yet unclassified' }
SBSignature >> stopEditing: aCommand [

	aCommand
		newSelector: self selector;
		newArguments: self arguments.
	
	currentInputMessagePart ifNotNil: #stopEditing.
	currentInputMessagePart := nil
]

{ #category : #'as yet unclassified' }
SBSignature >> textMorphFor: aString [

	| text |
	text := SBOwnTextMorph new contents: aString.
	SBColorPolicy boldMessageSends ifTrue: [text emphasis: TextEmphasis bold].
	^ text
]

{ #category : #'as yet unclassified' }
SBSignature >> writeSourceOn: aStream [

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
