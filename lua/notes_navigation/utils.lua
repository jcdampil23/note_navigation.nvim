local M = {};

M.fileExists = function(filePath)
    return vim.fn.filereadable(filePath) == 1;
end;

M.getTableLength = function(table)
    local count = 0;
    for _ in pairs(table) do count = count + 1 end
    return count;
end;

M.isDirectory = function(path)
    return vim.fn.isdirectory(path) == 1;
end;

return M;
