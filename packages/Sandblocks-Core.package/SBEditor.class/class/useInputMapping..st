initialize-release
useInputMapping: anInputMappingClass
	" self useInputMapping: SBTextInputMapping "

	InputMappingClass := anInputMappingClass.
	anInputMappingClass new applyFor: self