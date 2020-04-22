as yet unclassified
rootContext

	^ (SBToggledCode comment: '' active: 2 do: {[process suspendedContext]. [error signalerContext ifNil: [process suspendedContext]]})