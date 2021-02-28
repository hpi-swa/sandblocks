Class {
	#name : #SBRatPackRoute,
	#superclass : #SBMethodSubstitution,
	#category : #'Sandblocks-RatPack'
}

{ #category : #utils }
SBRatPackRoute class >> findRouteDescribtion: aCompiledMethod [

	^ (self findRoutePragma: aCompiledMethod)
		ifNotNil: [:routePragma | routePragma keyword -> routePragma arguments first]
]

{ #category : #utils }
SBRatPackRoute class >> findRoutePragma: aCompiledMethod [

	#(get: post: head: put: delete: options: trace:) do: [:method |
		(aCompiledMethod pragmaAt: method)
			ifNotNil: [:pragma | ^ pragma]].
	^ nil
]

{ #category : #'as yet unclassified' }
SBRatPackRoute class >> matches: aMethod [

	^ (super matches: aMethod) and: [(aMethod methodClass inheritsFrom: RPApplication) and: [aMethod pragmas anySatisfy: [:p | self validMethods includes: p keyword]]]
]

{ #category : #'as yet unclassified' }
SBRatPackRoute class >> newFor: anObject [

	| block |
	block := anObject asSandblock.
	^ self new
		selector: block selector arguments: block arguments class: block methodClass;
		body: block body;
		yourself
]

{ #category : #'as yet unclassified' }
SBRatPackRoute class >> validMethods [

	^ #(get: put: post: delete: patch: head: options: trace: connect:)
]

{ #category : #'as yet unclassified' }
SBRatPackRoute >> argumentsDo: aBlock [

	self signature argumentsDo: aBlock
]

{ #category : #accessing }
SBRatPackRoute >> body [

	^ self submorphs second
]

{ #category : #accessing }
SBRatPackRoute >> body: aBlock [

	super body: aBlock.
	
	self statements
		detect: [:s | s isPragma and: [self class validMethods includes: s selector]]
		ifFound: [:pragma |
			pragma delete.
			self methodInput object: pragma selector allButLast asSymbol.
			self pathArray addMorphBack: pragma arguments first].
	
	self addMorphBack: (SBRatPackRequestLog new
		serverClass: self rpApplication;
		handlerSelector: self selector;
		name: #requestLogMorph;
		yourself).

	self addMorphBack: (SBButton new
		label: 'send empty request'
		shortcut: nil
		do: [self sendEmptyRequest];
		name: #sendEmptyRequestButton;
		yourself).
]

{ #category : #hierarchy }
SBRatPackRoute >> childSandblocksDo: aBlock [

	aBlock value: self pathArray.
	aBlock value: self body
]

{ #category : #colors }
SBRatPackRoute >> drawnColor [

	^ Color veryDarkGray
]

{ #category : #initialization }
SBRatPackRoute >> initialize [

	super initialize.
	
	self
		addMorphBack: (SBRow new
			layoutPolicy: SBAlgebraLayout new;
			addMorphBack: (SBMethodSelect new object: #get);
			addMorphBack: SBArray new;
			addMorphBack: (SBSignature new hResizing: #spaceFill));
		layoutInset: 4;
		attachDecorator: SBResizableDecorator new
]

{ #category : #accessing }
SBRatPackRoute >> methodInput [

	^ self firstSubmorph firstSubmorph
]

{ #category : #actions }
SBRatPackRoute >> openRequestTracker [
	<action>
	
	self sandblockEditor openMorphInView: (SBRatPackRequestTracker new
		serverClass: self rpApplication).
]

{ #category : #accessing }
SBRatPackRoute >> pathArray [

	^ self firstSubmorph submorphs second
]

{ #category : #actions }
SBRatPackRoute >> reload [
	<action>
	
	self replaceBy: (SBRatPackRoute newFor: (self compiledMethod asSandblock))
]

{ #category : #'as yet unclassified' }
SBRatPackRoute >> reloadMethodInPlace [

	| newBody |
	newBody := self compiledMethod asSandblock body.
	newBody statements
		detect: [:s | s isPragma and: [self class validMethods includes: s selector]]
		ifFound: [:pragma |	pragma delete]. "todo update route string"

	self body replaceBy: newBody.
]

{ #category : #accessing }
SBRatPackRoute >> requestLogMorph [

	^ self submorphNamed: #requestLogMorph
]

{ #category : #accessing }
SBRatPackRoute >> rpApplication [

	^ self methodClass
]

{ #category : #accessing }
SBRatPackRoute >> selector [

	^ self currentSelector
]

{ #category : #'as yet unclassified' }
SBRatPackRoute >> selector: aSymbol arguments: aCollection class: aClass [

	super selector: aSymbol arguments: aCollection class: aClass.
	
	self signature selector: aSymbol arguments: aCollection
]

{ #category : #actions }
SBRatPackRoute >> sendEmptyRequest [
	<action>

	| service routeDescription localUrl |
	"this will use the first running service it finds"
	service := self rpApplication runningServices anyOne.
	routeDescription := self class findRouteDescribtion: self compiledMethod.
	localUrl := 'http://localhost:', service portNumber asString, routeDescription value.

	"fail on post and put"
	(#(put: post:) includes: routeDescription key)
		ifFalse: [
			| webClientMethod response |
			webClientMethod := routeDescription key asString.
			webClientMethod at: 1 put: (webClientMethod at: 1) asUppercase.
			webClientMethod := ('http', webClientMethod) asSymbol.
			response := WebClient perform: webClientMethod with: localUrl.
			response explore.]
		ifTrue: [self error: 'Empty requests cannot be created for put and post routes'].
]

{ #category : #accessing }
SBRatPackRoute >> sendEmptyRequestButton [

	^ self submorphNamed: #sendEmptyRequestButton
]

{ #category : #accessing }
SBRatPackRoute >> signature [

	^ self firstSubmorph submorphs third
]

{ #category : #printing }
SBRatPackRoute >> writeSignatureSourceOn: aStream [

	self signature writeSourceOn: aStream
]

{ #category : #printing }
SBRatPackRoute >> writeSourceOn: aStream [

	self writeSignatureSourceOn: aStream.
	aStream space.
	(SBPragma new selector: self methodInput object asSimpleSetter arguments: {self pathArray submorphs first veryDeepCopy}) writeSourceOn: aStream.
	aStream space.
	self body writeSourceOn: aStream
]
