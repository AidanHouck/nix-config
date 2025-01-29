" Some values taken from defaults.vim
set nocompatible " disable vi compatibility
set backspace=indent,eol,start " allow backspace over everything
set display=truncate " truncate last line
set nrformats-=octal " don't recognize octal number
map Q gq
inoremap <C-U> <C-G>u<C-U>

" Only do this part when compiled with support for autocommands.
if has("autocmd")
	filetype plugin indent on

	augroup vimStartup
		au!

		autocmd BufReadPost *
					\ if line("'\"") >= 1 && line("'\"") <= line("$") |
					\   exe "normal! g`\"" |
					\ endif

	augroup END

	" Fix nix-shell Shebang highlighting
	augroup my_filetypes
		autocmd BufNewFile,BufRead *.hs syntax match Comment /#!.*/
	augroup END

endif " has("autocmd")


"""""""""""""""""""""
" keybinds/behavior "
"""""""""""""""""""""
" <F5> = execute current file
" :F5 a b c = execute current file with args
nnoremap <F5> :!"%:p"<Enter>
command! -nargs=* F5 :!"%:p" <args>

" disable arrow keys
inoremap <Down> <Nop>
inoremap <Left> <Nop>
inoremap <Right> <Nop>
inoremap <Up> <Nop>

nnoremap <Down> <Nop>
nnoremap <Left> <Nop>
nnoremap <Right> <Nop>
nnoremap <Up> <Nop>

vnoremap <Down> <Nop>
vnoremap <Left> <Nop>
vnoremap <Right> <Nop>
vnoremap <Up> <Nop>

" ; = :
"nnoremap ; :
"vnoremap ; :

" space = search, ctrl+space = r-search
map <space> /
	map <C-space> ?

	" clear search highlighting automatically
	autocmd InsertEnter * :let @/=""

""""""""""""""""""""
" misc options
""""""""""""""""""""

" expand history
set history=500

" enable mouse because i'm a weakling
set mouse=a

" enable syntax highlighting
syntax on
let c_comment_strings=1

" enable command autocomplete menu on tab
set wildmenu

" search settings
set hlsearch
set incsearch
set wrapscan

" no bell noises
set noerrorbells
set novisualbell
set t_vb=
set tm=500

" change tab behavior
set tabstop=4
set shiftwidth=4
set softtabstop=4

" show whitespace
set list

" add line numbers
set number

" set line wrapping
set wrap

" scroll around the cursor, not at the very edge of the screen
set scrolloff=6

" timeout settings
set incsearch
set ttimeout            " time out for key codes
set ttimeoutlen=100     " wait up to 100ms after Esc for special key

" color
set background=dark
color desert

""""""""""""""""""""""""
" Plugin Configuration "
""""""""""""""""""""""""
" vim-autoformat
"let g:formatdef_alejandra_nix = '"alejandra -qq ."' " Use custom formatter
"let g:formatters_nix = ['alejandra_nix']
"au BufWrite *.nix :Autoformat " Format on file save

