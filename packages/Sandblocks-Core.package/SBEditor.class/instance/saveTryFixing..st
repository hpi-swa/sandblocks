actions
saveTryFixing: aBoolean

	saveAction
		ifNotNil: [saveAction value]
		ifNil: [
			(self method saveTryFixing: aBoolean) ifTrue: [
				self method hasUnsavedChanges: false.
				self allBlocksDo: [:block | block artefactSaved: self method]]]