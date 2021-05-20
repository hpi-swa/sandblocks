Class {
	#name : #SBOhmIdentifier,
	#superclass : #SBOhmTerminal,
	#category : #'Sandblocks-Ohm'
}

{ #category : #'as yet unclassified' }
SBOhmIdentifier >> associatedRule [

	^ self containingArtefact rules detect: [:rule | rule key = self contents]
]

{ #category : #'as yet unclassified' }
SBOhmIdentifier >> contents: aString [

	super contents: aString withBlanksTrimmed
]

{ #category : #'as yet unclassified' }
SBOhmIdentifier >> isIdentifier [

	^ true
]

{ #category : #'as yet unclassified' }
SBOhmIdentifier >> isTerminal [

	^ false
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

	self containingArtefact isOhm ifFalse: [^ false].
	^ self containingArtefact rules anySatisfy: [:rule | rule key = self contents]
]

{ #category : #'as yet unclassified' }
SBOhmIdentifier >> validContents [

	self contents ifEmpty: [^ false].
	^ self contents first isLetter and: [self contents viewAllButFirst allSatisfy: [:c | c isAlphaNumeric]]
]

{ #category : #'as yet unclassified' }
SBOhmIdentifier >> writeSourceOn: aStream [

	aStream nextPutAll: self contents
]
