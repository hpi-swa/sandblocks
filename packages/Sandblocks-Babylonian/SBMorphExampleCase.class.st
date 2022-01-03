"
A SBMorphExampleCase contains a piece of code that is run after the morph of an SBMorphExample has been setup. It may specify a testcase via assert: or just perform some additional actions after the morph is in its world.
"
Class {
	#name : #SBMorphExampleCase,
	#superclass : #SBBlock,
	#instVars : [
		'nameInput',
		'statusLabel',
		'status',
		'recording',
		'recordedEvents'
	],
	#category : #'Sandblocks-Babylonian'
}

{ #category : #'as yet unclassified' }
SBMorphExampleCase class >> name: aString caseBlock: aBlock [

	" marker "
]

{ #category : #callbacks }
SBMorphExampleCase >> artefactSaved: aMethod [

	self status = #restartOnSave ifTrue: [self run]
]

{ #category : #accessing }
SBMorphExampleCase >> caseBlock [

	^ self submorphs fourth
]

{ #category : #helper }
SBMorphExampleCase >> evaluateFor: aMorph in: aWorld [

	self caseBlock evaluateWithArguments: {aMorph. aWorld}
]

{ #category : #initialization }
SBMorphExampleCase >> initialize [

	super initialize.
	
	status := #restartOnSave.
	recording := false.
	
	self
		layoutPolicy: SBHorizontalLayout new;
		layoutInset: 8;
		vResizing: #shrinkWrap;
		hResizing: #shrinkWrap;
		cellGap: 4
]

{ #category : #'as yet unclassified' }
SBMorphExampleCase >> intoWorld: aWorld [

	self status = #restartOnSave ifTrue: [self run]
]

{ #category : #'as yet unclassified' }
SBMorphExampleCase >> manualRestart [
	<action>

	self status: #manualRestart
]

{ #category : #initialization }
SBMorphExampleCase >> name: aString caseBlock: aBlock [

	self
		removeAllMorphs;
		addMorphBack: (SBIcon iconRefresh on: #click send: #run to: self);
		addMorphBack: (SBIcon iconCircle on: #click send: #toggleRecord to: self);
		addMorphBack: (nameInput := SBTextBubble new contents: aString);
		addMorphBack: aBlock;
		addMorphBack: (statusLabel := SBStringMorph new on: #click send: #toggleRestartMethod to: self);
		updateLabel
]

{ #category : #accessing }
SBMorphExampleCase >> nameInput [

	^ nameInput
]

{ #category : #'as yet unclassified' }
SBMorphExampleCase >> recording [

	^ recording
]

{ #category : #'as yet unclassified' }
SBMorphExampleCase >> recording: aBoolean [

	recording := aBoolean
]

{ #category : #'as yet unclassified' }
SBMorphExampleCase >> restartOnSave [
	<action>

	self status: #restartOnSave
]

{ #category : #callbacks }
SBMorphExampleCase >> run [

	recording ifTrue: [
		recording := false.
		self triggerEvent: #stopRecord].
	self triggerEvent: #run with: self
]

{ #category : #accessing }
SBMorphExampleCase >> status [

	^ status
]

{ #category : #accessing }
SBMorphExampleCase >> status: aSymbol [

	status := aSymbol.
	self updateLabel.
	aSymbol ~= #manualRestart ifTrue: [self run]
]

{ #category : #'as yet unclassified' }
SBMorphExampleCase >> toggleRecord [
	<action>

	recording
		ifTrue: [
			recording := false.
			self triggerEvent: #stopRecord.
			self caseBlock statements: (recordedEvents collect: [:event | ('m owner handleEvent: (', (event sbStoreString, ')')) parseAsSandblock])]
		ifFalse: [
			recording := true.
			self triggerEvent: #startRecord with: (recordedEvents := OrderedCollection new)]
]

{ #category : #'as yet unclassified' }
SBMorphExampleCase >> toggleRestartMethod [
	<action>

	self status: (self status = #restartOnSave ifTrue: [#manualRestart] ifFalse: [#restartOnSave])
]

{ #category : #helper }
SBMorphExampleCase >> updateLabel [

	statusLabel contents: (status caseOf: {
		[#restartOnSave] -> ['- On Save -'].
		[#manualRestart] -> ['- Manual -']
	})
]

{ #category : #printing }
SBMorphExampleCase >> writeSourceOn: aStream [

	aStream nextPutAll: '(SBMorphExampleCase name: '.
	nameInput contents storeOn: aStream.
	aStream nextPutAll: ' caseBlock: '.
	self caseBlock writeSourceOn: aStream.
	aStream nextPut: $)
]
