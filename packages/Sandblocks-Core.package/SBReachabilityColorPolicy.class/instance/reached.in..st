as yet unclassified
reached: aNumber in: aCompiledMethod

	| method pc |
	aNumber isNumber
		ifTrue: [
			pc := aNumber.
			method := aCompiledMethod]
		ifFalse: [
			pc := aNumber value.
			method := aNumber key].
	
	methods at: (self hash: method) ifPresent: [:pcs | (pcs includes: pc) ifTrue: [^ true]].
	^ false