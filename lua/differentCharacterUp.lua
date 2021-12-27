function findCharacterAtPos(lineNum, col)
  local line = vim.fn.getline(lineNum)
  local reg =  '\\%' .. col .. 'c.'
  return vim.fn.matchstr(line, reg) -- àaèeíi
end

function findFirstDifferentCharacter()
  local lineNum = vim.api.nvim_win_get_cursor(0)[1]
  local col = vim.fn.col('.')
  local ref = findCharacterAtPos(lineNum, col)
  local curLn = 0

  for ln = lineNum-1,1,-1
    do
    local cur = findCharacterAtPos(ln, col)
    curLn = ln
    if ref ~= cur then
      break
    end
  end

  vim.fn.cursor(curLn, col)
end


print(findFirstDifferentCharacter())
