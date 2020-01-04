as yet unclassified
indent: aNumber around: aBlock 
	indent := indent + aNumber.
	aBlock value.
	indent := indent - aNumber