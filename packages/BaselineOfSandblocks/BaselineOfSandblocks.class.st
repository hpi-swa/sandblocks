Class {
	#name : #BaselineOfSandblocks,
	#superclass : #BaselineOf,
	#category : 'BaselineOfSandblocks'
}

{ #category : #'as yet unclassified' }
BaselineOfSandblocks class >> createSAR [

	| preamble zip |
	zip := ZipArchive new.
	preamble := String streamContents: [:preambleStream |
	    preambleStream
	        nextPutAll: '| loader |
	loader := MCVersionLoader new.';
	        cr.
	    (((self project version: 'baseline') allPackagesForSpecNamed: #default) collect: #name) do: [:name | | stream version |
	        stream := RWBinaryOrTextStream on: (String new: 10000).
	        version := MCVersion
	            package: (MCPackage named: name)
	            info: ((MCPackage named: 'Sandblocks-Core') workingCopy ancestry ancestors
					ifNotEmpty: #first
					ifEmpty: [MCVersionInfo name: name, '-generated.1' id: UUID new message: '' date: Date today time: Time now author: 'generated' ancestors: #()]).
	        version fileOutOn: stream.
	        (zip addString: stream contents as: name, '.mcz') desiredCompressionLevel: 0.
	        preambleStream
	            nextPutAll: 'loader addVersion: (MCMczReader versionFromStream: (self memberNamed: ''';
	            nextPutAll: name;
	            nextPutAll: '.mcz'') contentStream).';
	            cr].
	    preambleStream nextPutAll: 'loader load.'].
	zip addString: preamble as: 'install/preamble'.
	zip writeToFileNamed: 'sandblocks.sar'
]

{ #category : #'as yet unclassified' }
BaselineOfSandblocks class >> projectVersion [

	^ '0.0.0'
]

{ #category : #baseline }
BaselineOfSandblocks >> baseline: spec [
	<baseline>
	spec for: #common do: [
		spec
			baseline: 'ActiveExpressions' with: [spec repository: 'github://active-expressions/active-expressions-squeak:master/src'];
			"baseline: 'StatisticsWorkbench' with: [spec repository: 'github://hpi-swa-teaching/StatisticsWorkbench:dev/packages'];"
			baseline: 'RatPack' with: [spec repository: 'github://hpi-swa-teaching/RatPack:develop/packages'];
			baseline: 'QoppaS' with: [spec repository: 'github://hpi-swa-lab/QoppaS/packages'];
			baseline: 'Ohm' with: [spec repository: 'github://hpi-swa/ohm-s/packages'];
			package: 'SVG-Morphic' with: [spec repository: 'http://www.squeaksource.com/SVGMorph'];
			package: 'PoppyPrint-Core' with: [spec repository: 'github://tom95/poppy-print/packages'];
			
			package: 'Sandblocks-Core' with: [spec requires: #('SVG-Morphic' 'Sandblocks-Morphs' 'Sandblocks-Layout')];
			package: 'Sandblocks-Smalltalk' with: [spec requires: #('Sandblocks-Core' 'PoppyPrint-Core')];
			package: 'Sandblocks-Explorer' with: [spec requires: #('Sandblocks-Core') "'StatisticsWorkbench'"];
			package: 'Sandblocks-Watch' with: [spec requires: 'Sandblocks-Core'];
			package: 'Sandblocks-Debugger' with: [spec requires: 'Sandblocks-Core'];
			package: 'Sandblocks-Utils';
			package: 'Sandblocks-Layout';
			package: 'Sandblocks-Morphs';
			package: 'Sandblocks-Drawing';
			package: 'Sandblocks-Ohm' with: [spec requires: #('Sandblocks-Core' 'Ohm')];
			package: 'Sandblocks-Javascript' with: [spec requires: #('Sandblocks-Core' 'Sandblocks-Representation' 'Ohm')];
			package: 'Sandblocks-Scheme' with: [spec requires: #('Sandblocks-Core' 'Sandblocks-Representation' 'QoppaS')];
			package: 'Sandblocks-Compiler';
			package: 'Sandblocks-Babylonian' with: [spec requires: #('Sandblocks-Core')];
			package: 'Sandblocks-Tutorial' with: [spec requires: 'default'];
			package: 'Sandblocks-Representation';
			
			package: 'Sandblocks-RatPack' with: [spec requires: #('default' 'RatPack')];
			package: 'Sandblocks-ActiveExpression' with: [spec requires: #('default' 'ActiveExpressions')];
			package: 'JumpingCubes' with: [spec requires: #('Sandblocks-ActiveExpression')].
		spec
			group: 'default' with: #('Sandblocks-Core' 'Sandblocks-Smalltalk' 'Sandblocks-Layout' 'Sandblocks-Utils' 'Sandblocks-Debugger' 'Sandblocks-Morphs' 'Sandblocks-Explorer' 'Sandblocks-Watch' 'Sandblocks-Drawing' 'Sandblocks-Representation' 'Sandblocks-Compiler' 'Sandblocks-Babylonian' 'Sandblocks-Javascript' 'Sandblocks-Scheme' 'Sandblocks-Ohm');
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
