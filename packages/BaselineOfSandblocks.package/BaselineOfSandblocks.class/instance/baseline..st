baseline
baseline: spec
	<baseline>
	spec for: #common do: [
		spec
			baseline: 'ActiveExpressions' with: [spec repository: 'github://active-expressions/active-expressions-squeak:master/src'];
			package: 'SVG-Morphic' with: [spec repository: 'http://www.squeaksource.com/SVGMorph'];
			
			package: 'Sandblocks-Core' with: [spec requires: #('SVG-Morphic')];
			package: 'Sandblocks-Watch';
			package: 'Sandblocks-Drawing';
			package: 'Sandblocks-Format';
			package: 'Sandblocks-ActiveExpression' with: [spec requires: #('default' 'ActiveExpressions');
			package: 'JumpingCubes' with: [spec requires: #('Sandblocks-ActiveExpression')]].
		spec
			group: 'default' with: #('Sandblocks-Core' 'Sandblocks-Watch' 'Sandblocks-Format' 'Sandblocks-Drawing');
			group: 'withActiveExpressions' with: #('Sandblocks-ActiveExpression' 'JumpingCubes')]