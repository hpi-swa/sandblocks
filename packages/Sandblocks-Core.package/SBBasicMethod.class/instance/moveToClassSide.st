as yet unclassified
moveToClassSide
	<action>
	<actionValidIf: #isInstanceSideMethod>

	self sandblockEditor do: ((SBMoveMethodCommand newFor: self)
		method: self;
		toClass: self relatedClass class)