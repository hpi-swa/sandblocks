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
			"baseline: 'StatisticsWorkbench' with: [spec repository: 'github://hpi-swa-teaching/StatisticsWorkbench:dev/packages'];"
			baseline: 'RatPack' with: [spec repository: 'github://hpi-swa-teaching/RatPack:develop/packages'];
			package: 'SVG-Morphic' with: [spec repository: 'http://www.squeaksource.com/SVGMorph'];
			
			package: 'Sandblocks-Core' with: [spec requires: #('SVG-Morphic' 'Sandblocks-Morphs' 'Sandblocks-Layout')];
			package: 'Sandblocks-Explorer' with: [spec requires: #('Sandblocks-Core') "'StatisticsWorkbench'"];
			package: 'Sandblocks-Watch' with: [spec requires: 'Sandblocks-Core'];
			package: 'Sandblocks-Debugger' with: [spec requires: 'Sandblocks-Core'];
			package: 'Sandblocks-Utils';
			package: 'Sandblocks-Layout';
			package: 'Sandblocks-Morphs';
			package: 'Sandblocks-Drawing';
			package: 'Sandblocks-Javascript' with: [spec requires: #('Sandblocks-Core' 'Sandblocks-Representation')];
			package: 'Sandblocks-Compiler';
			package: 'Sandblocks-Format';
			package: 'Sandblocks-Babylonian' with: [spec requires: #('Sandblocks-Core')];
			package: 'Sandblocks-Tutorial' with: [spec requires: 'default'];
			package: 'Sandblocks-Representation';
			
			package: 'Sandblocks-RatPack' with: [spec requires: #('default' 'RatPack')];
			package: 'Sandblocks-ActiveExpression' with: [spec requires: #('default' 'ActiveExpressions')];
			package: 'JumpingCubes' with: [spec requires: #('Sandblocks-ActiveExpression')].
		spec
			group: 'default' with: #('Sandblocks-Core' 'Sandblocks-Layout' 'Sandblocks-Utils' 'Sandblocks-Debugger' 'Sandblocks-Morphs' 'Sandblocks-Explorer' 'Sandblocks-Watch' 'Sandblocks-Format' 'Sandblocks-Drawing' 'Sandblocks-Representation' 'Sandblocks-Compiler' 'Sandblocks-Babylonian' 'Sandblocks-Javascript');
			group: 'tutorial' with: #('Sandblocks-Tutorial');
			group: 'withActiveExpressions' with: #('Sandblocks-ActiveExpression' 'JumpingCubes');
			group: 'withRatPack' with: #('Sandblocks-RatPack')]
]

{ #category : #baseline }
BaselineOfSandblocks >> projectClass [
	^ Smalltalk
		at: #MetacelloCypressBaselineProject
		ifAbsent: [super projectClass]
]
