Class {
	#name : #SBStMorphPalette,
	#superclass : #SBPalette,
	#category : #'Sandblocks-Smalltalk'
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

	^ {#isSmalltalk. [:block | block containingArtefact satisfies: {#notNil. #isMethod. [:a | a relatedClass inheritsFrom: Morph]}]}
]

{ #category : #'as yet unclassified' }
SBStMorphPalette class >> grammarHandler [

	^ SBStGrammarHandler new
]
