Class {
	#name : #SBOhmIdentifier,
	#superclass : #SBOhmTerminal,
	#category : #'Sandblocks-Ohm'
}

{ #category : #'as yet unclassified' }
SBOhmIdentifier >> contents: aString [

	super contents: aString withBlanksTrimmed
]

{ #category : #'as yet unclassified' }
SBOhmIdentifier >> keyStroke: anEvent [

	super keyStroke: anEvent.
	self validContents ifFalse: [
		self currentTextMorph deleteBeforeCursor.
		self grammarHandler perform: anEvent keyCharacter for: self empty: false]
]

{ #category : #'as yet unclassified' }
SBOhmIdentifier >> symbols [

	^ #(nil nil)
]

{ #category : #'as yet unclassified' }
SBOhmIdentifier >> valid [

	^ self containingArtefact submorphs anySatisfy: [:rule | rule name = self contents]
]

{ #category : #'as yet unclassified' }
SBOhmIdentifier >> validContents [

	self contents ifEmpty: [^ false].
	^ self contents first isLetter and: [self contents viewAllButFirst allSatisfy: [:c | c isAlphaNumeric]]
]
