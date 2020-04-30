as yet unclassified
lastError: anError

	lastError := anError.
	(reportedError notNil and: [reportedError expanded not]) ifTrue: [reportedError delete].
	
	anError
		ifNotNil: [
			true ifTrue: [^ reportedError := self sandblockEditor reportError: anError process: ((Process
				forContext: anError signalerContext copyStack
				priority: Processor activeProcess priority)
					shouldResumeFromDebugger: false;
					yourself)"ToolSet debugException: anError"].
			
			errorIndicator ifNil: [self addMorphBack: (errorIndicator := SBIcon iconFlash large; color: Color orange)].
			
			(anError signalerContext
				findContextSuchThat: [:ctx | ctx method = self containingArtefact compiledMethod])
				ifNotNil: [:errorContext |
					(self containingArtefact blockForPC: errorContext previousPc)
						ifNotNil: [:b | b attachDecorator: (errorDecorator := SBErrorDecorator new message: anError asString)]]]
		ifNil: [
			errorIndicator ifNotNil: #delete.
			errorIndicator := nil]