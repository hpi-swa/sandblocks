Class {
	#name : #SBOwnTextMorph,
	#superclass : #Morph,
	#instVars : [
		'cursor',
		'contents',
		'emphasis',
		'suffix',
		'font'
	],
	#category : 'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBOwnTextMorph >> clear [

	self contents: ''
]

{ #category : #'as yet unclassified' }
SBOwnTextMorph >> clearEmphasis [

	self emphasis: TextEmphasis normal
]

{ #category : #'as yet unclassified' }
SBOwnTextMorph >> color [

	^ self sandblockForegroundColor
]

{ #category : #'as yet unclassified' }
SBOwnTextMorph >> contents [

	^ contents
]

{ #category : #'as yet unclassified' }
SBOwnTextMorph >> contents: aString [

	contents ~= aString ifTrue: [
		contents := aString.
		cursor := cursor min: aString size + 1.
	
		self
			changed;
			layoutChanged;
			triggerEvent: #contentsChanged]
]

{ #category : #'as yet unclassified' }
SBOwnTextMorph >> contentsAfterCursor [

	^ self contents copyFrom: self cursor to: self contents size
]

{ #category : #'as yet unclassified' }
SBOwnTextMorph >> contentsBeforeCursor [

	^ self contents copyFrom: 1 to: self cursor - 1
]

{ #category : #'as yet unclassified' }
SBOwnTextMorph >> cursor [

	^ cursor
]

{ #category : #'as yet unclassified' }
SBOwnTextMorph >> cursor: aNumber [

	cursor := aNumber.
	self changed
]

{ #category : #'as yet unclassified' }
SBOwnTextMorph >> deleteAfterCursor [

	self cursor <= self contents size ifTrue: [
		self contents: (self contents first: self cursor - 1), (self contents allButFirst: self cursor)]
]

{ #category : #'as yet unclassified' }
SBOwnTextMorph >> deleteBeforeCursor [

	self cursor <= 1 ifTrue: [^ self].
	
	self cursor = (self contents size + 1) ifTrue: [
		self contents: self contents allButLast.
		^ self].
	
	self contents: (self contents first: self cursor - 2), (self contents allButFirst: self cursor - 1).
	self moveCursorTo: self cursor - 1
]

{ #category : #'as yet unclassified' }
SBOwnTextMorph >> drawOn: aCanvas [

	| font cursorX colorToUse |
	font := self fontToUse.
	colorToUse := self color.
	self drawString: self contents on: aCanvas at: self position font: font color: colorToUse.
	
	suffix ifNotEmpty: [
		self drawString: self suffix on: aCanvas at: self position x + (font widthOfString: self contents) @ self position y font: font color: colorToUse].
	
	cursor > 0 ifTrue: [
		aCanvas clipBy: self bounds during: [:c |
			cursorX := (font widthOfString: self contents from: 1 to: cursor - 1) + self left.
			c line: cursorX @ self top to: cursorX @ self bottom width: 2 color: Color red]]
]

{ #category : #'as yet unclassified' }
SBOwnTextMorph >> drawString: aString on: aCanvas at: aPoint font: aFont color: aColor [

	SBColorPolicy usePango
		ifTrue: [
			PHPangoTextLayout new
				font: '6';
				text: aString;
				
				fullDrawOn: aCanvas
				transform: (MatrixTransform2x3 withOffset: self extent / 2 + self layoutBounds origin + aCanvas origin)
				color: aColor
				selectionColor: nil
				selectionFillColor: nil
				clip: (aCanvas clipRect translateBy: aCanvas origin)
				drawCursor: false
				finalPosition: self layoutBounds topLeft]
		ifFalse: [aCanvas drawString: aString at: aPoint font: aFont color: aColor]
]

{ #category : #'as yet unclassified' }
SBOwnTextMorph >> emphasis [

	^ emphasis
]

{ #category : #'as yet unclassified' }
SBOwnTextMorph >> emphasis: aTextEmphasis [

	emphasis := aTextEmphasis.
	self changed
]

{ #category : #'as yet unclassified' }
SBOwnTextMorph >> font [

	^ font
]

{ #category : #'as yet unclassified' }
SBOwnTextMorph >> font: aFont [

	font := aFont.
	self changed; layoutChanged
]

{ #category : #'as yet unclassified' }
SBOwnTextMorph >> fontToUse [

	^ (font ifNil: [TextStyle defaultFont]) emphasized: self emphasis emphasisCode
]

{ #category : #'as yet unclassified' }
SBOwnTextMorph >> fullContents [

	^ contents, suffix
]

{ #category : #'as yet unclassified' }
SBOwnTextMorph >> handlesKeyboard: anEvent [

	^ false
]

{ #category : #'as yet unclassified' }
SBOwnTextMorph >> handlesMouseDown: anEvent [

	^ false
]

{ #category : #'as yet unclassified' }
SBOwnTextMorph >> hasCursor [

	^ cursor > 0
]

{ #category : #'as yet unclassified' }
SBOwnTextMorph >> initialize [
	
	super initialize.
	self
		vResizing: #spaceFill;
		hResizing: #spaceFill.
	self extent: 0 @ 0.
	cursor := 0.
	suffix := ''.
	contents := ''.
	emphasis := TextEmphasis normal
]

{ #category : #'as yet unclassified' }
SBOwnTextMorph >> insertCharacter: aCharacter [

	self cursor > self contents size
		ifTrue: [self contents: self contents, aCharacter]
		ifFalse: [self contents: (self contents first: self cursor - 1), aCharacter, (self contents allButFirst: self cursor - 1)].
	self moveCursorTo: self cursor + 1
]

{ #category : #'as yet unclassified' }
SBOwnTextMorph >> insertString: aString [

	self cursor > self contents size
		ifTrue: [self contents: self contents, aString]
		ifFalse: [self contents: (self contents first: self cursor - 1), aString, (self contents allButFirst: self cursor - 1)].
	self moveCursorTo: self cursor + aString size
]

{ #category : #'as yet unclassified' }
SBOwnTextMorph >> isCursorAtEnd [

	^ self cursor = (self contents size + 1)
]

{ #category : #'as yet unclassified' }
SBOwnTextMorph >> isCursorAtStart [

	^ self cursor = 1
]

{ #category : #'as yet unclassified' }
SBOwnTextMorph >> keyStroke: anEvent [

	| char |
	char := anEvent keyCharacter.
	
	char = Character arrowLeft ifTrue: [^ self moveCursorTo: self cursor - 1].
	char = Character arrowRight ifTrue: [^ self moveCursorTo: self cursor + 1].
	char = Character backspace ifTrue: [^ self deleteBeforeCursor].
	char = Character delete ifTrue: [^ self deleteAfterCursor].
	
	anEvent commandKeyPressed ifTrue: [
		char = $h ifTrue: [^ self moveCursorTo: self cursor - 1].
		char = $l ifTrue: [^ self moveCursorTo: self cursor + 1].
		char = $a ifTrue: [^ self moveCursorTo: 1].
		char = $e ifTrue: [^ self moveCursorTo: self contents size + 1].
		char = $s ifTrue: [^ self contents: '']].
	
	self insertString: char asString
]

{ #category : #'as yet unclassified' }
SBOwnTextMorph >> keyboardFocusChange: weHaveFocus [

	self changed
]

{ #category : #'as yet unclassified' }
SBOwnTextMorph >> minExtent [

	| font |
	font := self fontToUse.
	^ (font widthOfString: self contents) @ font height max: 4 @ font height
]

{ #category : #'as yet unclassified' }
SBOwnTextMorph >> mouseDown: anEvent [

	anEvent hand newKeyboardFocus: self
]

{ #category : #'as yet unclassified' }
SBOwnTextMorph >> moveCursor: aNumber [

	self moveCursorTo: self cursor + aNumber
]

{ #category : #'as yet unclassified' }
SBOwnTextMorph >> moveCursorTo: aNumber [

	self cursor: (aNumber clampLow: 1 high: self contents size + 1)
]

{ #category : #'as yet unclassified' }
SBOwnTextMorph >> stopEditing [

	self cursor: 0
]

{ #category : #'as yet unclassified' }
SBOwnTextMorph >> suffix [

	^ suffix
]

{ #category : #'as yet unclassified' }
SBOwnTextMorph >> suffix: aString [

	suffix := aString
]

{ #category : #'as yet unclassified' }
SBOwnTextMorph >> wantsKeyboardFocus [

	^ false
]
