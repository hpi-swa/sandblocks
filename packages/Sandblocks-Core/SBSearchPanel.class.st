Class {
	#name : #SBSearchPanel,
	#superclass : #SBTextBubble,
	#instVars : [
		'currentFocus',
		'currentFocusIndicator',
		'currentHighlights'
	],
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBSearchPanel >> clearHighlights [

	^ currentHighlights ifNotNil: [currentHighlights do: #detach]
]

{ #category : #'as yet unclassified' }
SBSearchPanel >> currentFocus: m [

	currentFocus := m.
	self isSelected ifFalse: [^ m ifNotNil: #select].
	currentFocusIndicator detach.
	currentFocus ifNotNil: [
		currentFocus attachDecorator: currentFocusIndicator.
		currentFocus ensureVisible]
]

{ #category : #'as yet unclassified' }
SBSearchPanel >> initialize [

	super initialize.
	self when: #contentsChanged send: #updateSearch to: self.
	currentFocusIndicator := SBMarkedDecorator new
]

{ #category : #'as yet unclassified' }
SBSearchPanel >> keyStroke: anEvent [

	anEvent keyCharacter = Character cr
		ifTrue: [
			currentFocus ifNotNil: #select.
			self sandblockEditor endInput.
			currentFocusIndicator detach]
		ifFalse: [super keyStroke: anEvent]
]

{ #category : #'as yet unclassified' }
SBSearchPanel >> matchesQuery: aMorph [

	^ aMorph textContents asLowercase includesSubstring: self contents asLowercase
]

{ #category : #'as yet unclassified' }
SBSearchPanel >> nextSearchResult [
	<globalAction>

	| start |
	start := currentFocus ifNil: [self sandblockEditor].
	self
		searchFrom: start
		ifNone: [start ~= self sandblockEditor ifTrue: [self searchFrom: self sandblockEditor ifNone: [nil]]]
]

{ #category : #'as yet unclassified' }
SBSearchPanel >> prefix [

	^ 'Search: /'
]

{ #category : #'as yet unclassified' }
SBSearchPanel >> searchFrom: aMorph ifNone: aBlock [

	(aMorph nextBlockThat: [:m | self matchesQuery: m]) ifNotNil: [:m | self currentFocus: m] ifNil: aBlock
]

{ #category : #'as yet unclassified' }
SBSearchPanel >> startSearch [
	<globalAction>

	currentFocus := self sandblockEditor selection.
	self sandblockEditor startInput: self at: 900000000 replacingContents: true
]

{ #category : #'as yet unclassified' }
SBSearchPanel >> textContents [

	^ ''
]

{ #category : #'as yet unclassified' }
SBSearchPanel >> updateResultHighlights [

	self clearHighlights.
	
	currentHighlights := Array streamContents: [:stream |
		self sandblockEditor allBlocksDo: [:b |
			(self ~= b and: [self matchesQuery: b]) ifTrue: [ | decorator |
				decorator := SBHighlightDecorator new.
				stream nextPut: decorator]]]
]

{ #category : #'as yet unclassified' }
SBSearchPanel >> updateSearch [

	(SBWatch report: self contents for: 428507844) ifEmpty: [
		self clearHighlights.
		^ self].
	(currentFocus isNil or: [(self matchesQuery: currentFocus) not]) ifTrue: [self nextSearchResult].
	self updateResultHighlights
]
