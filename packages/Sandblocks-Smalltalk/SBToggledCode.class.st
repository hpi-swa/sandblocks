Class {
	#name : #SBToggledCode,
	#superclass : #SBStSubstitution,
	#instVars : [
		'comment'
	],
	#category : #'Sandblocks-Smalltalk'
}

{ #category : #'instance creation' }
SBToggledCode class >> comment: aString active: aNumber do: aCollection [

	^ aNumber > 0 ifTrue: [(aCollection at: aNumber) value] ifFalse: [nil]
]

{ #category : #suggestions }
SBToggledCode class >> instanceSuggestion [

	^ [self newEmpty]
]

{ #category : #testing }
SBToggledCode class >> matches: aBlock [

	(super matches: aBlock) ifFalse: [^ false].

	^ aBlock receiver isBinding and: [aBlock receiver contents = 'SBToggledCode'] and: [aBlock selector = 'comment:active:do:']
]

{ #category : #'instance creation' }
SBToggledCode class >> newEmpty [

	^ self new comment: '' active: 0 do: {SBStBlockBody new}
]

{ #category : #'instance creation' }
SBToggledCode class >> newFor: aBlock [

	^ self new
		comment: aBlock arguments first contents
		active: aBlock arguments second parsedContents
		do: aBlock arguments third childSandblocks
]

{ #category : #'as yet unclassified' }
SBToggledCode >> activeBlock [

	| index |
	index := self activeIndex.
	^ index > 0 ifTrue: [(self optionRows at: index) lastSubmorph] ifFalse: [nil]
]

{ #category : #'as yet unclassified' }
SBToggledCode >> activeIndex [

	self optionRows withIndexDo: [:row :index | row firstSubmorph value ifTrue: [^ index]].
	^ 0
]

{ #category : #'as yet unclassified' }
SBToggledCode >> addedMorph: aMorph [

	self updateSelected
]

{ #category : #'as yet unclassified' }
SBToggledCode >> binding: aString for: block class: aClass ifPresent: aBlock [

	^ (self isInActiveBlockBody: block)
		ifTrue: [super binding: aString for: block class: aClass ifPresent: aBlock]
		ifFalse: [
			block isDeclaration
				ifTrue: [nil]
				ifFalse: [
					aBlock value: (SBStName new
						contents: aString;
						behavior: SBStDeclarationForLocalVariable new;
						yourself)]]
]

{ #category : #'as yet unclassified' }
SBToggledCode >> block [

	^ self lastSubmorph
]

{ #category : #'as yet unclassified' }
SBToggledCode >> buildRowFor: aBlock active: aBoolean [

	| row |
	row := SBRow new.
	row
		layoutPolicy: SBAlgebraLayout new;
		softWrap: false;
		cellGap: 4;
		addMorphBack: (SBCheckbox new
			nonEdit: false;
			value: aBoolean;
			when: #toggled evaluate: [
				self
					deselectAllBut: (self optionRows indexOf: row);
					updateSelected];
			yourself);
		addMorphBack: (aBlock
			setProperty: #previousBlockColor
			toValue: (aBlock valueOfProperty: #sandblockBlockColor ifAbsent: [Color random])).
	^ row
]

{ #category : #'as yet unclassified' }
SBToggledCode >> color [

	^ self parentSandblock color
]

{ #category : #'as yet unclassified' }
SBToggledCode >> comment: aString active: aNumber do: aCollection [
	
	self optionRows copy do: #delete.
	
	comment contents: aString.
	aString ifNotEmpty: [self addMorphFront: comment] ifEmpty: [comment delete].
	
	"previousBlockColor := aBlock valueOfProperty: #sandblockBlockColor."
	aCollection withIndexDo: [:block :index |
		self addMorphBack: (self buildRowFor: block active: index = aNumber)].
	self updateSelected
]

{ #category : #'as yet unclassified' }
SBToggledCode >> deleteCommandFor: aBlock [

	^ (aBlock = self firstSubmorph and: [comment owner notNil])
		ifTrue: [
			SBMutatePropertyCommand new
				target: self firstSubmorph;
				selector: #contents;
				value: '']
		ifFalse: [SBDeleteCommand new target: aBlock owner]
]

{ #category : #'as yet unclassified' }
SBToggledCode >> deselectAllBut: aNumber [

	self optionRows withIndexDo: [:row :rowIndex |
		rowIndex ~= aNumber ifTrue: [
			row firstSubmorph value: false.
			row lastSubmorph localColorPolicy: SBPlainColorPolicy]]
]

{ #category : #'as yet unclassified' }
SBToggledCode >> drawnColor [

	^ Color white
]

{ #category : #'as yet unclassified' }
SBToggledCode >> fixedNumberOfChildren [

	^ false
]

{ #category : #'as yet unclassified' }
SBToggledCode >> guessedClass [

	^ self activeBlock ifNotNil: [:block | block isBlockBody ifTrue: [block lastSubmorph guessedClass] ifFalse: [block guessedClass]]
]

{ #category : #'as yet unclassified' }
SBToggledCode >> initialize [

	super initialize.
	
	comment := SBTextBubble new
		layoutInset: 6 @ 2;
		colored: false.
	
	self
		layoutInset: 2;
		cellGap: 4;
		vResizing: #shrinkWrap;
		hResizing: #shrinkWrap
]

{ #category : #'as yet unclassified' }
SBToggledCode >> insertCommandRequest: aMorph near: aBlock before: aBoolean [

	^ SBToggledCode comment: '' active: 2 do: {
		[
			SBCombinedCommand newWith: {
				row firstSubmorph toggleCommandFor: self containingArtefact.
				super insertCommandRequest: aMorph near: aBlock before: aBoolean}].
		[super insertCommandRequest: aMorph near: aBlock before: aBoolean]}
]

{ #category : #'as yet unclassified' }
SBToggledCode >> isInActiveBlockBody: aBlock [

	| block |
	block := aBlock containingBlock.
	[block] whileNotNil: [
		block = self activeBlock ifTrue: [^ true].
		block := block containingBlock].
	
	^ false
]

{ #category : #'as yet unclassified' }
SBToggledCode >> isWatch [

	^ false
]

{ #category : #'as yet unclassified' }
SBToggledCode >> layoutCommands [

	^ SBAlgebraCommand container
		morph: self;
		data: (self submorphs collect: #layoutCommands separatedBy: [SBAlgebraCommand hardLine withGap: true])
]

{ #category : #'as yet unclassified' }
SBToggledCode >> newEmptyChildNear: aBlock before: aBoolean [

	^ self buildRowFor: SBStBlockBody empty active: false
]

{ #category : #accessing }
SBToggledCode >> optionRows [

	^ comment owner ifNotNil: [self submorphs allButFirst] ifNil: [self submorphs]
]

{ #category : #'as yet unclassified' }
SBToggledCode >> prefix [

	^ '"  '
]

{ #category : #'as yet unclassified' }
SBToggledCode >> printOn: aStream [

	aStream nextPutAll: 'toggled code'.
]

{ #category : #'as yet unclassified' }
SBToggledCode >> startInputAt: aNumber replacingContents: aBoolean [

	comment owner ifNil: [self addMorphFront: comment].
	
	self sandblockEditor replaceInput: comment.
	^ comment startInputAt: aNumber replacingContents: aBoolean
]

{ #category : #'as yet unclassified' }
SBToggledCode >> symbols [

	^ self colorPolicy symbolsForComment: self
]

{ #category : #'as yet unclassified' }
SBToggledCode >> updateSelected [

	| index |
	index := self activeIndex.
	
	self deselectAllBut: index.
	
	index > 0 ifTrue: [ | block |
		block := (self optionRows at: index) lastSubmorph.
		block removeLocalColorPolicy]
]

{ #category : #'as yet unclassified' }
SBToggledCode >> writeSourceOn: aStream [

	aStream nextPutAll: '(SBToggledCode comment: '.
	comment contents storeOn: aStream.
	aStream nextPutAll: ' active: '.
	self activeIndex storeOn: aStream.
	aStream nextPutAll: ' do: {'.
	self optionRows do: [:row | row lastSubmorph writeSourceOn: aStream] separatedBy: [aStream nextPut: $.].
	aStream nextPutAll: '})'
]
