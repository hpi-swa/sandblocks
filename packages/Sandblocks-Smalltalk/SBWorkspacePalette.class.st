Class {
	#name : #SBWorkspacePalette,
	#superclass : #SBPalette,
	#category : #'Sandblocks-Smalltalk'
}

{ #category : #'as yet unclassified' }
SBWorkspacePalette class >> buildOn: aContainer [

	aContainer
		addHeader: 'Notebook';
		addSectionHeader: 'Cells';
		addBlock: 'Smalltalk' as: (SBWatch new
			newIdentifier;
			expression: (SBLanguageBox new
				source: '' lang: 'smalltalk';
				setEmptyWithHint: 'Cell content ...'));
		addBlock: 'Scheme' as: (SBWatch new
			newIdentifier;
			expression: (SBLanguageBox new
				source: '' lang: 'scheme';
				setEmptyWithHint: 'Cell content ...'));
		addBlock: 'Javascript' as: (SBWatch new
			newIdentifier;
			expression: (SBLanguageBox new
				source: '' lang: 'js';
				setEmptyWithHint: 'Cell content ...'));
		addBlock: 'Comment' as: SBLabel new
]

{ #category : #'as yet unclassified' }
SBWorkspacePalette class >> context [

	^ {[:b | b containingArtefact isRepl]}
]
