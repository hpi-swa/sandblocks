as yet unclassified
do

	(oldMorph ~= newMorph and: [newMorph owner isNil]) ifTrue: [oldMorph replaceBy: newMorph].
	newMorph contents: newText.
	^ newMorph