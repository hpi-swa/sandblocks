Class {
	#name : #SBOhmPalette,
	#superclass : #SBPalette,
	#category : #'Sandblocks-Ohm'
}

{ #category : #'as yet unclassified' }
SBOhmPalette class >> buildOn: aBuilder [

	aBuilder
		addHeader: 'Ohm';
		addSectionHeader: 'Rules';
		addBlock: 'Define' as: (SBOhmRule new name: '' alternatives: (self newNullBlock: 'expr'));
		addSectionHeader: 'Groups';
		addBlock: 'OR' as: (SBOhmList new
			connect: 'OR'
			expressions: {self newNullBlock: 'expr1'. self newNullBlock: 'expr2'});
		addBlock: 'AND' as: (SBOhmList new
			connect: 'AND'
			expressions: {self newNullBlock: 'expr1'. self newNullBlock: 'expr2'});
		addSectionHeader: 'Predicates';
		addBlock: 'Lookahead'
			as: (SBOhmPredicate new expression: (self newNullBlock: 'lookahead') predicate: $&);
		addBlock: 'Negative Lookahead'
			as: (SBOhmPredicate new expression: (self newNullBlock: 'negation') predicate: $~);
		addSectionHeader: 'Quantifier';
		addBlock: 'Plus'
			as: (SBOhmQuantifier new expression: (self newNullBlock: 'expr') quantifier: $+);
		addBlock: 'Star'
			as: (SBOhmQuantifier new expression: (self newNullBlock: 'expr') quantifier: $*);
		addBlock: 'Option'
			as: (SBOhmQuantifier new expression: (self newNullBlock: 'expr') quantifier: $?);
		addSectionHeader: 'Symbols';
		addBlock: 'Terminal' as: SBOhmTerminal new;
		addBlock: 'Identifier' as: (self newNullBlock: 'identifier')
]

{ #category : #'as yet unclassified' }
SBOhmPalette class >> context [

	^ {#isSandblock. #isOhm}
]

{ #category : #'as yet unclassified' }
SBOhmPalette class >> grammarHandler [

	^ SBOhmGrammarHandler new
]
