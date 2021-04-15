Class {
	#name : #SBStateMachineConditionList,
	#superclass : #SBStArray,
	#category : #'Sandblocks-Smalltalk'
}

{ #category : #'as yet unclassified' }
SBStateMachineConditionList >> newNullBlock [

	^ SBStateMachineTransitionCondition new type: #condition data: SBStBlockBody empty
]

{ #category : #'as yet unclassified' }
SBStateMachineConditionList >> objectInterfaceNear: aBlock at: aSymbol [

	^ {#isSandblock. #isSmalltalk. #isTransitionCondition understood}
]
