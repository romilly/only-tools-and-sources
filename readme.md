A collection of utilities and sample code to promote the use of the `-script` option in [Dyalog v14](http://dyalog.com/dyalog/dyalog-versions/140.htm)

Most APL developers are accustomed to storing their code in a _workspace_—a snapshot of how code and data are represented in the interpreter's memory.  A workspace is essentially a binary blob: a developer cannot open it in a text editor, view diffs when under a VCS, or use standard text processing tools such as grep or sed.

Despite this tradition, there is nothing in the core language that necessitates the use of workspaces.  This repository's goal is to demonstrate how writing APL programs in text files has become possible in Dyalog v14 with the introduction of the `-script` option.

The opinions expressed here are mine and do not necessarily coincide with Dyalog's.

To be able to run the examples, you need to [acquire a copy of Dyalog](http://www.dyalog.com/prices-and-licences.htm) and put the `bin` directory on your `$PATH`.
