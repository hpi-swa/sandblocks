as yet unclassified
createTestMethod
	<action>

	| guessedClassName name testClass guessedMethodName method |
	guessedClassName := (self relatedClass name, 'Test') asSymbol.
	testClass := Smalltalk
		at: guessedClassName
		ifAbsent: [
			name := (UIManager default request: 'Test Class name?' initialAnswer: guessedClassName) ifEmpty: [^ self].
			Smalltalk
				at: name
				ifAbsent: [ 
					TestCase
						subclass: name asSymbol
						instanceVariableNames: #()
						classVariableNames: #()
						poolDictionaries: #()
						category: self relatedClass category, '-Tests']].
	guessedMethodName := ('test', self selector capitalized copyReplaceAll: ':' with: '') asSymbol.
	[
		testClass methodDictionary includesKey: guessedMethodName] whileTrue: [guessedMethodName := guessedMethodName, 'x'].
	method := self sandblockEditor openMorphInView: (SBMethod new
		selector: guessedMethodName arguments: #() class: testClass;
		hasUnsavedChanges: true;
		body: SBBlockBody empty).
	self sandblockEditor startInput: method body statements first at: 1 replacingContents: true