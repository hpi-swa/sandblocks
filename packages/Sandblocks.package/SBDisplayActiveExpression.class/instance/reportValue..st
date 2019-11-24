as yet unclassified
reportValue: anObject

	anObject ~~ expression ifTrue: [
		expression := anObject.
		expression onChangeDo: [ | image stackDefs |
			stackDefs := (self relevantContextsFrom: thisContext) collect: [:context | SBCodeContext for: context].
			image := stackDefs first imageForm asMorph
				vResizing: #shrinkWrap;
				hResizing: #shrinkWrap;
				setProperty: #_stack toValue: stackDefs;
				balloonText: ((stackDefs collect: #stringRepresentation) joinSeparatedBy: String cr);
				on: #click send: #openStack:event:morph: to: self withValue: stackDefs;
				yourself.
			
			self addMorphBack: (SBRow new
				hResizing: #spaceFill;
				addMorphBack: (SBStringMorph new contents: expression lastValue asString, ' <- '; hResizing: #spaceFill);
				addMorphBack: image)]]