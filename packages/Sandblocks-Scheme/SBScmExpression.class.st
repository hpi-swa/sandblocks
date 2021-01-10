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
SBScmExpression >> childSandblocksDo: aBlock [

	self elements do: aBlock
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

{ #category : #'as yet unclassified' }
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
			['lambda'] -> [self elements size >= 3].
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

{ #category : #'as yet unclassified' }
SBScmExpression >> isMethodBody [

	^ false
]

{ #category : #'as yet unclassified' }
SBScmExpression >> isSExpr [

	^ true
]

{ #category : #'special form checking' }
SBScmExpression >> layoutCommands [

	| list |
	list := [self elements collect: #layoutCommands separatedBy: [SBAlgebraCommand softLineOrGap]].
	
	self elements ifEmpty: [^ SBAlgebraCommand container morph: self; data: {}].
	
	^ SBAlgebraCommand container
		morph: self;
		data: (self ifWellFormedSpecialFormDo: [:f | | e |
			e := self elements collect: #layoutCommands.
			f caseOf: {
				['if'] -> [{e first. SBAlgebraCommand gap. e second. SBAlgebraCommand indent data: {SBAlgebraCommand softLineOrGap. e third. SBAlgebraCommand softLineOrGap. e fourth}}].
				['define'] -> [{e first. SBAlgebraCommand gap. e second. SBAlgebraCommand indent data: (list value viewAllButFirst: 3)}].
				['lambda'] -> [{e first. SBAlgebraCommand gap. e second. SBAlgebraCommand indent data: (list value viewAllButFirst: 3)}].
				['begin'] -> [{e first. SBAlgebraCommand indent data: {SBAlgebraCommand hardLine}, (self elements viewAllButFirst collect: #layoutCommands separatedBy: [SBAlgebraCommand hardLine])}].
				['cond'] -> [{e first. SBAlgebraCommand indent data: {SBAlgebraCommand hardLine}, (self elements viewAllButFirst collect: #layoutCommands separatedBy: [SBAlgebraCommand hardLine])}]
			} otherwise: list] ifNone: [{list value first. SBAlgebraCommand indent data: (list value viewAllButFirst: 1)}])
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

	^ #('lambda' 'if' 'define' 'set!' 'let' 'let*' 'letrec' 'cond' 'begin')
]

{ #category : #'as yet unclassified' }
SBScmExpression >> statements [

	^ self expressions
]

{ #category : #'as yet unclassified' }
SBScmExpression >> symbols [

	self quoted ifTrue: [^ #('''(' ')')].
	^ #('(' ')')
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
