as yet unclassified
reportValue: anObject

	anObject ~~ expression ifTrue: [
		expression := anObject.
		expression onChangeDo: [ | sendingContext |
			sendingContext := (thisContext findContextSuchThat: [:context |
				context receiver = VarTra and:
				[context selector =  #notify:instVarNamed:ofObject:changedFrom:to:inContext:]
				and: [context isMethodContext]]) sender.
			self addMorphBack: (SBString new contents: sendingContext asString)]]