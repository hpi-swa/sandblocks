apply
do

	undo := OrderedCollection new.
	firstAdded := nil.
	firstRemoved := nil.
	doBlock value: self.
	^ firstAdded