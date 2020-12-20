as yet unclassified
rootContext

	^ SBToggledCode
		comment: ''
		active: 1
		do: {[process suspendedContext]. [(error ifNotNil: #signalerContext) ifNil: [process suspendedContext]]}