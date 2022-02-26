Class {
	#name : #SBCursorInsert,
	#superclass : #SBCursorPosition,
	#instVars : [
		'command',
		'before',
		'adjacent',
		'container',
		'bounds'
	],
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBCursorInsert >> = aPosition [

	^ aPosition class = self class and: [aPosition adjacent = self adjacent and: [aPosition before = self before and: [aPosition container = self container and: [self command hasSamePositionAs: aPosition command]]]]
]

{ #category : #'as yet unclassified' }
SBCursorInsert >> adjacent [

	^ adjacent
]

{ #category : #'as yet unclassified' }
SBCursorInsert >> adjacent: aBlock [

	adjacent := aBlock
]

{ #category : #'as yet unclassified' }
SBCursorInsert >> basicBoundsWithWidth: aNumber [

	| inset |
	bounds ifNotNil: [^ bounds].
	
	^ self hasHorizontalLayout
		ifTrue: [
			self adjacent
				ifNil: [ | height |
					inset := self container layoutInset asEdgeInsets.
					height := self container height max: TextStyle defaultFont height // 2.
					self before
						ifTrue: [self container topLeft + inset topLeft - (aNumber // 2 @ 0) extent: aNumber @ (height - inset vertical)]
						ifFalse: [self container topRight - (aNumber // 2 + inset right @ inset top negated) extent: aNumber @ (height - inset vertical)]]
				ifNotNil: [
					self before
						ifTrue: [self adjacent topLeft - (aNumber // 2 @ 0) extent: aNumber @ self adjacent height]
						ifFalse: [self adjacent topRight extent: aNumber @ self adjacent height]]]
		ifFalse: [
			self adjacent
				ifNil: [
					inset := self container layoutInset asEdgeInsets.
					"if we are in an empty container with vertical layout, we may get a 1x1 sized cursor. Scale it to be the font's height instead."
					self container width - inset x < 5
						ifTrue: [self container topLeft + inset topLeft extent: self lineWidth @ TextStyle defaultFont height]
						ifFalse: [
							self before
								ifTrue: [self container topLeft + inset topLeft extent: self container width - inset horizontal @ aNumber]
								ifFalse: [self container bottomLeft - (inset left negated @ (aNumber + inset bottom)) extent: self container width - inset horizontal @ aNumber]]]
				ifNotNil: [
					self before
						ifTrue: [self adjacent topLeft - (0 @ (aNumber // 2)) extent: self adjacent width @ aNumber]
						ifFalse: [self adjacent bottomLeft extent: self adjacent width @ aNumber]]]
]

{ #category : #'as yet unclassified' }
SBCursorInsert >> before [

	^ before
]

{ #category : #'as yet unclassified' }
SBCursorInsert >> before: aBoolean [

	before := aBoolean
]

{ #category : #'as yet unclassified' }
SBCursorInsert >> block [

	^ (self adjacent ifNil: [self container]) containingSandblock
]

{ #category : #'as yet unclassified' }
SBCursorInsert >> bounds [

	^ self boundsWithWidth: self lineWidth
]

{ #category : #'as yet unclassified' }
SBCursorInsert >> bounds: aRectangle [

	bounds := aRectangle
]

{ #category : #'as yet unclassified' }
SBCursorInsert >> boundsWithWidth: aNumber [

	| b |
	b := self basicBoundsWithWidth: aNumber.
	(b width <= self lineWidth and: [b height <= self lineWidth]) ifTrue: [^ b origin extent: self lineWidth @ TextStyle defaultFont height].
	^ b
]

{ #category : #'as yet unclassified' }
SBCursorInsert >> color [

	^ self container colorPolicy selectionColorForBlock: (self container parentSandblock ifNil: [self container])
]

{ #category : #'as yet unclassified' }
SBCursorInsert >> command [

	^ command
]

{ #category : #'as yet unclassified' }
SBCursorInsert >> command: aBlock [

	command := aBlock
]

{ #category : #'as yet unclassified' }
SBCursorInsert >> container [

	^ container
]

{ #category : #'as yet unclassified' }
SBCursorInsert >> container: aBlock [

	container := aBlock
]

{ #category : #'as yet unclassified' }
SBCursorInsert >> drawOn: aCanvas in: aRectangle color: aColor [

	SBToggledCode comment: '' active: 1 do: {
		[ | r |
			r := aRectangle expandBy: -1.
			aCanvas
				line: r topLeft
				to: (aRectangle height > 4 ifTrue: [r bottomLeft] ifFalse: [r topRight])
				width: (aRectangle height > 4 ifTrue: [aRectangle width] ifFalse: [aRectangle height])
				color: aColor
				dashLength: 1
				secondColor: Color transparent
				secondDashLength: 5
				startingOffset: 0].
		[aCanvas fillRectangle: aRectangle color: self color]}
]

{ #category : #'as yet unclassified' }
SBCursorInsert >> enterWith: aCursor [

	super enterWith: aCursor.
	aCursor showLabel: (command title ifNil: ['insert in ', self container printString]).
	command suggestions ifNotEmpty: [:s |
		aCursor editor suggestionMenu
			suggestions: s;
			focusOnOpen: false;
			openNear: aCursor requestor: command]
]

{ #category : #'as yet unclassified' }
SBCursorInsert >> hasHorizontalLayout [

	^ (command ifNil: [container]) hasHorizontalLayout
]

{ #category : #'as yet unclassified' }
SBCursorInsert >> hash [

	^ self adjacent hash bitXor: (self before hash bitXor: self container hash)
]

{ #category : #'as yet unclassified' }
SBCursorInsert >> horizontalOffsetInFloat [

	^ self block containingFloat
		ifNotNil: [:float | | reference |
			reference := self bounds center x.
			reference - float left]
		ifNil: [self bounds center x]
]

{ #category : #'as yet unclassified' }
SBCursorInsert >> isDistinctFrom: aPosition [

	^ self class = aPosition class
		ifTrue: [(self command hasSamePositionAs: aPosition command) not]
		ifFalse: [self ~= aPosition]
]

{ #category : #testing }
SBCursorInsert >> isInsert [

	^ true
]

{ #category : #'as yet unclassified' }
SBCursorInsert >> leaveIn: anEditor with: aCursor [

	aCursor showLabel: nil.
	aCursor editor suggestionMenu delete
]

{ #category : #'as yet unclassified' }
SBCursorInsert >> lineWidth [

	^ 3
]

{ #category : #'as yet unclassified' }
SBCursorInsert >> minimalBounds [

	^ self boundsWithWidth: 0
]

{ #category : #'as yet unclassified' }
SBCursorInsert >> mode [

	^ #insert
]

{ #category : #'as yet unclassified' }
SBCursorInsert >> moveHorizontal: aNumber wordWise: aBoolean [

	| next |
	next := self adjacentPosition: aNumber in: self container sandblockEditor.
	^ (next class = self class and: [next command hasSamePositionAs: self command])
		ifTrue: [next adjacentPosition: aNumber in: self container sandblockEditor]
		ifFalse: [next]
]

{ #category : #'as yet unclassified' }
SBCursorInsert >> objectInterface [

	^ self container
		objectInterfaceNear: self adjacent
		at: (self before ifTrue: [#before] ifFalse: [#after])
]

{ #category : #'as yet unclassified' }
SBCursorInsert >> printOn: aStream [

	aStream nextPutAll: self className.
	aStream nextPut: $(.
	aStream print: self container.
	aStream nextPut: $)
]

{ #category : #'as yet unclassified' }
SBCursorInsert >> secondaryInsertPosition [

	^ self command secondaryInsertPosition
]

{ #category : #'as yet unclassified' }
SBCursorInsert >> selectLarger [

	^ SBCursorSelect new block: self container containingSandblock
]

{ #category : #'as yet unclassified' }
SBCursorInsert >> selectSmaller [

	
]

{ #category : #'as yet unclassified' }
SBCursorInsert >> unhandledEvent: anEvent in: anEditor didHandle: aBlock [

	anEditor do: command.
	SBToggledCode comment: '' active: 1 do: {
		[ | position |
			position := nil.
			(command respondsTo: #morph)
				ifTrue: [
					command morph cursorPositionsDo: [:pos | " pick the first that is not a select, skipping over positions
that would cause the same insert as us"
					((position isNil or: [position isKindOf: SBCursorSelect]) and: [(pos isKindOf: SBCursorInsert) not or: [pos container ~= self container]]) ifTrue: [position := pos]].
					position ifNotNil: [anEditor cursor cursorPosition: position explicitMove: false axis: #none]]
				ifFalse: [anEditor selection inputContainedUnknown]].
		[anEditor performAction: #moveCursorSmaller].
		[anEditor selection inputContainedUnknown]}.
	(command continueAfterInsert: anEvent keyCharacter) ifTrue: [anEditor handle: anEvent].
	aBlock value
]
