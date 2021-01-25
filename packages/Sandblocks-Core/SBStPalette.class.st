Class {
	#name : #SBStPalette,
	#superclass : #SBPalette,
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBStPalette >> grammarHandler [

	^ SBSmalltalkGrammarHandler new
]

{ #category : #'as yet unclassified' }
SBStPalette >> initialize [

	super initialize.
	
	self	
		addSectionHeader: 'Expressions';
		addBlock: 'Message Send' as: (SBMessageSend new receiver: (self newNullBlock: 'receiver') selector: #message);
		addBlock: 'Assignment' as: (SBAssignment new binding: (self newNullBlock: 'name') value: (self newNullBlock: 'expr'));
		
		addSectionHeader: 'Data';
		addBlock: 'Array' as: (SBArray new contents: {self newNullBlock: 'array element 1'});
		addBlock: 'Block' as: (SBBlockBody new statements: {self newNullBlock: 'expr'}; temporaries: {}; bindings: {self newNullBlock: 'block arg'}; yourself)
]
