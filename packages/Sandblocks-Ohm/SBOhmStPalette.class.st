Class {
	#name : #SBOhmStPalette,
	#superclass : #SBPalette,
	#category : #'Sandblocks-Ohm'
}

{ #category : #'as yet unclassified' }
SBOhmStPalette class >> buildOn: aBuilder [

	aBuilder
		addHeader: 'Grammar';
		addSectionHeader: 'Grammar';
		addBlock: 'Grammar' as: (SBOhmGrammar new addMorphBack: (SBOhmRule new name: '' alternatives: (self newNullBlock: 'expr')))
]

{ #category : #'as yet unclassified' }
SBOhmStPalette class >> context [

	^ {#isSandblock. #isSmalltalk}
]

{ #category : #'as yet unclassified' }
SBOhmStPalette class >> grammarHandler [

	^ SBOhmGrammarHandler new
]
