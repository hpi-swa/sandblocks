as yet unclassified
activeIndex

	self submorphs allButFirst withIndexDo: [:row :index | row firstSubmorph parsedContents ifTrue: [^ index]].
	^ 0