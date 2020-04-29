as yet unclassified
rootContext

	^ SBToggledCode
		comment: ''
		active: 2
		do: {[process suspendedContext]. [(error ifNotNil: #signalerContext) ifNil: [process suspendedContext]]}