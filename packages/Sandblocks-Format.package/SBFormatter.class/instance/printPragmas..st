as yet unclassified
printPragmas: aNode

	aNode primitive > 0 ifTrue: [
		(aNode primitive between: 255 and: 519) ifFalse: [
			stream crtab: 1.
			aNode printPrimitiveOn: stream]].
	aNode printPragmasOn: stream