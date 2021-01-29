Class {
	#name : #SBDemoFormatter,
	#superclass : #Object,
	#instVars : [
		'stream',
		'indent',
		'parents',
		'preFormatCache',
		'literalLines'
	],
	#category : #'Sandblocks-Format'
}

{ #category : #'as yet unclassified' }
SBDemoFormatter class >> format: aMethodNode [

	| result formatter |
	SBExample self: [SBFormatter] args: [{(SBSignature >> #selectorAndEdit:) methodNode}] label: 'node test'.
	SBExample self: [SBFormatter] args: [{(SBSignature >> #addMessagePart) methodNode}] label: 'node test'.
	formatter := self new initForNode: aMethodNode.
	aMethodNode accept: formatter.
	SBExampleWatch report: (result := formatter contents) for: 971329700.
	SBLabel text: ['Sanity check to not produce invalid code'].
	self assert: aMethodNode asString = (Parser new parse: result class: aMethodNode methodClass) asString.
	^ result
]

{ #category : #'as yet unclassified' }
SBDemoFormatter class >> formatString: aString class: aClass noPattern: aBoolean [

	| formatter node methodNode |
	SBExample
		self: [SBDemoFormatter]
		args: [{'testMethod
  {$a.$b.$c.$d.$e.$f.$g.$h.$i}'. UndefinedObject. false}]
		label: 'brace node long'.
	node := self nodeFrom: aString class: aClass noPattern: aBoolean.
	formatter := self new initForNode: node.
	node accept: formatter.
	^ formatter contents
]

{ #category : #'as yet unclassified' }
SBDemoFormatter class >> nodeFrom: aString class: aClass noPattern: aBoolean [

	| methodNode |
	methodNode := Parser new parse: aString class: aClass noPattern: aBoolean notifying: nil ifFail: nil.
	^ aBoolean ifTrue: [methodNode body statements first expr] ifFalse: [methodNode]
]

{ #category : #'as yet unclassified' }
SBDemoFormatter >> blockStatementsOf: aNode [

	aNode statements ifEmpty: [^ #()].
	SBLabel text: ['note: this will also strip away legitimate return selfs'].
	^ (((self parentFor: aNode) isKindOf: MethodNode) and: [(aNode statements last isKindOf: ReturnNode) and: [aNode statements last isReturnSelf]]) ifTrue: [aNode statements allButLast] ifFalse: [aNode statements]
]

{ #category : #'as yet unclassified' }
SBDemoFormatter >> contents [
	^ stream contents copy replaceAll: (Character value: 0) with: Character cr
]

{ #category : #'as yet unclassified' }
SBDemoFormatter >> currentMaxLineLength [
	^ (self contents lines collect: #size) max
]

{ #category : #'as yet unclassified' }
SBDemoFormatter >> formatBlockStartOf: aNode startWithNewLine: aBoolean [

	stream nextPut: $[.
	aNode arguments ifNotEmpty: [:args |
		args do: [:arg |
			stream nextPut: $:.
			stream nextPutAll: arg name.
			stream space].
		stream nextPut: $|.
		aBoolean ifFalse: [stream space]]
]

{ #category : #'as yet unclassified' }
SBDemoFormatter >> formatTemporariesOf: aNode isMethod: isMethodBlock [

	| temporaries |
	temporaries := isMethodBlock ifTrue: [(self parentFor: aNode) temporaries] ifFalse: [aNode temporaries select: [:t | t scope ~= -2]].
	temporaries ifNotEmpty: [:temps | 
		isMethodBlock ifFalse: [stream space].
		stream nextPutAll: '| '.
		temps do: [:temp | stream nextPutAll: temp name] separatedBy: [stream space].
		stream nextPutAll: ' |'.
		isMethodBlock ifTrue: [self newLine]]
]

{ #category : #'as yet unclassified' }
SBDemoFormatter >> indent: aNumber [ 
	indent := aNumber
]

{ #category : #'as yet unclassified' }
SBDemoFormatter >> indent: aNumber around: aBlock [ 
	indent := indent + aNumber.
	aBlock value.
	indent := indent - aNumber
]

{ #category : #'as yet unclassified' }
SBDemoFormatter >> initForNode: aNode [ 
	parents := SBParentAssocVisitor getParentsFrom: aNode
]

{ #category : #'as yet unclassified' }
SBDemoFormatter >> initialize [

	super initialize.
	stream := '' writeStream.
	indent := 0.
	preFormatCache := Dictionary new.
	literalLines := OrderedCollection new
]

{ #category : #'as yet unclassified' }
SBDemoFormatter >> isMultiLineMessage: aNode [

	^ aNode arguments size > 1
		and: [(aNode originalSelector size + (aNode originalArguments inject: 0 into: [:sum :arg | sum + (self preFormat: arg) size])) > self maxLineLength]
]

{ #category : #'as yet unclassified' }
SBDemoFormatter >> literalLines [

	^ literalLines
]

{ #category : #'as yet unclassified' }
SBDemoFormatter >> maxLineLength [

	^ 20
]

{ #category : #'as yet unclassified' }
SBDemoFormatter >> needsParenthesisFor: aNode [

	SBExample self: [SBDemoFormatter new] args: [{'(self assert: 2) ifNotNil: 3' parseAsNode}] label: 'simple'.
	aNode isLeaf ifTrue: [^ false].
	(aNode isKindOf: ReturnNode) ifTrue: [^ false].
	aNode isBlockNode ifTrue: [^ false].
	(self parentFor: aNode) isBlockNode ifTrue: [^ false].
	(aNode isMessage and: [aNode originalSelector isUnary]) ifTrue: [^ false].
	(((self parentFor: aNode) isKindOf: CascadeNode) and: [
		aNode isMessage and: [
			aNode originalSelector isUnary not and: [(self parentFor: aNode) originalReceiver = aNode]]]) ifTrue: [^ true].
	(self precedenceOf: aNode) < (self precedenceOf: (self parentFor: aNode)) ifTrue: [^ false].
	^ true
]

{ #category : #'as yet unclassified' }
SBDemoFormatter >> newLine [
	stream crtab: indent
]

{ #category : #'as yet unclassified' }
SBDemoFormatter >> parentFor: aNode [ 
	^ parents at: aNode ifAbsent: [nil]
]

{ #category : #'as yet unclassified' }
SBDemoFormatter >> parents: aDictionary [ 
	parents := aDictionary
]

{ #category : #'as yet unclassified' }
SBDemoFormatter >> preFormat: aNode [

	| formatter |
	^ (preFormatCache
		at: aNode
		ifAbsentPut: [
			formatter := self class new.
			formatter parents: parents.
			formatter indent: indent.
			formatter preFormatCache: preFormatCache copy.
			aNode accept: formatter.
			{formatter rawContents. indent. formatter literalLines}]) first
]

{ #category : #'as yet unclassified' }
SBDemoFormatter >> preFormatCache: aDictionary [ 
	preFormatCache := aDictionary
]

{ #category : #'as yet unclassified' }
SBDemoFormatter >> precedenceOf: aNode [ 
	^ aNode accept: SBPrecedenceVisitor new
]

{ #category : #'as yet unclassified' }
SBDemoFormatter >> printArrayNode: aBraceNode on: aWriteStream [

	| width multiLine |
	width := aBraceNode elements inject: 0 into: [:sum :element | sum + (self preFormat: element) size].
	multiLine := width > self maxLineLength.
	
	aWriteStream nextPut: ${.
	self
		indent: (multiLine ifTrue: [1] ifFalse: [0])
		around: [
			aBraceNode elements
				do: [:element | self visitNode: element]
				separatedBy: [
					aWriteStream nextPut: $..
					multiLine ifTrue: [aWriteStream cr]]].
	aWriteStream nextPut: $}
]

{ #category : #'as yet unclassified' }
SBDemoFormatter >> printBraceNode2: aBraceNode on: aWriteStream [

	| multiLine width |
	width := aBraceNode elements inject: 0 into: [:sum :element | sum + (self preFormat: element) size].
	multiLine := width > self maxLineLength.
	
	aWriteStream nextPut: ${.
	self indent: (multiLine ifTrue: [1] ifFalse: [0]) around: [
	aBraceNode elements do: [:element | self visitNode: element] separatedBy: [aWriteStream nextPut: $.. multiLine ifTrue: [aWriteStream cr]]].
	aWriteStream nextPut: $}
]

{ #category : #'as yet unclassified' }
SBDemoFormatter >> printPragmas: aNode [

	aNode primitive > 0 ifTrue: [
		(aNode primitive between: 255 and: 519) ifFalse: [
			stream crtab: 1.
			aNode printPrimitiveOn: stream]].
	aNode printPragmasOn: stream
]

{ #category : #'as yet unclassified' }
SBDemoFormatter >> rawContents [

	^ stream contents
]

{ #category : #'as yet unclassified' }
SBDemoFormatter >> reindent: aStringAndIndentPair [

	| text currentIndent |
	SBExample self: [SBDemoFormatter new indent: 2] args: [{({'test
		a
		b
		c'. 2})}] label: 'same'.
	SBExample self: [SBDemoFormatter new indent: 3] args: [{({'test
		a
		b
		c'. 2})}] label: 'more'.
	SBExample self: [SBDemoFormatter new indent: 1] args: [{({'test
		a
		b
		c'. 2})}] label: 'less'.
	text := aStringAndIndentPair first.
	currentIndent := aStringAndIndentPair second.
	currentIndent ~= indent ifTrue: [ | lines |
		lines := text lines.
		2
			to: lines size
			do: [:index |
				lines
					at: index
					put: (currentIndent > indent
						ifTrue: [
							(lines at: index) allButFirst: currentIndent - indent]
						ifFalse: [
							(String new: indent - currentIndent withAll: Character tab), (lines at: index)])].
		text := lines joinSeparatedBy: Character cr].
	^ text
]

{ #category : #'as yet unclassified' }
SBDemoFormatter >> stream [
	^ stream
]

{ #category : #'as yet unclassified' }
SBDemoFormatter >> visitAssignmentNode: aNode [ 
	stream nextPutAll: aNode variable name.
	stream nextPutAll: ' := '.
	self visitNode: aNode value
]

{ #category : #'as yet unclassified' }
SBDemoFormatter >> visitBlockNode: aNode [

	| isMethodBlock startWithNewLine |
	isMethodBlock := (self parentFor: aNode) isKindOf: MethodNode.
	startWithNewLine := isMethodBlock not and: [
		aNode statements size > 1 or: [self willBeMultiLine: aNode statements first]].
	isMethodBlock ifFalse: [
		self formatBlockStartOf: aNode startWithNewLine: startWithNewLine].
	self formatTemporariesOf: aNode isMethod: isMethodBlock.
	self
		indent: (startWithNewLine ifTrue: [1] ifFalse: [0])
		around: [ | statements |
			statements := self blockStatementsOf: aNode.
			startWithNewLine ifTrue: [self newLine].
			statements do: [:statement |
				(statement isLiteralNode and: [statement key = #sbEmptyLine])
					ifTrue: [self newLine]
					ifFalse: [
						self visitNode: statement.
						statement ~= statements last ifTrue: [
							stream nextPut: $..
							self newLine]]]].
	isMethodBlock ifFalse: [stream nextPut: $]]
]

{ #category : #'as yet unclassified' }
SBDemoFormatter >> visitBraceNode: aNode [

	| width multiLine |
	1 / 0.
	true ifTrue: [Transcript showln: 'Hello World'].
	{1. 2. 3. 4} select: #positive.
	width := aNode elements inject: 0 into: [:sum :element | sum + ((self preFormat: element) size + 2)].
	multiLine := width > self maxLineLength.
	stream nextPut: ${.
	self
		indent: (multiLine ifTrue: [1] ifFalse: [0])
		around: [
			aNode elements
				do: [:element | self visitNode: element]
				separatedBy: [
					stream
						nextPut: $.;
						space.
					multiLine ifTrue: [stream cr]]].
	stream nextPut: $}
]

{ #category : #'as yet unclassified' }
SBDemoFormatter >> visitCascadeNode: aNode [

	self visitNode: aNode receiver.
	self
		indent: 1
		around: [
			aNode messages do: [:message | 
				self newLine.
				self visitNode: message] separatedBy: [stream nextPut: $;]]
]

{ #category : #'as yet unclassified' }
SBDemoFormatter >> visitFutureNode: aNode [

	self flag: #fixme.
	self visitNode: aNode receiver.
	self assert: aNode futureArgs isEmpty.
	stream
		space;
		nextPutAll: aNode originalSelector;
		space;
		nextPutAll: aNode futureSelector
]

{ #category : #'as yet unclassified' }
SBDemoFormatter >> visitInstanceVariableNode: aNode [ 
	stream nextPutAll: aNode name
]

{ #category : #'as yet unclassified' }
SBDemoFormatter >> visitLiteralNode: aNode [

	aNode key isString
		ifTrue: [(aNode key copy replaceAll: Character cr with: (Character value: 0)) storeOn: stream]
		ifFalse: [aNode key printAsLiteralOn: stream]
]

{ #category : #'as yet unclassified' }
SBDemoFormatter >> visitLiteralVariableNode: aNode [ 
	stream nextPutAll: aNode name
]

{ #category : #'as yet unclassified' }
SBDemoFormatter >> visitMessageNode: aNode [

	| multiLine newLineAfterReceiver isInCascade |
	isInCascade := ((self parentFor: aNode) isKindOf: CascadeNode) and: [(self parentFor: aNode) originalReceiver ~= aNode].
	isInCascade ifFalse: [self visitNode: aNode originalReceiver].
	aNode originalSelector isUnary ifTrue: [
		isInCascade ifFalse: [stream space].
		^ stream nextPutAll: aNode originalSelector].
	multiLine := self isMultiLineMessage: aNode.
	aNode originalSelector isBinary ifTrue: [
		aNode originalSelector ~= #, ifTrue: [stream space].
		stream
			nextPutAll: aNode originalSelector;
			space.
		self indent: (multiLine ifTrue: [1] ifFalse: [0]) around: [self visitNode: aNode arguments first].
		^ self].
	newLineAfterReceiver := multiLine and: [aNode originalSelector keywords size > 1].
	self
		indent: (newLineAfterReceiver ifTrue: [1] ifFalse: [0])
		around: [
			isInCascade ifFalse: [
				newLineAfterReceiver ifTrue: [self newLine] ifFalse: [stream space]].
			self
				with: aNode originalSelector keywords
				and: aNode originalArguments
				do: [:keyword :argument |
					stream nextPutAll: keyword.
					stream space.
					self visitNode: argument]
				separatedBy: [
					multiLine ifTrue: [self newLine] ifFalse: [stream space]]]
]

{ #category : #'as yet unclassified' }
SBDemoFormatter >> visitMethodNode: aNode [

	aNode selector isUnary
		ifTrue: [stream nextPutAll: aNode selector]
		ifFalse: [
			self
				with: aNode selector keywords
				and: aNode arguments
				do: [:part :arg | 
					stream nextPutAll: part.
					stream space.
					self visitNode: arg]
				separatedBy: [stream space]].
	self printPragmas: aNode.
	self newLine.
	self indent: 1 around: [
		self newLine.
		self visitNode: aNode block]
]

{ #category : #'as yet unclassified' }
SBDemoFormatter >> visitNode: aNode [ 
	| needsParens |
	needsParens := self needsParenthesisFor: aNode.
	needsParens
		ifTrue: [stream nextPut: $(].
	preFormatCache
		at: aNode
		ifPresent: [:pair | stream
				nextPutAll: (self reindent: pair)]
		ifAbsent: [aNode accept: self].
	needsParens
		ifTrue: [stream nextPut: $)]
]

{ #category : #'as yet unclassified' }
SBDemoFormatter >> visitReturnNode: aNode [ 
	stream nextPutAll: '^ '.
	self visitNode: aNode expr
]

{ #category : #'as yet unclassified' }
SBDemoFormatter >> visitTempVariableNode: aNode [ 
	stream nextPutAll: aNode name
]

{ #category : #'as yet unclassified' }
SBDemoFormatter >> visitTrackedAssignmentNode: aNode [ 
	self visitAssignmentNode: aNode
]

{ #category : #'as yet unclassified' }
SBDemoFormatter >> visitVariableNode: aNode [ 
	stream nextPutAll: aNode name
]

{ #category : #'as yet unclassified' }
SBDemoFormatter >> willBeMultiLine: aNode [

	| text |
	text := self preFormat: aNode.
	^ (text includes: Character cr) or: [text size > 50]
]

{ #category : #'as yet unclassified' }
SBDemoFormatter >> with: aCollection and: anotherCollection do: aBlock separatedBy: anotherBlock [ 
	aBlock value: aCollection first value: anotherCollection first.
	2
		to: aCollection size
		do: [:index | 
			anotherBlock value.
			aBlock
				value: (aCollection at: index)
				value: (anotherCollection at: index)]
]
