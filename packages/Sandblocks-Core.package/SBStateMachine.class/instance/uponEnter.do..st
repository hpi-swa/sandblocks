transitions
uponEnter: aState do: aBlock
	(enterActions at: aState ifAbsentPut: [ OrderedCollection new ]) add: aBlock