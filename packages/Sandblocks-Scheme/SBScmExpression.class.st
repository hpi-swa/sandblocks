Class {
	#name : #SBScmExpression,
	#superclass : #SBScmASTNode,
	#instVars : [
		'quoted'
	],
	#category : #'Sandblocks-Scheme'
}

{ #category : #'as yet unclassified' }
SBScmExpression >> addedMorph: aMorph [

	super addedMorph: aMorph.
	
	self clearCache
]

{ #category : #converting }
SBScmExpression >> asLanguageBox: converter [
	<convert>

	converter
		if: [
			self elements size = 3 and: [
				self elements first contents = 'eval-lang' and: [self elements viewAllButFirst allSatisfy: [:e | e isKindOf: SBScmString]]]]
		do: [SBScmLanguageBox lang: self elements second contents source: self elements third contents]
]

{ #category : #'special form checking' }
SBScmExpression >> binding: aString for: block class: aClass ifPresent: aBlock [

	self quoted ifTrue: [^ aBlock value: (SBScmSymbol new contents: aString)].
	
	self
		withStatementsDo: [:l |
			l detect: [:s | s isSExpr and: [s ifDefinition: [:d | d = aString] otherwise: [false]]] ifFound: [:s | aBlock value: s]]
		ifNotApplicable: [].
	
	self
		ifWellFormedSpecialFormDo: [:f |
			(#('let' 'let*' 'letrec') includes: f) ifTrue: [
				self expressions second elements
					detect: [:pair | pair elements first contents = aString]
					ifFound: [:pair | ^ aBlock value: pair elements first]].
			f = 'define' ifTrue: [
				self elements second isSExpr
					ifTrue: [
						self elements second elements detect: [:arg | arg contents = aString] ifFound: [:arg | ^ aBlock value: arg]]
					ifFalse: [self elements second contents = aString ifTrue: [^ aBlock value: self elements second]]].
			(f = 'cond' and: [aString = 'else' and: [self elements last elements first = block]]) ifTrue: [^ aBlock value: block].
			f = 'lambda' ifTrue: [
				self elements second elements detect: [:arg | arg contents = aString] ifFound: [:arg | ^ aBlock value: arg]]]
		ifNone: [nil].
	^ super binding: aString for: block class: aClass ifPresent: aBlock
]

{ #category : #'as yet unclassified' }
SBScmExpression >> canDeleteChild: aBlock [

	^ self elements size > 1 or: [self quoted]
]

{ #category : #'as yet unclassified' }
SBScmExpression >> centerAlignSymbols [

	^ self height < (self fontToUse height * 2.2)
]

{ #category : #'as yet unclassified' }
SBScmExpression >> elements [

	^ self submorphs
]

{ #category : #'as yet unclassified' }
SBScmExpression >> expressions [

	^ self submorphs
]

{ #category : #'as yet unclassified' }
SBScmExpression >> fixedNumberOfChildren [

	^ false
]

{ #category : #'special form checking' }
SBScmExpression >> ifDefinition: aBlock otherwise: anotherBlock [

	^ self
		ifWellFormedSpecialFormDo: [:f |
			f = 'define'
				ifTrue: [
					aBlock value: (self submorphs second isSExpr ifTrue: [self submorphs second submorphs first contents] ifFalse: [self submorphs second contents])]
				ifFalse: anotherBlock]
		ifNone: anotherBlock
]

{ #category : #'special form checking' }
SBScmExpression >> ifSpecialFormDo: aBlock ifNone: anotherBlock [

	^ (self elements notEmpty and: [self elements first isIdentifier and: [(self specialForms includes: self elements first contents)]])
		ifTrue: [aBlock value: self elements first contents]
		ifFalse: anotherBlock
]

{ #category : #'special form checking' }
SBScmExpression >> ifWellFormedSpecialFormDo: aBlock ifNone: anotherBlock [

	| form let set |
	form := nil.
	let := [self elements size >= 3 and: [self elements second isSExpr and: [self elements second elements allSatisfy: [:expr | expr isSExpr and: [expr elements size = 2]]]]].
	set := [self elements size = 3].
	
	^ (self ifSpecialFormDo: [:f |
		(form := f) caseOf: {
			['if'] -> [self elements size = 4].
			['define'] -> [self elements size >= 3 and: [(self elements second isSExpr and: [self elements second elements allSatisfy: [:e | e isIdentifier or: [e isUnknown]]]) or: [self elements second in: [:e | e isIdentifier or: [e isUnknown]]]]].
			['lambda'] -> [self elements size >= 3 and: [self elements second isSExpr]].
			['let'] -> [let value].
			['let*'] -> [let value].
			['letrec'] -> [let value].
			['set!'] -> [set value and: [self elements second isIdentifier or: [self elements second isUnknown]]].
			['set-car!'] -> [set value].
			['set-cdr!'] -> [set value].
			['cond'] -> [self elements size >= 1].
			['begin'] -> [self elements size >= 2].
		}] ifNone: [false]) ifTrue: [aBlock value: form] ifFalse: anotherBlock
]

{ #category : #'as yet unclassified' }
SBScmExpression >> initialize [

	super initialize.
	
	quoted := false
]

{ #category : #'as yet unclassified' }
SBScmExpression >> insertCommandRequest: anAfterBoolean near: aBlock [

	^ (SBInsertCommand newFor: self containingArtefact)
		index: (self childSandblocks indexOf: aBlock) + (anAfterBoolean ifTrue: [1] ifFalse: [0]);
		container: self;
		morph: self newNullBlock;
		shouldMergeWithNext: true;
		yourself
]

{ #category : #'as yet unclassified' }
SBScmExpression >> isBlockBody [

	^ self ifSpecialFormDo: [:f | f = 'lambda' or:
		[f = 'define' and: [self elements size >= 2 and: [self elements second isSExpr]]]] ifNone: [false]
]

{ #category : #'special form checking' }
SBScmExpression >> isExpression [

	^ true
]

{ #category : #'as yet unclassified' }
SBScmExpression >> isMethodBody [

	^ false
]

{ #category : #'as yet unclassified' }
SBScmExpression >> isSExpr [

	^ true
]

{ #category : #layout }
SBScmExpression >> layoutCommands [

	| list |
	list := [self elements collect: #layoutCommands separatedBy: [self layoutSoftLineOrGap]].
	
	self elements ifEmpty: [
		^ SBAlgebraCommand container
			morph: self;
			data: {}].
	
	^ SBAlgebraCommand container
		morph: self;
		data: (self
			ifWellFormedSpecialFormDo: [:f | | e |
				e := self elements collect: #layoutCommands.
				f
					caseOf: {
						['if'] -> [
							{
								e first.
								SBAlgebraCommand gap.
								e second.
								SBAlgebraCommand indent data: {self layoutSoftLineOrGap. e third. self layoutSoftLineOrGap. e fourth}}].
						['define'] -> [{e first. SBAlgebraCommand gap. e second. SBAlgebraCommand indent data: (list value viewAllButFirst: 3)}].
						['lambda'] -> [{e first. SBAlgebraCommand gap. e second. SBAlgebraCommand indent data: (list value viewAllButFirst: 3)}].
						['begin'] -> [
							{
								e first.
								SBAlgebraCommand indent data: {self layoutHardLine}, (self elements viewAllButFirst
									collect: #layoutCommands
									separatedBy: [self layoutHardLine])}].
						['cond'] -> [
							{
								e first.
								SBAlgebraCommand indent data: {self layoutHardLine}, (self elements viewAllButFirst
									collect: #layoutCommands
									separatedBy: [self layoutHardLine])}]}
					otherwise: list]
			ifNone: [{list value first. SBAlgebraCommand indent data: (list value viewAllButFirst: 1)}])
]

{ #category : #layout }
SBScmExpression >> layoutHardLine [

	^ SBAlgebraCommand hardLine withGap: SBScmASTNode displayParens not
]

{ #category : #layout }
SBScmExpression >> layoutSoftLineOrGap [

	^ SBAlgebraCommand softLineOrGap withGap: SBScmASTNode displayParens not
]

{ #category : #'as yet unclassified' }
SBScmExpression >> minimumHeight [

	^ TextStyle defaultFont height + 4
]

{ #category : #'as yet unclassified' }
SBScmExpression >> printOn: aStream [

	self
		ifWellFormedSpecialFormDo: [:f | aStream nextPutAll: 'special form '; nextPutAll: f]
		ifNone: [
			(self elements size > 0 and: [self elements first isIdentifier])
				ifTrue: [aStream nextPutAll: 'apply '; nextPutAll: self elements first contents]
				ifFalse: [aStream nextPutAll: 'sexpr']]
]

{ #category : #'as yet unclassified' }
SBScmExpression >> quoted [

	^ quoted
]

{ #category : #'as yet unclassified' }
SBScmExpression >> quoted: aBoolean [

	quoted := aBoolean
]

{ #category : #'as yet unclassified' }
SBScmExpression >> specialForms [

	^ #('lambda' 'if' 'define' 'set!' 'let' 'let*' 'letrec' 'cond' 'begin' 'set-car!' 'set-cdr!')
]

{ #category : #'as yet unclassified' }
SBScmExpression >> statements [

	^ self expressions
]

{ #category : #'as yet unclassified' }
SBScmExpression >> symbols [

	self quoted ifTrue: [^ #('''(' ')')].
	^ SBScmASTNode displayParens ifTrue: [#('(' ')')] ifFalse: [#(' ' ' ')]
]

{ #category : #'as yet unclassified' }
SBScmExpression >> toggleQuoted [
	<action>
	
	self sandblockEditor do: ((SBMutatePropertyCommand newFor: self containingArtefact)
		target: self;
		selector: #quoted;
		value: self quoted not;
		oldValue: self quoted).
	self layoutChanged
]

{ #category : #'as yet unclassified' }
SBScmExpression >> valid [

	^ self ifSpecialFormDo: [:f | self ifWellFormedSpecialFormDo: [:fi | true] ifNone: [false]] ifNone: [true]
]

{ #category : #'as yet unclassified' }
SBScmExpression >> wantsExtraSpace [

	^ false
]

{ #category : #'special form checking' }
SBScmExpression >> withStatementsDo: aBlock ifNotApplicable: anotherBlock [
	" check if we are a form that supports containing multiple statements (e.g. let or begin) "
	
	(self parentSandblock notNil and: [self parentSandblock isSExpr]) ifTrue: [
		self parentSandblock ifWellFormedSpecialFormDo: [:f |
			f = 'cond' ifTrue: [self submorphs viewAllButFirst]] ifNone: []].
	
	^ self
		ifWellFormedSpecialFormDo: [:f |
			aBlock value: (f caseOf: {
				['lambda'] -> [self submorphs viewAllButFirst: 2].
				['define'] -> [self submorphs second isSExpr ifTrue: [self submorphs viewAllButFirst: 2] ifFalse: [^ anotherBlock value]].
				['begin'] -> [self submorphs viewAllButFirst].
				['let'] -> [self submorphs viewAllButFirst: 3].
			} otherwise: [^ anotherBlock value])]
		ifNone: anotherBlock
]

{ #category : #'as yet unclassified' }
SBScmExpression >> writeSourceOn: aStream [

	self quoted ifTrue: [aStream nextPut: $'].
	
	aStream nextPut: $(.
	self elements do: [:e | e writeSourceOn: aStream] separatedBy: [aStream space].
	aStream nextPut: $)
]

{ #category : #'special form checking' }
SBScmExpression >> writeSourceOn: aStream indent: aNumber [

	| multiLine print printSeparator |
	self isQuoted ifTrue: [aStream nextPut: $'].
	aStream nextPut: $(.
	multiLine := self elements size > 2 and: [((SBCounterStream count: [:s | self writeSourceOn: s]) + (aNumber * 2)) > 70].
	printSeparator := [multiLine ifTrue: [self crIndent: aNumber + 1 on: aStream] ifFalse: [aStream space]].
	print := [:elements | elements do: [:el | el writeSourceOn: aStream indent: aNumber + 1] separatedBy: printSeparator].
	self
		ifWellFormedSpecialFormDo: [:form |
			(#('if' 'define') includes: form)
				ifTrue: [
					self elements first writeSourceOn: aStream indent: aNumber.
					aStream space.
					print value: self elements viewAllButFirst]
				ifFalse: [print value: self elements]]
		ifNone: [print value: self elements].
	aStream nextPut: $)
]
