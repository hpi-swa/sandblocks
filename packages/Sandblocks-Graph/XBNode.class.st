Class {
	#name : #XBNode,
	#superclass : #Morph,
	#instVars : [
		'flowOut',
		'flowIn',
		'inputs',
		'outputs'
	],
	#category : 'Sandblocks-Graph'
}

{ #category : #'as yet unclassified' }
XBNode >> addInput: aString [

	inputs addMorphBack: (SBNodeSocket new type: #dataIn; label: aString).
	self updateContents
]

{ #category : #'as yet unclassified' }
XBNode >> addOutput: aString [

	inputs addMorphBack: (SBNodeSocket new type: #dataOut; label: aString).
	self updateContents
]

{ #category : #'as yet unclassified' }
XBNode >> hasFlowSink [

	^ self subclassResponsibility
]

{ #category : #'as yet unclassified' }
XBNode >> hasFlowSource [

	^ self subclassResponsibility
]

{ #category : #'as yet unclassified' }
XBNode >> initialize [

	super initialize.
	
	self
		changeTableLayout;
		listDirection: #topToBottom;
		addMorphBack: (flowOut := SBNodeSocket new type: #flowOut; visible: false);
		addMorphBack: (flowIn := SBNodeSocket new type: #flowIn; visible: false);
		addMorphBack: (SBColumn new
			changeTableLayout;
			addMorphBack: (inputs := SBColumn new changeTableLayout);
			addMorphBack: (outputs := SBColumn new changeTableLayout))
]

{ #category : #'as yet unclassified' }
XBNode >> updateContents [

	flowIn visible: self hasFlowSink.
	flowOut visible: self hasFlowSource
]
