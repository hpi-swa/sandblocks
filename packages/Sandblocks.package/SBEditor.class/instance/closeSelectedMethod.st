actions
closeSelectedMethod

	self do: (SBDeleteCommand new wasEdit: false; target: self selection containingMethod owner)