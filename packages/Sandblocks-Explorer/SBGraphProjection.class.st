Class {
	#name : #SBGraphProjection,
	#superclass : #SBDataProjection,
	#category : #'Sandblocks-Explorer'
}

{ #category : #'as yet unclassified' }
SBGraphProjection class >> matches: anObject [

	^ anObject isCollection and: [anObject notEmpty and: [anObject size < 500 and: [anObject allSatisfy: [:num | num isNumber]]]]
]

{ #category : #'as yet unclassified' }
SBGraphProjection >> copyObject: anObject [

	self removeAllMorphs.
	self addMorphBack: (SWDiagram new
		visualize: (SWDataUnlabeled create
			addMany: (anObject withIndexCollect: [:num :index | {index. num}]);
			yourself)
		with: SWBarGraph create)
]

{ #category : #'as yet unclassified' }
SBGraphProjection >> example [

	SBMorphExample
		setUp: [SBGraphProjection new]
		cases: {(SBMorphExampleCase name: 'example 1' caseBlock: [:m | m object: #(3 4 2 8 2 9 12)])}
		extent: 300 @ 300
]

{ #category : #'as yet unclassified' }
SBGraphProjection >> initialize [

	super initialize.
	self
		changeTableLayout;
		extent: 200 asPoint;
		layoutInset: 4 withScalingFactor
]

{ #category : #'as yet unclassified' }
SBGraphProjection >> object [

	^ object
]

{ #category : #'as yet unclassified' }
SBGraphProjection >> object: anObject [

	super object: anObject.
	self removeAllMorphs.
	self addMorphBack: (((Smalltalk at: #SWDiagram) new
		visualize: ((Smalltalk at: #SWDataUnlabeled) create
			addMany: (anObject isDictionary
				ifTrue: [anObject associations collect: [:a | {a key. a value}]]
				ifFalse: [ | index |
					index := 0.
					anObject collect: [:num | index := index + 1. {index. num}] as: Array]);
			yourself)
		with: (Smalltalk at: #SWBarChart) create)
		vResizing: #spaceFill;
		hResizing: #spaceFill;
		yourself).
	
	self lastSubmorph charts first barWidth: 2
]
