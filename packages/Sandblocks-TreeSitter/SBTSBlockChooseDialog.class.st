Class {
	#name : #SBTSBlockChooseDialog,
	#superclass : #DialogWindow,
	#instVars : [
		'query',
		'currentBlocks',
		'currentValues',
		'exploreBlock'
	],
	#category : #'Sandblocks-TreeSitter'
}

{ #category : #'as yet unclassified' }
SBTSBlockChooseDialog >> do: aBlock query: aString [

	query := aString.
	exploreBlock := aBlock.
	self update.
	
	currentValues ifEmpty: [^ nil].
	^ currentValues size = 1 ifTrue: [currentValues first] ifFalse: [
		(ProvideAnswerNotification signal: nil) ifNotNil: [:answer |
			(answer = #cancel or: [answer isNil]) ifTrue: [^ nil].
			^ currentValues at: answer].
		self getUserResponseAtHand]
]

{ #category : #'as yet unclassified' }
SBTSBlockChooseDialog >> keyStroke: anEvent [

	({
		Character cr.
		Character escape.
		Character arrowDown.
		Character arrowLeft.
		Character arrowUp.
		Character arrowRight.
		Character tab} includes: anEvent keyCharacter) ifTrue: [^ super keyStroke: anEvent].
	
	anEvent keyCharacter = Character backspace
		ifTrue: [query := query allButLast]
		ifFalse: [query := query, anEvent keyCharacter].
	
	self update
]

{ #category : #'as yet unclassified' }
SBTSBlockChooseDialog >> update [

	currentBlocks := exploreBlock value: query.
	currentValues := currentBlocks.
	
	currentValues size = 1
		ifTrue: [self closeDialog: currentValues first]
		ifFalse: [self updateBlocks]
]

{ #category : #'as yet unclassified' }
SBTSBlockChooseDialog >> updateBlocks [

	buttonRow removeAllMorphs.
	currentValues with: currentBlocks do: [:block :value |
		self
			createButton: (block
				fullBounds;
				yourself)
			value: value].
	currentValues ifNotEmpty: [
		self selectedButtonIndex: 1.
		self preferredPosition: self selectedButton.
		self moveToPreferredPosition]
]
