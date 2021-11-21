Class {
	#name : #SBMultilineOwnTextMorph,
	#superclass : #SBOwnTextMorph,
	#instVars : [
		'paragraph',
		'maxWidth',
		'selectionBound'
	],
	#category : #'Sandblocks-Morphs'
}

{ #category : #'as yet unclassified' }
SBMultilineOwnTextMorph >> betterCursorAfterSelectionTo: aNumber [
	" determine whether to go left or right upon arrow key hits when leaving a selection "
	
	^ ((self selectionBound < self cursor and: [aNumber < 0])
		or: [self selectionBound > self cursor and: [aNumber > 0]])
		ifTrue: [self selectionBound]
		ifFalse: [self cursor]
]

{ #category : #'as yet unclassified' }
SBMultilineOwnTextMorph >> canMoveCursorDirection: aNumber [

	^ ((self cursor = (self contents size + 1) and: [aNumber > 0]) or: [self cursor = 1 and: [aNumber < 0]]) not
]

{ #category : #'as yet unclassified' }
SBMultilineOwnTextMorph >> contents: aString [

	super contents: aString.
	paragraph := nil
]

{ #category : #'as yet unclassified' }
SBMultilineOwnTextMorph >> cursor: aNumber [

	super cursor: aNumber.
	self updateCursor
]

{ #category : #'as yet unclassified' }
SBMultilineOwnTextMorph >> cursorFromEvent: anEvent [

	^ self cursorIndexForPosition: anEvent position
]

{ #category : #'as yet unclassified' }
SBMultilineOwnTextMorph >> cursorIndexForPosition: aPoint [

	self contents ifEmpty: [^ 0].
	^ (self paragraph characterBlockAtPoint: aPoint) stringIndex
]

{ #category : #'as yet unclassified' }
SBMultilineOwnTextMorph >> cursorPosition [

	^ (self paragraph characterBlockForIndex: self cursor) origin
]

{ #category : #'as yet unclassified' }
SBMultilineOwnTextMorph >> drawOn: aCanvas [

	self contents
		ifEmpty: [
			self
				drawString: self placeholderText
				on: aCanvas
				at: self position
				font: self placeholderFont
				color: (self color alpha: 0.7)]
		ifNotEmpty: [
			aCanvas
				paragraph: (self paragraph
					positionWhenComposed: self position;
					showCaret: self cursorVisible;
					caretColor: self color)
				bounds: (self position extent: self paragraph extent)
				color: self color]
]

{ #category : #'as yet unclassified' }
SBMultilineOwnTextMorph >> handlesMouseDown: anEvent [

	^ self hasCursor and: [anEvent redButtonPressed]
]

{ #category : #'as yet unclassified' }
SBMultilineOwnTextMorph >> hasSelection [

	^ self cursor ~= 0 and: [self selectionBound ~= self cursor and: [self selectionBound > 0]]
]

{ #category : #'as yet unclassified' }
SBMultilineOwnTextMorph >> indexAtLine: aNumber x: anotherNumber [
	| line p |
	p := self paragraph.
	line := p lines at: (aNumber clampLow: 1 high: p numberOfLines).
	^ {"((CharacterBlockScanner new text: p text textStyle: p textStyle)
		characterBlockAtPoint: (anotherNumber + self position x) @ line top index: nil in: line) stringIndex."
		(self paragraph characterBlockAtPoint: anotherNumber @ line top) stringIndex.
		0}
]

{ #category : #'as yet unclassified' }
SBMultilineOwnTextMorph >> initialize [
	
	super initialize.
	
	selectionBound := 0
]

{ #category : #'as yet unclassified' }
SBMultilineOwnTextMorph >> keyStroke: anEvent [

	| char |
	char := anEvent keyCharacter.
	
	(anEvent keyCharacter = $v and: [anEvent commandKeyPressed]) ifTrue: [^ self insertString: Clipboard clipboardText].
	(anEvent keyCharacter = $c and: [anEvent commandKeyPressed]) ifTrue: [^ Clipboard clipboardText: self selection].
	char = Character arrowLeft ifTrue: [
		^ self moveCursor: -1 selecting: anEvent shiftPressed].
	char = Character arrowRight ifTrue: [
		^ self moveCursor: 1 selecting: anEvent shiftPressed].
	char = Character arrowUp ifTrue: [
		^ self moveCursorVertically: -1 selecting: anEvent shiftPressed ifAtBound: []].
	char = Character arrowDown ifTrue: [
		^ self moveCursorVertically: 1 selecting: anEvent shiftPressed ifAtBound: []].
	
	^ super keyStroke: anEvent
]

{ #category : #'as yet unclassified' }
SBMultilineOwnTextMorph >> keyboardFocusColor [

	^ nil
]

{ #category : #'as yet unclassified' }
SBMultilineOwnTextMorph >> lineNumberOfIndex: aNumber [

	| block |
	block := self paragraph characterBlockForIndex: aNumber.
	^ {self paragraph lines indexOf: block textLine. block left - self position x}
]

{ #category : #'as yet unclassified' }
SBMultilineOwnTextMorph >> maxWidth: aNumber [

	maxWidth := aNumber
]

{ #category : #'as yet unclassified' }
SBMultilineOwnTextMorph >> minExtent [

	self contents ifEmpty: [^ super minExtent].
	^ self paragraph extent
]

{ #category : #'as yet unclassified' }
SBMultilineOwnTextMorph >> mouseDown: anEvent [

	| block |
	block := self paragraph characterBlockAtPoint: anEvent position.
	self paragraph selectionStart: block selectionStop: block.
	self moveCursorTo: block stringIndex.
	
	self sandblockEditor ifNotNil: [:e | e cursor updateHorizontalOffset]
]

{ #category : #'as yet unclassified' }
SBMultilineOwnTextMorph >> mouseMove: anEvent [

	self cursor: (self cursorFromEvent: anEvent)
]

{ #category : #'as yet unclassified' }
SBMultilineOwnTextMorph >> moveCursor: aNumber selecting: aBoolean [

	(self hasSelection and: [aBoolean not]) ifTrue: [
		^ self moveCursorTo: (self betterCursorAfterSelectionTo: aNumber)].
	
	(self canMoveCursorDirection: aNumber) ifTrue: [self cursor: self cursor + aNumber].
	
	aBoolean ifFalse: [self selectionBound: self cursor]
]

{ #category : #'as yet unclassified' }
SBMultilineOwnTextMorph >> moveCursorTo: aNumber [

	self selectFrom: aNumber to: aNumber
]

{ #category : #'as yet unclassified' }
SBMultilineOwnTextMorph >> moveCursorVertically: aNumber ifAtBound: aBlock [

	self
		moveCursorVertically: aNumber
		selecting: (ActiveEvent ifNotNil: #shiftPressed ifNil: [false])
		ifAtBound: aBlock
]

{ #category : #'as yet unclassified' }
SBMultilineOwnTextMorph >> moveCursorVertically: aNumber selecting: aBoolean ifAtBound: aBlock [

	| data line |
	data := self lineNumberOfIndex: self cursor.
	
	(aNumber < 0 and: [(data first + aNumber) < 1])
		ifTrue: [
			self cursor: 1.
			aBlock value]
		ifFalse: [
			(aNumber > 0 and: [
				(data first + aNumber) > self paragraph numberOfLines])
				ifTrue: [
					self cursor: self contents size + 1.
					aBlock value]
				ifFalse: [
					line := data first + aNumber.
					data := self indexAtLine: line x: (self sandblockEditor ifNotNil: [:e | e cursor globalHorizontalOffset] ifNil: [data second]).
					
					self cursor: data first + data second]].
	
	aBoolean ifFalse: [self selectionBound: self cursor]
]

{ #category : #'as yet unclassified' }
SBMultilineOwnTextMorph >> multiLine [

	^ true
]

{ #category : #'as yet unclassified' }
SBMultilineOwnTextMorph >> paragraph [

	^ paragraph ifNil: [ | cursors |
		paragraph := NewParagraph new
			compose: self contents asText
				style: TextStyle default
				from: 1
				in: (self position extent: (maxWidth ifNil: [9999]) @ 9999);
			adjustRightX;
			focused: true;
			showCaret: self cursor > 0.
		
		cursors := self selectionBounds.
		paragraph
			selectionStart: (paragraph characterBlockForIndex: cursors first)
			selectionStop: (paragraph characterBlockForIndex: cursors second)]
]

{ #category : #'as yet unclassified' }
SBMultilineOwnTextMorph >> privateMoveBy: delta [ 

	super privateMoveBy: delta.
	
	paragraph ifNotNil: [:p | p moveBy: delta]
]

{ #category : #'as yet unclassified' }
SBMultilineOwnTextMorph >> selectFrom: aNumber to: anotherNumber [

	self
		cursor: (anotherNumber clampLow: 1 high: self contents size + 1);
		selectionBound: (aNumber clampLow: 1 high: self contents size + 1)
]

{ #category : #'as yet unclassified' }
SBMultilineOwnTextMorph >> selection [

	| cursors |
	self hasSelection ifFalse: [^ ''].
	cursors := self selectionBounds.
	^ self contents copyFrom: cursors first to: cursors second - 1
]

{ #category : #'as yet unclassified' }
SBMultilineOwnTextMorph >> selectionBound [

	^ selectionBound
]

{ #category : #'as yet unclassified' }
SBMultilineOwnTextMorph >> selectionBound: aNumber [

	selectionBound := aNumber.
	self updateCursor
]

{ #category : #'as yet unclassified' }
SBMultilineOwnTextMorph >> selectionBounds [

	^ {self selectionBound min: self cursor. self selectionBound max: self cursor}
]

{ #category : #'as yet unclassified' }
SBMultilineOwnTextMorph >> stopEditing [

	super stopEditing.
	self selectionBound: 0
]

{ #category : #'as yet unclassified' }
SBMultilineOwnTextMorph >> updateCursor [

	| bounds p |
	bounds := self selectionBounds.
	p := self paragraph.
	
	p
		selectionStart: (p characterBlockForIndex: bounds first)
		selectionStop: (p characterBlockForIndex: bounds second).
	p showCaret: bounds first > 0.
	
	self triggerEvent: #selectionChanged
]
