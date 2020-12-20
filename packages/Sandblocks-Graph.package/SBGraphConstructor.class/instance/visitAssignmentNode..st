as yet unclassified
visitAssignmentNode: aNode

	| value variable assignment |
	variable := self visitLiteralNode: aNode variable.
	value := aNode value accept: self.
	
	assignment := self newNode: SBAssignmentNode.
	assignment update.
	self connect: variable outputSockets first to: assignment inputSockets first.
	self connect: value outputSockets first to: assignment inputSockets second.
	
	^ assignment