actions
evaluateExpression
	<action>
	<actionValidIf: #isExpression>

	| result explorer |
	result := self evaluate.
	self containingArtefact ifNotNil: [
		self containingArtefact cacheType: result class for: self].
	
	explorer := result representIn: self sandblockEditor as: #isToplevelMorph near: self.
	explorer focusAfterDelete: self.
	self sandblockEditor connectFrom: self to: explorer