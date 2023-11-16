# Note Navigation

## Preview
![](preview.mov)
## Features
- Note Navigation and creation.
- Add your own header or footer for every created note.
- Use your own custom note file type.
- Auto close all open note buffers and return to where you left off.
- Define prefix and suffix for your note files.

## Installation

### Lazy.nvim
```
{
    'jcdampil23/notes_plugin.nvim',
    opts = {},
    config = true,
}
```

### Packer.nvim
```
use {
    "jcdampil23/note_navigation.nvim",
    config = function() 
        require("note_navigation").setup({}) 
    end
}
```

## Commands
`:GoToNotesDirectory`: Go to your defined notes index

`:CloseNotes`: Close all open note buffers and returns you to the project buffer before going to notes

`:GoToOrCreateNote <cfile>`: Go to or create the note under your cursor (you can define the note directory and name if you like)

The `:CloseNotes` and `:GoToCreateNote` commands only works in the notes directory

## Default Options

```lua
note = {
    -- Name for the index note file
    index = 'home',
    -- What file type you want your notes to be
    noteType = 'md',
},
    -- Define your keybindings
keybindings = {
    closeNotes = '<leader>nc',
    goToOrCreateNote = 'gn',
},
-- Where you want your notes to be
-- You can make the directory with the :GoToNotesDirectory command if it doesn't exist yet
directory = '~/notes',
-- Adds a header or footer with every generated note
defaultHeader = {
    '## Links',
    '',
    '',
    '## Notes',
},
defaultFooter = {
    '',
    '',
    '# End of Notes',
}
```

## Why?

Honestly I would just recommend [Neorg](https://github.com/nvim-neorg/neorg) for any serious note taking as it's feature filled for your note taking needs, for me I just needed a way to navigate and create notes without thinking about too many features that works for a user defined file type
