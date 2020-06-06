Class {
	#name : #SBMultilineOwnTextMorph,
	#superclass : #SBOwnTextMorph,
	#instVars : [
		'paragraph'
	],
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBMultilineOwnTextMorph >> contents: aString [

	super contents: aString.
	paragraph := nil
]

{ #category : #'as yet unclassified' }
SBMultilineOwnTextMorph >> cursor: aNumber [

	super cursor: aNumber.
	paragraph := nil
]

{ #category : #'as yet unclassified' }
SBMultilineOwnTextMorph >> drawOn: aCanvas [

	aCanvas
		paragraph: (self paragraph positionWhenComposed: self position)
		bounds: (self position extent: self paragraph extent)
		color: self color
]

{ #category : #'as yet unclassified' }
SBMultilineOwnTextMorph >> handlesMouseDown: anEvent [

	^ self hasCursor
]

{ #category : #'as yet unclassified' }
SBMultilineOwnTextMorph >> keyboardFocusColor [

	^ nil
]

{ #category : #'as yet unclassified' }
SBMultilineOwnTextMorph >> minExtent [

	^ self paragraph extent
]

{ #category : #'as yet unclassified' }
SBMultilineOwnTextMorph >> mouseDown: anEvent [

	| block |
	block := self paragraph characterBlockAtPoint: anEvent position.
	self paragraph selectionStart: block selectionStop: block.
	self cursor: block stringIndex
]

{ #category : #'as yet unclassified' }
SBMultilineOwnTextMorph >> paragraph [

	^paragraph ifNil: [
		paragraph := NewParagraph new
			compose: self contents asText
			style: TextStyle default
			from: 1
			in: (self position extent: 9999 @ 9999);
			adjustRightX;
			focused: true;
			showCaret: self cursor > 0;
			caretColor: Color red.
		
		paragraph
			selectionStart: (paragraph characterBlockForIndex: self cursor)
			selectionStop: (paragraph characterBlockForIndex: self cursor)]
]

{ #category : #'as yet unclassified' }
SBMultilineOwnTextMorph >> privateMoveBy: delta [ 

	super privateMoveBy: delta.
	
	paragraph ifNotNil: [:p | p moveBy: delta]
]
