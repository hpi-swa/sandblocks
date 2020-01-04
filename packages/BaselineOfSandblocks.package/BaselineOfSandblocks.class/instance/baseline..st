baseline
baseline: spec
	<baseline>
	spec for: #common do: [
		spec
			package: 'Sandblocks';
			package: 'Sandblocks-Watch';
			package: 'Sandblocks-Drawing';
			package: 'Sandblocks-Format';
			package: 'Sandblocks-ActiveExpressions' with: [spec requires: #('default')].
		spec
			group: 'default' with: #('Sandblocks' 'Sandblocks-Watch' 'Sandblocks-Format' 'Sandblocks-Drawing');
			group: 'ActiveExpressions' with: #('Sandblocks-ActiveExpressions')]