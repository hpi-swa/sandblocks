Class {
	#name : #SBStPalette,
	#superclass : #SBPalette,
	#category : #'Sandblocks-Smalltalk'
}

{ #category : #'as yet unclassified' }
SBStPalette class >> buildOn: aContainer [

	aContainer
		addSectionHeader: 'Expressions';
		addBlock: 'Message Send'
			as: (SBStMessageSend new receiver: (self newNullBlock: 'receiver') selector: #message);
		addBlock: 'Assignment'
			as: (SBStAssignment new binding: (self newNullBlock: 'name') value: (self newNullBlock: 'expr'));
		addSectionHeader: 'Data & Methods';
		addBlock: 'Array' as: (SBStArray new contents: {self newNullBlock: 'array element 1'});
		addBlock: 'Block'
			as: (SBStBlockBody new
				statements: {self newNullBlock: 'expr'};
				temporaries: {};
				bindings: {self newNullBlock: 'block arg'};
				yourself);
		addBlock: 'Method'
			as: (SBStMethod new
				selector: 'method' arguments: #() class: Morph;
				hResizing: #shrinkWrap;
				body: (SBStBlockBody new in: [:b | b statements: {self newNullBlock: 'body'}]));
		addBlock: 'Class' as: (SBStClass new
			className: 'class';
			category: 'UserObjects');
		addSectionHeader: 'Operators';
		addBlock: 'Addition'
			as: (SBStMessageSend new receiver: (self newNullBlock: 'a') selector: #+ arguments: {self newNullBlock: 'b'});
		addBlock: 'Subtraction'
			as: (SBStMessageSend new receiver: (self newNullBlock: 'a') selector: #- arguments: {self newNullBlock: 'b'});
		addBlock: 'Multiplication'
			as: (SBStMessageSend new receiver: (self newNullBlock: 'a') selector: #* arguments: {self newNullBlock: 'b'});
		addBlock: 'Division'
			as: (SBStMessageSend new receiver: (self newNullBlock: 'a') selector: #/ arguments: {self newNullBlock: 'b'});
		addBlock: 'Equals'
			as: (SBStMessageSend new receiver: (self newNullBlock: 'a') selector: #= arguments: {self newNullBlock: 'b'});
		addSectionHeader: 'Lists';
		addBlock: 'Select'
			as: (SBStMessageSend new
				receiver: (self newNullBlock: 'list')
				selector: #select:
				arguments: {SBStBlockBody emptyWithDeclarations: {'each'}});
		addSectionHeader: 'Control Flow';
		addBlock: 'ifTrue:'
			as: (SBStMessageSend new receiver: (self newNullBlock: 'bool') selector: #ifTrue: arguments: {SBStBlockBody empty});
		addBlock: 'ifTrue:ifFalse:'
			as: (SBStMessageSend new
				receiver: (self newNullBlock: 'bool')
				selector: #ifTrue:ifFalse:
				arguments: {SBStBlockBody empty. SBStBlockBody empty})
]

{ #category : #'as yet unclassified' }
SBStPalette class >> context [

	^ #(isSmalltalk)
]

{ #category : #'as yet unclassified' }
SBStPalette class >> grammarHandler [

	^ SBStGrammarHandler new
]
