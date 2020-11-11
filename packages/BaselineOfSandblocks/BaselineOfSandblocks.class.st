Class {
	#name : #BaselineOfSandblocks,
	#superclass : #BaselineOf,
	#category : 'BaselineOfSandblocks'
}

{ #category : #baseline }
BaselineOfSandblocks >> baseline: spec [
	<baseline>
	spec for: #common do: [
		spec
			baseline: 'ActiveExpressions' with: [spec repository: 'github://active-expressions/active-expressions-squeak:master/src'];
			baseline: 'StatisticsWorkbench' with: [spec repository: 'github://hpi-swa-teaching/StatisticsWorkbench:dev/packages'];
			package: 'SVG-Morphic' with: [spec repository: 'http://www.squeaksource.com/SVGMorph'];
			
			package: 'Sandblocks-Core' with: [spec requires: #('SVG-Morphic' 'Sandblocks-Morphs')];
			package: 'Sandblocks-Explorer' with: [spec requires: 'StatisticsWorkbench'];
			package: 'Sandblocks-Watch';
			package: 'Sandblocks-Debugger';
			package: 'Sandblocks-Utils';
			package: 'Sandblocks-Layout';
			package: 'Sandblocks-Morphs';
			package: 'Sandblocks-Drawing';
			package: 'Sandblocks-Compiler';
			package: 'Sandblocks-Format';
			package: 'Sandblocks-Babylonian';
			package: 'Sandblocks-Tutorial';
			package: 'Sandblocks-Representation';
			package: 'Sandblocks-ActiveExpression' with: [spec requires: #('default' 'ActiveExpressions')];
			package: 'JumpingCubes' with: [spec requires: #('Sandblocks-ActiveExpression')].
		spec
			group: 'default' with: #('Sandblocks-Core' 'Sandblocks-Layout' 'Sandblocks-Utils' 'Sandblocks-Debugger' 'Sandblocks-Morphs' 'Sandblocks-Explorer' 'Sandblocks-Watch' 'Sandblocks-Format' 'Sandblocks-Drawing' 'Sandblocks-Representation' 'Sandblocks-Compiler' 'Sandblocks-Babylonian');
			group: 'tutorial' with: #('default' 'Sandblocks-Tutorial');
			group: 'withActiveExpressions' with: #('Sandblocks-ActiveExpression' 'JumpingCubes')]
]

{ #category : #baseline }
BaselineOfSandblocks >> projectClass [
	^ Smalltalk
		at: #MetacelloCypressBaselineProject
		ifAbsent: [super projectClass]
]
