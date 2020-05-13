set nocompatible              " be iMproved, required
filetype off                  " required

call plug#begin('~/.vim/plugged')

Plug 'Chiel92/vim-autoformat'

" golang plugin
Plug 'fatih/vim-go'
Plug 'buoto/gotests-vim'
Plug 'mattn/emmet-vim'

if has('nvim')
	Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
	Plug 'deoplete-plugins/deoplete-go', { 'do': 'make'}
else
	Plug 'Shougo/deoplete.nvim'
	Plug 'deoplete-plugins/deoplete-go', { 'do': 'make'}
	Plug 'roxma/nvim-yarp'
	Plug 'roxma/vim-hug-neovim-rpc'
endif
let g:deoplete#enable_at_startup = 1

" autocomplete
" added nerdtree
Plug 'scrooloose/nerdtree'
call plug#end()

filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line

set splitbelow
set splitright
syntax on
set autoindent smartindent
set smarttab

colorscheme default

set wildmenu
set incsearch
set completeopt=longest,menuone
set omnifunc=syntaxcomplete#Complete
set scrolloff=5

set number
set encoding=utf-8
set langmap=!\\"№\\;%?*ёйцукенгшщзхъфывапролджэячсмитьбюЁЙЦУКЕHГШЩЗХЪФЫВАПРОЛДЖЭЯЧСМИТЬБЮ;!@#$%&*`qwertyuiop[]asdfghjkl\\;'zxcvbnm\\,.~QWERTYUIOP{}ASDFGHJKL:\\"ZXCVBNM<>


map <F6> :setlocal spell! spelllang=ru<CR>
