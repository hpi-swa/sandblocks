as yet unclassified
activeIndex

	self submorphs allButFirst withIndexDo: [:row :index | row firstSubmorph value ifTrue: [^ index]].
	^ 0