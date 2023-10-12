"
Does not update its results anymore. Applying modification expressions is still possible.
"
Class {
	#name : #SBInactiveExampleWatch,
	#superclass : #SBExampleWatch,
	#category : #'Sandblocks-Babylonian'
}

{ #category : #'initialize-release' }
SBInactiveExampleWatch class >> newFromWatch: anActiveWatch [

	^ (anActiveWatch veryDeepCopy)
		primitiveChangeClassTo: self basicNew;
		expression: (SBTextBubble new contents: anActiveWatch expression sourceString);
		yourself 
]

{ #category : #callbacks }
SBInactiveExampleWatch >> artefactSaved: aBlock [

	"As we are inactive, we have to manually apply our modifyExpression if it changes. 
	Otherwise, we would reset by examples starting" 
	(aBlock = self containingArtefact) ifTrue: [self applyModifyExpressionOnValues] 
]

{ #category : #'event handling' }
SBInactiveExampleWatch >> doubleClick: evt [
	
	"Nothing"
]

{ #category : #'as yet unclassified' }
SBInactiveExampleWatch >> expression: aBlock [

	super expression: aBlock.
	watchedExpression selectable: false
]

{ #category : #accessing }
SBInactiveExampleWatch >> isActive [

	^ false
]

{ #category : #'*Sandblocks-Babylonian' }
SBInactiveExampleWatch >> listensToExamples [

	^ false
]
