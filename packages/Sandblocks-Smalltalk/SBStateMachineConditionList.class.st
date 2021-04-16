Class {
	#name : #SBStateMachineConditionList,
	#superclass : #SBStArray,
	#category : #'Sandblocks-Smalltalk'
}

{ #category : #'as yet unclassified' }
SBStateMachineConditionList >> newEmptyChildNear: aBlock before: aBoolean [

	^ SBStateMachineTransitionCondition new
		type: #condition
		data: SBStBlockBody empty
]

{ #category : #'as yet unclassified' }
SBStateMachineConditionList >> objectInterfaceNear: aBlock at: aSymbol [

	^ {#isSandblock. #isSmalltalk. #isTransitionCondition understood}
]
