call plug#begin('~/AppData/Local/nvim/plugged')

" Основной плагин
Plug 'tpope/vim-sensible'

" Использовать release ветку (рекомендуется)
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'neoclide/vim-jsx-improve'

" Поддержка Go
Plug 'josa42/coc-go', {'do': 'yarn install --frozen-lockfile'}

" Поддержка C++
Plug 'clangd/coc-clangd', {'do': 'yarn install --frozen-lockfile'}

" Поддержка Rust
Plug 'neoclide/coc-rls', {'do': 'yarn install --frozen-lockfile'}

" Плагин для терминала
Plug 'voldikss/vim-floaterm'

" Синяя тема
Plug 'rakr/vim-one'

" Плагин для проводника файлов
Plug 'preservim/nerdtree'

" Альтернатива auto-pairs
Plug 'windwp/nvim-autopairs'

" Airline для статусной строки/вкладок
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" Интеграция с Git
Plug 'tpope/vim-fugitive'

" Подсветка синтаксиса
Plug 'sheerun/vim-polyglot'

" Улучшенное комментирование кода
Plug 'b3nj5m1n/kommentary'

" Плагин для управления буферами
Plug 'jeetsukumaran/vim-buffergator'

call plug#end()

set number

" Настройки nvim-autopairs
lua << EOF
require('nvim-autopairs').setup{ 
    map_cr = true,
    map_complete = true
}
EOF

" Настройки coc.nvim
" Использовать Tab для вызова автодополнения и навигации
inoremap <silent><expr> <TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
inoremap <silent><expr> <S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

" Make <CR> to accept selected completion item or notify coc.nvim to format
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" Использовать [g и ]g для навигации по диагностике
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" Переход к определению кода
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Использовать K для показа документации в окне предпросмотра
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= -1)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

" Подсвечивать символ и его ссылки при удержании курсора
autocmd CursorHold * silent call CocActionAsync('highlight')

" Переименование символов
nmap <leader>rn <Plug>(coc-rename)

" Форматирование выделенного кода
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

" Настройка formatexpr для определенных типов файлов
autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')

" Обновление справки по подписи при переходе к заполнительному символу
autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')

" Set the leader key
let mapleader = ","

" Настройки Floaterm
nnoremap <silent> <leader>ft :FloatermToggle<CR>
tnoremap <silent> <leader>ft <C-\><C-n>:FloatermToggle<CR>

" Настройки NERDTree
nnoremap <silent> ,m :NERDTreeToggle<CR>

" Start NERDTree when Vim is started without file arguments.
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists('s:std_in') | NERDTree | endif

" Exit Vim if NERDTree is the only window remaining in the only tab.
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | call feedkeys(":quit\<CR>:\<BS>") | endif

let g:NERDTreeFileLines = 1
let g:NERDTreeDirArrowExpandable = '→'
let g:NERDTreeDirArrowCollapsible = '↓'

" Включение синей темы vim-one
syntax enable
set background=dark
colorscheme one

" Настройки Airline
let g:airline#extensions#tabline#enabled = 1

" Горячие клавиши для перехода между буферами
nnoremap <silent> <C-h> :bprevious<CR>
nnoremap <silent> <C-l> :bnext<CR>

" Включение kommentary
let g:kommentary_create_default_mappings = 1

" Настройки Buffergator
nnoremap <silent> <leader>bg :BuffergatorOpen<CR>

" Map Ctrl+A in normal mode to select all text
nnoremap <C-a> ggVG

" Map Ctrl+A in visual mode to select all text
vnoremap <C-a> ggVG

" Map Ctrl+Z to undo the previous state
nnoremap <C-z> u
inoremap <C-z> <C-o>u
vnoremap <C-z> <Esc>u

" Map <A-f> to execute the :G command in normal mode
nnoremap <A-f> =G<CR>

