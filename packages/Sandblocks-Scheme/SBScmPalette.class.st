Class {
	#name : #SBScmPalette,
	#superclass : #SBPalette,
	#category : #'Sandblocks-Scheme'
}

{ #category : #'as yet unclassified' }
SBScmPalette class >> buildOn: aContainer [

	aContainer
		addHeader: 'Scheme';
		addSectionHeader: 'Operators';
		addBlock: 'Generic'
			as: (SBScmExpression new addAllMorphs: {self newNullBlock: 'operator'. self newNullBlock: 'operand1'. self newNullBlock: 'operand2'});
		addBlock: 'Addition'
			as: (SBScmExpression new addAllMorphs: {SBScmIdentifier new contents: '+'. self newNullBlock: 'operand1'. self newNullBlock: 'operand2'});
		addBlock: 'Subtraction'
			as: (SBScmExpression new addAllMorphs: {SBScmIdentifier new contents: '-'. self newNullBlock: 'operand1'. self newNullBlock: 'operand2'});
		addBlock: 'Equals'
			as: (SBScmExpression new addAllMorphs: {SBScmIdentifier new contents: '='. self newNullBlock: 'operand1'. self newNullBlock: 'operand2'});
		addBlock: 'Larger than'
			as: (SBScmExpression new addAllMorphs: {SBScmIdentifier new contents: '>'. self newNullBlock: 'operand1'. self newNullBlock: 'operand2'});
		addBlock: 'Larger or equal than'
			as: (SBScmExpression new addAllMorphs: {SBScmIdentifier new contents: '>='. self newNullBlock: 'operand1'. self newNullBlock: 'operand2'});
		addBlock: 'Smaller than'
			as: (SBScmExpression new addAllMorphs: {SBScmIdentifier new contents: '<'. self newNullBlock: 'operand1'. self newNullBlock: 'operand2'});
		addBlock: 'Smaller or equal than'
			as: (SBScmExpression new addAllMorphs: {SBScmIdentifier new contents: '<='. self newNullBlock: 'operand1'. self newNullBlock: 'operand2'});
		addBlock: 'Or'
			as: (SBScmExpression new addAllMorphs: {SBScmIdentifier new contents: 'or'. self newNullBlock: 'bool1'. self newNullBlock: 'bool2'});
		addBlock: 'And'
			as: (SBScmExpression new addAllMorphs: {SBScmIdentifier new contents: 'and'. self newNullBlock: 'bool1'. self newNullBlock: 'bool2'});
		addSectionHeader: 'Definitions';
		addBlock: 'Define Function' as: (SBScmExpression new addAllMorphs: {
			SBScmIdentifier new contents: 'define'.
			SBScmExpression new addAllMorphs: {self newNullBlock: 'procedure'. self newNullBlock: 'arg1'}.
			self newNullBlock: 'expr'});
		addBlock: 'Define Binding'
			as: (SBScmExpression new addAllMorphs: {SBScmIdentifier new contents: 'define'. self newNullBlock: 'name'. self newNullBlock: 'value'});
		addBlock: 'let' as: (SBScmExpression new addAllMorphs: {
			SBScmIdentifier new contents: 'let'.
			SBScmExpression new addMorphBack: (SBScmExpression new addAllMorphs: {self newNullBlock: 'var'. self newNullBlock: 'value'}).
			self newNullBlock: 'expr'});
		addSectionHeader: 'Values / Data';
		addBlock: 'lambda' as: (SBScmExpression new addAllMorphs: {
			SBScmIdentifier new contents: 'lambda'.
			SBScmExpression new addMorphBack: (self newNullBlock: 'arg1').
			self newNullBlock: 'expr'});
		addBlock: 'cons Pair'
			as: (SBScmExpression new addAllMorphs: {SBScmIdentifier new contents: 'cons'. self newNullBlock: 'first'. self newNullBlock: 'second'});
		addBlock: 'Get 1st element of pair'
			as: (SBScmExpression new addAllMorphs: {SBScmIdentifier new contents: 'car'. self newNullBlock: 'pair'});
		addBlock: 'Get 2nd element of pair'
			as: (SBScmExpression new addAllMorphs: {SBScmIdentifier new contents: 'cdr'. self newNullBlock: 'pair'});
		addBlock: 'List'
			as: (SBScmExpression new addAllMorphs: {SBScmIdentifier new contents: 'list'. self newNullBlock: 'expr'});
		addBlock: 'Nil / Empty List' as: (SBScmExpression new quoted: true);
		addBlock: 'True' as: (SBScmBoolean new contents: 't');
		addBlock: 'False' as: (SBScmBoolean new contents: 'f');
		addSectionHeader: 'Control Flow';
		addBlock: 'if Condition' as: (SBScmExpression new addAllMorphs: {
			SBScmIdentifier new contents: 'if'.
			self newNullBlock: 'condition'.
			self newNullBlock: 'true'.
			self newNullBlock: 'false'});
		addBlock: 'cond Condition' as: (SBScmExpression new addAllMorphs: {
			SBScmIdentifier new contents: 'cond'.
			SBScmExpression new addAllMorphs: {self newNullBlock: 'condition1'. self newNullBlock: 'expr1'}});
		addSectionHeader: 'Higher-Order';
		addBlock: 'map'
			as: (SBScmExpression new addAllMorphs: {SBScmIdentifier new contents: 'map'. self newNullBlock: 'proc'. self newNullBlock: 'list'});
		addBlock: 'reduce' as: (SBScmExpression new addAllMorphs: {
			SBScmIdentifier new contents: 'reduce'.
			self newNullBlock: 'proc'.
			self newNullBlock: 'list'.
			self newNullBlock: 'initial'});
		addBlock: 'filter'
			as: (SBScmExpression new addAllMorphs: {SBScmIdentifier new contents: 'filter'. self newNullBlock: 'proc'. self newNullBlock: 'list'});
		addSectionHeader: 'Side Effects';
		addBlock: 'begin Statements'
			as: (SBScmExpression new addAllMorphs: {SBScmIdentifier new contents: 'begin'. self newNullBlock: 'expr1'});
		addBlock: 'set!'
			as: (SBScmExpression new addAllMorphs: {SBScmIdentifier new contents: 'set!'. self newNullBlock: 'name'. self newNullBlock: 'value'});
		addBlock: 'set-car!'
			as: (SBScmExpression new addAllMorphs: {SBScmIdentifier new contents: 'set-car!'. self newNullBlock: 'pair'. self newNullBlock: 'value'});
		addBlock: 'set-cdr!'
			as: (SBScmExpression new addAllMorphs: {SBScmIdentifier new contents: 'set-cdr!'. self newNullBlock: 'pair'. self newNullBlock: 'value'});
		addBlock: 'Display on console'
			as: (SBScmExpression new addAllMorphs: {SBScmIdentifier new contents: 'display'. self newNullBlock: 'expr'});
		addBlock: 'Newline on console'
			as: (SBScmExpression new addMorphBack: (SBScmIdentifier new contents: 'newline'));
		addSectionHeader: 'Smalltalk';
		addBlock: 'Perform'
			as: (SBScmExpression new addAllMorphs: {SBScmIdentifier new contents: 'perform'. self newNullBlock: 'object'. self newNullBlock: 'symbol'});
		addBlock: 'Language Box' as: (SBScmLanguageBox lang: 'smalltalk' source: '').
	
	SBToggledCode comment: '' active: 0 do: {
		[
			aContainer addSectionHeader: 'Your Definitions'.
			aContainer selection containingArtefact definitions do: [:def |
				def
					ifDefinition: [:name |
						aContainer
							addBlock: name
							as: (SBScmExpression new addMorphBack: (SBScmIdentifier new contents: name))]
					otherwise: []]]}
]

{ #category : #'as yet unclassified' }
SBScmPalette class >> context [

	^ #(isScheme)
]

{ #category : #'as yet unclassified' }
SBScmPalette class >> grammarHandler [

	^ SBScmGrammarHandler new
]

{ #category : #'as yet unclassified' }
SBScmPalette class >> title [

	^ 'Scheme'
]
