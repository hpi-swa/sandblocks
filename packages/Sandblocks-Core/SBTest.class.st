Class {
	#name : #SBTest,
	#superclass : #TestCase,
	#category : #'Sandblocks-Core-Tests'
}

{ #category : #'as yet unclassified' }
SBTest >> editorFor: aBlock [

	| editor |
	editor := SBEditor new.
	editor openMorphInView: (SBMethod new
		selector: #test arguments: #() class: nil class;
		body: (SBBlockBody new statements: {aBlock})).
	aBlock select.
	^ editor
]

{ #category : #'as yet unclassified' }
SBTest >> keyboardEvent: aCharacter [

	^ KeyboardEvent new setType: #keyStroke buttons: 0 position: 0 @ 0 keyValue: aCharacter hand: nil stamp: nil
]
