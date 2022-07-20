local keymap = vim.keymap.set

-- Bracey bindings
keymap('n', '<Leader>b', '<cmd> Bracey <cr>')
keymap('n', '<Leader>bb', '<cmd> BraceyStop <cr>')
keymap('n', '<Leader>bbb', '<cmd> BraceyReload <cr>')

-- Bufferline bindings
keymap('n', 'f', '<cmd> BufferLinePick <cr>')
keymap('n', 'F', '<cmd> BufferLinePickClose <cr>')
keymap('n', '<TAB>', '<cmd> BufferLineCycleNext <cr>')
keymap('n', '<S-TAB>', '<cmd> BufferLineCyclePrev <cr>')
keymap('n', 'm.', '<cmd> BufferLineMoveNext <cr>')
keymap('n', 'm,', '<cmd> BufferLineMovePrev <cr>')

-- LSP Diagnostics Toggle bindings
keymap('n', '<Leader>dd', '<cmd> ToggleDiag <cr>')

-- Other bindings nvimtree, Colorizer,
keymap('n', '<Leader>cc', '<cmd> ColorizerToggle <cr>')
keymap('n', '<Leader><Space>', '<cmd> noh <cr>')
keymap('n', '[[', '<cmd> vertical resize +7 <cr>')
keymap('n', ']]', '<cmd> vertical resize -7 <cr>')
keymap('n', '+', '<cmd> resize +1 <cr>')
keymap('n', '-', '<cmd> resize -1 <cr>')
