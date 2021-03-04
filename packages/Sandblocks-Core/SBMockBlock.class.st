Class {
	#name : #SBMockBlock,
	#superclass : #SBBlock,
	#instVars : [
		'mockActionTaken',
		'actionValid'
	],
	#category : #'Sandblocks-Core-Tests'
}

{ #category : #'as yet unclassified' }
SBMockBlock >> actionValid [

	^ actionValid ifNil: [false]
]

{ #category : #'as yet unclassified' }
SBMockBlock >> actionValid: aBoolean [

	actionValid := aBoolean
]

{ #category : #'as yet unclassified' }
SBMockBlock >> conditionalMockAction [
	<action>
	<actionValidIf: #actionValid>

	mockActionTaken := true
]

{ #category : #'as yet unclassified' }
SBMockBlock >> initialize [

	super initialize.
	
	mockActionTaken := false
]

{ #category : #'as yet unclassified' }
SBMockBlock >> mockAction [
	<action>

	mockActionTaken := true
]

{ #category : #'as yet unclassified' }
SBMockBlock >> mockActionTaken [

	^ mockActionTaken
]
