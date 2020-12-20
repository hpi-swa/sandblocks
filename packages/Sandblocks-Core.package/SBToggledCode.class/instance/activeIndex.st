as yet unclassified
activeIndex

	self optionRows withIndexDo: [:row :index | row firstSubmorph value ifTrue: [^ index]].
	^ 0