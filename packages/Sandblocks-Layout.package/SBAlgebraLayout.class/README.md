A SBAlgebraLayout is a layout policy that calls uses Commands to arrive at a layout. For example, a command could be #softLine, instructing the layout to only place a linebreak here if there is not enough horizontal space otherwise.

Each Morph can implement #layoutCommands, which must return a SBAlgebraCommand. If you want to use the SBAlgebraLayout, assign this layoutPolicy to all morphs in your subtree. The layoutPolicy will then take care that only the topmost layout will actually perform any positioning (#isAlgebraLayoutRoot:).

The algorithm is based on this paper: http://homepages.inf.ed.ac.uk/wadler/papers/prettier/prettier.pdf
See also this article for a simple explanation: https://blog.vjeux.com/2017/javascript/anatomy-of-a-javascript-pretty-printer.html