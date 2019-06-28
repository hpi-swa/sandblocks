as yet unclassified
openFor: aMethod

	| editor |
	editor := self new
		method: (Parser new parse: aMethod getSource class: aMethod methodClass) asSandblock.
	
	editor openInWindow openAsTool.
	^ editor