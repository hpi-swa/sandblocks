actions
saveTryFixing: aBoolean

	saveAction
		ifNotNil: [saveAction value]
		ifNil: [
			(self method saveTryFixing: aBoolean) ifTrue: [
				self allBlocksDo: [:block | block artefactSaved: self method]]]