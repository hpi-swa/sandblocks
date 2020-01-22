as yet unclassified
do

	oldValue ifNil: [oldValue := target perform: selector].
	target perform: selector asSimpleSetter with: value.
	^ target