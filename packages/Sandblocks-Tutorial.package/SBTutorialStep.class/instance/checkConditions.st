as yet unclassified
checkConditions

	steps submorphs withIndexDo: [:step :index | | checkbox |
		checkbox := step firstSubmorph.
		checkbox value ifFalse: [
			([
				(checkbox valueOfProperty: #checkBlock) value: self sandblockEditor] on: Error do: [:error |
				error signal.
				false]) ifTrue: [
				checkbox value: true.
				self class markStepCompleted: selector index: index]]]