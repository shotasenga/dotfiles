set nocompatible
set relativenumber number
set tabstop=2 shiftwidth=2 expandtab
set backspace=indent,eol,start
set hls
set termguicolors


" disable editing in read-only mode
autocmd BufRead * call RONoEdit()

function! RONoEdit()
  if &readonly == 1
    set nomodifiable
  else
    set modifiable
  endif
endfunction


lua << LUA
vim.pack.add({ "https://github.com/ChmaraX/herdr-nvim" })
require("herdr-nvim").setup({})
LUA
