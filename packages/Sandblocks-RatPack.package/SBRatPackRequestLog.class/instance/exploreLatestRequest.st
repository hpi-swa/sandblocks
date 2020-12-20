as yet unclassified
exploreLatestRequest

	self requestLog ifNotEmpty: [
		Project current addDeferredUIMessage: [
			self lastRequest explore]].