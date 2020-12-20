as yet unclassified
do

	oldValue ifNil: [oldValue := target perform: selector].
	target perform: (mutateSelector ifNil: [selector asSimpleSetter]) with: value.
	^ target