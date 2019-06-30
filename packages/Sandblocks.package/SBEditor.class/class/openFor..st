as yet unclassified
openFor: aMethod

	| editor |
	editor := self new compiledMethod: aMethod.
	
	editor openInWindow openAsTool.
	^ editor