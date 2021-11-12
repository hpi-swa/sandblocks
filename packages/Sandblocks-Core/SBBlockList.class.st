Class {
	#name : #SBBlockList,
	#superclass : #SBBlock,
	#instVars : [
		'newEmptyDo',
		'objectInterfaceDo'
	],
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBBlockList >> fixedNumberOfChildren [

	^ false
]

{ #category : #'as yet unclassified' }
SBBlockList >> initialize [

	super initialize.
	
	self
		changeTableLayout;
		listDirection: #topToBottom;
		hResizing: #shrinkWrap;
		vResizing: #shrinkWrap
]

{ #category : #'as yet unclassified' }
SBBlockList >> newEmptyChildNear: aBlock before: aBoolean [

	^ newEmptyDo ifNotNil: [newEmptyDo cull: aBlock cull: aBoolean]
]

{ #category : #'as yet unclassified' }
SBBlockList >> newEmptyDo: aBlock [

	newEmptyDo := aBlock
]

{ #category : #'as yet unclassified' }
SBBlockList >> objectInterfaceDo: aBlock [

	objectInterfaceDo := aBlock
]

{ #category : #'as yet unclassified' }
SBBlockList >> objectInterfaceNear: aBlock at: aSymbol [

	^ objectInterfaceDo
		ifNotNil: [:block | block cull: aBlock cull: aSymbol]
		ifNil: [super objectInterfaceNear: aBlock at: aSymbol]
]

{ #category : #'as yet unclassified' }
SBBlockList >> printOn: aStream [

	self knownName ifNotNil: [:n | aStream nextPutAll: n] ifNil: [super printOn: aStream]
]
