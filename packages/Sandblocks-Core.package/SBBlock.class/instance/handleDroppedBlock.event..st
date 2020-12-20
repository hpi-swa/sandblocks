as yet unclassified
handleDroppedBlock: aBlock event: anEvent

	aBlock isSelection ifTrue: [ | replacer |
		replacer := aBlock childSandblocks first.
		self isExpression ifTrue: [
			replacer isExpression
				ifTrue: [
					self sandblockEditor do: ((SBReplaceCommand newFor: self containingArtefact)
						replacer: replacer;
						target: self)]
				ifFalse: [ | index |
					index := UIManager default chooseFrom: {'Store into new Class Variable'}.
					index > 0 ifTrue: [ | class name |
						name := UIManager default request: 'Name for class variable?'.
						class := self containingArtefact relatedClass.
						self sandblockEditor declareClassVariable: name for: class.
						((self sandblockEditor openClass: class) saveTryFixing: false quick: false) ifTrue: [
							(class classBindingOf: name) value: replacer object.
							self sandblockEditor do: ((SBReplaceCommand newFor: self containingArtefact)
								replacer: (SBName contents: name);
								target: self)]]]]]