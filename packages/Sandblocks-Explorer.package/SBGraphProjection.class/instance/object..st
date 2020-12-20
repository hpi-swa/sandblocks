as yet unclassified
object: anObject

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