as yet unclassified
getParentsFrom: aMethodNode

	| visitor |
	visitor := self new.
	aMethodNode accept: visitor.
	^ visitor parents