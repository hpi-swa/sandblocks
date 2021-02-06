Class {
	#name : #SBStPalette,
	#superclass : #SBPalette,
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBStPalette class >> buildOn: aContainer [

	aContainer
		addSectionHeader: 'Expressions';
		addBlock: 'Message Send'
			as: (SBMessageSend new receiver: (self newNullBlock: 'receiver') selector: #message);
		addBlock: 'Assignment'
			as: (SBAssignment new binding: (self newNullBlock: 'name') value: (self newNullBlock: 'expr'));
		addSectionHeader: 'Data & Methods';
		addBlock: 'Array' as: (SBArray new contents: {self newNullBlock: 'array element 1'});
		addBlock: 'Block'
			as: (SBBlockBody new
				statements: {self newNullBlock: 'expr'};
				temporaries: {};
				bindings: {self newNullBlock: 'block arg'};
				yourself);
		addBlock: 'Method'
			as: (SBMethod new
				selector: 'method' arguments: #() class: Morph;
				hResizing: #shrinkWrap;
				body: (SBBlockBody new in: [:b | b statements: {self newNullBlock: 'body'}]));
		addBlock: 'Class' as: (SBClass new
			className: 'class';
			category: 'UserObjects');
		addSectionHeader: 'Operators';
		addBlock: 'Addition'
			as: (SBMessageSend new receiver: (self newNullBlock: 'a') selector: #+ arguments: {self newNullBlock: 'b'});
		addBlock: 'Subtraction'
			as: (SBMessageSend new receiver: (self newNullBlock: 'a') selector: #- arguments: {self newNullBlock: 'b'});
		addBlock: 'Multiplication'
			as: (SBMessageSend new receiver: (self newNullBlock: 'a') selector: #* arguments: {self newNullBlock: 'b'});
		addBlock: 'Division'
			as: (SBMessageSend new receiver: (self newNullBlock: 'a') selector: #/ arguments: {self newNullBlock: 'b'});
		addBlock: 'Equals'
			as: (SBMessageSend new receiver: (self newNullBlock: 'a') selector: #= arguments: {self newNullBlock: 'b'});
		addSectionHeader: 'Lists';
		addBlock: 'Select'
			as: (SBMessageSend new
				receiver: (self newNullBlock: 'list')
				selector: #select:
				arguments: {SBBlockBody emptyWithDeclarations: {'each'}});
		addSectionHeader: 'Control Flow';
		addBlock: 'ifTrue:'
			as: (SBMessageSend new receiver: (self newNullBlock: 'bool') selector: #ifTrue: arguments: {SBBlockBody empty});
		addBlock: 'ifTrue:ifFalse:'
			as: (SBMessageSend new
				receiver: (self newNullBlock: 'bool')
				selector: #ifTrue:ifFalse:
				arguments: {SBBlockBody empty. SBBlockBody empty})
]

{ #category : #'as yet unclassified' }
SBStPalette class >> context [

	^ #isSmalltalkExpression
]

{ #category : #'as yet unclassified' }
SBStPalette class >> grammarHandler [

	^ SBSmalltalkGrammarHandler new
]
