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

  " golang specific tools
  Plugin 'fatih/vim-go' " language support
  Plugin 'buoto/gotests-vim' " test generation

  Plugin 'github/copilot.vim'
  let g:copilot_filetypes = {
    \ 'markdown': v:true,
  \}
call vundle#end()
