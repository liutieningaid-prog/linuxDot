" 恢复快捷键
noremap <C-u> <C-r>
noremap <C-r> <C-u>
noremap zz u
noremap Z <C-r>
" 代码折叠
noremap zi :set foldmethod=indent<CR>
noremap zm :set foldmethod=marker<CR>
" 翻页快捷键
noremap j k
noremap k j
noremap <C-h> ^
noremap <C-l> <end>
" noremap <C-j> <C-f>
" noremap <C-k> <C-b>
noremap J 25k
noremap K 25j
"保存快捷键
map s <nop>
map <C-s> :w<CR>
"取消高亮
noremap \/ :nohlsearch<CR>
"分屏
noremap \h :set nosplitright<CR>:vsplit<CR>
noremap \l :set splitright<CR>:vsplit<CR>
noremap \j :set nosplitbelow<CR>:split<CR>
noremap \k :set splitbelow<CR>:split<CR>
noremap \a <C-w>h
noremap \d <C-w>l
noremap \w <C-w>j
noremap \s <C-w>k
" 标签
noremap \n :tabe<CR>
noremap \q :-tabnext<CR>
noremap \e :+tabnext<CR>

" tmux Copy to system clipboard
" nnoremap \c :call CopyToSystem()<CR>
" function CopyToSystem()
"     let bExistTermuxApi=!system('dpkg -s termux-api >/dev/null 2>&1; echo $?')
"     if bExistTermuxApi
"         let tmpfile = system('mktemp')
"         call writefile(getreg('0',1,1), tmpfile, 'b')
"         call system('cat "'. tmpfile . '" |termux-clipboard-set')
"         call system('termux-toast "copied to clipboard."')
"         call system('rm "' . tmpfile . '"' )
"     else
"         echom "termux-api not installed."
"     endif
" endfunc


" =========================
" set
" =========================


set fileencodings=utf-8,ucs-bom,gb18030,gbk,gb2312,cp936
set termencoding=utf-8
set encoding=utf-8

" 取消查找时大小写
" set ic
set ignorecase
set smartcase
" 开启查找时高亮
set hlsearch
set incsearch
exec "nohlsearch"

" set is
" 如果退格键无法正常使用
set backspace=indent,eol,start
" 显示行号
set number
set relativenumber
" 显示光标当前位置
set ruler
" 设置缩进
set cindent
set tabstop=4
set shiftwidth=4

" 设置换行
set wrap

" 突出显示当前行
set cursorline
" 左下角显示当前 vim 模式
set showmode
set showcmd
" vim指令有选项
set wildmenu

" 代码折叠
set nofoldenable
set foldmethod=indent

" 重新进入记住位置
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

" =========================
" plugs
" =========================
execute pathogen#infect()
syntax on
filetype plugin indent on

" =========================
" lightline
set laststatus=2
let g:lightline = {
      \ 'colorscheme': 'powerline',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'readonly', 'filename', 'modified' ] ],
      \   'right': [ [ 'percent' ],
      \              [ 'fileformat', 'fileencoding', 'filetype' ] ]
      \ },
      \ }

" === Undotree
" ===
let g:undotree_DiffAutoOpen = 0
map \z :UndotreeToggle<CR>

" 主题
" set background=dark
" colorscheme elflord
" colorscheme ron


