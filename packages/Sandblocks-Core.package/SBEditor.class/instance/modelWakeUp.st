initialize-release
modelWakeUp

	" when our window takes focus again and we're detached, bring us back to the front "
	Project current addDeferredUIMessage: [
		self valueOfProperty: #previousWindow ifPresentDo: [:window | self owner addMorphFront: self]]