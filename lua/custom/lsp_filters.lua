local M = {}

-- Files to skip when jumping to definitions or listing references.
-- Lua patterns, not globs: "%.test%.tsx?$" ~ *.test.ts / *.test.tsx
M.ignore_patterns = { "%.test%.tsx?$", "%.spec%.tsx?$" }

function M.is_ignored(filename)
	for _, pat in ipairs(M.ignore_patterns) do
		if filename:match(pat) then
			return true
		end
	end
	return false
end

return M
