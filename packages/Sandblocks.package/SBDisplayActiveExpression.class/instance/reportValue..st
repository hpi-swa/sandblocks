as yet unclassified
reportValue: anObject

	anObject ~~ expression ifTrue: [
		expression := anObject.
		expression onChangeDo: [ | image stackDefs |
			stackDefs := (self relevantContextsFrom: thisContext) collect: [:context | SBCodeContext for: context].
			image := stackDefs first imageForm asMorph
				vResizing: #shrinkWrap;
				hResizing: #shrinkWrap;
				balloonText: ((stackDefs collect: #stringRepresentation) joinSeparatedBy: String cr);
				yourself.
			
			image setProperty: #_stack toValue: stackDefs.
			image on: #click send: #openStack:event:morph: to: self withValue: stackDefs.
			self addMorphBack: image]]