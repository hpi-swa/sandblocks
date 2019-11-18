as yet unclassified
reportValue: anObject

	anObject ~~ expression ifTrue: [
		expression := anObject.
		expression onChangeDo: [ | sendingContext image |
			sendingContext := (thisContext findContextSuchThat: [:context |
				context receiver = VarTra and:
				[context selector =  #notify:instVarNamed:ofObject:changedFrom:to:inContext:]
				and: [context isMethodContext]]) sender.
			
			"self addMorphBack: (SBString new contents: sendingContext asString)"
			image := ((SBEditor new openCompiledMethod: sendingContext method) methods first blockForPC: sendingContext pc) imageForm asMorph
				vResizing: #shrinkWrap;
				hResizing: #shrinkWrap;
				balloonText: (((sendingContext stackOfSize: 5) collect: #asString) joinSeparatedBy: String cr);
				yourself.
			self addMorphBack: (image )]]