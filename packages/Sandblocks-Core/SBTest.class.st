Class {
	#name : #SBTest,
	#superclass : #TestCase,
	#category : #'Sandblocks-Core-Tests'
}

{ #category : #'as yet unclassified' }
SBTest >> editorFor: aBlock [

	| editor |
	editor := SBEditor new.
	editor openMorphInView: (SBMethod new
		selector: #test arguments: #() class: nil class;
		body: (SBBlockBody new statements: {aBlock})).
	^ editor
]
