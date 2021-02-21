Class {
	#name : #SBStMorphPalette,
	#superclass : #SBPalette,
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBStMorphPalette class >> buildOn: aContainer [

	aContainer
		addHeader: 'Morph';
		addSectionHeader: 'Examples'.
	(aContainer selectedBlock notNil and: [aContainer selectedBlock containingArtefact notNil]) ifTrue: [
		aContainer
			addBlock: 'Example'
			as: (SBStMethod new
				selector: #example arguments: #() class: aContainer selectedBlock containingArtefact relatedClass;
				hasUnsavedChanges: true;
				statements: {SBMorphExample buildTemplateFor: aContainer selectedBlock extent: 40 asPoint})]
]

{ #category : #'as yet unclassified' }
SBStMorphPalette class >> context [

	^ #(#isSmalltalk)
]

{ #category : #'as yet unclassified' }
SBStMorphPalette >> grammarHandler [

	^ SBStGrammarHandler new
]

{ #category : #'as yet unclassified' }
SBStMorphPalette >> matchesBlock: aBlock [

	^ aBlock containingArtefact relatedClass inheritsFrom: Morph
]
