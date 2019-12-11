actions
save

	saveAction
		ifNotNil: [saveAction value]
		ifNil: [
			self method save ifTrue: [
				self allBlocksDo: [:block | block artefactSaved: self method]]]