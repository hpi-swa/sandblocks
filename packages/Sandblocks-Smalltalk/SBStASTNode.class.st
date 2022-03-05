Class {
	#name : #SBStASTNode,
	#superclass : #SBBlock,
	#category : #'Sandblocks-Smalltalk'
}

{ #category : #'as yet unclassified' }
SBStASTNode class >> icon [

	^ Form
	extent: 16@16
	depth: 32
	fromArray: #( 2960685 0 0 1378957119 2759491469 3364983712 4223517379 3887183771 3936656831 3329788324 1984455004 1126052657 0 0 0 2960685 2566184 302647304 2390188388 4293050822 4294432464 4294300871 4293054656 4291153590 4288127389 4289963435 4291542727 4273651385 2557569618 605624076 0 3026478 355939381 3400696450 4294957518 4294960327 4294502594 4293063363 4292017855 4290962921 4291617508 4293450923 4293766844 4293831896 4293768930 4039943574 1194140945 2434857 1921476456 4294560180 4294962884 4294043579 4292344263 4291952580 4291030482 4291354623 4290828522 4294574017 4293516969 4294948277 4294093004 4294224895 3600247689 119941414 2628294019 4294961335 4294237606 4292082629 4292083654 4290640564 4291354875 4290961407 4290105835 4294574018 4294115250 4293706404 4294947505 4293564353 4293431039 2021678472 3538800803 4294956689 4292209325 4291559360 4290183070 4290044880 4291617535 4290172927 4289449193 4294508479 4294639544 4293190293 4294945708 4294942876 4292967131 3587606766 3201807232 4294299004 4290706860 4290445221 4288871058 4290303991 4290566911 4288596223 4288463840 4294574002 4294508466 4293326984 4294418579 4294942103 4293292208 3317327831 1820683601 4292789613 4289200022 4288413563 4287620250 4290105855 4289844479 4287282431 4288463825 4294770603 4294377386 4293328772 4294154369 4294938252 4241249403 1263547999 356004144 3937375819 4288151415 4286971741 4286895018 4288857855 4287611135 4284917503 4288858293 4294705047 4294115220 4292800362 4294540402 4294932087 2624397858 1845028 2237481 1849962518 4288015712 4286119759 4285974444 4287084543 4285640447 4283274239 4290764689 4294311814 4293656437 4292262741 4294926697 3905633855 520880128 2764077 2895149 33554432 2906879532 4286381900 4285318561 4285507839 4283341311 4283601883 4293131378 4293721964 4292409164 4294602066 3737204026 823592197 0 3026478 2960685 0 268502530 3494819883 4285062784 4284390911 4281632767 4287281821 4294573923 4293262669 4292376637 2945327144 487129345 0 0 3026478 2960685 0 0 318899968 2838328100 4265644513 4283537114 4292079703 3937717304 2858763800 1311506440 0 0 0 0 2829099 2960685 0 0 0 1090978050 1695751978 2385789735 1698447383 387257873 395277 659215 1052944 1118481 1118481 1118481 3881787 2960685 0 0 0 2538552115 4021255010 3041669417 10856108 15198184 15329769 15329769 15329769 15329769 15329769 15329769 15592941 2894892 0 0 0 1782787621 4224025186 2000429334 12633028 16777215 16777215 16777215 16777215 16777215 16777215 16777215 16777215)
	offset: 0@0
]

{ #category : #'as yet unclassified' }
SBStASTNode class >> preferredColor [

	^ Color r: 0.216 g: 0.249 b: 0.436
]

{ #category : #'as yet unclassified' }
SBStASTNode class >> registerShortcuts: aProvider [

	aProvider
		cmdShortcut: $" do: #wrapInToggledCode;
		noInsertShortcut: $[ do: #wrapInBlock;
		noInsertShortcut: ${ do: #wrapInDynamicArray;
		cmdShortcut: $: do: #wrapInAssignment;
		noInsertShortcut: $; do: #wrapInCascade;
		noInsertShortcut: $^ do: #wrapInReturn;
		cmdShortcut: $' do: #useAsStString;
		cmdShortcut: $# do: #useAsStSymbol;
		cmdShortcut: $$ do: #useAsStCharacter;
		shortcut: Character space shift modes: #(#input #command) do: #wrapAsArgument;
		shortcut: Character space modes: #(#input #command) do: #wrapInMessageSend
]

{ #category : #'action helpers' }
SBStASTNode >> actionProviders [

	^ {self grammarHandler}, super actionProviders
]

{ #category : #suggestions }
SBStASTNode >> artefactCompletionBindingsFor: aBlock [
	"May be overridden by subclasses."

	^ Smalltalk globals declarations
]

{ #category : #suggestions }
SBStASTNode >> artefactCompletionBindingsFor: aBlock matching: matchString [

	^ self
		completionKeysFrom: (self artefactCompletionBindingsFor: aBlock)
		matching: matchString
		stringBlock: [:binding | binding key]
]

{ #category : #suggestions }
SBStASTNode >> artefactCompletionProjectionsFor: aBlock class: aClass [
	"May be overridden by subclasses."

	^ SBStSubstitution allSubclasses
]

{ #category : #suggestions }
SBStASTNode >> artefactCompletionProjectionsFor: aBlock matching: matchString [
	"May be overridden by subclasses."

	^ self
		completionKeysFrom: (self artefactCompletionProjectionsFor: aBlock class: aBlock guessClassExpensive)
		matching: matchString
		stringBlock: [:projectionClass | projectionClass name]
]

{ #category : #suggestions }
SBStASTNode >> artefactCompletionSelectorsForSend: aBlock class: aClass [

	| list |
	list := aClass
		ifNil: [Symbol allSymbols select: [:ea | [ea isMessageSelector] on: Error do: [false]]]
		ifNotNil: [aClass sandblocksSuggestionsFor: self].
	self selector ifNotNil: [:sel | list := list copyWith: sel].
	^ list
]

{ #category : #suggestions }
SBStASTNode >> artefactCompletionSelectorsForSend: aBlock matching: matchString [

	^ self
		completionSelectorsFrom: (self artefactCompletionSelectorsForSend: aBlock class: aBlock guessClassExpensive)
		matching: matchString
]

{ #category : #suggestions }
SBStASTNode >> artefactCompletionSelectorsForSymbol: aBlock matching: matchString [
	"May be overridden by subclasses."

	^ self completionSelectorsFrom: Symbol allSymbols matching: matchString
]

{ #category : #suggestions }
SBStASTNode >> artefactCompletionSuggestionsForBinding: aBlock matching: matchString [
	"May be overridden by subclasses."

	^ (self artefactCompletionBindingsFor: aBlock matching: matchString) collect: [:binding |
		SBSuggestionItem selector: binding key label: ((binding value isBehavior and: [binding key == binding value name])
			ifTrue: ['class']
			ifFalse: ['global'])]
]

{ #category : #suggestions }
SBStASTNode >> artefactCompletionSuggestionsForProjection: aBlock matching: matchString [
	"May be overridden by subclasses."

	^ (self artefactCompletionProjectionsFor: aBlock matching: matchString) collect: [:projectionClass |
		(SBProjectionSuggestionItem selector: projectionClass name label: 'projection')
			completionAction: projectionClass suggestion;
			instanceSuggestion: projectionClass instanceSuggestion
				editor: aBlock sandblockEditor;
			yourself]
]

{ #category : #suggestions }
SBStASTNode >> artefactCompletionSuggestionsForSend: aBlock matching: matchString [
	"May be overridden by subclasses."

	^ (self artefactCompletionSelectorsForSend: aBlock matching: matchString) collect: [:symbol | SBSuggestionItem selector: symbol label: 'send']
]

{ #category : #suggestions }
SBStASTNode >> artefactCompletionSuggestionsForSymbol: aBlock matching: matchString [
	"May be overridden by subclasses."

	^ (self artefactCompletionSelectorsForSymbol: aBlock matching: matchString) collect: [:symbol | SBSuggestionItem selector: symbol label: 'symbol']
]

{ #category : #converting }
SBStASTNode >> asMessagePart: aConverter [
	<convert>
	
	^ aConverter
		if: [self currentTextMorph notNil]
		do: [SBStMessagePart new contents: self currentTextMorph contents]
]

{ #category : #converting }
SBStASTNode >> asMorphBlock: converter [
	<convert>
	
	" we can't generally convert ourselves to morphs since we need our artefact owner "
]

{ #category : #actions }
SBStASTNode >> browseImplementors [

	^ self grammarHandler
		block: self;
		browseImplementors
]

{ #category : #testing }
SBStASTNode >> canEvaluate [

	^ self isExpression
]

{ #category : #caching }
SBStASTNode >> clearCacheSelf [

	super clearCacheSelf.
	self removeProperty: #guessedClassExpensive
]

{ #category : #evaluate }
SBStASTNode >> compilationCueWith: aRequestor for: aContext [

	| receiver class |
	receiver := aContext ifNotNil: #receiver.
	class := Compiler new classForReceiver: receiver context: aContext.
	^ CompilationCue
		source: self sourceString readStream
		context: aContext
		receiver: receiver
		class: class
		environment: class environment
		requestor: aRequestor
]

{ #category : #suggestions }
SBStASTNode >> completionSuggestionsForBinding: matchString [

	^ (self containingArtefact ifNil: [^ #()])
		artefactCompletionSuggestionsForBinding: self
		matching: matchString
]

{ #category : #suggestions }
SBStASTNode >> completionSuggestionsForProjection: matchString [

	^ (self containingArtefact ifNil: [^ #()])
		artefactCompletionSuggestionsForProjection: self
		matching: matchString
]

{ #category : #suggestions }
SBStASTNode >> completionSuggestionsForSend: matchString [

	^ (self containingArtefact ifNil: [^ #()])
		artefactCompletionSuggestionsForSend: self
		matching: matchString
]

{ #category : #evaluate }
SBStASTNode >> evaluate [

	| artefact |
	artefact := SBExecutionEnvironment value ifNil: [self containingArtefact].
	
	^ artefact
		ifNotNil: [ | context |
			context := artefact evaluationContext.
			Compiler new
				evaluate: self sourceString
				in: context
				to: (context ifNil: [artefact evaluationReceiver] ifNotNil: #receiver)
				notifying: artefact
				ifFail: nil]
		ifNil: [Compiler evaluate: self sourceString]
]

{ #category : #evaluate }
SBStASTNode >> evaluateIn: aBlock [

	| artefact method |
	artefact := self containingArtefact.
	method := (Compiler new
		compileNoPattern: self sourceString
		in: (Compiler new classForReceiver: (artefact ifNotNil: #evaluationReceiver) context: (artefact ifNotNil: #evaluationContext))
		notifying: artefact
		ifFail: nil) generate.
	^ aBlock value: [
		(artefact ifNotNil: [artefact evaluationContext ifNil: [artefact evaluationReceiver] ifNotNil: #receiver]) withArgs: #() executeMethod: method]
]

{ #category : #evaluate }
SBStASTNode >> evaluationContext [

	^ nil
]

{ #category : #evaluate }
SBStASTNode >> evaluationReceiver [

	^ nil
]

{ #category : #accessing }
SBStASTNode >> grammarHandler [

	^ SBStGrammarHandler new
]

{ #category : #accessing }
SBStASTNode >> guessClassExpensive [

	^ self guessedClass ifNil: [
		self valueOfProperty: #guessedClassExpensive ifAbsentPut: [
			Smalltalk at: #Sandbox ifPresent: [:sandboxClass |
				[
					sandboxClass new
						stepLimit: 100000;
						evaluate: [
								self evaluate ifNotNil: [:result |
									[result class] on: MessageNotUnderstood do: ["might be ProtoObject"
									thisContext objectClass: result]]]
							ifFailed: [nil]]
					on: (Smalltalk at: #SandboxError)
					do: [:err | nil]]]]
]

{ #category : #accessing }
SBStASTNode >> guessedClass [

	" return a non-nil value to help services like autocompletion do their job "
	^ nil
]

{ #category : #converting }
SBStASTNode >> inLanguageBox: converter [
	<convert>

	^ converter
		if: [self completeSubtree and: [self isExpression]]
		do: [SBLanguageBox new source: self sourceString lang: 'smalltalk']
]

{ #category : #'initialize-release' }
SBStASTNode >> initialize [

	super initialize.
	
	self
		layoutPolicy: SBAlgebraLayout new;
		hResizing: #shrinkWrap;
		vResizing: #shrinkWrap
]

{ #category : #testing }
SBStASTNode >> isReturn [

	^ false
]

{ #category : #testing }
SBStASTNode >> isSmalltalk [

	^ true
]

{ #category : #'action helpers' }
SBStASTNode >> lookupAction: aSymbol [
	" first try our leaf class, then the grammar handler, then our base classes "

	self class lookupSelector: aSymbol upTo: SBStASTNode ifPresent: [:m | (self isValidAction: m) ifTrue: [^ self]] ifAbsent: [].
	
	(self grammarHandler class lookupSelector: aSymbol) ifNotNil: [:m | (self isValidAction: m) ifTrue: [^ self grammarHandler]].
	
	(SBStASTNode superclass lookupSelector: aSymbol) ifNotNil: [:m | (self isValidAction: m) ifTrue: [^ self]].
	
	^ super lookupAction: aSymbol.
]

{ #category : #accessing }
SBStASTNode >> newCommentBlock [

	^ self grammarHandler newCommentBlock
]

{ #category : #'object interface' }
SBStASTNode >> object [

	^ self
]

{ #category : #'object interface' }
SBStASTNode >> objectInterfaceNear: aBlock at: aSymbol [

	(aSymbol = #replace or: [self dynamicNumberOfChildren]) ifTrue: [^ SBInterfaces stExpression].
	^ SBInterfaces never
]

{ #category : #accessing }
SBStASTNode >> pc [

	^ 0
]

{ #category : #accessing }
SBStASTNode >> pc: aNumber [

	" save a pc if you are an accessible point during execution "
]

{ #category : #accessing }
SBStASTNode >> preferredColor [

	^ self class preferredColor
]

{ #category : #printing }
SBStASTNode >> prettySourceString [

	| source |
	source := self sourceString.
	^ [PPFormatter formatString: source class: (self containingArtefact ifNotNil: #relatedClass ifNil: [nil class]) noPattern: self ~= self containingArtefact] on: SyntaxErrorNotification do: [source]
]

{ #category : #refactoring }
SBStASTNode >> resolveLocalBindings [

	| bindings |
	bindings := Array streamContents: [:stream |
		self allBlocksDo: [:block |
			block isBinding ifTrue: [ | binding |
				binding := block resolveBinding.
				
				(binding notNil and: [binding isDeclaration] and: [binding isMethodLocal] and: [(binding hasOwner: self) not]) ifTrue: [
					stream nextPut: binding]]]].
	
	^ (KeyedSet keyBlock: #name) addAll: bindings
]

{ #category : #printing }
SBStASTNode >> selectionLabel [

	^ String streamContents: [:stream |
		self printOn: stream.
		
		self guessedClass ifNotNil: [:c | stream space; nextPut: $(. c printOn: stream. stream nextPut: $)]]
]

{ #category : #accessing }
SBStASTNode >> selector [
	" if this node represents any selector, return it here "

	^ nil
]

{ #category : #printing }
SBStASTNode >> sourceString [

	^ String streamContents: [:s | self writeSourceOn: s]
]

{ #category : #accessing }
SBStASTNode >> updatePCFrom: aBlock [

	self pc: aBlock pc
]

{ #category : #converting }
SBStASTNode >> wrapInPlayground: convert [
	<convert>
	
	convert do: [SBStPlayground new statements: {self veryDeepCopy}]
]

{ #category : #printing }
SBStASTNode >> writeSourceOn: aStream [

	^ self subclassResponsibility
]
