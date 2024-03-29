Extension { #name : #SBStGrammarHandler }

{ #category : #'*Sandblocks-Babylonian' }
SBStGrammarHandler >> addExample [
	<action>

	| method |
	self block isExample ifTrue: [^ self block toggleRunning].
	
	method := self block containingArtefact.
	self addExample: (self createExampleIn: method classed: method methodClass).
]

{ #category : #'*Sandblocks-Babylonian' }
SBStGrammarHandler >> addExample: anExample [

	| method |
	method := self block containingArtefact.
	
	self block sandblockEditor do: (SBInsertCommand new
		container: method body;
		index: 2;
		morph: anExample).
		
	anExample startRunning.
	self block sandblockEditor select: anExample nameBlock.
	self block sandblockEditor save: method tryFixing: true quick: false.
]

{ #category : #'*Sandblocks-Babylonian' }
SBStGrammarHandler >> createExampleIn: aMethod classed: aClass [

	^ SBExample new
			self: (aMethod isClassSide 
				ifTrue: [SBStName contents: aClass theNonMetaClassName] 
				ifFalse: [
					SBStMessageSend new
						receiver: (SBStName contents: aClass name)
						selector: (aMethod selector = #initialize ifTrue: [#basicNew] ifFalse: [#new])])
			args: (SBStArray new
				type: #dynamic
				contents: (aMethod arguments collect: [:anArgument | 
					self extractBlockFromArgumentName: anArgument contents]))
			label: 'example'.
]

{ #category : #'*Sandblocks-Babylonian' }
SBStGrammarHandler >> extractBlockFromArgumentName: aString [

	| classes |
	classes := self extractClassesFromName: aString.
	^ (classes second = UndefinedObject) 
		ifTrue: [classes first exampleBlock] 
		ifFalse: [classes first exampleBlockContainingClass: classes second]
]

{ #category : #'*Sandblocks-Babylonian' }
SBStGrammarHandler >> extractClassesFromName: aParameterName [

	"Working with groups isn't supported, so we do a nested request"
	"When it does work, use : '((?<=[\w*])[A-Z]\w*)[Oo]f([A-Z]\w*)s'"
	(aParameterName allRegexMatches: '(?<=[\w*])[A-Z]\w*')
		ifNotEmpty: [:theCollection | | argWOPrefix |
			argWOPrefix := theCollection first.
			(argWOPrefix matchesRegex: '[A-Z]\w*Of[A-Z]\w*s')
				ifFalse: [^ {self searchClassNamed: argWOPrefix. UndefinedObject}]
				ifTrue: [^ {
					self searchClassNamed: ((argWOPrefix allRegexMatches: '[A-Z]\w*(?=Of[A-Z]\w*s)') first). 
					self searchClassNamed: ((argWOPrefix allRegexMatches: '(?<=[A-Z]\w*Of)[A-Z]\w*(?=s)') first).}]].
		
	^ {UndefinedObject. UndefinedObject}
]

{ #category : #'*Sandblocks-Babylonian' }
SBStGrammarHandler >> searchClassNamed: aString [
	
	^ (self environment classNamed: aString) ifNil: [UndefinedObject]
]
