"
A SBMorphExampleCase contains a piece of code that is run after the morph of an SBMorphExample has been setup. It may specify a testcase via assert: or just perform some additional actions after the morph is in its world.
"
Class {
	#name : #SBMorphExampleCase,
	#superclass : #SBBlock,
	#instVars : [
		'nameInput',
		'statusLabel',
		'status'
	],
	#category : #'Sandblocks-Core'
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

	^ self submorphs third
]

{ #category : #accessing }
SBMorphExampleCase >> childSandblocksDo: aBlock [

	aBlock value: nameInput.
	aBlock value: self caseBlock
]

{ #category : #accessing }
SBMorphExampleCase >> codeActions [

	^ super codeActions, {
		SBCodeAction labeled: 'Restart on save' for: self do: [:node | node status: #restartOnSave].
		SBCodeAction labeled: 'Manual restart' for: self do: [:node | node status: #manualRestart].
	}
]

{ #category : #helper }
SBMorphExampleCase >> evaluateFor: aMorph in: aWorld [

	self caseBlock evaluateWithArguments: {aMorph. aWorld}
]

{ #category : #initialization }
SBMorphExampleCase >> initialize [

	super initialize.
	
	status := #manualRestart.
	
	self
		layoutPolicy: SBHorizontalLayout new;
		layoutInset: 8 withScalingFactor;
		vResizing: #shrinkWrap;
		hResizing: #shrinkWrap;
		cellGap: 4 withScalingFactor
]

{ #category : #initialization }
SBMorphExampleCase >> name: aString caseBlock: aBlock [

	self
		removeAllMorphs;
		addMorphBack: (SBIcon iconRefresh color: Color white; on: #click send: #run to: self);
		addMorphBack: (nameInput := SBTextBubble new contents: aString);
		addMorphBack: aBlock;
		addMorphBack: (statusLabel := (SBStringMorph new on: #click send: #promptChangeStatus to: self));
		updateLabel
]

{ #category : #accessing }
SBMorphExampleCase >> nameInput [

	^ nameInput
]

{ #category : #callbacks }
SBMorphExampleCase >> promptChangeStatus [

	self sandblockEditor
		select: self;
		promptCodeAction
]

{ #category : #callbacks }
SBMorphExampleCase >> run [

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

{ #category : #helper }
SBMorphExampleCase >> updateLabel [

	statusLabel contents: (status caseOf: {
		[#restartOnSave] -> ['- Restart on Save -'].
		[#manualRestart] -> ['- Manual Restart -']
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
