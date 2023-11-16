local M = {};
local context = {};
local utils = require('notes_navigation.utils')

local function goToOrCreateNote(filePath)
    if utils.fileExists(filePath) then
        vim.cmd.edit(filePath);
    else
        local header = {}
        header = context.opts.defaultHeader;
        local cursor_position = utils.getTableLength(header) + 1;
        header[2] = context.opts.note.index;
        local footer = context.opts.defaultFooter;

        vim.cmd.edit(filePath);

        vim.api.nvim_buf_set_lines(0, 0, 0, 0, header);
        vim.api.nvim_buf_set_lines(0, cursor_position, cursor_position, 0, footer);
        vim.api.nvim_win_set_cursor(0, { cursor_position, 0 });

        vim.cmd('w ++p');
    end
end

local function goToNotesDirectory()
    local notesDirectory = vim.fn.expand(context.opts.directory);
    local returnPath = vim.fn.expand('%:p');
    context.returnPath = returnPath;

    goToOrCreateNote(
        notesDirectory .. '/' .. context.opts.note.index .. '.' .. context.opts.note.noteType
    );
    vim.cmd('lcd ' .. notesDirectory);
end

local function closeNotes()
    vim.cmd('bufdo if (bufname() =~ ".*\\.' .. context.opts.note.noteType .. '$") | bd | endif')
    local directory = vim.fn.fnamemodify(context.returnPath, ":p:h")

    if utils.isDirectory(context.returnPath) then
        vim.cmd('lcd ' .. directory);
        vim.cmd.edit(context.returnPath);
    else
        vim.cmd('lcd ' .. directory);
        vim.cmd.edit(context.returnPath);
    end
end

local function generateCommands()
    vim.api.nvim_create_user_command(
        'GoToNotesDirectory',
        function()
            goToNotesDirectory()
        end,
        {}
    );

    vim.api.nvim_create_user_command(
        'CloseNotes',
        function()
            closeNotes()
        end,
        {}
    );

    vim.api.nvim_create_user_command(
        'GoToOrCreateNote',
        function(opts)
            vim.cmd('lcd ' .. context.opts.note.directory);
            vim.cmd.write();
            local filePath = vim.fn.expand(opts.args);
            local completePath = vim.fn.expand(
                context.opts.directory .. '/' .. filePath .. '.' .. context.opts.note.noteType);
            goToOrCreateNote(completePath);
        end,
        { nargs = 1 }
    )

    local group = vim.api.nvim_create_augroup('notesPlugin', { clear = true });
    vim.api.nvim_create_autocmd(
        { 'BufRead', 'BufNewFile' }, {
            group = group,
            pattern = vim.fn.expand(context.opts.directory) .. '/**.' .. context.opts.note.noteType,
            command = 'noremap <buffer> ' ..
                context.opts.keybindings.goToOrCreateNote .. ' :GoToOrCreateNote <cfile> <CR>',
        }
    )
    vim.api.nvim_create_autocmd(
        { 'BufRead', 'BufNewFile' }, {
            group = group,
            pattern = vim.fn.expand(context.opts.directory) .. '/**.' .. context.opts.note.noteType,
            command = 'noremap <buffer> ' .. context.opts.keybindings.closeNotes .. ' :CloseNotes <CR>',
        }
    )
end

M.setup = function(opts)
    opts = opts or {};
    local defaultOpts = {
        note = {
            index = 'home',
            noteType = 'md',
        },
        keybindings = {
            closeNotes = '<leader>nc',
            goToOrCreateNote = 'gn',
        },
        directory = '~/notes',
        defaultHeader = {
            '## Backlinks',
            'home',
            '',
            '## Notes',
        },
        defaultFooter = {
            '',
            '',
            '# End of Notes',
        }
    };
    context.opts = vim.tbl_extend('force', defaultOpts, opts);
    generateCommands();
end

return M;
