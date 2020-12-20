as yet unclassified
moveToInstanceSide
	<action>
	<actionValidIf: #isClassSideMethod>

	self sandblockEditor do: ((SBMoveMethodCommand newFor: self)
		method: self;
		toClass: self relatedClass theNonMetaClass)