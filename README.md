# ltreesitter

![test](https://github.com/euclidianAce/ltreesitter/workflows/test/badge.svg)

Tree sitter bindings for Lua

# Documentation

Documentation can be found at [this repo's github pages](https://euclidianace.github.io/ltreesitter/)
(Which are autogenerated using the [Teal](https://github.com/teal-language/tl) script `scripts/gen.tl`)

# Installation

`ltreesitter` is avaliable on luarocks

```
luarocks install ltreesitter
```

or the latest main branch
```
luarocks install --dev ltreesitter
```

# Examples

Looking for a quick start? These snippets should be descriptive enough to get you started. If you need more detail, take a look at the documentation

## Setup

### Loading parsers you have installed on your system
```lua
local ltreesitter = require("ltreesitter")
local c_parser = ltreesitter.require("c") -- assuming you have a compiled c parser named 'c.so' (or 'c.dll' on windows) in '~/.tree-sitter/bin/' and package.cpath
local lua_parser = ltreesitter.require("parser", "lua") -- you have a 'parser.so' (or .dll) with the symbol 'tree_sitter_lua' to load the language
```

```lua
local local_c_parser = ltreesitter.load("./c-parser.so", "c") -- load will just directly load from the filename given. Using a path without a path separator may have unintended consequences, see documentation for details.
```

## Basic parsing and usage of trees and nodes
```lua
local source_code = [[
#include <stdio.h>

// a function that does stuff
static void stuff_doer(void) {
    printf("I'm doing stuff! :D\n");
}

int main(int argc, char **argv) {
    stuff_doer();
    return 0;
}
]]

local tree = c_parser:parse_string(source_code)
print(tree) -- tostring (which print calls automatically) will return the string of s-expressions of trees and nodes

for child in tree:root():named_children() do -- some iterators over nodes' children are provided
   print(child)
end
```

## Queries
Using the above `c_parser` and `tree`
```lua
-- Grab the names of all functions
local my_query = c_parser:query[[
    (translation_unit
      (function_definition
        declarator: (function_declarator
                      declarator: (identifier) @name))) ]]

for capture, name in my_query:capture(tree:root()) do -- iterate over captured nodes without caring about order
   -- Node:source() gives the source code that the node comes from
   print(capture:source(), name) -- => "stuff_doer", "name" and "main", "name"
end

for match in my_query:match(tree:root()) do
   print(match.captures["name"]:source()) -- => "stuff_doer" and "main"
end
```
