Class {
	#name : #SBOwnTextMorph,
	#superclass : #Morph,
	#instVars : [
		'cursor',
		'contents',
		'emphasis',
		'suffix',
		'font',
		'colorAlpha',
		'placeholderText'
	],
	#category : #'Sandblocks-Morphs'
}

{ #category : #'as yet unclassified' }
SBOwnTextMorph >> bold [

	self emphasis: TextEmphasis bold
]

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

	^ self sandblockForegroundColor alpha: colorAlpha
]

{ #category : #'as yet unclassified' }
SBOwnTextMorph >> colorAlpha [

	^ colorAlpha
]

{ #category : #'as yet unclassified' }
SBOwnTextMorph >> colorAlpha: aNumber [

	colorAlpha := aNumber.
	self changed
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
SBOwnTextMorph >> contentsToDisplay [

	^ self contents ifEmpty: [self placeholderText]
]

{ #category : #'as yet unclassified' }
SBOwnTextMorph >> cursor [

	^ cursor
]

{ #category : #'as yet unclassified' }
SBOwnTextMorph >> cursor: aNumber [

	cursor := aNumber.
	
	self sandblockEditor ifNil: [true] ifNotNil: [:e | e cursor resetBlink].
	
	self changed
]

{ #category : #'as yet unclassified' }
SBOwnTextMorph >> cursorColor [

	^ self sandblockEditor ifNotNil: [:e | e cursor color]
]

{ #category : #'as yet unclassified' }
SBOwnTextMorph >> cursorIndexForPosition: aPoint [

	| font offset index |
	font := self fontToUse.
	offset := aPoint x - self position x.
	index := 0.
	[offset > 0 and: [index < self contents size]] whileTrue: [
		index := index + 1.
		offset := offset - (font widthOf: (self contents at: index))].
	^ offset > 0 ifTrue: [index + 1] ifFalse: [index]
]

{ #category : #'as yet unclassified' }
SBOwnTextMorph >> cursorPosition [

	| font |
	font := self fontToUse.
	^ (self left + (font widthOfString: self contents from: 1 to: self cursor - 1)) @ self y
]

{ #category : #'as yet unclassified' }
SBOwnTextMorph >> cursorVisible [

	^ cursor > 0 and: [self sandblockEditor ifNil: [true] ifNotNil: [:e | e cursor cursorVisible]]
]

{ #category : #'as yet unclassified' }
SBOwnTextMorph >> deleteAfterCursor [

	self cursor <= self contents size ifTrue: [ | range rangeStop |
		range := self selectionBounds.
		rangeStop := range first = range second
			ifTrue: [range second]
			ifFalse: [range second - 1].
		self contents: (self contents first: range first - 1), (self contents allButFirst: rangeStop).
		self moveCursorTo: range first]
]

{ #category : #'as yet unclassified' }
SBOwnTextMorph >> deleteBeforeCursor [

	| range rangeStart |
	self cursor <= 1 ifTrue: [^ self].
	
	self cursor = (self contents size + 1) ifTrue: [
		self contents: self contents allButLast.
		^ self].
	
	range := self selectionBounds.
	rangeStart := range first = range second ifTrue: [range first - 2] ifFalse: [range first - 1].
	self contents: (self contents first: rangeStart), (self contents allButFirst: range second - 1).
	self moveCursorTo: rangeStart + 1
]

{ #category : #'as yet unclassified' }
SBOwnTextMorph >> displayDumbbellCursorOn: aCanvas at: leftX color: aColor [

	| w |
	" adapted from NewParagraph"
	w := 2.
	1 to: w do: [:i |
		"Draw caret triangles at top and bottom"
		aCanvas
			fillRectangle: (leftX - w + i - 1 @ (self top + i - 1) extent: w - i * 2 + 3 @ 1)
			color: aColor.
		aCanvas
			fillRectangle: (leftX - w + i - 1 @ (self bottom - i) extent: w - i * 2 + 3 @ 1)
			color: aColor].
	aCanvas line: leftX @ self top to: leftX @ (self bottom - 1) color: aColor
]

{ #category : #'as yet unclassified' }
SBOwnTextMorph >> displaySimpleCursorOn: aCanvas at: cursorX color: aColor [

	^ aCanvas
		line: cursorX @ self top to: cursorX @ self bottom color: aColor;
		line: cursorX + 1 @ self top to: cursorX + 1 @ self bottom color: (aColor alpha: 0.3)
]

{ #category : #'as yet unclassified' }
SBOwnTextMorph >> drawOn: aCanvas [

	| font cursorX colorToUse |
	font := self fontToUse.
	colorToUse := self color.
	
	self contents
		ifEmpty: [
			self
				drawString: self placeholderText
				on: aCanvas
				at: self position
				font: self placeholderFont
				color: (colorToUse alpha: 0.7)]
		ifNotEmpty: [self drawString: self contentsToDisplay on: aCanvas at: self position font: font color: colorToUse].
	
	suffix ifNotEmpty: [
		self
			drawString: self suffix
			on: aCanvas
			at: self position x + (font widthOfString: self contents) @ self position y
			font: font
			color: colorToUse].
	
	self cursorVisible ifTrue: [ | cursorColor |
		cursorColor := self cursorColor ifNil: [colorToUse].
		cursorX := (font widthOfString: self contentsToDisplay from: 1 to: cursor - 1) + self left.
		Editor dumbbellCursor
			ifTrue: [self displayDumbbellCursorOn: aCanvas at: cursorX - 1 color: cursorColor]
			ifFalse: [self displaySimpleCursorOn: aCanvas at: cursorX color: cursorColor]]
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

	^ (font ifNil: [TextStyle defaultFont])
		emphasized: (self emphasis == #derive ifTrue: [self containingSandblock emphasis] ifFalse: [self emphasis]) emphasisCode
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
	colorAlpha := 1.
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

	(self cursor > self contents size or: [self contents isEmpty])
		ifTrue: [self contents: self contents, aString]
		ifFalse: [self contents: (self contents first: self cursor - 1), aString, (self contents allButFirst: self cursor - 1)].
	self moveCursorTo: self cursor + aString size
]

{ #category : #'as yet unclassified' }
SBOwnTextMorph >> invalidRect: aRectangle [

	^ super invalidRect: (aRectangle expandBy: 2)
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
SBOwnTextMorph >> isTextMorph [

	^ true
]

{ #category : #'as yet unclassified' }
SBOwnTextMorph >> italic [

	self emphasis: TextEmphasis italic
]

{ #category : #'as yet unclassified' }
SBOwnTextMorph >> keyStroke: anEvent [

	| char |
	char := anEvent keyCharacter.
	
	({Character arrowUp. Character arrowDown. Character insert} includes: char) ifTrue: [^ self].
	(self multiLine not and: [char = Character cr]) ifTrue: [^ self].
	
	char = Character arrowLeft ifTrue: [^ self moveCursorTo: self cursor - 1].
	char = Character arrowRight ifTrue: [^ self moveCursorTo: self cursor + 1].
	char = Character backspace ifTrue: [^ self deleteBeforeCursor].
	char = Character delete ifTrue: [^ self deleteAfterCursor].
	
	self insertString: char asString
]

{ #category : #'as yet unclassified' }
SBOwnTextMorph >> keyboardFocusChange: weHaveFocus [

	self changed
]

{ #category : #'as yet unclassified' }
SBOwnTextMorph >> maxWidth: aNumber [

	
]

{ #category : #'as yet unclassified' }
SBOwnTextMorph >> minExtent [

	| font |
	font := self fontToUse.
	^ (font widthOfString: self contentsToDisplay) @ font height max: 4 @ font height
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
SBOwnTextMorph >> moveCursor: aNumber ifAtBound: aBlock wordWise: aBoolean [

	(aBoolean and: [(aNumber < 0 and: [self cursor = 1]) or: [aNumber > 0 and: [self cursor = (self contents size + 1)]]])
		ifTrue: [^ aBlock value].
	
	self
		moveCursorTo: (aBoolean
			ifTrue: [aNumber > 0 ifTrue: [self contents size + 1] ifFalse: [1]]
			ifFalse: [self cursor + aNumber])
		ifAtBound: aBlock
]

{ #category : #'as yet unclassified' }
SBOwnTextMorph >> moveCursorTo: aNumber [

	self cursor: (aNumber clampLow: 1 high: self contents size + 1)
]

{ #category : #'as yet unclassified' }
SBOwnTextMorph >> moveCursorTo: aNumber ifAtBound: aBlock [

	(aNumber < 1 or: [aNumber > (self contents size + 1)]) ifTrue: [^ aBlock value].
	self moveCursorTo: aNumber
]

{ #category : #'as yet unclassified' }
SBOwnTextMorph >> moveCursorVertically: aNumber ifAtBound: aBlock [

	aBlock value
]

{ #category : #'as yet unclassified' }
SBOwnTextMorph >> multiLine [

	^ false
]

{ #category : #'as yet unclassified' }
SBOwnTextMorph >> placeholderFont [

	^ (font ifNil: [TextStyle defaultFont]) emphasized: TextEmphasis italic emphasisCode
]

{ #category : #'as yet unclassified' }
SBOwnTextMorph >> placeholderText [

	^ placeholderText ifNil: ['']
]

{ #category : #'as yet unclassified' }
SBOwnTextMorph >> placeholderText: aString [

	placeholderText := aString.
	self layoutChanged
]

{ #category : #'as yet unclassified' }
SBOwnTextMorph >> selectionBounds [

	^ {self cursor. self cursor}
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
SBOwnTextMorph >> userString [

	^ self contents
]

{ #category : #'as yet unclassified' }
SBOwnTextMorph >> wantsKeyboardFocus [

	^ false
]

{ #category : #'as yet unclassified' }
SBOwnTextMorph >> wantsMetaMenu [

	^ false
]
