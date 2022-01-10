set splitbelow
set splitright
set autoindent smartindent
set smarttab

colorscheme default

set wildmenu
set incsearch
set completeopt=longest,menuone
set scrolloff=5

set number
set encoding=utf-8
set langmap=!\\"№\\;%?*ёйцукенгшщзхъфывапролджэячсмитьбюЁЙЦУКЕHГШЩЗХЪФЫВАПРОЛДЖЭЯЧСМИТЬБЮ;!@#$%&*`qwertyuiop[]asdfghjkl\\;'zxcvbnm\\,.~QWERTYUIOP{}ASDFGHJKL:\\"ZXCVBNM<>

map <F6> :setlocal spell! spelllang=ru<CR>

set rtp+=~/.config/nvim/bundle/Vundle.vim

call vundle#begin()
  " tree
  Plugin 'preservim/nerdtree'

  " lsp integration
  Plugin 'neovim/nvim-lspconfig'

  " completion: main dependency
  Plugin 'ms-jpq/coq_nvim', {'branch': 'coq'}
  " completion: 9000+ Snippets dependency
  Plugin 'ms-jpq/coq.artifacts', {'branch': 'artifacts'}
  " completion: lua & third party sources -- See https://github.com/ms-jpq/coq.thirdparty
  Plugin 'ms-jpq/coq.thirdparty', {'branch': '3p'}

  " golang specific tools
  Plugin 'fatih/vim-go'
call vundle#end()

" start completion automaticaly
let g:coq_settings = { 'auto_start': v:true }

" start completion
lua require("coq")

" no icons for completion (needs a special font installed to function properly)
let g:coq_settings = { 'display.icons.mode': 'none' }

lua require'lspconfig'.gopls.setup{}

