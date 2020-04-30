as yet unclassified
object: anObject

	super object: anObject.
	self removeAllMorphs.
	self addMorphBack: ((SWDiagram new
		visualize: (SWDataUnlabeled create
			addMany: (anObject isDictionary
				ifTrue: [anObject associations collect: [:a | {a key. a value}]]
				ifFalse: [anObject withIndexCollect: [:num :index | {index. num}]]);
			yourself)
		with: SWBarGraph create)
		vResizing: #spaceFill;
		hResizing: #spaceFill;
		yourself).
	
	(self lastSubmorph  charts first) barWidth: 2