transitions
uponLeave: aState do: aBlock
	(leaveActions at: aState ifAbsentPut: [ OrderedCollection new ]) add: aBlock