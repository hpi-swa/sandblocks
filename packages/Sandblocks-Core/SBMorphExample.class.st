"
A SBMorphExample partially sandboxes a morph in its own pasteupmorph. Together with the SBMorphExampleCase it will reopen the morph when requested.
"
Class {
	#name : #SBMorphExample,
	#superclass : #SBSubstitution,
	#instVars : [
		'view',
		'cases',
		'errorDecorator',
		'header',
		'errorIcon',
		'reportedError'
	],
	#category : 'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBMorphExample class >> matches: aBlock [

	(super matches: aBlock) ifFalse: [^ false].

	^ aBlock receiver isBinding and: [aBlock receiver contents = self name] and: [aBlock selector = 'setUp:cases:extent:']
]

{ #category : #'as yet unclassified' }
SBMorphExample class >> newFor: aBlock [

	^ self new
		setUp: aBlock arguments first
		cases: aBlock arguments second submorphs
		extent: aBlock arguments third contents
]

{ #category : #'as yet unclassified' }
SBMorphExample class >> setUp: aBlock cases: aCollectionOfBlocks extent: aPoint [

	" marker "
]

{ #category : #'as yet unclassified' }
SBMorphExample class >> suggestion [

	^ [:block | | setUp |
		setUp := SBBlockBody empty.
		block sandblockEditor selectedArtefact relatedClass ifNotNil: [:class |
			setUp statements: {SBMessageSend new
				receiver: (SBName contents: class name)
				selector: #new}].
		block sandblockEditor do: ((SBReplaceCommand newFor: block containingArtefact)
			target: block;
			replacer: ((SBMorphExample new
				setUp: setUp
				cases: {}
				extent: 300 asPoint)
					addCase: ((SBBlockBody emptyWithDeclarations: {'m'}) statements: {SBName contents: 'm'}) name: 'example 1');
					yourself)]
]

{ #category : #callbacks }
SBMorphExample >> addCase: aBlock name: aString [

	cases addMorphBack: (SBMorphExampleCase new
		name: aString caseBlock: aBlock;
		when: #run send: #runCase: to: self)
]

{ #category : #callbacks }
SBMorphExample >> artefactChanged: anArtefact [

	" re-trigger e.g. a changed drawOn: "
	view changed
]

{ #category : #testing }
SBMorphExample >> canDeleteChild: aBlock [

	^ aBlock owner = cases
]

{ #category : #accessing }
SBMorphExample >> cases [

	^ cases submorphs
]

{ #category : #accessing }
SBMorphExample >> childSandblocksDo: aBlock [

	aBlock value: self setUpMorph.
	self cases do: aBlock
]

{ #category : #errors }
SBMorphExample >> clearErrors [

	errorDecorator ifNotNil: [
		errorDecorator detach.
		errorDecorator := nil].
	
	errorIcon ifNotNil: [
		errorIcon delete.
		errorIcon := nil]
]

{ #category : #errors }
SBMorphExample >> displayError: anError [

	header addMorphBack: (errorIcon := SBIcon iconFlash balloonText: anError asString)
]

{ #category : #colors }
SBMorphExample >> drawnColor [

	^ Color veryDarkGray
]

{ #category : #initialization }
SBMorphExample >> initialize [

	super initialize.
	
	self
		hResizing: #shrinkWrap;
		vResizing: #shrinkWrap;
		changeTableLayout;
		layoutInset: 6 withScalingFactor;
		addMorphBack: (TransformMorph new
			hResizing: #shrinkWrap;
			vResizing: #shrinkWrap;
			changeTableLayout;
			addMorph: (view := SBSandboxPasteUpMorph new
				when: #reportError send: #reportError: to: self));
		addMorphBack: (cases := SBColumn new layoutInset: 0)
]

{ #category : #callbacks }
SBMorphExample >> insertCommandRequest: anAfterBoolean near: aBlock [

	| index case |
	index := (cases submorphIndexOf: aBlock) ifNil: [1] ifNotNil: [:i | i   + (anAfterBoolean ifTrue: [1] ifFalse: [0])].
	
	case := (SBMorphExampleCase new name: '' caseBlock: (SBBlockBody emptyWithDeclarations: {'m'}))
		when: #run send: #runCase: to: self.
	
	^ (SBInsertCommand newFor: self containingArtefact)
		index: index;
		container: cases;
		morph: case;
		yourself
]

{ #category : #testing }
SBMorphExample >> isExpression [

	^ false
]

{ #category : #testing }
SBMorphExample >> isMorphExample [

	^ true
]

{ #category : #errors }
SBMorphExample >> reportError: anError [

	| editor ctx i |
	self
		clearErrors;
		displayError: anError.
	
	true ifTrue: [
		(reportedError notNil and: [reportedError expanded not]) ifTrue: [reportedError delete].
		
		^ Project current addDeferredUIMessage: [reportedError := self sandblockEditor reportError: anError process: ((Process
			forContext: anError signalerContext copyStack
			priority: Processor activeProcess priority)
				shouldResumeFromDebugger: false;
				yourself)"ToolSet debugException: anError"]].
	
	editor := self sandblockEditor.
	i := 1.
	ctx := anError signalerContext.
	[ctx] whileNotNil: [
		" error was during our example case setup, locate the correct expression from the DoIt "
		ctx method = (SBMorphExampleCase >> #evaluateFor:in:) ifTrue: [ | caseBlock doItCtx |
			caseBlock := self cases first caseBlock.
			doItCtx := anError signalerContext stack at: i - 3.
			" this 73 currently is a mystery, but maybe it's caseBlock pc - doItCtx method initialPC ? further investigation needed "
			(caseBlock containingArtefact blockForPC: doItCtx pc + 73)  ifNotNil: [:b |
				b attachDecorator: (errorDecorator := SBErrorDecorator new message: anError asString)].
			^ self].
		
		" error was elsewhere, see if we have an open artefact with this context "
		editor
			methodForContext: ctx
			ifOpen: [:method |
				(method blockForPC: ctx previousPc) ifNotNil: [:b |
					b attachDecorator: (errorDecorator := SBErrorDecorator new message: anError asString)].
				^ self]
			ifClosed: [false].
		ctx := ctx sender.
		i := i + 1]
]

{ #category : #callbacks }
SBMorphExample >> runCase: aCase [

	| morph |
	self sendStartNotification.
	
	self clearErrors.
	view removeAllMorphs.
	
	[
		morph := self setUpMorph evaluate.
		morph ifNotNil: [
			view addMorphBack: (morph center: view center).
			aCase evaluateFor: morph in: view]
	] on: Error do: [:error | ^ self reportError: error]
]

{ #category : #helper }
SBMorphExample >> sendStartNotification [

	self sandblockEditor allBlocksDo: [:morph |
		morph isGlobalWatch ifTrue: [morph exampleStarting: self]]
]

{ #category : #initialization }
SBMorphExample >> setUp: aBlock cases: aCollectionOfBlocks extent: aPoint [

	self addMorph: (header := SBRow new
		cellGap: 4 * self scalingFactor;
		addMorphBack: (SBStringMorph new contents: 'Setup:');
		addMorphBack: (aBlock statements first);
		addMorphBack: (SBIcon iconSpinner
			balloonText: 'Toggle stepping';
			on: #click send: #toggleStepping to: self)).
	
	aCollectionOfBlocks do: [:m | self addCase: m arguments second name: m arguments first contents].
	
	view extent: aPoint
]

{ #category : #accessing }
SBMorphExample >> setUpMorph [

	" we can't just save a reference to it because editing ops may change the morph, but it's position will say the same "
	^ self firstSubmorph submorphs second
]

{ #category : #callbacks }
SBMorphExample >> toggleStepping [
	<action>

	view submorphsDo: [:morph |
		morph isStepping ifFalse: [morph startStepping] ifTrue: [morph stopStepping]]
]

{ #category : #errors }
SBMorphExample >> veryDeepCopyWith: aCopier [

	| copy oldError |
	oldError := reportedError.
	reportedError := nil.
	
	copy := super veryDeepCopyWith: aCopier.
	reportedError := oldError.
	
	^ copy
]

{ #category : #accessing }
SBMorphExample >> view [

	^ view
]

{ #category : #printing }
SBMorphExample >> writeSourceOn: aStream [

	aStream nextPutAll: '(SBMorphExample setUp: ['.
	self setUpMorph writeSourceOn: aStream.
	aStream nextPutAll: '] cases: '.
	(SBArray withContents: self cases veryDeepCopy) writeSourceOn: aStream.
	aStream nextPutAll: ' extent: '.
	view extent storeOn: aStream.
	aStream nextPut: $)
]
