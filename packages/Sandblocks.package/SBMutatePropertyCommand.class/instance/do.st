as yet unclassified
do

	oldValue := target perform: selector.
	target perform: selector asMutator with: value.
	^ target