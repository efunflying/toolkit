"set backup
"syntax on
"set autoindent
"set list
"set cindent
"set shiftwidth=4
"set tabstop=4
"set expandtab
" An example for a vimrc file.
"
" Maintainer:	Bram Moolenaar <Bram@vim.org>
" Last change:	2006 Aug 12
"
" To use it, copy it to
"     for Unix and OS/2:  ~/.vimrc
"	      for Amiga:  s:.vimrc
"  for MS-DOS and Win32:  $VIM\_vimrc
"	    for OpenVMS:  sys$login:.vimrc

" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim"
  finish
endif

" Use Vim settings, rather then Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

if has("vms")
  set nobackup		" do not keep a backup file, use versions instead
else
  set backup		" keep a backup file
endif
set history=50		" keep 50 lines of command line history
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set incsearch		" do incremental searching

" For Win32 GUI: remove 't' flag from 'guioptions': no tearoff menu entries
" let &guioptions = substitute(&guioptions, "t", "", "g")

" Don't use Ex mode, use Q for formatting
map Q gq

" In an xterm the mouse should work quite well, thus enable it.
set mouse=a

" This is an alternative that also works in block mode, but the deleted
" text is lost and it only works for putting the current register.
"vnoremap p "_dp

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif

  augroup END

else

  set autoindent		" always set autoindenting on

endif " has("autocmd")

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
	 	\ | wincmd p | diffthis

set nu
set tabstop=4
set shiftwidth=4


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" mapleader settings 
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Set mapleader
let mapleader = ","

" Fast reloading of the .vimrc
map <silent> <leader>ss :source ~/.vimrc<cr>

" Fast editing .vimrc
map <silent> <leader>ee :e ~/.vimrc<cr>

" When .vimrc is edited, reload it
autocmd! bufwritepost .vimrc source ~/.vimrc


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Tag list (ctags)
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let Tlist_Ctags_Cmd='/usr/bin/ctags'
let Tlist_Show_One_File=1
let Tlist_Exit_OnlyWindow=1
let Tlist_Use_Right_Window=1

if filereadable("../../tags")
	set tags=../../tags
endif
if filereadable("../tags")
	set tags=../tags
endif
if filereadable("tags")
	set tags=tags
endif

map <silent> <F8> <C-W>]
map <silent> <F12> :q<cr>
map <silent> <F7> :scs find c <C-R>=expand("<cword>")<CR><CR>
map <silent> <F4> @:

map <silent> <F9> :TlistToggle<cr>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" netrw setting
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:netrw_winsize=30
nmap <silent> <leader>fe :Sexplore!<cr>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" BufExplorer
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:bufExplorerDefaultHelp=0
let g:bufExplorerShowRelativePath=1
let g:bufExplorerSortBy='mru'
let g:bufExplorerSplitRight=0
let g:bufExplorerSplitVertical=1
let g:bufExplorerSplitVertSize=30
let g:bufExplorerUseCurrentWindow=1
let g:bufExplorerMinHeight=8
let g:bufExplorerMaxHeight=10
autocmd BufWinEnter \[Buf\ List\] setl nonumber

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" winManager setting
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:winManagerWindowLayout="BufExplorer,FileExplorer|TagList"
let g:winManagerWidth=30
let g:defaultExplorer=0
nmap <C-W><C-F> :FirstExplorerWindow<cr>
nmap <C-W><C-B> :BottomExplorerWindow<cr>
nmap <silent> <leader>wm :WMToggle<cr>
nmap <silent> <leader>me <C-W>_
nmap <silent> <leader>eq <C-W>=

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" lookupfile setting
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" lookup file with ignore case
function! LookupFile_IgnoreCaseFunc(pattern)
	let _tags = &tags
	try
		let &tags = eval(g:LookupFile_TagExpr)
		let newpattern = '\c' . a:pattern
		let tags = taglist(newpattern)
	catch
		echohl ErrorMsg | echo "Exception: " . v:exception | echohl NONE
		return ""
	finally
		let &tags = _tags
	endtry

	" Show the matches for what is typed so far.
	let files = map(tags, 'v:val["filename"]')
	return files
endfunction

let g:LookupFile_LookupFunc = 'LookupFile_IgnoreCaseFunc'
let g:LookupFile_MinPatLength=2
let g:LookupFile_PreserveLastPattern=0
let g:LookupFile_PreservePatternHistory=1
let g:LookupFile_AlwaysAcceptFirst=1
let g:LookupFile_AllowNewFiles=0
if filereadable("./filenametags")
	let g:LookupFile_TagExpr='"./filenametags"'
endif
nmap <silent> <leader>ll :LUBufs<cr>
nmap <silent> <leader>lw :LUWalk<cr>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" mark setting
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"nmap <silent> <leader>hl <Plug>MarkSet
"vmap <silent> <leader>hl <Plug>MarkSet
"nmap <silent> <leader>hh <Plug>MarkClear
"vmap <silent> <leader>hh <Plug>MarkClear
"nmap <silent> <leader>hr <Plug>MarkRegex
"vmap <silent> <leader>hr <Plug>MarkRegex


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" scope setting
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if has("cscope")
	set csprg=/usr/bin/cscope
	set csto=1
	set cst
	set nocsverb
	" add any database in current directory
	if filereadable("cscope.out")
		cs add cscope.out
	endif
	if filereadable("../cscope.out")
		cs add ../cscope.out
	endif
	if filereadable("../../cscope.out")
		cs add ../../cscope.out
	endif
	set csverb
endif

nmap <C-@>s :scs find s <C-R>=expand("<cword>")<CR><CR>
nmap <C-@>g :scs find g <C-R>=expand("<cword>")<CR><CR>
nmap <C-@>c :scs find c <C-R>=expand("<cword>")<CR><CR>
nmap <C-@>t :scs find t <C-R>=expand("<cword>")<CR><CR>
nmap <C-@>e :scs find e <C-R>=expand("<cword>")<CR><CR>
nmap <C-@>f :scs find f <C-R>=expand("<cfile>")<CR><CR>
nmap <C-@>i :scs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
nmap <C-@>d :scs find d <C-R>=expand("<cword>")<CR><CR>

au BufWinLeave * silent mkview
au BufWinEnter * silent loadview

set laststatus=2
".................
"set statusline=%2*%n%m%r%h%w%*\ %F\
"%1*[FORMAT=%2*%{&ff}:%{&fenc!=''?&fenc:&enc}%1*]\ [TYPE=%2*%Y%1*]\
"[COL=%2*%03v%1*]\ [ROW=%2*%03l%1*/%3*%L(%p%%)%1*]\ *^÷
"".................
function! InsertStatuslineColor(mode)
	if a:mode == 'i'
		hi statusline guibg=peru
	elseif a:mode == 'r'
		hi statusline guibg=blue
	else
		hi statusline guibg=red
	endif
endfunction

au InsertEnter * call InsertStatuslineColor(v:insertmode)
au InsertLeave * hi statusline guibg=orange guifg=white
hi statusline guibg=green

if filereadable("search_path.vim")
	source search_path.vim
endif

if filereadable("workspace.vim")
	source workspace.vim
endif

set tags+=~/.vim/systags

if filereadable("inc.vim")
	source inc.vim
endif

set list
set listchars=tab:>-,trail:-

highlight Search term=standout ctermfg=0 ctermbg=Yellow guifg=Black guibg=Yellow
highlight Comment term=standout ctermfg=6

set expandtab
