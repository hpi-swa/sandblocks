actions
promptChangeClassNewWindow: aBoolean

	| methods index class method |
	class := UIManager default chooseClassOrTrait ifNil: [^ self].
	methods := class methodDict keys.
	
	method := nil.
	methods size > 1
		ifTrue: [
			index := UIManager default chooseFrom: methods.
			index > 0 ifTrue: [
				method  := class >> (methods at: index)]]
		ifFalse: [method := class >> methods first].
	
	aBoolean
		ifTrue: [SBEditor openFor: method] ifFalse: [self compiledMethod: method]