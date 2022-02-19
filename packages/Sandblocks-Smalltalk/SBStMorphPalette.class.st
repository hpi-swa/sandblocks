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
	SBToggledCode comment: '' active: 0 do: {
		[
			(aContainer selectedBlock notNil and: [aContainer selectedBlock containingArtefact notNil]) ifTrue: [
				aContainer addBlock: 'Example' as: (SBStMethod new
					selector: #example
						arguments: #()
						class: aContainer selectedBlock containingArtefact relatedClass;
					statements: {SBMorphExample buildTemplateFor: aContainer selectedBlock extent: 40 asPoint})]]}.
	aContainer
		addSectionHeader: 'Geometry';
		addBlock: 'Set Position' as: (SBStMessageSend new
			receiver: (SBStName contents: 'self')
			selector: #position:
			arguments: {SBPoint new});
		addBlock: 'Get Position'
			as: (SBStMessageSend new receiver: (SBStName contents: 'self') selector: #position);
		addBlock: 'Move' as: (SBStMessageSend new
			receiver: (SBStName contents: 'self')
			selector: #moveBy:
			arguments: {self newNullBlock: 'point'});
		addBlock: 'Set Extent' as: (SBStMessageSend new
			receiver: (SBStName contents: 'self')
			selector: #extent:
			arguments: {SBPoint new});
		addBlock: 'Left'
			as: (SBStMessageSend new receiver: (SBStName contents: 'self') selector: #left);
		addBlock: 'Right'
			as: (SBStMessageSend new receiver: (SBStName contents: 'self') selector: #right);
		addBlock: 'Top'
			as: (SBStMessageSend new receiver: (SBStName contents: 'self') selector: #top);
		addBlock: 'Bottom'
			as: (SBStMessageSend new receiver: (SBStName contents: 'self') selector: #bottom);
		addSectionHeader: 'Hierarchy';
		addBlock: 'Owner'
			as: (SBStMessageSend new receiver: (SBStName contents: 'self') selector: #owner);
		addBlock: 'Submorphs'
			as: (SBStMessageSend new receiver: (SBStName contents: 'self') selector: #submorphs);
		addBlock: 'World'
			as: (SBStMessageSend new receiver: (SBStName contents: 'self') selector: #world);
		addBlock: 'Color' as: (SBStMessageSend new
			receiver: (SBStName contents: 'self')
			selector: #color:
			arguments: {SBColor new})
]

{ #category : #'as yet unclassified' }
SBStMorphPalette class >> context [

	^ {#isSmalltalk. [:block | block containingArtefact satisfies: {#notNil. #isMethod. [:a | a relatedClass includesBehavior: Morph]}]}
]

{ #category : #'as yet unclassified' }
SBStMorphPalette class >> grammarHandler [

	^ SBStGrammarHandler new
]
