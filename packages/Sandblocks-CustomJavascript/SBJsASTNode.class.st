Class {
	#name : #SBJsASTNode,
	#superclass : #SBBlock,
	#category : #'Sandblocks-CustomJavascript'
}

{ #category : #'as yet unclassified' }
SBJsASTNode class >> icon [
	^ Form
	extent: 16@16
	depth: 32
	fromArray: #( 4294370048 4294436096 4294436096 4294436096 4294436096 4294436096 4294436096 4294436096 4294436096 4294436096 4294436096 4294436096 4294436096 4294436096 4294435840 4294370048 4294435840 4294436352 4294436352 4294436352 4294436352 4294436352 4294436352 4294436352 4294436352 4294436352 4294436352 4294436352 4294436352 4294436352 4294436096 4294435840 4294436096 4294436352 4294436352 4294436352 4294436352 4294436352 4294436352 4294436352 4294436352 4294436352 4294436352 4294436352 4294436352 4294436352 4294436352 4294436096 4294436096 4294436352 4294436352 4294436352 4294436352 4294436352 4294436352 4294436352 4294436352 4294436352 4294436352 4294436352 4294436352 4294436352 4294436352 4294436096 4294436096 4294436352 4294436352 4294436352 4294436352 4294436352 4294436352 4294436352 4294436352 4294436352 4294436352 4294436352 4294436352 4294436352 4294436352 4294436096 4294436096 4294436352 4294436352 4294436352 4294436352 4294436352 4294436352 4294436352 4294436352 4294436352 4294436352 4294436352 4294502144 4294436352 4294436352 4294436096 4294436096 4294436352 4294436352 4294436352 4294436352 4294436352 4294436352 4294700800 4294635008 4294436096 4294634496 4294701056 4294635008 4294701056 4294502144 4294436096 4294436096 4294436352 4294436352 4294436352 4294436352 4294502144 4294502656 4286082560 4286740224 4294701312 4292002304 4283977984 4282399488 4287924224 4294304768 4294436352 4294436096 4294436352 4294436352 4294436352 4294436352 4294502144 4294568704 4280689408 4282004480 4294568704 4280886528 4280360450 4282991360 4280031490 4292659968 4294568448 4294436096 4294436352 4294436352 4294436352 4294436352 4294502144 4294568448 4281347072 4282728192 4294040576 4278255872 4284701184 4294701312 4294172928 4294502656 4294436096 4294436096 4294436352 4294436352 4294436352 4294436352 4294502144 4294568448 4281347072 4282465024 4294833152 4284964352 4278190080 4281347072 4289240064 4294568448 4294436352 4294436096 4294436352 4294436352 4294436352 4294502656 4294634752 4294568704 4281347072 4282399232 4294767104 4294701056 4288516608 4281018113 4278190080 4287792384 4294701056 4294436096 4294436352 4294436352 4294502400 4293712128 4292199680 4294833152 4281083904 4282465024 4294173952 4290094848 4294634752 4294700800 4280623617 4281872896 4294634496 4294436096 4294436352 4294502144 4294701312 4285950720 4278584577 4283320320 4278190080 4286608384 4291739136 4278190080 4281478400 4283780864 4278190080 4285490432 4294701056 4294435840 4294436096 4294436096 4294502656 4292989184 4285424896 4282202112 4285885184 4293778432 4294634496 4290029056 4283451648 4282136320 4286411520 4293843968 4294502144 4294435840 4294436096 4294436096 4294435840 4294502656 4294701056 4294634496 4294701056 4294502144 4294435840 4294635008 4294700800 4294634496 4294701312 4294502144 4294370048)
	offset: 0@0
]

{ #category : #'as yet unclassified' }
SBJsASTNode class >> registerShortcuts: aProvider [

	aProvider
		cmdShortcut: $} do: #wrapInObjectLiteral;
		cmdShortcut: ${ do: #wrapInKeywordBlock;
		cmdShortcut: $( do: #wrapInClosure;
		cmdShortcut: Character space do: #wrapInInfixOp;
		cmdShortcut: Character space shift do: #wrapInPrefixOp
]

{ #category : #'action helpers' }
SBJsASTNode >> actionProviders [

	^ {self grammarHandler}, super actionProviders
]

{ #category : #drawing }
SBJsASTNode >> centerAlignSymbols [

	^ false
]

{ #category : #printing }
SBJsASTNode >> evaluate [

	^ Smalltalk
		at: #Polyglot
		ifPresent: [:polyglot | polyglot eval: 'js' string: self sourceString withBindingsNamed: 'bindings']
		ifAbsent: [self error: 'no runtime for js available']
]

{ #category : #accessing }
SBJsASTNode >> grammarHandler [

	^ SBJsGrammarHandler new
]

{ #category : #converting }
SBJsASTNode >> inLanguageBox: converter [
	<convert>
	
	^ converter
		if: [self completeSubtree]
		do: [SBLanguageBox new source: self sourceString lang: 'js']
]

{ #category : #'initialize-release' }
SBJsASTNode >> initialize [

	super initialize.
	
	self
		hResizing: #shrinkWrap;
		vResizing: #shrinkWrap;
		layoutPolicy: SBAlgebraLayout new
]

{ #category : #testing }
SBJsASTNode >> isBinaryOperator [

	^ false
]

{ #category : #testing }
SBJsASTNode >> isClosure [

	^ false
]

{ #category : #testing }
SBJsASTNode >> isExpression [

	^ true
]

{ #category : #testing }
SBJsASTNode >> isJavascript [

	^ true
]

{ #category : #'as yet unclassified' }
SBJsASTNode >> isStatement [

	^ true
]

{ #category : #'as yet unclassified' }
SBJsASTNode >> isVariable [

	^ false
]

{ #category : #'action helpers' }
SBJsASTNode >> lookupAction: aSymbol [
	" first try our leaf class, then the grammar handler, then our base classes "

	self class lookupSelector: aSymbol upTo: SBJsASTNode ifPresent: [:m | (self isValidAction: m) ifTrue: [^ self]] ifAbsent: [].
	
	(self grammarHandler class lookupSelector: aSymbol) ifNotNil: [:m | (self isValidAction: m) ifTrue: [^ self grammarHandler]].
	
	(SBStASTNode superclass lookupSelector: aSymbol) ifNotNil: [:m | (self isValidAction: m) ifTrue: [^ self]].
	
	^ nil
]

{ #category : #'object interface' }
SBJsASTNode >> object [

	^ self
]

{ #category : #'as yet unclassified' }
SBJsASTNode >> objectInterfaceNear: aBlock at: aSymbol [

	(aSymbol = #replace or: [self dynamicNumberOfChildren]) ifTrue: [^ SBInterfaces jsExpression].
	^ SBInterfaces never
]

{ #category : #'as yet unclassified' }
SBJsASTNode >> preferredColor [

	^ Color r: 0.795 g: 0.57 b: 0.063
]

{ #category : #printing }
SBJsASTNode >> prettySourceString [

	^ self sourceString
]

{ #category : #printing }
SBJsASTNode >> sourceString [

	^ String streamContents: [:s | self writeSourceOn: s]
]

{ #category : #printing }
SBJsASTNode >> writeSourceOn: aStream [

	self subclassResponsibility
]
