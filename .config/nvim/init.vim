filetype off

let mapleader =","

if ! filereadable(system('echo -n "${XDG_CONFIG_HOME:-$HOME/.config}/nvim/autoload/plug.vim"'))
	echo "Downloading junegunn/vim-plug to manage plugins..."
	silent !mkdir -p ${XDG_CONFIG_HOME:-$HOME/.config}/nvim/autoload/
	silent !curl "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim" > ${XDG_CONFIG_HOME:-$HOME/.config}/nvim/autoload/plug.vim
	autocmd VimEnter * PlugInstall
endif

call plug#begin(system('echo -n "${XDG_CONFIG_HOME:-$HOME/.config}/nvim/plugged"'))
" Tooling
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'editorconfig/editorconfig-vim'
Plug 'vim-autoformat/vim-autoformat'
" For vsnip users.
Plug 'hrsh7th/cmp-vsnip'
Plug 'hrsh7th/vim-vsnip'

Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'bronson/vim-trailing-whitespace'
Plug 'jiangmiao/auto-pairs'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'

Plug 'preservim/nerdtree'
Plug 'junegunn/goyo.vim'

" Language Plugins
Plug 'fatih/vim-go'


" Python
Plug 'jmcantrell/vim-virtualenv'

" Visual Things
Plug 'joshdick/onedark.vim'
Plug 'kyazdani42/nvim-web-devicons'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
call plug#end()

let g:python3_host_prog = "/usr/bin/python"
set title
set bg=light
set go=a
set mouse=a
set clipboard+=unnamedplus
set noshowmode
set noruler
set laststatus=0
set noshowcmd

" Theme
	colorscheme onedark
	set termguicolors

" Some basics:
	noremap <Up> <nop>
	noremap <Down> <nop>
	noremap <Left> <nop>
	noremap <Right> <nop>

	nnoremap c "_c
	set nocompatible
	filetype plugin indent on
	syntax on
	set encoding=utf-8
	set fileencoding=utf-8
	set termencoding=utf-8
	set number relativenumber
	set autoindent
	set backspace=indent,eol,start
	set complete-=1
	set smarttab
	set wildmenu
	set autoread
	set scrolloff=5
	set sidescrolloff=5
	set display+=lastline
	set listchars=tab:▸\ ,eol:¬,trail:-,extends:>,precedes:<,nbsp:+
	set whichwrap+=<,>,h,l
	set linebreak
	set splitright
	set splitbelow

" Shortcut for ESC
	imap ei <Esc>
" Searching
	nnoremap / /\v
	vnoremap / /\v
	set hlsearch
	set incsearch
	set ignorecase
	set smartcase
	set magic
	map <leader><space> :let @/=''<cr> " clear search

""" Telescope
nnoremap <leader>tf <cmd>Telescope find_files<cr>
nnoremap <leader>tg <cmd>Telescope live_grep<cr>
nnoremap <leader>tb <cmd>Telescope buffers<cr>
nnoremap <leader>th <cmd>Telescope help_tags<cr>

""" Default indention
set tabstop=4
set shiftwidth=4
set softtabstop=4
set noexpandtab

" Gcc Comments


""" Move up and down visual lines (works well with wrapping)
	nnoremap j gj
	nnoremap k gk

""" Change line style (rnu = relativenumber)
	nmap <leader>rl :set rnu<cr>
	nmap <leader>al :set nornu<cr>

	map <leader>q :bd<cr>

" Working with windows
	map <C-j> <C-W>j
	map <C-k> <C-W>k
	map <C-h> <C-W>h
	map <C-l> <C-W>l
" Enable autocompletion:
	set wildmode=longest,list,full

" Disables automatic commenting on newline:
	autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

" Perform dot commands over visual blocks:
	vnoremap . :normal .<CR>

" Goyo plugin makes text more readable when writing prose:
	map <leader>f :Goyo \| set bg=light \| set linebreak<CR>

" Spell-check set to <leader>o, 'o' for 'orthography':
	map <leader>o :setlocal spell! spelllang=en_us<CR>

" Splits open at the bottom and right, which is non-retarded, unlike vim defaults.
	set splitbelow splitright

" Nerd tree
	map <leader>n :NERDTreeToggle<CR>
	autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
	if has('nvim')
		let NERDTreeBookmarksFile = stdpath('data') . '/NERDTreeBookmarks'
	else
		let NERDTreeBookmarksFile = '~/.vim' . '/NERDTreeBookmarks'
	endif

" Replace ex mode with gq
	map Q gq
" AutoFormat
	noremap <F3> :Autoformat<CR>
" filetype detect:
	map <leader>r :filetype detect<CR>

" Check file in shellcheck:
	map <leader>s :!clear && shellcheck -x %<CR>

" Replace all is aliased to S.
	nnoremap S :%s//g<Left><Left>

" Runs a script that cleans out tex build files whenever I close out of a .tex file.
	autocmd VimLeave *.tex !texclear %

" Ensure files are read as what I want:
	let g:vimwiki_ext2syntax = {'.Rmd': 'markdown', '.rmd': 'markdown','.md': 'markdown', '.markdown': 'markdown', '.mdown': 'markdown'}
	map <leader>v :VimwikiIndex<CR>
	let g:vimwiki_list = [{'path': '~/.local/share/nvim/vimwiki', 'syntax': 'markdown', 'ext': '.md'}]
	autocmd BufRead,BufNewFile /tmp/calcurse*,~/.calcurse/notes/* set filetype=markdown
	autocmd BufRead,BufNewFile *.ms,*.me,*.mom,*.man set filetype=groff
	autocmd BufRead,BufNewFile *.tex set filetype=tex

" Save file as sudo on files that require root permission
	cnoremap w!! execute 'silent! write !sudo tee % >/dev/null' <bar> edit!

" Enable Goyo by default for mutt writing
	autocmd BufRead,BufNewFile /tmp/neomutt* let g:goyo_width=80
	autocmd BufRead,BufNewFile /tmp/neomutt* :Goyo | set bg=light
	autocmd BufRead,BufNewFile /tmp/neomutt* map ZZ :Goyo\|x!<CR>
	autocmd BufRead,BufNewFile /tmp/neomutt* map ZQ :Goyo\|q!<CR>

" Automatically deletes all trailing whitespace and newlines at end of file on save. & reset cursor position
 	autocmd BufWritePre * let currPos = getpos(".")
	autocmd BufWritePre * %s/\s\+$//e
	autocmd BufWritePre * %s/\n\+\%$//e
	autocmd BufWritePre *.[ch] %s/\%$/\r/e
  	autocmd BufWritePre * cal cursor(currPos[1], currPos[2])

" When shortcut files are updated, renew bash and ranger configs with new material:
	autocmd BufWritePost bm-files,bm-dirs !shortcuts
" Run xrdb whenever Xdefaults or Xresources are updated.
	autocmd BufRead,BufNewFile Xresources,Xdefaults,xresources,xdefaults set filetype=xdefaults
	autocmd BufWritePost Xresources,Xdefaults,xresources,xdefaults !xrdb %
" Recompile dwmblocks on config edit.
	autocmd BufWritePost ~/.local/src/dwmblocks/config.h !cd ~/.local/src/dwmblocks/; sudo make install && { killall -q dwmblocks;setsid -f dwmblocks }

" Turns off highlighting on the bits of code that are changed, so the line that is changed is highlighted but the actual text that has changed stands out on the line and is readable.
if &diff
    highlight! link DiffText MatchParen
endif

" Function for toggling the bottom statusbar:
let s:hidden_all = 0
function! ToggleHiddenAll()
    if s:hidden_all  == 0
        let s:hidden_all = 1
        set noshowmode
        set noruler
        set laststatus=0
        set noshowcmd
    else
        let s:hidden_all = 0
        set showmode
        set ruler
        set laststatus=2
        set showcmd
    endif
endfunction
nnoremap <leader>h :call ToggleHiddenAll()<CR>

" vim-airline
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#formatter = 'unique_tail_improved'
let g:airline#extensions#virtualenv#enabled = 1
let g:airline#extensions#virtualenv#ft = ['python']
let g:airline_powerline_fonts = 1
let g:airline_theme='onedark'

let g:c_formatter_42_format_on_save=0

""" NVIM LSP Config
lua << EOF
local telescope = require('telescope')
telescope.setup{
	defaults = { file_ignore_patterns = {"vendor"} }
}

local nvim_lsp = require('lspconfig')
local cmp = require('cmp')

cmp.setup({
	snippet = {
      -- REQUIRED - you must specify a snippet engine
	  expand = function(args)
        vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
        -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
        -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
        -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
      end,
    },
	mapping = {
		['<C-Space>'] = cmp.mapping.complete(),
		['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
	},
	sources = {
		{ name = 'nvim_lsp' },
		{ name = 'buffer' },
	}
})

local on_attach = function(client, bufnr)
	local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
	local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

	buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

	local opts = { noremap=true, silent=true }

	buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
	buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
	buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
	buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
	buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
end

local servers = { 'pylsp' ,'rust_analyzer','ccls',  'tsserver', 'gopls', 'svelte', 'zls', 'rescriptls', 'solargraph'}
for _, lsp in ipairs(servers) do
	config = {
		on_attach = on_attach,
		flags = {
			debounce_text_changes = 150,
		},
		capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities()),
	}

	if lsp == 'zls' then
		config.cmd = { '/home/erik/zls/zls' }
	end

	if lsp == 'rescriptls' then
		config.cmd = {'node', '/home/erik/.vim/plugged/vim-rescript/server/out/server.js', '--stdio'}
	end

	nvim_lsp[lsp].setup(config)
end
EOF
