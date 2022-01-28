Class {
	#name : #SBStPalette,
	#superclass : #SBPalette,
	#category : #'Sandblocks-Smalltalk'
}

{ #category : #'as yet unclassified' }
SBStPalette class >> buildOn: aContainer [

	aContainer
		addHeader: 'Smalltalk';
		addSectionHeader: 'Expressions';
		addBlock: 'Message Send'
			as: (SBStMessageSend new receiver: (self newNullBlock: 'receiver') selector: #message);
		addBlock: 'Assignment' as: (SBStMessageSend new
			binding: (self newNullBlock: 'name')
			value: (self newNullBlock: 'expr'));
		addSectionHeader: 'Data & Methods';
		addBlock: 'Array' as: (SBStArray new contents: {self newNullBlock: 'array element 1'});
		addBlock: 'Block' as: (SBStBlockBody new
			statements: {self newNullBlock: 'expr'};
			temporaries: {};
			bindings: {self newNullBlock: 'block arg'};
			yourself);
		addBlock: 'Point' as: (SBStMessageSend new
			receiver: (self newNullBlock: 'x')
			selector: #@
			arguments: {self newNullBlock: 'y'});
		addBlock: 'Method' as: (SBStMethod new
			selector: 'method' arguments: #() class: Morph;
			hResizing: #shrinkWrap;
			body: (SBStBlockBody new in: [:b | b statements: {self newNullBlock: 'body'}]));
		addBlock: 'Class' as: (SBStClass new category: 'UserObjects');
		addSectionHeader: 'Arithmetic Operators';
		addBlock: 'Addition' as: (SBStMessageSend new
			receiver: (self newNullBlock: 'a')
			selector: #+
			arguments: {self newNullBlock: 'b'});
		addBlock: 'Subtraction' as: (SBStMessageSend new
			receiver: (self newNullBlock: 'a')
			selector: #-
			arguments: {self newNullBlock: 'b'});
		addBlock: 'Multiplication' as: (SBStMessageSend new
			receiver: (self newNullBlock: 'a')
			selector: #*
			arguments: {self newNullBlock: 'b'});
		addBlock: 'Division' as: (SBStMessageSend new
			receiver: (self newNullBlock: 'a')
			selector: #/
			arguments: {self newNullBlock: 'b'});
		addBlock: 'Negation'
			as: (SBStMessageSend new receiver: (self newNullBlock: 'a') selector: #negated);
		addSectionHeader: 'Comparison Operators';
		addBlock: 'Equals' as: (SBStMessageSend new
			receiver: (self newNullBlock: 'a')
			selector: #=
			arguments: {self newNullBlock: 'b'});
		addBlock: 'Greater than' as: (SBStMessageSend new
			receiver: (self newNullBlock: 'a')
			selector: #>
			arguments: {self newNullBlock: 'b'});
		addBlock: 'Less than' as: (SBStMessageSend new
			receiver: (self newNullBlock: 'a')
			selector: #<
			arguments: {self newNullBlock: 'b'});
		addBlock: 'Greater or equal to' as: (SBStMessageSend new
			receiver: (self newNullBlock: 'a')
			selector: #>=
			arguments: {self newNullBlock: 'b'});
		addBlock: 'Less or equal to' as: (SBStMessageSend new
			receiver: (self newNullBlock: 'a')
			selector: #<=
			arguments: {self newNullBlock: 'b'});
		addSectionHeader: 'Lists';
		addBlock: 'Select' as: (SBStMessageSend new
			receiver: (self newNullBlock: 'list')
			selector: #select:
			arguments: {SBStBlockBody emptyWithDeclarations: {'each'}});
		addSectionHeader: 'Control Flow';
		addBlock: 'ifTrue:' as: (SBStMessageSend new
			receiver: (self newNullBlock: 'bool')
			selector: #ifTrue:
			arguments: {SBStBlockBody empty});
		addBlock: 'ifTrue:ifFalse:' as: (SBStMessageSend new
			receiver: (self newNullBlock: 'bool')
			selector: #ifTrue:ifFalse:
			arguments: {SBStBlockBody empty. SBStBlockBody empty}).
	SBToggledCode comment: '' active: 0 do: {
		[
			aContainer addBlock: 'Custom Morph' as: (SBStClassMethodEditor new category: 'UserObjects' superclass: Morph methodsDo: [:add :class |
				{
					add value: #initialization value: {
						SBStMethod new
							selector: 'initialize' arguments: #() class: class;
							body: (SBStBlockBody new in: [:b |
								b statements: {
									SBStMessageSend new receiver: (SBStName contents: 'super') selector: #initialize.
									self newNullBlock: 'body'}])}.
					add value: #stepping value: {
						SBStMethod new
							selector: 'step' arguments: #() class: class;
							body: (SBStBlockBody new in: [:b | b statements: {self newNullBlock: 'body'}]).
						SBStMethod new
							selector: 'stepTime' arguments: #() class: class;
							body: (SBStBlockBody new in: [:b | b statements: {SBStReturn new expression: (SBStNumber new contents: '1')}])}.
					add value: #drawing value: {
						SBStMethod new
							selector: 'drawOn:' arguments: {SBStName contents: 'aCanvas'} class: class;
							body: (SBStBlockBody new in: [:b | b statements: {self newNullBlock: 'body'}])}.
					add value: #examples value: {
						SBStMethod new
							selector: #example arguments: #() class: class;
							statements: {SBMorphExample buildTemplateFor: aContainer selectedBlock extent: 300 @ 200}}}])]}
]

{ #category : #'as yet unclassified' }
SBStPalette class >> context [

	^ #(isSmalltalk)
]

{ #category : #'as yet unclassified' }
SBStPalette class >> grammarHandler [

	^ SBStGrammarHandler new
]

{ #category : #'as yet unclassified' }
SBStPalette class >> title [

	^ 'Smalltalk'
]
