as yet unclassified
imageForm

	^ ((SBEditor new openCompiledMethod: self method; yourself) method blockForPC: self pc) imageForm