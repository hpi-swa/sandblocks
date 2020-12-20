as yet unclassified
copyObject: anObject

	self removeAllMorphs.
	self addMorphBack: (SWDiagram new
		visualize: (SWDataUnlabeled create
			addMany: (anObject withIndexCollect: [:num :index | {index. num}]);
			yourself)
		with: SWBarGraph create)