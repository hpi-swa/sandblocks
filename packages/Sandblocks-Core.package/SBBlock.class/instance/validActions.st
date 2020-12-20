as yet unclassified
validActions

	| mode |
	mode := self sandblockEditor mode.
	^ self actions select: [:action |
		((mode = #input and: [action keyword = #inputAction]) or: [
			(mode = #command and: [
				#(#action #multiSelectAction) includes: action keyword]) or: [
				(mode = #selection or: [mode = #continuousSelection]) and: [action keyword = #multiSelectAction]]]) and: [
			(action method pragmaAt: #actionValidIf:) ifNotNil: [:validPragma | self perform: validPragma arguments first] ifNil: [true]]]