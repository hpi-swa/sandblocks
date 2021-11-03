Class {
	#name : #SBPyPalette,
	#superclass : #SBPalette,
	#category : #'Sandblocks-Python'
}

{ #category : #'as yet unclassified' }
SBPyPalette class >> buildOn: aBuilder [

	aBuilder addSectionHeader: 'Python'.
	aBuilder addBlock: 'Open' as: (SBPython parse: 'open("")') childSandblocks first.
	aBuilder addBlock: 'Path' as: (SBPyFilepath new
		factory: SBPython new;
		path: '')
]

{ #category : #'as yet unclassified' }
SBPyPalette class >> context [

	^ {#isInlineBlock. [:block | block language = #python]}
]

{ #category : #'as yet unclassified' }
SBPyPalette class >> grammarHandler [

	^ SBMetaGrammarHandler new
]
