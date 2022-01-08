Class {
	#name : #SBScmASTNode,
	#superclass : #SBBlock,
	#classVars : [
		'DisplayParens'
	],
	#category : #'Sandblocks-Scheme'
}

{ #category : #'as yet unclassified' }
SBScmASTNode class >> displayParens [

	^ DisplayParens ifNil: [true]
]

{ #category : #'as yet unclassified' }
SBScmASTNode class >> displayParens: aBoolean [

	DisplayParens := aBoolean
]

{ #category : #'as yet unclassified' }
SBScmASTNode class >> icon [

	^ (Form
	extent: 16@16
	depth: 32
	fromArray: #( 0 0 0 0 0 1057953322 2132749652 2132749652 2132749652 2132749652 2132749652 0 0 0 0 0 0 0 0 1061109567 3217014719 4294967295 4291745257 4282276777 4282276777 4282276777 4282276777 4282276777 2116301142 0 0 0 0 0 1059522312 4291792527 4294967295 4294967295 4294967295 4291745513 4282276777 4282276777 4282276777 4282276777 4282276777 3207480446 0 0 0 1059588104 4288617760 4288617760 4290205015 4293379783 4294967295 4294967295 4291745513 4282276777 4282276777 4282276777 4282276777 4282276777 3124317571 0 0 3212252440 4288617760 4288617760 4288617760 4288617760 4293379783 4294967295 4294967295 4291745513 4282276777 4282276777 4282276777 4282276777 4282276777 1057953322 1059587848 4288617760 4288617760 4288617760 4288617760 4288617760 4289477952 4294967295 4294967295 4294967295 4288589268 4282276777 4282276777 4282276777 4282276777 3023851653 2135887376 4288617760 4288617760 4288617760 4288617760 4288617760 4293379783 4294967295 4294967295 4294967295 4294967295 4285433022 4282276777 4282276777 4282276777 4282276777 2135887376 4288617760 4288617760 4288617760 4288617760 4293379783 4294967295 4294967295 4291792527 4294967295 4294967295 4292534254 4282276777 4282276777 4282276777 4282276777 2135887376 4288617760 4288617760 4288617760 4290205015 4294967295 4294967295 4291792527 4288617760 4291792527 4294967295 4294967295 4288589268 4282276777 4282276777 4282276777 2135887376 4288617760 4288617760 4288617760 4294967295 4294967295 4293379783 4288617760 4288617760 4288617760 4294967295 4294967295 4294967295 4282276777 4282276777 4282276777 2069109275 4288617760 4288617760 4291792527 4294967295 4294967295 4290205015 4288617760 4288617760 4288617760 4291792527 4294967295 4294967295 4288589268 4282276777 3629543347 0 4288617760 4288617760 4294967295 4294967295 4293379783 4288617760 4288617760 4288617760 4288617760 4288617760 4294967295 4294967295 4294967295 4282276777 2132749652 0 1851269667 4291792527 4294967295 4294967295 4291527814 4288617760 4288617760 4288617760 4288617760 4288617760 4293379783 4294967295 4294967295 3380778696 0 0 0 3215427207 4294967295 4294967295 4288617760 4288617760 4288617760 4288617760 4288617760 4288617760 4291792527 4294967295 4294967295 1061109567 0 0 0 0 2411708351 4293313990 4288617760 4288617760 4288617760 4288617760 4288617760 4288617760 4288617760 3271557119 1061109567 0 0 0 0 0 0 1059522312 2558668850 4288617760 4288617760 4288617760 4288617760 3383507773 2135887376 0 0 0 0)
	offset: 0@0)
]

{ #category : #'as yet unclassified' }
SBScmASTNode class >> registerShortcuts: aProvider [

	aProvider
		registerShortcut: $( do: #wrapInSExpr;
		registerShortcut: $) do: #splitSExpr;
		cmdShortcut: $' do: #useAsScmSymbol;
		cmdShortcut: $" do: #useAsScmString
]

{ #category : #'action helpers' }
SBScmASTNode >> actionProviders [

	^ {self grammarHandler}, super actionProviders
]

{ #category : #printing }
SBScmASTNode >> crIndent: aNumber on: aStream [

	aStream cr.
	aNumber timesRepeat: [
		aStream space; space]
]

{ #category : #evaluation }
SBScmASTNode >> evaluate [

	^ SBExecutionEnvironment
		value: self containingArtefact
		during: [SBLanguageBox eval: self sourceString lang: 'scheme']
]

{ #category : #accessing }
SBScmASTNode >> grammarHandler [

	^ SBScmGrammarHandler new
]

{ #category : #converting }
SBScmASTNode >> inLanguageBox: converter [
	<convert>
	
	^ converter
		if: [self completeSubtree]
		do: [SBLanguageBox new source: self sourceString lang: 'scheme']
]

{ #category : #'initialize-release' }
SBScmASTNode >> initialize [

	super initialize.
		
	self
		hResizing: #shrinkWrap;
		vResizing: #shrinkWrap;
		layoutPolicy: SBAlgebraLayout new
]

{ #category : #testing }
SBScmASTNode >> isExpression [

	^ true
]

{ #category : #testing }
SBScmASTNode >> isIdentifier [

	^ false
]

{ #category : #testing }
SBScmASTNode >> isSExpr [

	^ false
]

{ #category : #testing }
SBScmASTNode >> isScheme [

	^ true
]

{ #category : #testing }
SBScmASTNode >> leftRotate [
	<actionValidIf: #never>
]

{ #category : #testing }
SBScmASTNode >> never [

	^ false
]

{ #category : #accessing }
SBScmASTNode >> newCommentBlock [

	^ self grammarHandler newCommentBlock
]

{ #category : #'object interface' }
SBScmASTNode >> object [

	^ self
]

{ #category : #'as yet unclassified' }
SBScmASTNode >> objectInterfaceNear: aBlock at: aSymbol [

	^ SBInterfaces scmExpression
]

{ #category : #accessing }
SBScmASTNode >> preferredColor [

	^ Color r: 0.398 g: 0.128 b: 0.079
]

{ #category : #printing }
SBScmASTNode >> prettySourceString [

	^ String streamContents: [:s |
		self writeSourceOn: s indent: 0]
]

{ #category : #printing }
SBScmASTNode >> sourceString [

	^ String streamContents: [:s | self writeSourceOn: s]
]

{ #category : #printing }
SBScmASTNode >> writeSourceOn: aStream indent: aNumber [

	^ self subclassResponsibility
]
