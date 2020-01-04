as yet unclassified
pushConsArrayWithElements: numElements
	"Push Cons Array of size numElements popping numElements items from the stack into the array bytecode."
	^ currentContext pushConsArrayWithElements: numElements