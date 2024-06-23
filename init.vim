call plug#begin('~/AppData/Local/nvim/plugged')

" Основной плагин
Plug 'tpope/vim-sensible'

" Использовать release ветку (рекомендуется)
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'neoclide/vim-jsx-improve'

" Плагин для терминала
Plug 'voldikss/vim-floaterm'

" Синяя тема
Plug 'folke/tokyonight.nvim'

" Плагин для проводника файлов
Plug 'preservim/nerdtree'

" Альтернатива auto-pairs
Plug 'windwp/nvim-autopairs'

" Вкладки
Plug 'nvim-tree/nvim-web-devicons' " OPTIONAL: for file icons
Plug 'lewis6991/gitsigns.nvim' " OPTIONAL: for git status
Plug 'romgrk/barbar.nvim'

" Add galaxyline plugin
Plug 'glepnir/galaxyline.nvim'
Plug 'SmiteshP/nvim-gps'
Plug 'nvim-treesitter/nvim-treesitter'
Plug 'mfussenegger/nvim-dap'

" Icons 
Plug 'ryanoasis/vim-devicons'      " vimscript

" Cursor line
Plug 'yamatsum/nvim-cursorline'

" Интеграция с Git
Plug 'tpope/vim-fugitive'

" Подсветка синтаксиса
Plug 'sheerun/vim-polyglot'
Plug 'maxmellon/vim-jsx-pretty'
Plug 'leafgarland/typescript-vim'
Plug 'peitalin/vim-jsx-typescript'

" Улучшенное комментирование кода
Plug 'preservim/nerdcommenter'

" Плагин для управления буферами
Plug 'jeetsukumaran/vim-buffergator'

call plug#end()

set encoding=UTF-8
set number
syntax on
colorscheme tokyonight-storm

" Syntax ts, tsx settings
let g:typescript_compiler_binary = 'tsc'
let g:typescript_compiler_options = ''

" set filetypes as typescriptreact
autocmd BufNewFile,BufRead *.tsx,*.jsx set filetype=typescriptreact

" dark red
hi tsxTagName guifg=#E06C75
hi tsxComponentName guifg=#E06C75
hi tsxCloseComponentName guifg=#E06C75
hi tsxCloseTagName guifg=#E06C75

" Syntax jsx settings
let g:vim_jsx_pretty_highlight_close_tag = 1
let g:vim_jsx_pretty_colorful_config = 1 " default 0

lua << EOF
-- Настройка для nvim-autopairs
require('nvim-autopairs').setup{ 
    map_cr = true,
    map_complete = true
}
-- Настройка для nvim-cursorline
require('nvim-cursorline').setup {
  cursorline = {
    enable = true,
    timeout = 1000,
    number = false,
  },
  cursorword = {
    enable = true,
    min_length = 3,
    hl = { underline = true },
  }
}
-- Настройка git символов изменений
require('gitsigns').setup {
  signs = {
    add          = { text = '┃' },
    change       = { text = '┃' },
    delete       = { text = '_' },
    topdelete    = { text = '‾' },
    changedelete = { text = '~' },
    untracked    = { text = '┆' },
  },
  signcolumn = true,  -- Toggle with `:Gitsigns toggle_signs`
  numhl      = false, -- Toggle with `:Gitsigns toggle_numhl`
  linehl     = false, -- Toggle with `:Gitsigns toggle_linehl`
  word_diff  = false, -- Toggle with `:Gitsigns toggle_word_diff`
  watch_gitdir = {
    follow_files = true
  },
  auto_attach = true,
  attach_to_untracked = false,
  current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
  current_line_blame_opts = {
    virt_text = true,
    virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
    delay = 1000,
    ignore_whitespace = false,
    virt_text_priority = 100,
  },
  current_line_blame_formatter = '<author>, <author_time:%R> - <summary>',
  sign_priority = 6,
  update_debounce = 100,
  status_formatter = nil, -- Use default
  max_file_length = 40000, -- Disable if file is longer than this (in lines)
  preview_config = {
    -- Options passed to nvim_open_win
    border = 'single',
    style = 'minimal',
    relative = 'cursor',
    row = 0,
    col = 1
  },
}
EOF

" Настройка для galaxyline
:luafile ~/AppData/Local/nvim/galaxy_line_config.lua

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

" Горячие клавиши для перехода между буферами
nnoremap <silent> <C-h> :bprevious<CR>
nnoremap <silent> <C-l> :bnext<CR>

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

" Toggle comment with Ctrl+/
nnoremap <silent> <C-_> :call nerdcommenter#Comment('n', 'toggle')<CR>
vnoremap <silent> <C-_> :call nerdcommenter#Comment('x', 'toggle')<CR>

