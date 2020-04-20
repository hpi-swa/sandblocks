as yet unclassified
currentBlockForPC

	| method |
	method := self sandblockEditor openCompiledMethod: (self currentStackFrame context method).
	^ method blockForPC: self currentStackFrame context pc