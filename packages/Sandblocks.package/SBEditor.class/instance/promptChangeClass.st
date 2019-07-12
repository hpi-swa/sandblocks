actions
promptChangeClass

	| methods index class |
	class := UIManager default chooseClassOrTrait ifNil: [^ self].
	methods := class methodDict keys.
	
	methods size > 1
		ifTrue: [
			index := UIManager default chooseFrom: methods.
			index > 0 ifTrue: [ | method |
				method  := class >> (methods at: index).
				self compiledMethod: method]]
		ifFalse: [self compiledMethod: class >> methods first.]