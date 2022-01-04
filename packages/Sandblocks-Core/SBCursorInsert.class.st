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

	bounds ifNotNil: [^ bounds].
	
	^ self container hasHorizontalLayout
		ifTrue: [
			self adjacent
				ifNil: [ | inset |
					inset := self container layoutInset asEdgeInsets.
					self before
						ifTrue: [self container topLeft + inset topLeft - (self lineWidth // 2 @ 0) extent: self lineWidth @ (self container height - inset vertical)]
						ifFalse: [self container topRight - (self lineWidth // 2 + inset right @ inset top negated) extent: self lineWidth @ (self container height - inset vertical)]]
				ifNotNil: [
					self before
						ifTrue: [self adjacent topLeft - (self lineWidth // 2 @ 0) extent: self lineWidth @ self adjacent height]
						ifFalse: [self adjacent topRight extent: self lineWidth @ self adjacent height]]]
		ifFalse: [
			self adjacent
				ifNil: [ | inset |
					inset := self container layoutInset asEdgeInsets.
					self before
						ifTrue: [self container topLeft + inset topLeft extent: self container width - inset horizontal @ self lineWidth]
						ifFalse: [self container bottomLeft - (inset left negated @ (self lineWidth + inset bottom)) extent: self container width - inset horizontal @ self lineWidth]]
				ifNotNil: [
					self before
						ifTrue: [self adjacent topLeft - (0 @ (self lineWidth // 2)) extent: self adjacent width @ self lineWidth]
						ifFalse: [self adjacent bottomLeft extent: self adjacent width @ self lineWidth]]]
]

{ #category : #'as yet unclassified' }
SBCursorInsert >> bounds: aRectangle [

	bounds := aRectangle
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
SBCursorInsert >> drawOn: aCanvas in: aRectangle [

	aCanvas fillRectangle: aRectangle color: self color
]

{ #category : #'as yet unclassified' }
SBCursorInsert >> enter [

	super enter.
	self triggerEvent: #showLabel with: (command title ifNil: ['insert in ', self container printString])
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
SBCursorInsert >> leaveIn: anEditor [

	self triggerEvent: #showLabel with: nil
]

{ #category : #'as yet unclassified' }
SBCursorInsert >> lineWidth [

	^ 3
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
