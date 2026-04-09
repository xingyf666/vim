
"
" Scroll to the end of this file to see my plugin list.
" Comment or uncomment some of them as you wish.
"
scriptencoding utf-8

"
" Key maps
" --------
"
" q     - equivalent to :wq, save and exit current window
" <C-q> - equivalent to :bd, close current opening file
" Q     - equivalent to q in old mappings, to record macros
" H     - equivalent to ^, goto start of line, 3H for goto the 3rd char
" L     - equivalent to $, goto end of line, 3L for the 3rd char from end
" kj    - equivalent to <ESC>, exit insert mode
" t     - find character over lines (vim-easymotion)
"
" <F1>  - save and switch to last used tab
" <F2>  - save and switch to previous tab
" <F3>  - save and switch to next tab
" <F4>  - save all opened files
"
" gcc       - comment selected code (support visual mode)
" gcu       - uncomment selected code (support visual mode)
" gc<space> - toggle comment of selected code (support visual mode)
" gci       - invert comment of selected code (support visual mode)
" gc$       - comment until EOL using line comment
" gcA       - append line comment on current line
"
" <F5>     - build and run current CMake project
" <F6>     - build current CMake project, but don't run
" <F7>     - run current file as a single script (.c .cpp .py)
" <S-F5>   - stop current async task
" <S-F6>   - configure current CMake project
" zt       - toggle project file tree window
" zp       - toggle compile error window (quickfix)
"
" <C-t>    - toggle built-in terminal
" <ESC>    - enter normal mode in terminal (to select text)
" i or a   - get back to insert mode in terminal
" <C-w> w  - switch out of terminal window (back to editor)
" <C-w> "" - paste from vim clipboard to terminal
"
"
" Build and Run
" =============
"
" For build and run projects, I use the plugin 'asynctasks.vim'.
"
" By default <F5> will build the CMake project, and run the target named 'main'.
" This is defined in the '~/.vim/tasks.ini', which is bundled in my '.vim':
"
" [+]
" build_type=Release
" build_target=main
" build_dir=build
" build_generator=NMake Makefiles
" run_target="$(VIM:build_dir)\$(VIM:build_target).exe"
" build_options=
" build_configs=
"
" [project-build]
" command=cmake -G "$(VIM:build_generator)" -B "$(VIM:build_dir)" -DCMAKE_EXPORT_COMPILE_COMMANDS:BOOL=ON -DCMAKE_BUILD_TYPE="$(VIM:build_type)" $(VIM:build_configs) && cmake --build "$(VIM:build_dir)" --target "$(VIM:build_target)" --config "$(VIM:build_type)" $(VIM:build_options)
" output=quickfix
" cwd=$(VIM_ROOT)
"
" [project-run]
" command=$(VIM:run_target)
" output=quickfix
" cwd=$(VIM_ROOT)
"
" You can create a file named '.tasks' locally in the root of your project to
" override the default rules and variables, customized for your project, e.g.:
"
" [+]
" build_type=Debug
" build_target=zeno_pybind_module
" build_generator=NMake Makefiles
" run_target=python my_start_script.py
"
" May also use the :AsyncTaskEdit to create the '.tasks' file in project root.
" It will recognize the first directory containing '.tasks' or '.git' as root.
"
" See https://github.com/skywind3000/asynctasks.vim/blob/master/README-cn.md
"
"
" Auto completion
" ===============
"
" For auto-completion, I use the plugin 'coc.nvim', recommended by my students.
" Although 'coc.nvim' sounds like a NeoVim plugin, it works well in Vim too.
"
" IMPORTANT: Even after running :PlugInstall, auto-completion still won't work.
" You need the follow the below instructions carefully to set it up as well.
"
" To make 'coc.nvim' work at all, you need to first install Node.js:
"
" $ pacman -S nodejs          # Arch Linux
" $ apt install nodejs        # Ubuntu
" $ brew install -g node      # MacOS
" $ node --version            # check if installation succeed
"
"
" For C++ developers
" ------------------
"
" To make 'coc.nvim' work for C++, you need to install 'ccls'.
" First, run this command in Vim to enable 'ccls' in 'coc.nvim':
"
" :CocInstall coc-ccls
"
" Second, you need to install 'ccls' to your system.
" Arch Linux could install from their package manager:
"
" $ sudo pacman -S ccls
" $ ccls --version
"
" Ubuntu and MacOS could build ccls from source (tested on clang-13):
"
" $ git clone --depth=1 --recursive https://github.com/MaskRay/ccls.git
" $ cmake -B build -DCMAKE_BUILD_TYPE=Release -DCMAKE_CXX_COMPILER=clang++
" $ cmake --build build --parallel 4
" $ sudo cmake --build build --target install
" $ ccls --version
"
" Now create a C++ file to test if auto-completion works, say:
"
" $ vim /tmp/test.cpp
"
" If it complains an error: 'extension "coc-ccls" doesn't contain main file'
" Don't worry, I meet this error too. Fix it by executing:
"
" $ cd ~/.config/coc/extensions/node_modules/coc-ccls/
" $ ln -s node_modules/ws/lib/ ./
"
" windows - cmd.exe
" cd C:\Users\81408\AppData\Local\coc\extensions\node_modules\coc-ccls
" mklink /D lib node_modules\ws\lib
"
" Now restart Vim and the error is gone, and another error occurs:
"
" [coc.nvim] Server languageserver.ccls failed to start: Error: invalid params
" of initialize: expected array for /workspaceFolders
"
" This means it doesn't find the 'compile_commands.json' of your project.
" This file contains information like compiler flags, include directories which
" are required by 'ccls' for providing auto-completion.
"
" If your project is CMake, simply set CMAKE_EXPORT_COMPILE_COMMANDS to ON:
"
" $ cd MyProject/
" $ cmake -B build -DCMAKE_EXPORT_COMPILE_COMMANDS:BOOL=ON
" $ vim MySourceFile.cpp
"
" CMake will automatically create the file 'build/compile_commands.json'.
" 'ccls' will recognize it. Now restart Vim, and auto-completion should work.
" If you use other build systems, search Bing: 'Bazel compile_commands.json'
"
" If you are using my <F5> key mapping to build your CMake project, then the
" '-DCMAKE_EXPORT_COMPILE_COMMANDS:BOOL=ON' is automatically added, no worry.
"
" Note that the build directory must be 'build', otherwise ccls won't find it.
"
" Also try run :CocConfig to open the ~/.vim/coc-settings.json file. This file
" is already bundled in my .vim folder, containing a C/C++ configuration.
"
"
" For Python developers
" ---------------------
"
" To make 'coc.nvim' work for Python, you need 'pyright'.
" First, run this command in Vim to enable 'pyright' in 'coc.nvim':
"
" :CocInstall coc-pyright
"
" For more details (e.g. work with Conda), see their official document:
" https://github.com/fannheyward/coc-pyright
"
" For other languages support of 'coc.nvim', see their official support list:
"
" https://github.com/neoclide/coc.nvim/wiki/Language-servers#ccobjective-c
"
"
" Key maps
" --------
"
" <c-space> - trigger completion (in insert mode)
" <tab>     - next completion (in insert mode)
" <s-tab>   - previous completion (in insert mode)
"
" gd - goto definition
" gD - goto implementation
" gy - goto type definition
" gY - goto declaration
" gr - goto references
" gR - rename current symbol under cursor
" gq - format selected code (visual mode)
" gf - goto file path under cursor (no line number)
" gF - goto file path under cursor (with line number)
" gx - open url under cursor in default browser
" K  - show documentation of symbol under cursor
"
" gaga - show code actions on current line
" gaq  - quick fix error on current line
"
" vif  - select current function scope (inner)
" vaf  - select current function scope (outer)
" vic  - select current class scope (inner)
" vac  - select current class scope (outer)
"
"
" Fuzzy find
" ==========
"
" For fuzzy find, I use the plugin 'LeaderF'. It uses the Unix command
" line tools 'rg'. So make sure you have installed it first:
"
" $ pacman -S ripgrep                  # Arch Linux
" $ apt-get install ripgrep            # Ubuntu
" $ brew install ripgrep               # MacOS
" $ rg --version                       # check if installation succeed
"
"
" Key maps
" --------
"
" ,o - fuzzy find file names in project directory
" ,k - fuzzy find string in project directory (ripgrep)
" ,b - fuzzy find file names in all opened files
" ,m - fuzzy find most-recently-used opened files
" ,: - fuzzy find runned ex-commands (:) in history
" ,/ - fuzzy find searched strings (/) in history
" ,x - fuzzy find vim ex-commands (including plugins)
" ,j - fuzzy find in vim jump history (related to Ctrl-I Ctrl-O)
" ,h - fuzzy find in vim marks (related to m<char> and '<char>)
" ,n - fuzzy find function name in opened files
" ,l - fuzzy find string in current opened file
" ,t - fuzzy find tags in current opened file
" ,q - fuzzy find string in quickfix result
" ,i - fuzzy find string under cursor in current file (may visual)
" ,a - fuzzy find string under cursor in project directory (may visual)
" ,. - recall last fuzzy find window
"
" <C-j> - select next fuzzy candidate (in fuzzy find window)
" <C-k> - select previous fuzzy candidate (in fuzzy find window)
" <C-p>  - peek the current selected candidate in popup window (fuzzy find window)
" <C-r> - toggle between normal search and regex search (fuzzy find window)
" <C-f> - toggle between full path search and name-only search (fuzzy find window)
" <C-v> - paste from system clipboard (fuzzy find window)
" <C-\> - choose the split method to open selected target (fuzzy find window)
" <CR>  - open current selected candidate (double click will work too)
" <TAB> - switch between normal mode / insert mode (in fuzzy find window)
" p     - peek the current selected candidate in popup window (fuzzy normal mode)
" v     - open current selected candidate in vertical splitted window (fuzzy normal mode)
" x     - open current selected candidate in horizontal splitted window (fuzzy normal mode)
" Q     - add current selected candidate to quickfix list (fuzzy normal mode)
" L     - add current selected candidate to location list (fuzzy normal mode)
" d     - delete current selected candidate (fuzzy normal mode)
" q     - quit fuzzy search window (fuzzy normal mode)
"

set nocompatible
set encoding=utf-8
set et ts=4 sts=4 sw=4
set ls=2 fdm=syntax fdl=100
set nu rnu ru
set hls is si
set cinoptions=j1,(0,ws,Ws,g0
set timeout ttimeout
set timeoutlen=500
set ttimeoutlen=10
set mouse=a
set laststatus=2
set listchars=tab:>-,trail:.,extends:>,precedes:<
set showbreak=>>
set list
set virtualedit=all
"set noek
"set rulerformat=%55(%{strftime('%a\ %b\ %e\ %I:%M\ %p')}\ %5l,%-6(%c%V%)\ %P%)
"set switchbuf=usetab
set undofile
if has('win32') || has('win64')
    let g:webdevicons_enable_nerdtree = 1
    let g:NERDTreeIgnore = get(g:, 'NERDTreeIgnore', [])
    call extend(g:NERDTreeIgnore, ['\c^ntuser\.dat$', '\c^ntuser\.dat\.log1$', '\c^ntuser\.dat\.log2$'])
endif
if has('nvim')
    set undodir=/tmp//,.
    set backupdir=/tmp//,.
    set directory=/tmp//,.
else
    set undodir=/tmp//,.
    set backupdir=/tmp//,.
    set directory=/tmp//,.
endif
"set bg=dark


syntax on
filetype on
filetype plugin on
filetype indent on

"let g:mapleader = ' '
"let g:mapleader = ','
let g:mapleader = 'g'

nnoremap <silent> <F1> :wa<CR>:b#<CR>
nnoremap <silent> <F2> :wa<CR>:bp<CR>
nnoremap <silent> <F3> :wa<CR>:bn<CR>
nnoremap <silent> <F4> :wa<CR>
inoremap <silent> <F1> <ESC>
vnoremap <silent> <F1> <ESC>
vmap <F2> <ESC><F2>
imap <F2> <ESC><F2>
tmap <F2> <ESC><F2>
vmap <F3> <ESC><F3>
imap <F3> <ESC><F3>
tmap <F3> <ESC><F3>
vmap <F4> <ESC><F4>
imap <F4> <ESC><F4>
tmap <F4> <ESC><F4>
nnoremap <F5> :call <SID>BuildProjectThenRun()<CR>
vmap <F5> <ESC><F5>
imap <F5> <ESC><F5>
tmap <F5> <ESC><F5>
if has('nvim')
    nnoremap <F17> :AsyncStop<CR>
    vmap <F17> <ESC><F17>
    imap <F17> <ESC><F17>
    tmap <F17> <ESC><F17>
else
    nnoremap <S-F5> :AsyncStop!<CR>
    vmap <S-F5> <ESC><S-F5>
    imap <S-F5> <ESC><S-F5>
    tmap <S-F5> <ESC><S-F5>
endif
nnoremap <F6> :call <SID>RunAsyncTask('project-build')<CR>
vmap <F6> <ESC><F6>
imap <F6> <ESC><F6>
tmap <F6> <ESC><F6>
nnoremap <F7> :call <SID>BuildFileThenRun()<CR>
vmap <F7> <ESC><F7>
imap <F7> <ESC><F7>
tmap <F7> <ESC><F7>
if has('nvim')
    nnoremap <F18> :AsyncTask project-config<CR>
    vmap <F18> <ESC><F18>
    imap <F18> <ESC><F18>
    tmap <F18> <ESC><F18>
else
    nnoremap <S-F6> :call <SID>RunAsyncTask('project-config')<CR>
    vmap <S-F6> <ESC><S-F6>
    imap <S-F6> <ESC><S-F6>
    tmap <S-F6> <ESC><S-F6>
endif
nnoremap <silent> <Space> :call <SID>ShowKeyOverview()<CR>
if has('nvim')
    nnoremap <silent> zt :call <SID>ToggleProjectView()<CR>
    nnoremap <silent> zp :wa<CR>:QFix<CR>
else
    nnoremap <silent> zt :call <SID>ToggleProjectView()<CR>
    nnoremap <silent> zp :call <SID>ToggleQuickfix()<CR>
endif
"nnoremap <silent> <C-k> <C-w>k:q<CR>
"nnoremap <silent> <C-j> <C-w>j
inoremap kj <ESC>
inoremap jk <ESC>
"inoremap <DEL> <ESC>
"nnoremap <DEL> <ESC>
"vnoremap <DEL> <ESC>
"set pastetoggle=<F1>

nnoremap Q q
vmap Q <ESC>Q
nnoremap <silent> q :call <SID>uni_wq()<CR>
vmap q <ESC>q
nnoremap <silent> <C-q> :call <SID>uni_bd()<CR>
vmap <C-q> <ESC><C-q>
imap <C-q> <ESC><C-q>
tmap <C-q> <ESC><C-q>
"nnoremap Z :wa!<CR>:qa!<CR>
"vmap Z <ESC>Z
nnoremap <silent><expr> H (v:count == 0 ? '^' : '^^' . (v:count == 1 ? (v:count - 1) . 'l' : ''))
nnoremap <silent><expr> L (v:count == 0 ? '$' : '^$' . (v:count == 1 ? (v:count - 1) . 'h' : ''))
xnoremap <silent><expr> H (v:count == 0 ? '^' : '^^' . (v:count == 1 ? (v:count - 1) . 'l' : ''))
xnoremap <silent><expr> L (v:count == 0 ? '$' : '^$' . (v:count == 1 ? (v:count - 1) . 'h' : ''))
"nnoremap z zz
"vnoremap z zz
"nnoremap <CR> O<ESC>cc<ESC>j

tnoremap <ESC> <C-\><C-n>
if !has('nvim')
    tnoremap <ScrollWheelUp> <C-\><C-n><ScrollWheelUp>
    tnoremap <ScrollWheelDown> <C-\><C-n><ScrollWheelDown>
    tnoremap <S-PageUp> <C-\><C-n><C-u>
    tnoremap <S-PageDown> <C-\><C-n><C-d>
endif
nnoremap <PageUp> <C-u>
nnoremap <PageDown> <C-d>
vnoremap <PageUp> <C-u>
vnoremap <PageDown> <C-d>

if executable("xsel")
    vnoremap zy :w !xsel -ib<CR><CR>
elseif executable("pbcopy")
    vnoremap zy :w !pbcopy<CR><CR>
endif

function! s:uni_bd() abort
    let l:nr = win_getid()
    let l:wi = getwininfo(l:nr)[0]
    let l:ty = &buftype
    if l:ty == 'popup'
        FloatermKill
    elseif l:ty == 'quickfix'
        bd!
        cclose
    elseif l:wi.terminal == 1
        if exists('b:floaterm_cmd')
            FloatermKill
        else
            bd!
        endif
    else
        wa!
        bd!
    endif
endfunction

function! s:uni_wq() abort
    let l:nr = win_getid()
    let l:wi = getwininfo(l:nr)[0]
    let l:ty = &buftype
    if l:ty == 'popup'
        FloatermKill
    elseif l:ty == 'quickfix'
        q " cclose
    elseif l:wi.terminal == 1
        if exists('b:floaterm_cmd')
            FloatermKill
        else
            q!
        endif
    else
        wa!
        q!
    endif
endfunction

function! s:CloseTerminalBuffer() abort
    if exists('b:floaterm_cmd') || &filetype ==# 'floaterm'
        if exists(':FloatermHide') == 2
            silent! execute 'FloatermHide'
        endif
        if exists(':FloatermKill') == 2
            silent! execute 'FloatermKill'
        else
            bd!
        endif
    elseif &buftype ==# 'terminal'
        bd!
    endif
endfunction

function! s:BindTerminalCloseKey() abort
    nnoremap <silent><buffer> q :call <SID>CloseTerminalBuffer()<CR>
    nnoremap <silent><buffer> <BS> :call <SID>CloseTerminalBuffer()<CR>
endfunction

augroup terminal_close_key
    autocmd!
    if exists('##TerminalOpen')
        autocmd TerminalOpen * call <SID>BindTerminalCloseKey()
    endif
    autocmd FileType floaterm call <SID>BindTerminalCloseKey()
augroup end

augroup insert_curline
    autocmd InsertEnter,InsertLeave * set cul!
augroup end

"augroup archibate_abbrs
"autocmd!
"exec "au FileType py iabbr gc subprocess.check_call(["
"exec "au FileType py iabbr gj os.path.join("
"exec "au FileType cpp iabbr gi #include <"
"exec "au FileType cpp iabbr gv std::vector<"
"exec "au FileType cpp iabbr gs std::string"
"exec "au FileType cpp iabbr gt std::tuple<"
"exec "au FileType cpp iabbr ga std::array<"
"exec "au FileType cpp iabbr gm std::map<"
"exec "au FileType cpp iabbr gum std::unordered_map<"
"exec "au FileType cpp iabbr gf std::function<"
"exec "au FileType cpp iabbr gfv std::function<void()>"
"exec "au FileType cpp iabbr gsc static_cast<"
"exec "au FileType cpp iabbr gdc dynamic_cast<"
"exec "au FileType cpp iabbr gspc std::static_pointer_cast<"
"exec "au FileType cpp iabbr gdpc std::dynamic_pointer_cast<"
"exec "au FileType cpp iabbr gms std::make_shared<"
"exec "au FileType cpp iabbr gmu std::make_unique<"
"exec "au FileType cpp iabbr gsp std::shared_ptr<"
"exec "au FileType cpp iabbr gup std::unique_ptr<"
"exec "au FileType cpp iabbr gwp std::weak_ptr<"
"exec "au FileType cpp iabbr gnz namespace zeno {"
"exec "au FileType cpp iabbr gnv namespace zenovis {"
"augroup end

" no longer used vimspector:
"nmap <S-F3> <Plug>VimspectorStop
"nmap <S-F4> <Plug>VimspectorRestart
"nmap <S-F5> <Plug>VimspectorContinue
"nmap <S-F6> <Plug>VimspectorPause
"nmap <S-F8> <Plug>VimspectorRunToCursor
"nmap <C-S-F8> <Plug>VimspectorAddFunctionBreakpoint
"nmap <S-F9> <Plug>VimspectorToggleBreakpoint
"nmap <C-S-F9> <Plug>VimspectorToggleConditionalBreakpoint
"nmap <S-F10> <Plug>VimspectorStepOver
"nmap <S-F11> <Plug>VimspectorStepInfo
"nmap <S-F12> <Plug>VimspectorStepOut
"nmap <LEADER>= <Plug>VimspectorBalloonEval
"xmap <LEADER>= <Plug>VimspectorBalloonEval
"let g:ycm_semantic_triggers = {'VimspectorPrompt': ['.', '->', ':', '<']}
"let g:cmake_vimspector_support = 1
"let g:cmake_vimspector_default_configuration = {
"\ 'adapter': 'vscode-cpptools',
"\ 'configuration': {
   "\ 'type': '',
   "\ 'request': 'launch',
   "\ 'cwd': '${workspaceRoot}',
   "\ 'Mimode': '',
   "\ 'args': [],
   "\ 'program': '',
   "\ "setupCommands": [
   "\ {
   "\ "description": "Enable pretty-printing for gdb",
   "\ "text": "-enable-pretty-printing",
   "\ "ignoreFailures": 'true',
   "\ }
   "\ ],
   "\ }
"\ }

" don't extend the stupid comments:
autocmd FileType * setlocal formatoptions-=cro

" rid annoying swap prompts:
autocmd SwapExists * let v:swapchoice = "e"

" goto last location on open:
autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

" open NERDTree on vim start:
"autocmd VimEnter * NERDTree | wincmd p
"autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif

" no longer used cmake4vim:
"let g:cmake_usr_args = '-GNinja'
"let g:cmake_build_target = 'main'
"let g:cmake_build_type = 'Release'
"let g:cmake_compile_commands = 1
"let g:cmake_build_path_pattern = ["%s/build", "getcwd()"]

" no longer used YouCompleteMe:
"let g:ycm_confirm_extra_conf = 0
"let g:ycm_error_symbol = '闂?
"let g:ycm_warning_symbol = '闂?
"let g:ycm_filetype_whitelist = {"c": 1, "cpp": 1, "python": 1}
"let g:ycm_min_num_of_chars_for_completion = 2
"let g:ycm_show_diagnostics_ui = 1
"let g:ycm_key_invoke_completion = '<c-z>'
"let g:ycm_enable_diagnostic_signs = 0
"let g:ycm_enable_diagnostic_highlighting = 1
""let g:ycm_show_diagnostics_ui = 0
""let g:ycm_key_list_select_completion = ['<TAB>']
""let g:ycm_key_list_previous_completion = []

" no longer used ultisnips:
"let g:UltiSnipsExpandTrigger="<c-s>"
"let g:UltiSnipsJumpForwardTrigger="<tab>"
"let g:UltiSnipsJumpBackwardTrigger="<s-tab>"
"let g:UltiSnipsEditSplit="vertical"

" no longer used vim-cpp-modern:
"let g:cpp_attributes_highlight = 1
"let g:cpp_member_highlight = 1

" no longer used vim-airline:
"let g:airline#extensions#coc#enabled = 1
"let g:airline#extensions#tabline#enabled = 1
"let g:airline#extensions#tabline#left_alt_sep = '|'
"let g:airline#extensions#tabline#buffer_nr_show = 0
"let g:airline#extensions#tabline#formatter = 'default'
"let g:airline#extensions#keymap#enabled = 1
"let g:airline#extensions#tabline#buffer_idx_mode = 1
"" 闂傚倸鍊搁崐鎼佸磹閹间礁纾归柟闂寸绾惧綊鏌熼梻瀵割槮缁炬儳缍婇弻鐔兼⒒鐎靛壊妲紒鐐劤缂嶅﹪寮婚悢鍏尖拻閻庨潧澹婂Σ顔剧磼閻愵剙鍔ょ紓宥咃躬瀵鎮㈤崗灏栨嫽闁诲酣娼ф竟濠偽ｉ鍓х＜闁绘劦鍓欓崝銈囩磽瀹ュ拑韬€殿喖顭烽幃銏ゅ礂鐏忔牗瀚介梺璇查叄濞佳勭珶婵犲伣锝夘敊閸撗咃紲闂佺粯鍔﹂崜娆撳礉閵堝棛绡€闁逞屽墴閺屽棗顓奸崨顖氬Е婵＄偑鍊栫敮鎺楀磹瑜版帒鍚归柍褜鍓熼弻锝嗘償閵忕姴姣堥梺鍛婄懃閸燁偊鎮惧畡鎵殾闁搞儜灞绢棥闂佽鍑界徊濠氬礉鐎ｎ€兾旈崨顔规嫼闂侀潻瀵岄崢濂稿礉鐎ｎ喗鐓曢柕濞垮劤缁夎櫣鈧娲橀崝娆撳箖濞嗘挻鍊绘俊顖濇〃閻㈢粯绻濋悽闈浶㈤柨鏇樺€濆畷顖炲箥椤斿彞绗夐梺鐓庮潟閸婃劙宕戦幘鏂ユ灁闁割煈鍠楅悘宥嗙節閻㈤潧浠滈柨鏇ㄤ簻椤曪綁顢曢敃鈧粈鍐┿亜閺冨洤浜归柨娑欑矊閳规垿鎮欓弶鎴犱桓闂佺厧缍婄粻鏍偘椤曗偓瀹曞ジ鎮㈤崜浣虹暰闂備胶绮崝锔界濠婂牆鐒垫い鎴炲劤閳ь剚绻傞悾鐑藉閿涘嫷娴勯柣搴秵娴滄粓鎮楅銏♀拺闁告捁灏欓崢娑㈡煕鐎ｎ亝顥㈤柕鍡楁嚇瀹曪絾寰勫畝鈧惁鍫ユ⒒閸屾氨澧涘〒姘殜瀹曟洟骞囬悧鍫㈠幗闂佽鍎抽悺銊х矆閸愵亞纾肩紓浣诡焽濞插鈧娲栧畷顒冪亙闂佸憡鍔︽禍鍫曞船閾忓湱纾介柛灞剧懆閸忓苯鈹戦鑲╀粵缂佺粯绋掔换婵嬪炊瑜戦幗鏇㈡倵楠炲灝鍔氶柣妤佺矊椤﹪濡搁埡鍌楁嫼闂佸憡绋戦敃銉т焊閹殿喚纾奸悹鍥皺婢э箓鏌℃担鐟板闁诡喗鐟╁鍫曞箣閻樼數宓佹繝鐢靛Х閺佹悂宕戦悙鍨殰婵°倐鍋撴い顏勫暣閹稿﹥寰勫Ο鐑橆吙濠电偛顕慨鎾敄閸岀偛鐒垫い鎺嶈兌婢х敻鏌涢埡浣割伃鐎规洘锕㈤崺鐐村緞濮濆本顎楀┑鐘垫暩婵兘銆傛禒瀣婵犻潧顑呯粻鏍煕瀹€鈧崑娑㈠及閵夆晜鐓ラ柣鏂挎惈瀛濈紒鐐劤閸氬骞堥妸銉建闁糕剝顨呴～鈺侇渻閵堝啫鍔滄い銊ワ工椤繑绻濆顒傦紲濠电偛妫欑敮鎺楀储閿涘嫮纾肩紓浣靛灩楠炴牠鏌ｉ弽顐㈠付闁伙絽鍢查…銊╁礃閿濆棙鏉搁梺璇插嚱缁茶姤顨ョ粙妫垫椽鏁冮崒姣佳囨煥閺冨倸浜鹃柛鐔稿灴閺屾洟宕煎┑鍡╀痪闂佹椿鍋勭换妯侯潖缂佹ɑ濯撮柛娑橈龚绾偓闂備胶顭堢花娲磹濠靛宓侀柟閭﹀枟鐎氭碍绻涢弶鎴剱闁诲骸鎼埞鎴︽偐鐠囇冧紣闂佺粯顨呴敃顏堝春濞戙垹绠ｉ柨鏃傛櫕閸橀亶姊洪崷顓炰壕婵炲吋鐟у濠勬嫚鐟佷胶鎳撻…銊╁焵椤掑倸鍨濇繛鍡樻尭閽冪喐绻涢幋鐐茬劰闁稿鎹囬弫鎰償濠靛牆鍤梻渚€娼荤徊鍧楀疾椤愩倖顫曢柟鐑樻尰缂嶅洭鏌嶆潪鐗堫樂婵″弶鍔欓幃妤冩喆閸曨剛顦梺鍛婎焼閸パ呭幋闂佺鎻粻鎴犵矆閸愵喗鐓冮柛婵嗗閳ь剛鎳撻…鍧楀箣閿旇В鎷婚梺绋挎湰閻熴劑宕楀畝鈧槐鎺楊敋閸涱厾浠搁悗瑙勬礃缁诲牆顕ｉ幘顔藉€婚柛鈩冾殕椤撳潡姊绘担绋款棌闁稿鎳庣叅闁哄稁鍘介埛鎺撱亜閺嶎偄浠﹂柣鎾卞灪娣囧﹪顢涘▎鎺濆妳濠碘€冲级閹告娊寮婚敓鐘茬劦妞ゆ帒瀚崵宥夋煏婢舵稓瀵肩紒銊ヮ煼濮婃椽宕崟顐ｆ濠电偛鐪伴崐娑€傞崸妤佲拺閻犲洩灏欑粻鏉课旈悩鑼婵﹣绮欏畷鐔碱敇閻斿嘲绨ユ繝鐢靛█濞佳囶敄閸涘瓨鍊块柛顭戝亖娴滄粓鏌熼崫鍕ラ柛蹇撶焸閺岋綁鎮㈡搴Ｐㄩ梺鍝勮嫰缁夌兘篓娓氣偓閺屾盯骞樼€靛憡鍣伴梺鎸庣箘閸嬬姷绮诲☉妯锋婵炲棙鍔曢崝鎺楁⒒娓氣偓濞艰崵鈧潧鐭傚畷銏°偅閸愨晜娅栧┑鐘诧工閸熺娀寮ㄦ禒瀣厓闁芥ê顦伴ˉ婊堟煟韫囨洖校缂佺粯绋撻埀顒佺⊕椤洭銆傞懠顒傜＜闁稿本姘ㄥ瓭濡炪値鍘归崝鎴濈暦閸楃偐鏋庨幖娣€曢悞缁樼節閻㈤潧啸闁轰礁鎲￠幈銊╂倻閽樺鐎梺鍛婄☉閿曘儵宕ｈ箛娑欑厸濠㈣泛顑呭▓顔界箾瀹割喕绨婚崶鎾⒑閹肩偛鍔€閻忕偟铏庡Λ銉╂⒒閸屾瑨鍏屾い顐㈩儔瀹曠喖宕归銈嗘闂傚倷鑳剁划顖炲箰婵犳碍鍋￠柍鍝勬噹閽冪喖鏌ｉ弬璺ㄦ闁哄妫冮弻娑⑩€﹂幋婵囩亶闂佽绻愰悧鍡涒€旈崘顔嘉ч煫鍥ㄦ礀閸╁矂姊洪棃娑氬闁诡喖鍊搁锝嗙節濮橆厽娅滄繝銏ｆ硾閿曪箓顢欓幒妤佺厽閹兼番鍨婚埊鏇熴亜椤撶偞鍠橀挊婵喢归悡搴ｆ憼闁抽攱鍨块幃褰掑炊閿濆倸浜鹃柧蹇ｅ亞娴滆埖淇婇悙顏勨偓鎴﹀礉瀹€鍕櫇妞ゅ繐瀚烽崵鏇熴亜閹板墎鐣辩紒鐘崇洴閺屸剝寰勬繝鍕檸缂備焦鍔栫粙鎴︹€旈崘顔嘉ч柛鈩兠弳妤呮⒑閸濄儱孝闂佸府缍佸畷娲焵椤掍降浜滈柟鍝勬娴滈箖姊绘担绋跨盎缂佽弓绮欓敐鐐剁疀閺囩姷锛滃┑鈽嗗灥閸嬫劙骞婂┑瀣拺闁硅偐鍋涢崝鈧梺鍛婂姦閻撳牓宕濋埀顒勬⒒閸屾艾鈧兘鎮為敃鍌氱畺闁割偅娲栫粈澶屸偓鍏夊亾闁告洦鍓欐禍顖炴⒑缂佹ɑ灏悗鍨浮瀹曠敻寮撮悙鈺傛杸闂佺粯锚绾绢參銆傞弻銉︾厸闁告粈绀佹晶鎾煛鐏炲墽娲寸€殿喗鎸虫俊鎼佸Χ閸パ冩瘓闂傚倷绀侀幉鈥趁洪弽顓炵柈闁哄鍩堝鏍ㄧ箾瀹割喕绨荤€瑰憡绻傞埞鎴︽偐閹绘帗娈梺浼欏閸忔ê顫忓ú顏勫窛濠电姴鍟ˇ鈺呮⒑缁嬫鍎忛悗姘嵆楠炲啫顫滈埀顒勫极閹剧粯鍋愰柡鍌樺劜鐎氫粙姊绘担渚劸闁哄牜鍓熼幃鐑藉Ω閳轰胶顦ч悗鍏夊亾闁逞屽墴閹偓妞ゅ繐鐗滈弫鍥煟閹扮増娑ч柣鎾跺枛閹鈻撻崹顔界亶閻熸粍婢橀崯鎾春閵夛箑绶炲┑鐘插閸嶇敻姊洪幐搴ｇ畵闁瑰啿绉电粩鐔煎即閻愨晜鏂€濡炪倖姊归弸缁樼瑹濞戙垺鐓曟俊顖氬悑濞呮洘绻涢崱鎰伈鐎殿喖顭锋俊鐑芥晜閹冪闂傚倷鐒︾€笛呮崲閸岀偛绠犻幖绮瑰灳閿濆洨纾兼俊顖炴櫜缁ㄨ顪冮妶鍡楀Ё缂佹彃娼￠幆宀勫箳濡や胶鍘遍梺瀹狀潐閸庤櫕绂嶉悙顑跨箚闁绘劦浜滈埀顒佺墱閺侇噣骞掗弬鍝勪壕婵ǜ鍎辨慨鍌炴煕閳规儳浜炬俊鐐€栭崹鐓庘枖閺囩姷鐜婚柡鍐ㄥ€甸崑鎾斥枔閸喗鐝梺闈╃秶缂嶄礁鐣峰ú顏勭劦妞ゆ帊闄嶆禍婊堟煙閻戞ê鐏ユい蹇婃櫇缁辨帡鎮埀顒勫垂閸洖钃熸繛鎴炃氬Σ鍫ユ煕濡ゅ啫浠уù鐙€鍙冮弻锝嗘償閵忋埄鏆￠悗鍏夊亾闁归棿绀侀拑鐔衡偓骞垮劚椤︻垶鎮″☉妯忓綊鏁愰崨顔兼殘濠电偛鐗嗘晶搴ｆ閹惧瓨濯撮柛鎾冲级绗戝┑鐘媰閸涱喗鐝┑鈥冲级閸旀瑩鐛Ο鍏煎珰闁肩⒈鍓ㄧ槐鍙夌節濞堝灝鏋熼柨鏇楁櫊瀹曟顫滈埀顒€鐣烽幋锕€绠婚悹鍥皺椤旀劖绻涙潏鍓у埌闁硅姤绮撻弫宥呪枎閹剧补鎷洪悷婊呭鐢鏁嶉悢铏圭＜闁逞屽墯閹峰懘宕崟鍨棥闂備浇宕甸崰鏍磻婵犲倶鈧帗绻濆顓炩偓鐢告煥濠靛棛鍑圭紒銊х帛閵囧嫰骞掔€ｎ亞浠奸梺瀹狀潐閸ㄥ潡銆佸☉姗嗘僵闁靛鍎伴崚鎺楁⒒娴ｅ憡鎯堥柣顓烆槺濡叉劙寮撮悢渚祫闂佹寧姊婚崑鎾垛偓姘哺閺岀喓绱掑Ο铏圭懆濡炪値鍋呴幐鍓ф閹惧瓨濯撮柛婵嗗婢规洟姊虹粙鍨劉濠电偛锕崹楣冩晝閸屾稑鈧鏌﹀Ο渚Ъ闁硅姤娲熷铏圭磼濡儵鎷婚梺鍛婎焼閸涱垳鐒奸梺鍓插亖閸ㄦ椽宕伴幇鎵彄闁搞儯鍔嶇粈鍐煛閸℃鐭嬬紒缁樼洴楠炲鈻庤箛鏇氱棯闂備胶绮幐楣冨窗閺嶎厼钃熼柣鏃傚帶缁犳氨鎲歌箛娑樼闁绘鏁哥壕濂告煃瑜滈崜娑㈠焵椤掑﹦绉甸柛鐘愁殜閹€斥槈閵忊€斥偓鍫曟煟閹邦剛浠涙繛鍛礋瀵偊宕奸妷锔规嫼缂備緡鍨卞ú姗€寮惰ぐ鎺撶厱闁规儳顕粻鐐搭殽閻愯尙绠荤€规洏鍔戝鍫曞箣濠靛牏宕烘繝鐢靛Х閺佸憡鎱ㄩ幘顔肩獥婵娉涢悿顕€鏌嶈閸撶喎顫忔繝姘＜婵﹩鍏橀崑鎾绘倻閼恒儱鈧潡鏌ㄩ弴鐐测偓鍝ョ矆閸喐鍙忔俊顖涘绾箖鏌涢妸銉モ偓鍧楀蓟濞戞鏃堝礃瑜忛梻顖氣攽閻愬弶鈻曞ù婊勭箞瀹曟垿宕熼娑氬幗闂佽宕樺▍鏇㈠船婢舵劖鐓欓柤鎭掑劜缁€瀣叏婵犲啯銇濇鐐村姈閹棃鏁愰崶鈺傛濠碉紕鍋戦崐褏鈧潧鐭傚畷鐟扮暦閸パ冪亰缂傚倷鐒﹂…鍥╁姬閳ь剙鈹戦鏂や緵闁告ê銈搁崺鈧い鎺嗗亾闁诲繑姘ㄩ幑銏犫槈閵忕姷顓洪梺缁樺姇閻忔岸宕虫禒瀣拺缂備焦锚缁椻晛鈹戦鍝勨偓婵囦繆閻㈢绀嬫い鏍ㄧ⊕濞呭棝姊洪崜鑼帥闁哥姵鐗滅划濠囶敊鐏忔牗鏂€濡炪倖姊婚妴瀣绩缂佹ü绻嗛柣鎰煐椤ュ鏌ｉ敐鍥у幋妞ゃ垺娲熼弫鍐焵椤掑倻鐭嗛悗锝庡亖娴滄粓鏌熼崫鍕ら柛鏂跨Ч閹顫濋搹顐ゅ涧缂備胶绮换鍫ュ箖娴犲顥堟繛鎴烆殘閹规洟鏌ｆ惔銏╁晱闁哥姵鐗犻幃銉︾附缁嬫寧鐎柣搴秵娴滆泛銆掓繝姘厪闁割偅绻冮ˉ鐐电棯閻愵剚鍊愰柡灞剧⊕閹棃濡搁敂浠嬫暘闂備椒绱徊鍧楀礂濮椻偓楠炲啴濮€閵忕姵鐎抽柡澶婄墑閸斿秴鈻嶉崶顒佲拻濞达綀娅ｇ敮娑㈡煛鐏炶濡界紒鏃傚枑缁绘繈宕掗妶鍥уШ闂備礁鎼崯鐘诲磻閹惧墎纾肩紓浣诡焽缁犳捇鏌嶇紒妯诲磳鐎规洖缍婇、娆撴偩鐏炲吋鍠氶梻鍌氬€烽悞锔锯偓绗涘厾鍝勵吋婢跺﹦鏌ч梺缁橆焾鐏忔瑩寮抽敂鐣岀瘈濠电姴鍊搁弳濠囨煛鐎ｎ亪鍙勯柡宀€鍠栭幃娆擃敆娴ｈ櫣鈻忓┑鐐茬摠缁秹銆冩繝鍌ゆ綎闁惧繐婀遍惌娆撴煙缁嬪灝顒㈤柟鐑戒憾濮婅櫣鍖栭弴鐔哥彅闂佸摜鍠愬娆擃敋閿濆惟闁挎梻铏庡ù鍕煟鎼搭垳绉甸柛瀣瀹曘垽鎸婃径鍡樻杸闂佸疇妫勫Λ妤呮倶閳╁啩绻嗛柣鎰级閸嬨儳鈧娲﹂崹鐢电不濞戞ǚ妲堟繛鍡樺灥楠炴劙姊绘担铏广€婃俊鐙欏洤鐤炬繛鎴欏灪閸婂爼鏌ㄩ弴鐐测偓褰掓偂濞戙垺鍊堕柣鎰仛濞呮洟宕粙娆炬富闁靛洤宕崐鑽ょ玻閺冨牊鐓涢悘鐐插⒔濞插瓨顨ラ悙鎼劷闁逞屽墴濞佳囧箟閿熺姴绀嗘繛鎴欏灪閸婄敻鎮峰▎蹇擃仾缂佲偓閸愵喗鐓曢柕濠忕畱椤曟粌菐閸パ嶈含妤犵偞鐗楅幏鍛村传閵夈儱绠版繝鐢靛仩閹活亞寰婄捄銊ょ剨闁靛ě鍕垫綗闂備緡鍓欑粔鐢稿煕閹烘垯鈧帒顫濋敐鍛婵犵數鍋橀崠鐘诲川椤旂厧绨ラ梻浣虹《閸撴繈濡甸崒鐐存櫜濠㈣泛锕ょ粣娑橆渻閵堝棙灏扮紒瀣浮閹ɑ鎷呴崷顓狀啎闁诲海鏁搁…鍫濈摥婵＄偑鍊栭崹闈浳涘┑瀣畺闁跨喓濮甸崑鍕煕韫囨艾浜归柛妯兼暬濮婄粯绗熼崶褍浼庣紓浣哄У閸ㄥ爼寮查懜鐢电瘈婵﹩鍘鹃崢閬嶆⒑闂堟稓澧曟繛灞傚€濆鍛婃償椤兛绨诲銈嗘尨閳ь剙鍟挎慨宄邦渻閵堝繘妾柟鍛婂▕瀵鍩勯崘鈺侇€撻柣鐔哥懃鐎氼剟鍩€椤掍礁濮嶉柡灞剧洴閸╃偤骞嗚婢规洖鈹戦敍鍕杭闁稿﹥鐗滈弫顔界節閸曨剦鍋ㄩ梺璺ㄥ枔婵挳鎮块鈧悡顐﹀炊閵娧€濮囬梺缁樻尰濞茬喖寮婚敐鍛傜喖鎼归惂鍝ョ濠电姭鎷冮崨顔芥瘓闂佸搫鐬奸崰鏍€佸▎鎾充紶闁告洦鍋勯～姘辩磽閸屾瑦绁版俊妞煎妿閸掓帒鈻庤箛鏇熸濡炪倖鍔х粻鎴濇暜闂備線娼ч敍蹇旀媴闂€鎰瀳闂傚倸鍊搁崐宄懊归崶顒夋晪鐟滄柨鐣峰▎鎾村仼鐎光偓閳ь剛绮堟繝鍥ㄧ厱闁斥晛鍟伴埥澶愭⒒閸屻倕鐏￠柕鍥у瀵潙螖閳ь剚绂嶆ィ鍐╁€垫繛鍫濈仢濞呮﹢鏌涚€ｎ亷宸ラ柣锝囧厴瀹曞ジ寮撮妸锔芥珜濠电偠鎻徊浠嬪箹椤愶妇宓佹俊銈呮噺閳锋帒霉閿濆懏鍟為柟顖氱墦閺屾盯鎮㈤崫鍕ㄦ瀰閻庤娲橀崹鍧楃嵁濡吋鎯ュù锝囧劋閸も偓濡炪値鍘归崝鎴﹀春閳ь剚銇勯幒鎴濃偓鎼佸垂濠靛洨绠鹃柛鈩冾殘缁犳娊鏌￠崱顓犵暤闁哄瞼鍠愬蹇涘箲閹邦剚鍊曢梻渚€鈧偛鑻晶顖涗繆椤愩垹鏆ｉ柛銊╃畺瀵噣宕煎顏佹櫊閺屽秹宕崟顐熷亾閻㈢绠┑鐘崇閳锋垹绱掔€ｎ偄顕滄繝鈧导瀛樼厾鐟滅増甯為悾娲煕閳规儳浜炬俊鐐€栫敮濠囨倿閿曞倸纾归柟閭﹀枓閸嬫挾鎲撮崟顒傤槰闂佸憡姊归悷鈺呮偘椤曗偓瀵粙濡搁敃鈧鎾绘⒑閸涘﹦缂氶柛搴ゅ吹濡叉劙顢氶埀顒€顫忕紒妯诲闁告縿鍎虫婵犵妲呴崑澶娾枖閺囩姴鍨濋柛顐ゅ枑婵挳鏌涘┑鍡楊伌婵☆偅绮撻幃宄邦煥閸涱収鏆柣銏╁灡椤ㄥ﹪骞冮垾鏂ユ瀻闁瑰墽琛ラ幏濠氭⒑缁嬫寧婀伴柛鎴濈秺瀹曠敻鎮㈤幖鐐扮盎闂佹寧姊婚崢褔銆呴鍕厽闁靛鍠曢柇顖涱殽閻愬弶顥℃い锕€顕槐鎺撳緞鐎ｎ偁浠㈤梺鍝勫閳ь剙纾弳鍡涙倵閿濆骸澧扮悮锔戒繆閵堝洤啸闁稿鐩、鏍ㄥ緞閹邦剚鐎梺鍦濠㈡ê顔忓┑瀣厱婵炴垵宕弸鐔衡偓瑙勬礀閻倿寮婚敍鍕勃闁告挆鈧慨鍥╃磽娴ｈ櫣甯涚紒璇茬墕閻ｇ兘骞掗幋鏃€顫嶅┑鈽嗗灥椤螣婵犲洦鈷掗柛灞剧懅椤︼箓鏌熺喊鍗炰簽闁诡噮鍣ｉ、鏇㈡晝閳ь剛绮堟径鎰厵閻庢稒顭囩粻銉╂煕閵堝棙绀嬮柡宀€鍠撶槐鎺楀閻樺磭浜堕梻浣侯焾閿曨亪寮ㄦ潏鈺傚床婵炴垯鍨圭痪褔鏌熼幖顓炲箹闁告挾澧楃换娑氣偓娑欘焽閻﹤顭胯缁瑩鐛径鎰濞达絿鎳撴禍閬嶆⒑閸撴彃浜濈紒璇插閹兘濡歌绾惧ジ鏌ｉ幇闈涘闁告柣鍊栫换娑氭兜妞嬪海鐦堥悗娈垮枛椤兘骞冮姀銏″仒闁炽儱鍘栨竟鏇㈡⒑濮瑰洤鐏い鏃€鐗犻幃鐐淬偅閸愩劌鍞ㄩ梺璺ㄥ枔婵敻鍩涢幋锔界厱婵犻潧瀚崝姘跺冀閿熺姵鈷戦柛娑橈攻閳锋劙鏌ｉ悢鍙夋珔妞ゆ洩绲剧换婵嗩潩椤撶喐鐝抽梻浣告啞缁嬫垿宕愰悷鎷旀盯宕橀鍏兼К闂侀€炲苯澧柕鍥у楠炴帡骞嬪┑鎰棯闂備胶顭堥鍛搭敄婢舵劕钃熸繛鎴欏灩閻掓椽鏌涢幇鍏哥凹闁革綆鍠氱槐鎾存媴閸濆嫅锝嗕繆椤愩垹鏆ｇ€殿喖顭烽幃銏ゅ礂閻撳簶鍋撶紒妯圭箚妞ゆ牗绮岄崝锕傛煙閻ゎ垰鍚圭紒杈ㄥ浮閹瑩顢楅埀顒勫礉閵堝鐓忛柛顐ゅ枑閸婃劗鈧鍠涢褔顢樻總绋块唶妞ゆ劧缍嗛埀顒€娲缁樻媴閸涘﹤鏆堥梺鍦焾椤兘骞婂┑鍥ュ亝闁告劗鍋撻弲顏堟⒑闂堟侗妲撮柡鍛〒缁牏鈧綆鍋佹禍婊堟煙閹屽殶缂佺姵鐗犻弻娑㈠即閻愬弶娈剁紓浣介哺閹稿骞忛崨鏉戠闁圭粯甯掓竟鍫ユ⒒娓氣偓濞佳兠洪敃浣规噷缂傚倷鐒﹀濠氬窗閺嵮屽殨闁圭虎鍠栭～鍛存煃闁款垰浜鹃梺鍦焿濞咃絿妲愰幘瀛樺闁告挻褰冮崜闈涒攽閻愬樊妲规繛鍙夌矌閸掓帗绻濆顓炰罕闂佸壊鍋呯粙鎰姳婵犳碍鈷戦柟绋垮椤ュ棙銇勯弴鍡楁处閸婂爼鏌ㄥ☉妯侯伀缁炬儳銈搁弻娑氫沪閻愵剛娈ら柡宥忕節濮婃椽妫冨☉姘拪缂傚倸绉崇粈渚€鎮惧畡閭︽建闁逞屽墴瀹曟椽鎮欓悜妯衡偓閿嬨亜閹哄棗浜惧銈呯箰缂嶅﹤顫忔繝姘＜婵﹩鍏橀崑鎾搭槹鎼淬埄鍋ㄩ梺璺ㄥ枔婵澹曟繝姘厱闁斥晛鍟伴埥澶岀棯閸撗呭笡缂佺粯鐩獮瀣枎韫囨洑鐥梻浣规偠閸婃牠宕濋弽顓炍﹂柛鏇ㄥ灠閸愨偓闂侀潧臎閳ь剚鎱ㄩ崶褉鏀介柣鎰级閸ｈ棄鈹戦悙鈺佷壕闂備礁鎼惉濂稿窗閹捐埖顫曢柟鐑橆殔椤懘鏌ｅΟ铏癸紞濞存粌鐖煎缁樻媴閾忕懓绗￠梺瑙勭摃椤曆呭弲闂佺粯姊婚崢褔鎷戦悢琛″亾楠炲灝鍔氭繛璇х畵瀹曚即宕卞☉娆戝幈闂佸搫娲㈤崝灞剧濠婂啠鏀芥い鏂挎惈閻忣亞绱掔紒妯笺€掗柍褜鍓氱粙鎺椻€﹂崶顒佸剹鐎光偓閸曨剛鍘遍柣搴秵閸嬪懐浜搁幍顔剧＜鐎光偓閸愵喖鎽电紓浣虹帛缁诲牆鐣烽崼鏇炍╅柕澶堝灩娴滈箖姊洪崹顕呭剭濞存粍绮撻悡顐﹀炊閵婏箑纰嶅銈呯箞閸婃繈寮诲☉姘ｅ亾閿濆骸浜濈€规洖鐬奸埀顒侇問閸犳洜鍒掑▎鎾扁偓渚€寮撮姀鈩冩珳闂佺硶鍓濋敃鈺呭船閼哥數绡€闁汇垽娼у暩闂佽桨绀侀幉锟犲箞閵娧€鍋撻悽鐢点€婇柛瀣尭椤繈鎮℃惔銏㈠綆闂備浇顕栭崹浼存儗閸屾氨鏆﹂柛妤冨剱濞撳鎮樿箛鏃傚ⅹ濞存粓绠栭弻鐔兼倻濡櫣鍔稿┑鐐茬毞閺呯娀寮婚妸銉㈡斀闁糕剝锚濞呫垺绻濋姀锝庢綈婵炶尙鍠栧濠氭晲閸℃ê鍔呴梺闈涚墕鐎涒晝绱為崼婵冩斀闁绘劖褰冪痪褏绱掗鑺ュ碍妞ゆ洩缍侀、鏇㈡晲閸モ晝妲囨繝娈垮枟鑿ч柛搴櫍瀹曟垿骞樼€涙ê顎撻梺鐓庡级缁诲啫螞閸愩劎鏆﹂柕濞炬櫓閺佸洭鏌ｅ▎灞戒壕濠德ゅ蔼椤绌辨繝鍥ㄥ€锋い蹇撳閸嬫捇寮介锝嗘闂佸湱鍎ら〃鍛瑜版帗鐓欓梻鍌滎棎閸忓瞼鈧鎸风欢姘跺蓟濞戙埄鏁冮柣妯诲絻婵洟姊洪幎鑺ユ暠閻㈩垱甯″﹢渚€姊洪幐搴ｇ畵婵炲眰鍔戦獮妤呭磼濞戞氨顔曢梺绋跨箳閸樠勬叏婢舵劖鐓冪憸婊堝礈濠靛缍栧璺衡姇閸濆嫷娼ㄩ柍褜鍓熷顐も偓锝庡枟閳锋垹鈧娲栧ú銊ф暜濞戙垺鐓涢悘鐐额嚙婵倿鏌涢埞鍨姕鐎垫澘瀚伴獮鍥敆婢跺绉遍梻鍌欒兌缁垵鎽悷婊勬緲閸燁偊鍩㈤幘璇参ч柛鈩冪懅閻﹀牓姊哄Ч鍥х伈婵炰匠鍕浄闁挎洖鍊归悡鏇熴亜椤撶喎鐏ラ柣蹇ュ閳ь剝顫夊ú婊堝箠閹捐泛寮叉俊鐐€曠换鎰板箠鎼淬垻顩叉俊銈呮噺閳锋垹绱撴担鑲℃垿鎮￠妷鈺傜厵闁兼亽鍎抽惌宀€绱掗鍓у笡闁靛牞缍佸畷姗€鍩￠崘銊ョ闂備浇顕х€涒晝绮欓幒妞烩偓锕傚炊閳哄啩绗夐梺鐟板⒔缁垶鎮￠悩铏弿婵犻潧妫涢悞鐐箾閸忕厧濮夌紒杈ㄥ笧缁辨帒螣閸忕厧鍨遍柣搴ゎ潐濞插繘宕濋幋锔衡偓浣割潨閳ь剟骞冮埡渚囨建闁割偁鍨昏摫闂備線娼уú銈団偓姘卞娣囧﹪骞栨担瑙勬珳闂佸憡渚楅崢鑹邦杺闂傚倸鍊峰ù鍥敋閺嶎厼绐楁俊銈呮噺閸嬶繝鏌嶉崫鍕櫧鐎规挷绶氶弻鈥愁吋鎼粹€冲闂佽桨绀佸ú顓㈠蓟閿濆憘鐔烘嫚閼碱剛銈峰┑掳鍊栧Λ鍐潖婵犳艾纾兼慨姗嗗厴閸嬫挻顦版惔锝囩劶婵炶揪缍€濞咃絿绮堟繝鍌楁斀闁绘ê寮剁涵钘夘熆閼搁潧濮囩紒鐘差煼閹妫冨☉娆愬枑濡炪倖姊瑰ú鐔奉潖濞差亝鐒婚柣鎰蔼鐎氭澘顭胯閹告娊寮婚垾宕囨殕闁逞屽墴瀹曠増鎯旈妸锕€浠奸梺缁樺灱濡嫰鎮欐繝鍕枑濠㈣埖鍔曢崙鐘绘煕濞戝崬寮炬繛鎾愁煼閺屾洟宕煎┑鍡樻闂佽娴氭禍婵嬪Φ閸曨垰惟闁靛鍨甸崥顐︽倵鐟欏嫭绀冩俊鐐扮矙瀹曟椽鍩€椤掍降浜滈柟鍝勭Ч濡惧嘲霉濠婂嫮鐭掗柡宀€鍠栭幃婊兾熼搹閫涙樊婵＄偑鍊曞ù姘跺磻閸℃稑鐒垫い鎺戝枤濞兼劙鏌熼幖渚囨婵炲棎鍨归～婵堟崉妤︽寧鎲伴梻浣虹帛濮婂宕㈣缁濡烽敂杞扮盎闂佸搫鍟崐鐢稿箯閿熺姵鐓涢柛鈾€鏅涘顔芥叏婵犲啯銇濇鐐查叄閹崇偤濡烽敂鑺ヮ啅闂備焦鐪归崺鍕垂鏉堚晜鏆滈柍銉ь劜閼板灝銆掑锝呬壕濠殿喖锕ュ浠嬬嵁閹邦厽鍎熼柨婵嗘川閺嗐倝姊绘担鐑樺殌闁哥喕娉曢幑銏犖熼搹瑙勬濡炪倖鐗滈崑鐐哄磹閻戣姤鐓熼柟瀵稿剱閻掍粙鏌涘鈧禍璺侯潖閾忓湱纾兼俊顖濆吹閸欏棝姊洪崷顓涙嫛闁稿鎳愮划瀣箳閹搭厾鍙嗛梺鍓插亞閸犳捇宕㈤鍫熲拺缂侇垱娲栨晶鏌ユ煥濮樿京纾兼俊銈勭缁楁岸鏌曢崶褍顏い銏℃礋閺佹劙宕堕埡鍐╂緰濠碉紕鍋戦崐鎴﹀垂濞差亖鈧箓宕奸妷瀣喘楠炲酣鎳為妷褍骞楅梻渚€娼ч悧鍡欌偓姘煎枤缁綁寮崼鐔哄幍濡炪倖姊婚悺鏂库枔濮椻偓閺岀喖宕ｆ径瀣攭閻庤娲滈崰鏍€佸Δ鍛＜闁挎梹鍎抽弸鐘绘⒒閸屾艾鈧兘鎮為敃鍌氱畺闁割偅娲栫粈澶屸偓骞垮劚閹峰銆掓繝姘厾闁诡厽甯掗崝娆戠磼鐠囧弶顥㈤柡灞剧洴椤㈡洟鏁愰崱娆樻О闂備礁鎼幊蹇氥亹閸愵喒鈧妇鎹勯妸锕€纾梺缁樼濞兼瑦鎱ㄥ☉姗嗘富闁靛牆绻楃粈瀣煕閺冣偓閸ㄧ敻锝炶箛娑欐優闁革富鍘鹃敍婊冣攽閳藉棗鐏犻柟纰卞亯椤ゅ倿姊婚崒娆戭槮闁硅绻濋獮鎰節濮橆厼娈炴俊銈忕到閸燁偊鎮″┑鍫氬亾楠炲灝鍔氭い锔诲灣缁粯绻濆顓犲幐闂佺鏈敋闁告梹绮撻弻锟犲磼濡も偓娴滈箖姊婚崒姘偓鐑芥嚄閸撲礁鍨濇い鏍仦閺呮繈鏌嶉崫鍕櫣缂佹劖顨婇弻鈥愁吋鎼粹€崇闂佺锕ら悥鐓庮潖濞差亶鏁嗛柍褜鍓涚划鏃堟偨閸涘﹤浜楅梺鍝勬储閸ㄦ椽鎮￠崘顔界厱婵犻潧妫楅鈺呮煃瑜滈崜娑氬垝椤栫偛鐤鹃柛顐ｆ礃閸嬨劎鐥悧鍩亝绂嶆ィ鍐╁仭婵炲棗绻愰顏嗙磼閳ь剟宕橀鍡欙紲闁荤姴娲╃亸娆愭櫠閺囩喆浜滈柡鍥朵簽缁嬭崵绱掗崒娑樼闁逞屽墾缁蹭粙鎮樺璺虹柧闁挎繂顦伴埛鎴犵磽娴ｅ顏呮叏瀹ュ棛绠惧ù锝呭暱濞层劌鐣垫笟鈧弻娑㈩敃閻樻彃濮曢梺鎶芥敱鐢帡婀侀梺鎸庣箓濞层倝宕濈€ｎ喗鐓曢柕鍫濆€告禍鎯р攽閿涘嫬浜奸柛濠冪墪鐓ら柨鏇炲€搁崒銊ッ归悩宸剰缂佺姷鍋ら弻鏇熺節韫囨挾妲ｅ┑鈩冨絻缂嶅﹪鐛弽顐㈠灊閻熸瑥瀚峰鎴濃攽閳藉棗浜濈紒顔芥尭椤繐煤椤忓懎娈熼梺闈涱槸閸犳碍绂嶉鍥紓闂備線娼ф蹇曞緤缂佹顩茬憸鐗堝笚閻撴瑩鏌ｉ幋鐐嗘垹浜搁悧鍫㈢闁告侗鍠氶惌鎺撴叏婵犲啯銇濈€规洏鍔嶇换婵嬪礋椤撶姴濮搁梻鍌欒兌缁垳鏁鍛箚闁搞儮鏅滈～鏇㈡煟閹邦剙妫橀柣鏂挎憸閻熻銇勯弽銊р槈闁伙附绮撳缁樼瑹閳ь剙顭囪閹囧幢濞戞鐤囬梺褰掑亰閸犳碍绋夊鍚ゅ綊鎮℃惔锝嗘喖闂佺粯鎸鹃崰鎰┍婵犲洤围闁稿本鐭竟鏇㈡⒒娴ｇ懓顕滄繛璇ч檮缁傚秴顭ㄩ崼鐔蜂患闂佺粯鍨煎Λ鍕不濞戙垺鐓涘璺猴攻閸嬨儵鏌涢悙鑼煟婵﹥妞藉畷顐﹀礋椤掆偓缁愭盯姊洪崫銉バｉ柟鐟版搐閻ｇ兘濮€閵堝懐顢呴梺缁樺姀閺呮粓寮埀顒勬⒑閸︻厼鍔嬪┑鐐诧工閻ｇ兘骞囬弶鍨祮闂侀潧绻掓慨鐑藉蓟閸繍娓婚柕鍫濇婵呯磼閹绘帗鍋ラ柕鍡楁嚇閹崇娀顢楁担鍛婄€鹃梻浣虹帛椤ㄥ懘鎮ч崱娆戠當婵鍩栭悡鐔兼煙閹屽殶婵炲弶鎸抽弻锛勪沪閻ｅ睗銉︺亜瑜岀欢姘跺蓟濞戙垹绠婚悹铏瑰劋閻忓牆螖閻橀潧浠滈柨鏇ㄤ邯楠炲啫鈻庨幘鍏呯炊闂佸憡娲栫花娲礉閹达箑钃熼柕濞垮劗閺€浠嬫煕閳╁喚娈㈠ù灏栧亾闂傚倷鑳堕崕鐢稿疾濞戙垺鐓€闁挎繂鎷嬪鏍磽娴ｈ偂鎴炲垔閹绢喗鐓曟繛鎴烇公閺€濠氭煕鎼淬垺宕屾慨濠呮缁瑩宕犻垾鍏呯矗婵犵數濮崑鎾绘⒑椤掆偓缁夋挳鎮為崹顐犱簻闁圭儤鍨甸埀顒€顭烽獮濠偽旈崨顔惧幈闂侀潧顦伴崹鐢稿箠閹版澘姹插ù鐓庣摠閳锋帒霉閿濆浂鐒炬い銉ョ箻閺屾稓鈧絺鏅濈粣鏃傗偓瑙勬礃濞茬喎顕ｆ繝姘ㄩ柨鏇楀亾濞存粍顨婂娲川婵犲倸袝婵炲瓨绮嶇换鍫濈暦娴兼潙绠涙い鎾跺Х閻﹀牊绻濋悽闈浶㈤柛濠勭帛閺呭爼寮撮悩鐢碉紲闂侀€炲苯澧寸€规洖銈搁幃銏㈢矙閸喕绱熷┑鐘殿暯濡插懘宕归弶娆剧劷闁跨喓濮存导鐘绘煣韫囨挸甯ㄩ柛瀣尵閹叉挳宕熼鍌ゆО闂備胶绮幖顐ゆ崲濠靛棭鍤曢悹鍥ㄧゴ濡插牊淇婇姘倯婵炲牊娲熷娲焻閻愯尪瀚板褍顕埀顒冾潐濞叉ê煤閻旇偐宓侀柛銉墮缁狙囨煙缁嬫寧鎹ｉ柍?<\> + <i> 闂傚倸鍊搁崐鎼佸磹閹间礁纾归柟闂寸绾惧綊鏌熼梻瀵割槮缁炬儳缍婇弻鐔兼⒒鐎靛壊妲紒鐐劤缂嶅﹪寮婚悢鍏尖拻閻庨潧澹婂Σ顔剧磼閻愵剙鍔ょ紓宥咃躬瀵鎮㈤崗灏栨嫽闁诲酣娼ф竟濠偽ｉ鍓х＜闁绘劦鍓欓崝銈囩磽瀹ュ拑韬€殿喖顭烽幃銏ゅ礂鐏忔牗瀚介梺璇查叄濞佳勭珶婵犲伣锝夘敊閸撗咃紲闂佺粯鍔﹂崜娆撳礉閵堝洨纾界€广儱鎷戦煬顒傗偓娈垮枛椤兘骞冮姀銈呯閻忓繑鐗楃€氫粙姊虹拠鏌ュ弰婵炰匠鍕彾濠电姴浼ｉ敐澶樻晩闁告挆鍜冪床闂備浇顕栭崹搴ㄥ礃閿濆棗鐦遍梻鍌欒兌椤㈠﹤鈻嶉弴銏犵闁搞儺鍓欓悘鎶芥煛閸愩劎澧曠紒鈧崘鈹夸簻闊洤娴烽ˇ锕€霉濠婂牏鐣洪柡灞诲妼閳规垿宕卞▎蹇撴瘓缂傚倷闄嶉崝宀勫Χ閹间礁钃熼柣鏂垮悑閸庡矂鏌涘┑鍕姢鐞氾箓姊绘担鍛婃儓闁活厼顦辩槐鐐寸瑹閳ь剟濡存担鍓叉建闁逞屽墴楠炲啫鈻庨幘宕囶啇濡炪倖鎸鹃崳銉ノ涜濮婂宕掑▎鎴犵崲濠电偘鍖犻崗鐐☉閳诲酣骞嬮悙瀛橆唶闂備礁婀遍崕銈夈€冮幇顔剧闁哄秲鍔庣弧鈧梻鍌氱墛娓氭宕曢幇鐗堢厸闁告侗鍠氶崣鈧梺鍝勬湰缁嬫垿鍩ユ径鎰闁绘劕妯婂缁樹繆閻愵亜鈧垿宕曢弻銉﹀殞濡わ絽鍟悡姗€鏌熺€电浠滅紒鐘靛█濮婅櫣绮欓崠鈩冩暰濡炪們鍔屽Λ婵嬬嵁閸儱惟闁冲搫鍊搁埀顒€顭烽弻锕€螣娓氼垱楔闂佹寧绋掔粙鎴﹀煘閹达附鍊烽柡澶嬪灩娴滃爼姊洪悷鎵紞闁稿鍊曢悾鐑藉醇閺囥劍鏅㈡繛杈剧秮閺呰尙绱撻幘鍓佺＝闁稿本鐟чˇ锔姐亜閹存繃顥犻柍褜鍓涢悷鎶藉炊閵娿儮鍋撻崹顐犱簻闁圭儤鍨甸顏堟煕婵犲倻浠涙い銊ｅ劦閹瑩鎳犻鑳闂備礁鎲″鍦枈瀹ュ桅闁告洦鍨遍弲婊堟偣閸ヮ亜鐨哄ù鐙€鍨崇槐鎾寸瑹閸パ勭亪闂佺粯顨呯换姗€宕洪埀顒併亜閹烘埊鍔熺紒澶屾暬閺屾稓鈧絺鏅濋崝宥囩磼閸屾氨孝妞ゎ厹鍔戝畷濂告偄閸濆嫬绠ラ梻鍌欑閹诧紕鎹㈤崒婧惧亾濮樼厧鏋﹂柛濠冩尦濮婄粯鎷呴崨濠傛殘闂佸搫琚崝搴ｅ垝閺冨牊鍋ㄧ紒瀣嚦閿曞倹鐓曢柡鍥ュ妼閻忕姵淇婇锝忚€块柡宀€鍠撶划娆撳锤濡ゅň鍋撳Δ鍛厸閻庯綆鍓欏瓭闂佸疇顫夐崹鍧椼€佸▎鎴炲厹鐎瑰嫭婢橀～鐘电磽閸屾瑧璐伴柛锝庡櫍瀹曞綊宕奸弴鐘茬ウ闂婎偄娲︾粙鎴濐啅濠靛鐓涘璺侯儏閻忋儳绱掗幇顓犫姇缂佺粯绻堥幃浠嬫濞磋翰鍨介弻鐔兼惞椤愩垹顫掗梺闈涙缁舵艾鐣烽妸褉鍋撳☉娅辨岸骞忕紒妯肩閺夊牆澧界€靛ジ鎮归埀顒勬晝閸屾稑鈧潡鏌涢幘妤€鎳愰敍婊堟⒑闂堟侗鐓梻鍕婵￠潧鈹戦崼姘壕閻熸瑥瀚粈鍐煕閺冣偓濞茬喖宕洪悙鍝勭闁挎洍鍋撴鐐灪缁绘盯宕卞Ο鍝勵潔濡炪倖姊瑰ú鐔奉潖婵犳艾纾兼慨姗嗗厴閸嬫捇骞栨担鐟颁罕婵犵數濮撮崯浼存偡鐟欏嫪绻嗛柕鍫濆€告禍鎯ь渻閵堝骸骞栨繛宸弮瀹曟椽鏁撻悩鑼紲濠碘槅鍨板﹢閬嶆儎鎼淬劍鈷掑ù锝囧劋閸も偓濡炪倖娲﹂崢浠嬪箞閵娧€鍋撳☉娆樼劷妞も晝鍏橀弻銊╁籍閳ь剟宕瑰┑鍫熷床闁糕剝绋掗悡鐔兼煙闁箑骞栨い銉ヮ儔閺岋綁顢橀悢鐑樺櫚闂佸搫鏈ú鐔风暦闁秴鍗抽柣妯兼暩瀹曟煡鏌ｆ惔銏╁晱闁革綆鍣ｅ畷鎶芥晲閸涱垱娈鹃梺缁樻尭缁ㄥ爼寮ㄦ禒瀣厱闁斥晛鍟伴幊鍛偓瑙勬礀閹碱偊鍩為幋锔芥櫖闁告洦鍋傞弶顓㈡⒑缁嬪尅鏀婚柣妤佹礋閿濈偠绠涢弮鍌滅槇濠殿喗锕╅崜娑㈠蓟瑜嶉—鍐Χ閸℃顫囬梺绋垮瘨閸ㄨ京绮嬪鍫涗汗闁圭儤鎸鹃崢閬嶆⒑闂堟侗妯堥柛鐘崇墬閺呭爼顢涢悙瀵稿帗闂備礁鐏濋鍛归鈧弻锛勪沪閸撗佲偓鎺懨归悪鍛暤鐎规洘绮忛ˇ鎶芥煕閿濆骸鏋ょ紒杈ㄦ尰閹峰懘鎮烽弶娆炬綌婵犵妲呴崑鍕疮閺夋埈鍤曢悹鍥ф▕閸氬鏌涢顐簼妞ゅ骸娲缁樻媴閸涘﹤鏆堥梺鍦焾椤兘骞嗛崟顖ｆ晬婵椴稿▓楣冩⒑閻熸壆鎽犵紒鐑樺劤鍗遍柛顐犲劜閻撳繘鐓崶顬ｅ牓宕戦幘缁樻優妞ゆ劦鍋勯幃鍫熺節绾板纾块柛瀣灴瀹曟劙寮介鐔蜂罕濠德板€曢崯浼存儗濞嗘挻鐓欓柣鎴灻悘宥夋煛鐎ｎ亞效闁哄矉绲借灒闁兼祴鏅涚粭锟犳⒑缂佹ɑ灏伴柣鐔濆懏顫曢柟鎯х摠婵挳姊婚崼鐔恒€掑ù鐘层偢濮婃椽宕崟闈涘壋闂佸摜濮甸悧鐘差嚕婵犳碍鏅插璺猴功椤旀帡鏌ｆ惔銊︽锭闁硅绻濆畷鎶筋敇閵忊檧鎷洪梻鍌氱墛缁嬫帡骞栭幇鐗堝€垫慨姗嗗幗缁跺弶銇勯弴顏嗙М鐎殿喖鐖奸獮濠囨惞椤愶綆妫冮梺绯曟杹閸嬫挸顪冮妶鍡楃瑐闁煎啿鐖奸妴鍛村蓟閵夛妇鍘遍梺鍦亾椤ㄥ懘骞婇幇鐗堟櫖婵犻潧娲ㄧ粻楣冨级閸繂鈷旈柛鎺嶅嵆閺岀喓鍠婇崡鐐扮凹闂佺粯顨呴柊锝咁潖缂佹ɑ濯撮柧蹇曟嚀缁椻€愁渻閵堝啫濡奸柣妤€锕﹂幑銏犫槈閵忕姷鍔﹀銈嗗笒鐎氼參鎮￠悢鍝ョ闁瑰瓨绻傞懜瑙勭箾閸涱厾肖闁逞屽墲椤煤濮椻偓閺佸啴濮€閵堝懐浼嬮梺鎸庢礀閸婂摜绮婚敐澶嬬厽婵☆垵顕х徊缁樻叏鐟欏嫮鍙€婵﹤顭峰畷鎺戔枎閹搭厽袦濠电姰鍨婚幊鎾绘晝椤忓嫮鏆﹂柟杈剧畱楠炪垺绻涢幋鐑嗙劷闁绘稏鍎甸弻鐔煎礂閼测晜娈梺鍛婃煥缁夌懓鐣烽弴鐐垫殕闁告洦鍓涢崢閬嶆⒑閸濆嫭鍌ㄩ柛鏂挎湰閺呭爼骞嶉鍓э紲闂佹娊鏁崑鎾绘煕鐎ｎ偅宕屾慨濠勭帛缁楃喖鍩€椤掆偓椤洩顦虫い銊ｅ劥缁犳盯寮撮悙鐢电摌闂備礁鎲￠幐鍡涘礋椤愩垹绠叉繝寰锋澘鈧呭緤娴犲鐤い鏍仜绾惧綊鏌涢…鎴濅簽缂佺娀绠栭弻鐔衡偓鐢殿焾娴犳粎绱掑Δ浣侯暡缂佺粯鐩畷銊╊敇閵婏附鏆版俊鐐€戦崝濠囧磿閻㈢绠栨繛鍡楁禋閸熷懏銇勯弬鍨缓鐟滄棃寮婚敐鍡樺劅婵犻潧鐗忛妶鐑芥⒑缁嬫鍎愰柛鏃€鐟╁畷娲焵椤掍降浜滈柟鍝勭Х閸忓矂鏌嶉娑欑闁圭缍佹俊鑸靛緞鐎ｎ剙骞嶅┑锛勫仜椤戝懎霉妞嬪孩鏆滄繛鎴炴皑绾捐偐绱撴担璇＄劷婵炴彃鐡ㄩ〃銉╂倷鏉堟崘鈧法鈧鍠栭悥濂哥嵁鐎ｎ喗鍋愰柟缁樺醇閻樼粯鈷掗柛灞剧懆閸忓本銇勯鐐靛ⅵ妞ゃ垺鐗犲畷鍗炩槈濡⒈鍞堕梻浣哄帶椤洟宕愰弽褏鏆﹂柛娆忣槺缁犻箖鏌熺€电浠ч柟鍐插閳规垿顢涘☉娆忓攭闂佸搫鏈惄顖炵嵁閸ヮ剦鏁嗛柍褜鍓涢惀顏囶槾闁汇儺浜、妯衡攽閸垻鍘梻浣告惈閺堫剟鎯勯娑楃箚闁绘垹鐡旈弫濠囨煟閹惧磭宀搁柟宄邦煼濮婄粯鎷呴懞銉ｂ偓鍐磼閳ь剚鎷呯拠銉︽そ椤㈡﹢濮€閻樼儤鎲伴梻浣告惈濞村嫮妲愰弴銏″仾闁逞屽墴濮婃椽宕崟顒€绐涢梺绋款煬閸嬪﹥淇婇悜钘夌厸闁稿本绮屽铏節閻㈤潧浠﹂柛銊ョ埣閹虫繃銈ｉ崘銊ュ殤濠电偞鍨堕悷锕傚矗韫囨挴鏀介柣妯哄级閸ｇ儤銇勮箛鏇炐ｇ紒缁樼洴楠炲鎮╅搹顐ｇ槗闁诲氦顫夊ú蹇涘礉閹达负鈧礁鈻庨幇顔规敵闂佺懓鍚€缁€浣圭妤ｅ啯鐓欓梺顓ㄧ畱楠炴绱掗埦鈧崑鎾绘⒒娓氣偓濞佳勵殽韫囨洜绀婇柛鈩冾殢閻掍粙鏌熼幍顔碱暭闁绘挾鍠栭弻锝夊棘閸喚楠囧┑鐐叉噹閹虫﹢寮婚敐澶嬫櫜闁搞儜鍐ㄧ闁诲氦顫夊ú鏍Χ缁嬫鍤曢柟缁㈠枛鎯熼梺鎸庢婵倝鎮靛鍕瘈闁汇垽娼цⅷ闂佹悶鍔庨崢褔鍩㈤弬搴撴闁靛繆鏅滈弲鐐烘⒑缁洖澧查柕鍥ㄧ洴瀵顓兼径瀣幈闂侀潧顦介崰鏍ㄦ櫠椤栫偞鐓冮梺鍨儏缁楁帡妫佹径鎰叆婵犻潧妫欐径鍕煕閵堝倸浜惧┑锛勫亼閸婃牕煤濡厧鍨濈€广儱妫涢埞宥呪攽閻樺弶绁╅柡浣稿暣閺屽秹鍩℃担鍛婃闂侀潧鐗婂姗€鈥旈崘顔嘉ч煫鍥ㄦ礈琚︾紓鍌欒兌婵敻鎮ч弴顫稏闊洦鏌ｉ崑濠囨偡娴ｉ潧鈧挸效濡ゅ懏鈷戦柛锔诲幖閸斿鏌熺粙娆剧吋鐎殿喗濞婇幃鈺伱圭€ｎ偅鏉搁梻浣瑰缁嬫垹鈧凹鍓氱粋鎺楀箳閺冨倻锛滃銈嗘⒒閺咁偊骞婇崘鈹夸簻闁哄浂浜炵粙鑽ょ磼缂佹绠撴い顐ｇ箞椤㈡﹢鎮㈤崫銉ョ濠电姷鏁告慨浼村垂閻撳簶鏋栨繛鎴欏焺閺佸嫰鏌涘☉鍗炴灓妞も晛寮剁换婵囩節閸屾粌顤€闂佹娊鏀遍崹鍧楀蓟濞戞ǚ妲堟慨妤€鐗嗘慨娑氱磽閸屾艾鈧懓鐣濋幖浣歌摕婵炴垶鐟﹂崕鐔兼煏韫囧鐏╃€殿喓鍔戦幃妤冩喆閸曨剛顦ラ梺姹囧€曞ú顓℃閻熸粎澧楃敮妤呮偂濞戞埃鍋撻崗澶婁壕闁诲函缍嗛崜娑滄懌闂傚倷娴囬鏍垂閸楃倣娑㈠礃閳哄倸寮块梺閫炲苯澧撮柡灞诲妼閳藉螣娓氼垯鐥俊鐐€栭幐鎼佲€﹀畡閭︽綎缂備焦蓱婵潙銆掑鐓庣仯闁告柨鎽滅槐鎾存媴閾忕懓绗￠梺鎼炲妼濞尖€愁嚕椤愩倐鍋撻敐搴℃灍闁抽攱鍨甸湁闁稿繗鍋愰幊鍛存煙椤旂鍋㈤柡灞剧缁犳盯寮幘鍏夊亾閸ф鐓忛柛鈩冩礈椤︼箓鏌嶉挊澶樻Ц閾伙綁姊洪崹顕呭剱闁哄鎮傚缁樻媴缁嬫妫岄梺绋款儎缁舵艾鐣疯ぐ鎺戜紶闁告洜鏁搁崬鐢告⒑閻熼偊鍤熼柛瀣枔瀵囧焵椤掑嫭鈷戞慨鐟版搐閻忓弶绻涙担鍐插椤╃兘鏌ㄩ弴鐐测偓褰掓偂閺囥垺鐓忓┑鐐茬仢閸斻倝鏌涢埡瀣М闁哄瞼鍠栭、娆撴倷椤掑倸濮芥俊鐐€х粻鎴濓耿闁秴鐒垫い鎺戝枤濞兼劖绻涢幓鎺旂鐎规洝顫夌粋鎺斺偓锝庝海閹芥洟姊虹化鏇炲⒉妞ゃ劌绻樺畷銉р偓锝庡枟閻撴洟鏌嶉妷銉э紞缂佺姵鐓￠幃妤€顫濋鎯т划濠殿喖锕︾划顖炲箯閸涙潙宸濆┑鐘叉噽椤㈠懏淇婇悙顏勨偓銈夊储婵傚憡鍋嬮柛鈩冪⊕缁犳帒鈹戦敍鍕粶妞ゆ垵鎳庨湁闂佸灝顑囬埢鏃傗偓骞垮劚椤︿即鎮″▎鎾寸厽闁逛即娼ф晶鎵磼閹邦喖浠遍柡宀嬬節瀹曟﹢濡歌椤も偓闂備胶顭堥鍡涘礉閺嶎偅宕叉繛鎴欏灩闁卞洭鏌ㄥ┑鍡橆棤闁靛棗锕娲川婵犲啠鎷归梺璇″枛閸婃悂锝炶箛娑欐優闁稿繐顦禍楣冩煕閿旇骞栨い搴＄焸閺屾盯濡堕崱娆愬櫘缂備浇椴哥敮妤€顕ラ崟顓涘亾閿濆骸浜滈柛鐐差槸椤啴濡堕崘銊т痪闁藉啳浜槐鎺楁惞鐟欏嫭鐝紓渚囧枟閻熝囧箲閸曨垰惟闁靛鍨规禍楣冩煟閹邦喖鍔嬮柍閿嬪灴閺岀喓绮欓幐搴㈠闯缂備胶濮甸幑鍥蓟閻旂厧绀冮柤纰卞劮閿濆洨纾奸柡鍐ㄥ€搁弸娑氣偓娈垮枟閹歌櫕鎱ㄩ埀顒勬煥濞戞ê顏╂鐐搭殜濮婄粯鎷呴搹鐟扮闂佸搫琚崝鎴︾嵁濡も偓椤劑宕煎┑鍫㈡瀮闂備礁鎲￠崝锕傚窗濡ゅ懎纾归柛顭戝亝閸欏繑淇婇婊冨付閻㈩垵鍩栭〃銉╂倷閹碱厾鍔风紓浣介哺鐢繝銆佸▎鎾村殐闁宠桨璁查崣娲煟鎼淬値娼愭繛鍙夛耿閺佸啴濮€閵堝懏妲梺璺ㄥ枔婵绮堥崘鈹夸簻闊洦鎸惧瓭闂佸搫鎷嬮崣鍐潖婵犳艾纾兼繛鍡樺姉閵堜即姊虹粙娆惧剱闁告梹鐟╁畷鍝勨槈閵忕娀鍞堕梺闈涱槶閸庢娊藝椤撶偐鏀介柣鎰级椤ョ偤鏌熼崨濠冨€愮€规洘鐟╅幃鈺佺暦閸モ晩鍟庨梻浣烘嚀閻°劑鎮烽妷鈺傚€舵い蹇撶墛閻撶喖鏌熼幑鎰【闁哄鍨圭槐鎺旂磼濡吋鍒涘Δ鐘靛仜椤戝懘鍩為幋锕€骞㈡慨姗嗗墰閸樻潙鈹戦悩鍨毄闁稿鐩獮濠冩償閿濆洨鐓嬮梺鍓插亝濞叉牠鎮為崹顐犱簻闁圭儤鍨甸弸銈嗙箾閸忕厧濮堢紒缁樼洴瀹曪絾寰勭仦瑙ｆ嫲濠电姷顣介埀顒€纾崺锝団偓瑙勬磸閸斿秶鎹㈠┑鍥ㄥ闁惧繐婀遍弳浼存⒒閸屾瑨鍏岀紒顕呭灦瀹曞綊宕楅崗鐓庡伎闂侀潧鐗嗛ˇ顖炴偪閻愵剛绡€闂傚牊渚楅崕鎰版煟閹惧啿鏆熼柟鑼焾椤劑宕煎┑鍫Ф婵犵數鍋涘Λ娆撳箰閹间焦鍋傛繝闈涱儐閻撴瑩鏌涢幘妤€鎳庣粭锟犳⒑缁嬫鍎忛悗姘嵆瀵鈽夊鍛澑闂佽宕橀崺鏍儌娓氣偓濮婇缚銇愰幒鎾存殸濠碉紕鍋犲Λ鍕綖韫囨梻绡€婵﹩鍓涢敍婊冣攽椤旂煫顏勭暦椤掑娂鐑藉焵椤掑嫭鈷掑ù锝呮啞閸熺偤鏌涢弮鈧敋闁伙絿鍏樺Λ鍐圭粵鍦М妤犵偛娲幃褔宕奸悢鍓蹭户闂傚倷鑳剁划顖炴晪缂佸墽铏庨崣鍐ㄧ暦閵忋倕纭€闁绘劏鏅滈弬鈧梻浣虹帛钃卞褏濞€瀹曞ジ濡烽妷褝绱遍梻浣筋潐閸庤櫕鏅舵惔锝咁棜濠靛倸鎲￠悡鍐喐濠婂牆绀堟慨妯夸含缁犳棃鏌ｉ弮鍌氬付闁绘帒鐏氶妵鍕箳閸℃ぞ澹曟俊?tab
"nmap <silent> g1 <Plug>AirlineSelectTab1
"nmap <silent> g2 <Plug>AirlineSelectTab2
"nmap <silent> g3 <Plug>AirlineSelectTab3
"nmap <silent> g4 <Plug>AirlineSelectTab4
"nmap <silent> g5 <Plug>AirlineSelectTab5
"nmap <silent> g6 <Plug>AirlineSelectTab6
"nmap <silent> g7 <Plug>AirlineSelectTab7
"nmap <silent> g8 <Plug>AirlineSelectTab8
"nmap <silent> g9 <Plug>AirlineSelectTab9
""nmap <silent> g1 :tab1<CR>
""nmap <silent> g2 :tab2<CR>
""nmap <silent> g3 :tab3<CR>
""nmap <silent> g4 :tab4<CR>
""nmap <silent> g5 :tab5<CR>
""nmap <silent> g6 :tab6<CR>
""nmap <silent> g7 :tab7<CR>
""nmap <silent> g8 :tab8<CR>
""nmap <silent> g9 :tab9<CR>
""cabbrev o tab drop
""cabbrev e tabe
""cabbrev m tabm
""cabbrev a tab ball
""autocmd BufReadPost * tab ball

" no longer used vim-terminal-help:

"let g:terminal_key = '<c-=>'
"let g:terminal_default_mapping = 1

"inoremap 闂傚倸鍊搁崐鎼佸磹閹间礁纾归柟闂寸绾惧綊鏌熼梻瀵割槮缁炬儳缍婇弻鐔兼⒒鐎靛壊妲紒鐐劤缂嶅﹪寮婚悢鍏尖拻閻庨潧澹婂Σ顔剧磼閻愵剙鍔ょ紓宥咃躬瀵鎮㈤崗灏栨嫽闁诲酣娼ф竟濠偽ｉ鍓х＜闁绘劦鍓欓崝銈囩磽瀹ュ拑韬€殿喖顭烽幃銏ゅ礂鐏忔牗瀚介梺璇查叄濞佳勭珶婵犲伣锝夘敊閸撗咃紲闂佽鍨庨崘锝嗗瘱闂備胶顢婂▍鏇㈠箲閸ヮ剙鐏抽柡鍐ㄧ墕缁€鍐┿亜韫囧海顦﹀ù婊堢畺閺屻劌鈹戦崱娆忓毈缂備降鍔岄妶鎼佸蓟閻斿吋鍎岄柛婵勫劤琚﹂梻浣告惈閻绱炴笟鈧妴浣割潨閳ь剟骞冨▎鎾崇妞ゆ挾鍣ュΛ褔姊婚崒娆戠獢婵炰匠鍏炬稑鈻庨幋鐐存闂佸湱鍎ら〃鎰礊閺嶃劎绡€闂傚牊渚楅崕鎰版煛閸涱喚鍙€闁哄本绋戦埥澶愬础閻愬樊娼绘俊鐐€戦崕鎻掔暆缁嬫娼栭柧蹇氼潐鐎氭岸鏌涘▎蹇ｆЦ闁衡偓椤撶儐娓婚柕鍫濋娴滄粍銇勯敂璇茬仯闁告瑥鎳樺Λ鍛搭敃閵忊€愁槱缂備礁顑嗛崹瑙勭珶閺囥垹閿ゆ俊銈勮兌閸樼敻姊虹拠鈥崇仯濠⒀勵殜钘熷鑸靛姈閻撶喖鏌熼悜妯虹仼濞寸姵鐩弻鏇㈠炊瑜嶉顓燁殽閻愭潙娴鐐差儔椤㈡稑顫濋澶嬫祮缂傚倸鍊搁崐椋庣矆娓氣偓钘濋梺顒€绉撮弸浣糕攽閻樺疇澹橀柦鍐枑缁绘盯骞嬪▎蹇曚痪闂佺顑嗛崝妤呭焵椤掑喚娼愭繛鍙夌墪鐓ら柕鍫濐槸閻撴洟鏌涢鐘茬伄缁炬崘妫勯妴鎺戭潩椤掍焦鎮欓梺鍝勵儜闂勫嫰濡甸崟顖氬嵆闁糕剝顨嗙粊顐ょ磽瀹ュ棛澧紒缁樼箞濡啫鈽夐崡鐐插闂備焦鎮堕崐鏇㈩敄婢跺娼栧┑鐘宠壘闁卞洭鏌ｉ弮鍥モ偓鈧柡瀣濮婅櫣绮欏▎鎯у壉闂佸湱鎳撳ú銈夋偩闁垮闄勭紒瀣仢瀹撳棝姊虹紒妯荤叆闁圭⒈鍋婇悰顔嘉旈崨顔规嫽婵炶揪绲介幗婊呯矓濞差亝鐓曢悗锝庝悍闊剛鈧娲樼划宀勫煡婢舵劕顫呴柣妯活問閸熷牓姊绘担铏瑰笡妞ゎ厼娲ㄩ崚鎺楊敍閻愭潙浜楅梺缁樻閸嬫劙宕ｉ幘缁樼厱闁靛鏅╁Λ鎴︽煕閹烘柨顣肩紒缁樼洴瀹曘劑顢橀悩妯犲洦鐓?<ESC>A
"inoremap 闂傚倸鍊搁崐鎼佸磹閹间礁纾归柟闂寸绾惧綊鏌熼梻瀵割槮缁炬儳缍婇弻鐔兼⒒鐎靛壊妲紒鐐劤缂嶅﹪寮婚悢鍏尖拻閻庨潧澹婂Σ顔剧磼閻愵剙鍔ょ紓宥咃躬瀵鎮㈤崗灏栨嫽闁诲酣娼ф竟濠偽ｉ鍓х＜闁绘劦鍓欓崝銈囩磽瀹ュ拑韬€殿喖顭烽幃銏ゅ礂鐏忔牗瀚介梺璇查叄濞佳勭珶婵犲伣锝夘敊閸撗咃紲闂佽鍨庨崘锝嗗瘱闂備胶顢婂▍鏇㈠箲閸ヮ剙鐏抽柡鍐ㄧ墕缁€鍐┿亜韫囧海顦﹀ù婊堢畺閺屻劌鈹戦崱娆忓毈缂備降鍔岄妶鎼佸蓟閻斿吋鍎岄柛婵勫劤琚﹂梻浣告惈閻绱炴笟鈧妴浣割潨閳ь剟骞冨▎鎾崇妞ゆ挾鍣ュΛ褔姊婚崒娆戠獢婵炰匠鍏炬稑鈻庨幋鐐存闂佸湱鍎ら〃鎰礊閺嶃劎绡€闂傚牊渚楅崕鎰版煛閸涱喚鍙€闁哄本绋戦埥澶愬础閻愬樊娼绘俊鐐€戦崕鎻掔暆缁嬫娼栭柧蹇氼潐鐎氭岸鏌涘▎蹇ｆЦ闁衡偓椤撶儐娓婚柕鍫濋娴滄粍銇勯敂璇茬仯闁告瑥鎳樺Λ鍛搭敃閵忊€愁槱缂備礁顑嗛崹瑙勭珶閺囥垹閿ゆ俊銈勮兌閸樼敻姊虹拠鈥崇仯濠⒀勵殜钘熷鑸靛姈閻撶喖鏌熼悜妯虹仼濞寸姵鐩弻鏇㈠炊瑜嶉顓燁殽閻愭潙娴鐐差儔椤㈡稑顫濋澶嬫祮缂傚倸鍊搁崐椋庣矆娓氣偓钘濋梺顒€绉撮弸浣糕攽閻樺疇澹橀柦鍐枑缁绘盯骞嬪▎蹇曚痪闂佺顑嗛崝妤呭焵椤掑喚娼愭繛鍙夌墪鐓ら柕鍫濐槸閻撴洟鏌涢鐘茬伄缁炬崘妫勯妴鎺戭潩椤掍焦鎮欓梺鍝勵儜闂勫嫰濡甸崟顖氬嵆闁糕剝顨嗙粊顐ょ磽瀹ュ棛澧紒缁樼箞濡啫鈽夐崡鐐插闂備焦鎮堕崐鏇㈩敄婢跺娼栧┑鐘宠壘闁卞洭鏌ｉ弮鍥モ偓鈧柡瀣濮婅櫣绮欏▎鎯у壉闂佸湱鎳撳ú銈夋偩闁垮闄勭紒瀣仢瀹撳棝姊虹紒妯荤叆闁圭⒈鍋婇悰顔嘉旈崨顔规嫽婵炶揪绲介幗婊呯矓濞差亝鐓曢悗锝庝悍闊剛鈧娲樼划宀勫煡婢舵劕顫呴柣妯活問閸熷牓姊绘担铏瑰笡妞ゎ厼娲ㄩ崚鎺楊敍閻愭潙浜楅梺缁樻閸嬫劙宕ｉ幘缁樼厱闁靛鏅╁Λ鎴︽煕閹烘柨顣肩紒缁樼洴瀹曘劑顢橀悩妯犲洦鐓?<ESC>I
"nnoremap 闂傚倸鍊搁崐鎼佸磹閹间礁纾归柟闂寸绾惧綊鏌熼梻瀵割槮缁炬儳缍婇弻鐔兼⒒鐎靛壊妲紒鐐劤缂嶅﹪寮婚悢鍏尖拻閻庨潧澹婂Σ顔剧磼閻愵剙鍔ょ紓宥咃躬瀵鎮㈤崗灏栨嫽闁诲酣娼ф竟濠偽ｉ鍓х＜闁绘劦鍓欓崝銈囩磽瀹ュ拑韬€殿喖顭烽幃銏ゅ礂鐏忔牗瀚介梺璇查叄濞佳勭珶婵犲伣锝夘敊閸撗咃紲闂佽鍨庨崘锝嗗瘱闂備胶顢婂▍鏇㈠箲閸ヮ剙鐏抽柡鍐ㄧ墕缁€鍐┿亜韫囧海顦﹀ù婊堢畺閺屻劌鈹戦崱娆忓毈缂備降鍔岄妶鎼佸蓟閻斿吋鍎岄柛婵勫劤琚﹂梻浣告惈閻绱炴笟鈧妴浣割潨閳ь剟骞冨▎鎾崇妞ゆ挾鍣ュΛ褔姊婚崒娆戠獢婵炰匠鍏炬稑鈻庨幋鐐存闂佸湱鍎ら〃鎰礊閺嶃劎绡€闂傚牊渚楅崕鎰版煛閸涱喚鍙€闁哄本绋戦埥澶愬础閻愬樊娼绘俊鐐€戦崕鎻掔暆缁嬫娼栭柧蹇氼潐鐎氭岸鏌涘▎蹇ｆЦ闁衡偓椤撶儐娓婚柕鍫濋娴滄粍銇勯敂璇茬仯闁告瑥鎳樺Λ鍛搭敃閵忊€愁槱缂備礁顑嗛崹瑙勭珶閺囥垹閿ゆ俊銈勮兌閸樼敻姊虹拠鈥崇仯濠⒀勵殜钘熷鑸靛姈閻撶喖鏌熼悜妯虹仼濞寸姵鐩弻鏇㈠炊瑜嶉顓燁殽閻愭潙娴鐐差儔椤㈡稑顫濋澶嬫祮缂傚倸鍊搁崐椋庣矆娓氣偓钘濋梺顒€绉撮弸浣糕攽閻樺疇澹橀柦鍐枑缁绘盯骞嬪▎蹇曚痪闂佺顑嗛崝妤呭焵椤掑喚娼愭繛鍙夌墪鐓ら柕鍫濐槸閻撴洟鏌涢鐘茬伄缁炬崘妫勯妴鎺戭潩椤掍焦鎮欓梺鍝勵儜闂勫嫰濡甸崟顖氬嵆闁糕剝顨嗙粊顐ょ磽瀹ュ棛澧紒缁樼箞濡啫鈽夐崡鐐插闂備焦鎮堕崐鏇㈩敄婢跺娼栧┑鐘宠壘闁卞洭鏌ｉ弮鍥モ偓鈧柡瀣濮婅櫣绮欏▎鎯у壉闂佸湱鎳撳ú銈夋偩闁垮闄勭紒瀣仢瀹撳棝姊虹紒妯荤叆闁圭⒈鍋婇悰顔嘉旈崨顔规嫽婵炶揪绲介幗婊呯矓濞差亝鐓曢悗锝庝悍闊剛鈧娲樼划宀勫煡婢舵劕顫呴柣妯活問閸熷牓姊绘担铏瑰笡妞ゎ厼娲ㄩ崚鎺楊敍閻愭潙浜楅梺缁樻閸嬫劙宕ｉ幘缁樼厱闁靛鏅╁Λ鎴︽煕閹烘柨顣肩紒缁樼洴瀹曘劑顢橀悩妯犲洦鐓?^
"nnoremap 闂傚倸鍊搁崐鎼佸磹閹间礁纾归柟闂寸绾惧綊鏌熼梻瀵割槮缁炬儳缍婇弻鐔兼⒒鐎靛壊妲紒鐐劤缂嶅﹪寮婚悢鍏尖拻閻庨潧澹婂Σ顔剧磼閻愵剙鍔ょ紓宥咃躬瀵鎮㈤崗灏栨嫽闁诲酣娼ф竟濠偽ｉ鍓х＜闁绘劦鍓欓崝銈囩磽瀹ュ拑韬€殿喖顭烽幃銏ゅ礂鐏忔牗瀚介梺璇查叄濞佳勭珶婵犲伣锝夘敊閸撗咃紲闂佽鍨庨崘锝嗗瘱闂備胶顢婂▍鏇㈠箲閸ヮ剙鐏抽柡鍐ㄧ墕缁€鍐┿亜韫囧海顦﹀ù婊堢畺閺屻劌鈹戦崱娆忓毈缂備降鍔岄妶鎼佸蓟閻斿吋鍎岄柛婵勫劤琚﹂梻浣告惈閻绱炴笟鈧妴浣割潨閳ь剟骞冨▎鎾崇妞ゆ挾鍣ュΛ褔姊婚崒娆戠獢婵炰匠鍏炬稑鈻庨幋鐐存闂佸湱鍎ら〃鎰礊閺嶃劎绡€闂傚牊渚楅崕鎰版煛閸涱喚鍙€闁哄本绋戦埥澶愬础閻愬樊娼绘俊鐐€戦崕鎻掔暆缁嬫娼栭柧蹇氼潐鐎氭岸鏌涘▎蹇ｆЦ闁衡偓椤撶儐娓婚柕鍫濋娴滄粍銇勯敂璇茬仯闁告瑥鎳樺Λ鍛搭敃閵忊€愁槱缂備礁顑嗛崹瑙勭珶閺囥垹閿ゆ俊銈勮兌閸樼敻姊虹拠鈥崇仯濠⒀勵殜钘熷鑸靛姈閻撶喖鏌熼悜妯虹仼濞寸姵鐩弻鏇㈠炊瑜嶉顓燁殽閻愭潙娴鐐差儔椤㈡稑顫濋澶嬫祮缂傚倸鍊搁崐椋庣矆娓氣偓钘濋梺顒€绉撮弸浣糕攽閻樺疇澹橀柦鍐枑缁绘盯骞嬪▎蹇曚痪闂佺顑嗛崝妤呭焵椤掑喚娼愭繛鍙夌墪鐓ら柕鍫濐槸閻撴洟鏌涢鐘茬伄缁炬崘妫勯妴鎺戭潩椤掍焦鎮欓梺鍝勵儜闂勫嫰濡甸崟顖氬嵆闁糕剝顨嗙粊顐ょ磽瀹ュ棛澧紒缁樼箞濡啫鈽夐崡鐐插闂備焦鎮堕崐鏇㈩敄婢跺娼栧┑鐘宠壘闁卞洭鏌ｉ弮鍥モ偓鈧柡瀣濮婅櫣绮欏▎鎯у壉闂佸湱鎳撳ú銈夋偩闁垮闄勭紒瀣仢瀹撳棝姊虹紒妯荤叆闁圭⒈鍋婇悰顔嘉旈崨顔规嫽婵炶揪绲介幗婊呯矓濞差亝鐓曢悗锝庝悍闊剛鈧娲樼划宀勫煡婢舵劕顫呴柣妯活問閸熷牓姊绘担铏瑰笡妞ゎ厼娲ㄩ崚鎺楊敍閻愭潙浜楅梺缁樻閸嬫劙宕ｉ幘缁樼厱闁靛鏅╁Λ鎴︽煕閹烘柨顣肩紒缁樼洴瀹曘劑顢橀悩妯犲洦鐓?$
"vnoremap 闂傚倸鍊搁崐鎼佸磹閹间礁纾归柟闂寸绾惧綊鏌熼梻瀵割槮缁炬儳缍婇弻鐔兼⒒鐎靛壊妲紒鐐劤缂嶅﹪寮婚悢鍏尖拻閻庨潧澹婂Σ顔剧磼閻愵剙鍔ょ紓宥咃躬瀵鎮㈤崗灏栨嫽闁诲酣娼ф竟濠偽ｉ鍓х＜闁绘劦鍓欓崝銈囩磽瀹ュ拑韬€殿喖顭烽幃銏ゅ礂鐏忔牗瀚介梺璇查叄濞佳勭珶婵犲伣锝夘敊閸撗咃紲闂佽鍨庨崘锝嗗瘱闂備胶顢婂▍鏇㈠箲閸ヮ剙鐏抽柡鍐ㄧ墕缁€鍐┿亜韫囧海顦﹀ù婊堢畺閺屻劌鈹戦崱娆忓毈缂備降鍔岄妶鎼佸蓟閻斿吋鍎岄柛婵勫劤琚﹂梻浣告惈閻绱炴笟鈧妴浣割潨閳ь剟骞冨▎鎾崇妞ゆ挾鍣ュΛ褔姊婚崒娆戠獢婵炰匠鍏炬稑鈻庨幋鐐存闂佸湱鍎ら〃鎰礊閺嶃劎绡€闂傚牊渚楅崕鎰版煛閸涱喚鍙€闁哄本绋戦埥澶愬础閻愬樊娼绘俊鐐€戦崕鎻掔暆缁嬫娼栭柧蹇氼潐鐎氭岸鏌涘▎蹇ｆЦ闁衡偓椤撶儐娓婚柕鍫濋娴滄粍銇勯敂璇茬仯闁告瑥鎳樺Λ鍛搭敃閵忊€愁槱缂備礁顑嗛崹瑙勭珶閺囥垹閿ゆ俊銈勮兌閸樼敻姊虹拠鈥崇仯濠⒀勵殜钘熷鑸靛姈閻撶喖鏌熼悜妯虹仼濞寸姵鐩弻鏇㈠炊瑜嶉顓燁殽閻愭潙娴鐐差儔椤㈡稑顫濋澶嬫祮缂傚倸鍊搁崐椋庣矆娓氣偓钘濋梺顒€绉撮弸浣糕攽閻樺疇澹橀柦鍐枑缁绘盯骞嬪▎蹇曚痪闂佺顑嗛崝妤呭焵椤掑喚娼愭繛鍙夌墪鐓ら柕鍫濐槸閻撴洟鏌涢鐘茬伄缁炬崘妫勯妴鎺戭潩椤掍焦鎮欓梺鍝勵儜闂勫嫰濡甸崟顖氬嵆闁糕剝顨嗙粊顐ょ磽瀹ュ棛澧紒缁樼箞濡啫鈽夐崡鐐插闂備焦鎮堕崐鏇㈩敄婢跺娼栧┑鐘宠壘闁卞洭鏌ｉ弮鍥モ偓鈧柡瀣濮婅櫣绮欏▎鎯у壉闂佸湱鎳撳ú銈夋偩闁垮闄勭紒瀣仢瀹撳棝姊虹紒妯荤叆闁圭⒈鍋婇悰顔嘉旈崨顔规嫽婵炶揪绲介幗婊呯矓濞差亝鐓曢悗锝庝悍闊剛鈧娲樼划宀勫煡婢舵劕顫呴柣妯活問閸熷牓姊绘担铏瑰笡妞ゎ厼娲ㄩ崚鎺楊敍閻愭潙浜楅梺缁樻閸嬫劙宕ｉ幘缁樼厱闁靛鏅╁Λ鎴︽煕閹烘柨顣肩紒缁樼洴瀹曘劑顢橀悩妯犲洦鐓?^
"vnoremap 闂傚倸鍊搁崐鎼佸磹閹间礁纾归柟闂寸绾惧綊鏌熼梻瀵割槮缁炬儳缍婇弻鐔兼⒒鐎靛壊妲紒鐐劤缂嶅﹪寮婚悢鍏尖拻閻庨潧澹婂Σ顔剧磼閻愵剙鍔ょ紓宥咃躬瀵鎮㈤崗灏栨嫽闁诲酣娼ф竟濠偽ｉ鍓х＜闁绘劦鍓欓崝銈囩磽瀹ュ拑韬€殿喖顭烽幃銏ゅ礂鐏忔牗瀚介梺璇查叄濞佳勭珶婵犲伣锝夘敊閸撗咃紲闂佽鍨庨崘锝嗗瘱闂備胶顢婂▍鏇㈠箲閸ヮ剙鐏抽柡鍐ㄧ墕缁€鍐┿亜韫囧海顦﹀ù婊堢畺閺屻劌鈹戦崱娆忓毈缂備降鍔岄妶鎼佸蓟閻斿吋鍎岄柛婵勫劤琚﹂梻浣告惈閻绱炴笟鈧妴浣割潨閳ь剟骞冨▎鎾崇妞ゆ挾鍣ュΛ褔姊婚崒娆戠獢婵炰匠鍏炬稑鈻庨幋鐐存闂佸湱鍎ら〃鎰礊閺嶃劎绡€闂傚牊渚楅崕鎰版煛閸涱喚鍙€闁哄本绋戦埥澶愬础閻愬樊娼绘俊鐐€戦崕鎻掔暆缁嬫娼栭柧蹇氼潐鐎氭岸鏌涘▎蹇ｆЦ闁衡偓椤撶儐娓婚柕鍫濋娴滄粍銇勯敂璇茬仯闁告瑥鎳樺Λ鍛搭敃閵忊€愁槱缂備礁顑嗛崹瑙勭珶閺囥垹閿ゆ俊銈勮兌閸樼敻姊虹拠鈥崇仯濠⒀勵殜钘熷鑸靛姈閻撶喖鏌熼悜妯虹仼濞寸姵鐩弻鏇㈠炊瑜嶉顓燁殽閻愭潙娴鐐差儔椤㈡稑顫濋澶嬫祮缂傚倸鍊搁崐椋庣矆娓氣偓钘濋梺顒€绉撮弸浣糕攽閻樺疇澹橀柦鍐枑缁绘盯骞嬪▎蹇曚痪闂佺顑嗛崝妤呭焵椤掑喚娼愭繛鍙夌墪鐓ら柕鍫濐槸閻撴洟鏌涢鐘茬伄缁炬崘妫勯妴鎺戭潩椤掍焦鎮欓梺鍝勵儜闂勫嫰濡甸崟顖氬嵆闁糕剝顨嗙粊顐ょ磽瀹ュ棛澧紒缁樼箞濡啫鈽夐崡鐐插闂備焦鎮堕崐鏇㈩敄婢跺娼栧┑鐘宠壘闁卞洭鏌ｉ弮鍥モ偓鈧柡瀣濮婅櫣绮欏▎鎯у壉闂佸湱鎳撳ú銈夋偩闁垮闄勭紒瀣仢瀹撳棝姊虹紒妯荤叆闁圭⒈鍋婇悰顔嘉旈崨顔规嫽婵炶揪绲介幗婊呯矓濞差亝鐓曢悗锝庝悍闊剛鈧娲樼划宀勫煡婢舵劕顫呴柣妯活問閸熷牓姊绘担铏瑰笡妞ゎ厼娲ㄩ崚鎺楊敍閻愭潙浜楅梺缁樻閸嬫劙宕ｉ幘缁樼厱闁靛鏅╁Λ鎴︽煕閹烘柨顣肩紒缁樼洴瀹曘劑顢橀悩妯犲洦鐓?$

" no longer used YouCompleteMe:
"nnoremap <LEADER><LEADER> :YcmCompleter GoTo<CR>
"nnoremap <LEADER>[ :YcmCompleter GoToDefinitionElseDeclaration<CR>
"nnoremap <LEADER>d :YcmCompleter GetDoc<CR>
"nnoremap <LEADER>r :YcmCompleter RefactorRename<SPACE>
"nnoremap <LEADER>f :YcmCompleter FixIt<CR>1
"nnoremap <LEADER>y :call ToggleYcmDiagnostics()<CR><CR>:wa<CR>:e<CR>
"func! ToggleYcmDiagnostics()
    "let g:ycm_show_diagnostics_ui = !g:ycm_show_diagnostics_ui
    "YcmRestartServer
"endfunc

" no longer used vim-ctrlspace:
"if has('nvim')
    "let g:CtrlSpaceDefaultMappingKey = "<C-space> "
"endif

"let g:CtrlSpaceLoadLastWorkspaceOnStart = 1
"let g:CtrlSpaceSaveWorkspaceOnSwitch = 1
"let g:CtrlSpaceSaveWorkspaceOnExit = 1
"if executable('rg')
    "let g:CtrlSpaceGlobCommand = 'rg --color=never --files'
"elseif executable('ag')
    "let g:CtrlSpaceGlobCommand = 'ag -l --nocolor -g ""'
"endif
"nnoremap <silent><C-p> :CtrlSpace O<CR>

" no longer used fzf.vim:
"nnoremap <silent> <space>f :Files<CR>
"nnoremap <silent> <space>g :GFiles<CR>
"nnoremap <silent> <space>s :GFiles?<CR>
"nnoremap <silent> <space>b :Buffers<CR>
"nnoremap <silent> <space>a :Ag<CR>
"nnoremap <silent> <space>r :Rg<CR>
"nnoremap <silent> <space>l :Lines<CR>
"nnoremap <silent> <space>o :BLines<CR>
"nnoremap <silent> <space>h :History<CR>
"nnoremap <silent> <space>: :History:<CR>
"nnoremap <silent> <space>/ :History/<CR>
"nnoremap <silent> <space>c :Commits<CR>
"nnoremap <silent> <space>x :Commands<CR>
"nnoremap <silent> <space>w :Windows<CR>
"nnoremap <silent> <space>m :Maps<CR>

"nmap g<tab> <plug>(fzf-maps-n)
"xmap g<tab> <plug>(fzf-maps-x)
"omap g<tab> <plug>(fzf-maps-o)

"imap <c-x><c-k> <plug>(fzf-complete-word)
"imap <c-x><c-f> <plug>(fzf-complete-path)
"imap <c-x><c-l> <plug>(fzf-complete-line)

" for LeaderF:

let g:Lf_HideHelp = 1
let g:Lf_WindowPosition = 'popup'
let g:Lf_PreviewInPopup = 1
let g:Lf_PreviewCode = 1
"let g:Lf_StlSeparator = { 'left': "\ue0b0", 'right': "\ue0b2", 'font': "DejaVu Sans Mono for Powerline" }
"let g:Lf_PreviewResult = {'Function': 0, 'BufTag': 0 }

let g:Lf_ShortcutF = ''
let g:Lf_ShortcutB = ''
noremap ,k :Leaderf rg<CR>
noremap ,o :Leaderf file<CR>
noremap ,b :Leaderf! buffer<CR>
noremap ,m :Leaderf! mru<CR>
noremap ,t :Leaderf! bufTag<CR>
noremap ,l :Leaderf line<CR>
noremap ,x :Leaderf command<CR>
noremap ,: :Leaderf! cmdHistory<CR>
noremap ,/ :Leaderf! searchHistory<CR>
noremap ,w :Leaderf! window<CR>
noremap ,h :Leaderf! marks<CR>
noremap ,j :Leaderf! jumps<CR>
noremap ,n :Leaderf function<CR>
noremap ,q :Leaderf quickfix<CR>

noremap ,i :<C-U><C-R>=printf("Leaderf! rg --current-buffer -e %s", expand("<cword>"))<CR><CR>
noremap ,a :<C-U><C-R>=printf("Leaderf! rg -e %s", expand("<cword>"))<CR><CR>
xnoremap ,i :<C-U><C-R>=printf("Leaderf! rg --current-buffer -F -e %s", leaderf#Rg#visual())<CR><CR>
xnoremap ,a :<C-U><C-R>=printf("Leaderf! rg -F -e %s", leaderf#Rg#visual())<CR><CR>
noremap ,. :<C-U>Leaderf! --recall<CR>

" should use `Leaderf gtags --update` first
"let g:Lf_GtagsAutoGenerate = 0
"let g:Lf_Gtagslabel = 'native-pygments'
"noremap gfr :<C-U><C-R>=printf("Leaderf! gtags -r %s --auto-jump", expand("<cword>"))<CR><CR>
"noremap gfd :<C-U><C-R>=printf("Leaderf! gtags -d %s --auto-jump", expand("<cword>"))<CR><CR>
"noremap gfo :<C-U><C-R>=printf("Leaderf! gtags --recall %s", "")<CR><CR>
"noremap gfn :<C-U><C-R>=printf("Leaderf gtags --next %s", "")<CR><CR>
"noremap gfp :<C-U><C-R>=printf("Leaderf gtags --previous %s", "")<CR><CR>

" for vim-easymotion:

map t <Plug>(easymotion-bd-f)
nmap t <Plug>(easymotion-overwin-f)
map T <Plug>(easymotion-bd-w)
nmap T <Plug>(easymotion-overwin-w)
let g:EasyMotion_do_mapping = 0

" for coc.nvim:
let g:coc_global_extensions = ['coc-clangd', 'coc-json', 'coc-git']

" BEGIN_COC_NVIM {{{
" References: https://github.com/neoclide/coc.nvim#example-vim-configuration

set hidden
set nobackup
set nowritebackup
set updatetime=300
set cmdheight=1
set shortmess+=c

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
if 0 "has("nvim-0.5.0") || has("patch-8.1.1564")
  set signcolumn=number
else
  set signcolumn=yes
endif

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
"inoremap <silent><expr> <TAB>
      "\ coc#pum#visible() ? coc#pum#next(1) :
      "\ <SID>check_back_space() ? "\<TAB>" :
      "\ coc#refresh()
"inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-space> coc#pum#visible() ? coc#pum#confirm() : coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#pum#visible() ? coc#pum#confirm() : coc#refresh()
endif

" Make <CR> auto-select the first completion item and notify coc.nvim to
" format on enter, <cr> could be remapped by other vim plugin
" inoremap <silent><expr> <cr> coc#pum#visible() ? coc#pum#confirm()
                              "\: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
inoremap <silent><expr> <TAB> coc#pum#visible() ? (<SID>check_back_space() ? "\<TAB>" : coc#pum#confirm()) : "\<TAB>"
inoremap <silent><expr> <CR> coc#pum#visible() ? (<SID>check_back_space() ? "\<CR>" : coc#pum#confirm()) : "\<CR>" 

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> gl[ <Plug>(coc-diagnostic-prev)
nmap <silent> gl] <Plug>(coc-diagnostic-next)


" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gD <Plug>(coc-implementation)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gY <Plug>(coc-declaration)
nmap <silent> gr <Plug>(coc-references)

" Use gi to show documentation in preview window.
nnoremap <silent> gi :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim', 'help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
"autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap gR <Plug>(coc-rename)

" Formatting selected code.
xmap gq <Plug>(coc-format-selected)
"nmap gq <Plug>(coc-format-selected)
nnoremap gq :Format<CR>

" Restart CoC
"nmap <silent> gt :CocRestart<CR><CR>

augroup coc_group_ts_json
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying codeAction to the selected region.
" Example: `gaap` for current paragraph
xmap ga  <Plug>(coc-codeaction-selected)
nmap ga  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current buffer.
nmap gac <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap gaq  <Plug>(coc-fix-current)

" Run the Code Lens action on the current line.
nmap gal <Plug>(coc-codelens-action)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Remap <C-f> and <C-b> for scroll float windows/popups.
if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif

" Use CTRL-S for selections ranges.
" Requires 'textDocument/selectionRange' support of language server.
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer.
command! -nargs=0 Format    :call CocActionAsync('format')

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold      :call CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OrgImport :call CocActionAsync('runCommand', 'editor.action.organizeImport')

" Add (Neo)Vim's native statusline support.
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline.
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Mappings for CoCList
" Using CocList
" Show all diagnostics
nnoremap <silent> gla  :<C-u>CocList diagnostics<cr>
" Manage extensions
nnoremap <silent> gle  :<C-u>CocList extensions<cr>
" Show commands
nnoremap <silent> glc  :<C-u>CocList commands<cr>
" Find symbol of current document
nnoremap <silent> glo  :<C-u>CocList outline<cr>
" Search workspace symbols
nnoremap <silent> gls  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent> glj  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent> glk  :<C-u>CocPrev<CR>
" Resume latest coc list
nnoremap <silent> glp  :<C-u>CocListResume<CR>
" Show git status
nnoremap <silent> glg  :<C-u>CocList --normal gstatus<CR>

" }}} END_COC_NVIM

" for coc-snippets:

let g:coc_snippet_next = '<tab>'

" for vim-floaterm:

let g:floaterm_wintype = 'split'
let g:floaterm_position = 'botright'
let g:floaterm_height = 6

"let g:floaterm_keymap_new    = '<F1>'
"let g:floaterm_keymap_prev   = '<F2>'
"let g:floaterm_keymap_next   = '<F3>'
"let g:floaterm_keymap_toggle = '<C-t>'
"let g:floaterm_autoclose     = 1
"let g:floaterm_autoinsert    = 1
let g:floaterm_rootmarks = ['.tasks', '.git/']
if has('win32') || has('win64')
    let s:powershell_utf8_preamble = '[Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.UTF8Encoding]::new($false); $OutputEncoding=[Console]::OutputEncoding; chcp 65001 > $null'
    let s:powershell_shell_cmd = 'powershell -NoLogo -NoProfile -ExecutionPolicy Bypass -NoExit -Command "' . s:powershell_utf8_preamble . '"'
    let g:floaterm_shell = s:powershell_shell_cmd
endif

"todo: input this to floaterm esc: set norelativenumber nonumber noeol nolist showbreak= signcolumn=no

"function s:on_floaterm_gf() abort
  "let f = findfile(expand('<cfile>'))
  "if !empty(f)
    "FloatermHide
    "execute 'e ' . f
  "endif
"endfunction

"augroup floaterm_gf_key
"autocmd FileType floaterm nnoremap <silent><buffer> gf :call <SID>on_floaterm_gf()<CR>
"augroup end

" for asynctasks.vim:

let g:asyncrun_open = 6
if has('win32') || has('win64')
    let g:asyncrun_encs = 'utf-8'
endif
let g:asynctasks_term_pos = 'floaterm_reuse'
let g:asynctasks_term_rows = 6
let g:asynctasks_term_cols = 50
let g:asynctasks_term_reuse = 0
let g:asynctasks_term_focus = 0
let g:asyncrun_rootmarks = ['.tasks', '.git/']

function! AsyncTaskMultiple(first, ...)
    if len(a:000) >= 1
        if a:first == 0
            cclose
        else
            FloatermHide!
        endif
        let l:tmp = ""
        for task in a:000[1:]
            let l:tmp .= "'".l:task."',"
        endfor
        let l:tmp = l:tmp[:-1]
        let g:asyncrun_exit = "if g:asyncrun_code == 0 | call AsyncTaskMultiple(0, ".l:tmp.") | else | call AsyncTaskMultiple(0) | endif"
        exec "AsyncTask ".a:000[0]
    else
        let g:asyncrun_exit = ""
    endif
endfunction
command! -nargs=+ AsyncTasks   :call AsyncTaskMultiple(1, <f-args>)

function! s:PowershellLiteral(text) abort
    return "'" . substitute(a:text, "'", "''", 'g') . "'"
endfunction

function! s:GetTaskRoot() abort
    if exists('*asynctasks#current_root')
        let l:root = asynctasks#current_root()
        if l:root != ''
            return l:root
        endif
    endif
    return getcwd()
endfunction

function! s:GetTaskVar(name, fallback) abort
    if exists('*asynctasks#variable')
        let l:value = asynctasks#variable('', a:name)
        if type(l:value) == type('') && l:value != ''
            return l:value
        endif
    endif
    return a:fallback
endfunction

function! s:OpenRunTerminal(cmd, cwd) abort
    if exists(':FloatermNew') != 2
        if has('win32') || has('win64')
            execute 'terminal ' . s:powershell_shell_cmd
        else
            execute 'terminal'
        endif
        call s:BindTerminalCloseKey()
        if exists('*term_sendkeys')
            call term_sendkeys(bufnr('%'), a:cmd . "\r")
        endif
        return
    endif

    let l:config = {
                \ 'wintype': g:floaterm_wintype,
                \ 'position': g:floaterm_position,
                \ 'height': g:floaterm_height,
                \ 'cwd': a:cwd,
                \ 'autoclose': 0,
                \ 'silent': 0,
                \ }
    let l:bufnr = floaterm#new(v:true, '', {}, l:config)
    call s:BindTerminalCloseKey()
    call floaterm#terminal#send(l:bufnr, [a:cmd])
    stopinsert
endfunction

function! s:RunProjectTarget() abort
    let l:root = s:GetTaskRoot()
    let l:build_dir = s:GetTaskVar('build_dir', 'build')
    let l:build_type = s:GetTaskVar('build_type', 'Release')
    let l:build_target = s:GetTaskVar('build_target', 'main')
    let l:target = fnamemodify(l:root . '\' . l:build_dir . '\' . l:build_type . '\' . l:build_target . '.exe', ':p')

    if !filereadable(l:target)
        echohl WarningMsg
        echom 'Run target not found: ' . l:target
        echohl None
        return
    endif

    call s:OpenRunTerminal('& ' . s:PowershellLiteral(l:target), l:root)
endfunction

function! s:RunCurrentFile() abort
    let l:filedir = expand('%:p:h')
    let l:filepath = expand('%:p')
    let l:command = ''

    if &filetype ==# 'c' || &filetype ==# 'cpp' || &filetype ==# 'rust'
        let l:target = expand('%:p:r') . '.exe'
        if !filereadable(l:target)
            echohl WarningMsg
            echom 'Run target not found: ' . l:target
            echohl None
            return
        endif
        let l:command = '& ' . s:PowershellLiteral(l:target)
    elseif &filetype ==# 'python'
        let l:command = 'python ' . s:PowershellLiteral(expand('%:t'))
    elseif &filetype ==# 'javascript'
        let l:command = 'node ' . s:PowershellLiteral(expand('%:t'))
    elseif &filetype ==# 'sh'
        let l:command = 'bash ' . s:PowershellLiteral(expand('%:t'))
    else
        let l:command = '& ' . s:PowershellLiteral(l:filepath)
    endif

    call s:OpenRunTerminal(l:command, l:filedir)
endfunction

function! VimRunFollowup(kind) abort
    let g:asyncrun_exit = ''
    if a:kind ==# 'project'
        call s:RunProjectTarget()
    elseif a:kind ==# 'file'
        call s:RunCurrentFile()
    endif
endfunction

function! s:BuildProjectThenRun() abort
    if exists(':AsyncTask') == 2
        let g:asyncrun_exit = "if g:asyncrun_code == 0 | call VimRunFollowup('project') | else | let g:asyncrun_exit = '' | endif"
        execute 'AsyncTask project-build'
    else
        echohl WarningMsg
        echom 'AsyncTask is unavailable. Run :PlugInstall first.'
        echohl None
    endif
endfunction

function! s:BuildFileThenRun() abort
    if exists(':AsyncTask') == 2
        let g:asyncrun_exit = "if g:asyncrun_code == 0 | call VimRunFollowup('file') | else | let g:asyncrun_exit = '' | endif"
        execute 'AsyncTask file-build'
    else
        echohl WarningMsg
        echom 'AsyncTask is unavailable. Run :PlugInstall first.'
        echohl None
    endif
endfunction

"" for incsearch.vim

"map /  <Plug>(incsearch-forward)
"map ?  <Plug>(incsearch-backward)
"map g/ <Plug>(incsearch-stay)

"" below integrate with easymotion:
"function! s:config_easyfuzzymotion(...) abort
  "return extend(copy({
  "\   'converters': [incsearch#config#fuzzyword#converter()],
  "\   'modules': [incsearch#config#easymotion#module({'overwin': 1})],
  "\   'keymap': {"\<CR>": '<Over>(easymotion)'},
  "\   'is_expr': 0,
  "\   'is_stay': 1
  "\ }), get(a:, 1, {}))
"endfunction

"noremap <silent><expr> g? incsearch#go(<SID>config_easyfuzzymotion())

"set hlsearch
"let g:incsearch#auto_nohlsearch = 1
"map n  <Plug>(incsearch-nohl-n)
"map N  <Plug>(incsearch-nohl-N)
"map *  <Plug>(incsearch-nohl-*)
"map #  <Plug>(incsearch-nohl-#)
"map g* <Plug>(incsearch-nohl-g*)
"map g# <Plug>(incsearch-nohl-g#)

"function! s:noregexp(pattern) abort
  "return '\V' . escape(a:pattern, '\')
"endfunction

"function! s:incsconfig() abort
  "return {'converters': [function('s:noregexp')]}
"endfunction

"noremap <silent><expr> z/ incsearch#go(<SID>incsconfig())

" for lightline.vim:

set noshowmode
" lightline
let g:lightline = {
      \ 'active': {
      \   'left': [
      \             [ 'mode', 'paste', ],
      \             [ 'readonly', 'filename', 'modified', ],
      \             [ 'branch', 'blame', ],
      \           ],
      \   'right': [
      \             [ 'lineinfo', ],
      \             [ 'percent', ],
      \             [ 'fileformat', 'fileencoding', 'filetype', ],
      \            ],
      \ },
      \ 'tabline': {
      \   'left': [['tabs']],
      \   'right': [['close']],
      \ },
      \ 'tab': {
      \   'active': [ 'tabnum', 'filename', 'modified', ],
      \   'inactive': [ 'tabnum', 'filename', 'modified', ],
      \ },
      \ 'component_function': {
      \   'branch': 'LightlineGitBranch',
      \   'blame': 'LightlineGitBlame',
      \ },
      \ 'enable': { 'statusline': 1, 'tabline': 1, },
      \ }

function! LightlineGitBranch() abort
  let branch = get(g:, 'coc_git_status', '')
  return branch
endfunction

function! LightlineGitBlame() abort
  let blame = get(b:, 'coc_git_blame', '')
  " return blame
  return winwidth(0) > 120 ? blame : ''
endfunction

" no longer used vim-workspace:

"let g:workspace_session_directory = $HOME . '/.vim/sessions/'
"let g:workspace_undodir = $HOME . '/.vim/sessions/.undodir'
"let g:workspace_autosave_always = 1
"let g:workspace_autosave_untrailspaces = 0
"let g:workspace_autosave_untrailtabs = 0
"let g:workspace_autocreate = 1
"let g:workspace_session_disable_on_args = 1

" for vim-which-key:

" begin plugin list

if filereadable(expand('~/.vim/autoload/plug.vim'))
call plug#begin(expand('~/.vim/plugged'))

Plug 'ryanoasis/vim-devicons'
Plug 'sheerun/vim-polyglot'
Plug 'tpope/vim-sensible'
Plug 'junegunn/seoul256.vim'
Plug 'iamcco/mathjax-support-for-mkdp'
Plug 'iamcco/markdown-preview.vim'
Plug 'jiangmiao/auto-pairs'
"Plug 'vim-scripts/surround.vim'
Plug 'tpope/vim-surround'
Plug 'scrooloose/nerdtree', {'on': 'NERDTreeToggle'}
Plug 'archibate/QFixToggle', {'on': 'QFix'}
Plug 'tpope/vim-fugitive'
"Plug 'bfrg/vim-cpp-modern', {'for': 'cpp'}
"Plug 'vim-scripts/vim-airline'
"Plug 'cskeeters/vim-smooth-scroll'
Plug 'tikhomirov/vim-glsl', {'for': 'glsl'}
"Plug 'junegunn/vim-slash'
"Plug 'vim-scripts/a.vim', {'for': ['c', 'cpp', 'cuda']}
"Plug 'machakann/vim-swap'
Plug 'preservim/nerdcommenter'
"Plug 'preservim/vimux'
"Plug 'peterhoeg/vim-qml', {'for': 'qml'}
"Plug 'SirVer/ultisnips'
"Plug 'honza/vim-snippets'
"Plug 'neoclide/coc-snippets'
Plug 'jackguo380/vim-lsp-cxx-highlight'
Plug 'mbbill/undotree', {'on': 'UndotreeToggle'}
"Plug 'ilyachur/cmake4vim', {'on': ['CMake', 'CMakeBuild', 'CMakeInfo', 'CMakeRun']}
"Plug 'puremourning/vimspector'
"Plug 'ctrlpvim/ctrlp.vim', {'on': ['CtrlP']}
"Plug 'ycm-core/YouCompleteMe', {'do': './install.py --clang-completer', 'for': ['c', 'cpp', 'python']}
Plug 'neoclide/coc.nvim', {'branch': 'release'}
"Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
"Plug 'junegunn/fzf.vim'
Plug 'skywind3000/asynctasks.vim'
Plug 'skywind3000/asyncrun.vim'
"Plug 'skywind3000/vim-terminal-help'
"Plug 'aben20807/vim-runner'
"Plug 'christoomey/vim-tmux-runner'
"Plug 'viniciusgerevini/tmux-runner.vim'
"Plug 'vim-ctrlspace/vim-ctrlspace'
"Plug 'haya14busa/incsearch.vim'
"Plug 'haya14busa/incsearch-fuzzy.vim'
"Plug 'haya14busa/incsearch-easymotion.vim'
Plug 'voldikss/vim-floaterm'
"Plug 'findango/vim-mdx', {'for': 'mdx'}
Plug 'Yggdroot/LeaderF', { 'do': ':LeaderfInstallCExtension' }
"Plug 'voldikss/LeaderF-floaterm'
Plug 'liuchengxu/vista.vim', {'on': 'Vista!!'}
Plug 'morhetz/gruvbox'
Plug 'tomasr/molokai'
Plug 'xuyuanp/nerdtree-git-plugin', {'on': 'NERDTreeToggle'}
"Plug 'thaerkh/vim-workspace'
Plug 'itchyny/lightline.vim'
"Plug 'mkitt/tabline.vim'
Plug 'tpope/vim-repeat'
Plug 'easymotion/vim-easymotion'
Plug 'liuchengxu/vim-which-key'
"Plug 'wincent/terminus'

call plug#end()
endif

let g:maplocalleader = ','
let g:which_key_timeout = 500

let g:which_key_map_comma = {}
let g:which_key_map_comma.name = "\u002b\u641c\u7d22"
let g:which_key_map_comma.o = "\u641c\u7d22\u6587\u4ef6"
let g:which_key_map_comma.k = "\u5168\u9879\u76ee\u6587\u672c\u641c\u7d22"
let g:which_key_map_comma.b = "\u641c\u7d22\u5df2\u6253\u5f00\u7f13\u51b2\u533a"
let g:which_key_map_comma.m = "\u6700\u8fd1\u6587\u4ef6"
let g:which_key_map_comma.t = "\u5f53\u524d\u7f13\u51b2\u533a\u6807\u7b7e"
let g:which_key_map_comma.l = "\u5f53\u524d\u6587\u4ef6\u884c\u641c\u7d22"
let g:which_key_map_comma.x = "\u547d\u4ee4\u5217\u8868"
let g:which_key_map_comma[':'] = "\u547d\u4ee4\u5386\u53f2"
let g:which_key_map_comma['/'] = "\u641c\u7d22\u5386\u53f2"
let g:which_key_map_comma.w = "\u7a97\u53e3\u5217\u8868"
let g:which_key_map_comma.h = "\u6807\u8bb0\u5217\u8868"
let g:which_key_map_comma.j = "\u8df3\u8f6c\u5386\u53f2"
let g:which_key_map_comma.n = "\u51fd\u6570\u5217\u8868"
let g:which_key_map_comma.q = "quickfix \u5217\u8868"
let g:which_key_map_comma.i = "\u641c\u7d22\u5f53\u524d\u8bcd(\u5f53\u524d\u6587\u4ef6)"
let g:which_key_map_comma.a = "\u641c\u7d22\u5f53\u524d\u8bcd(\u6574\u4e2a\u9879\u76ee)"
let g:which_key_map_comma['.'] = "\u6062\u590d\u4e0a\u6b21\u641c\u7d22"

let g:which_key_map_z = {}
let g:which_key_map_z.name = "\u002b\u7a97\u53e3"
let g:which_key_map_z.h = ['<C-w>h', "\u5207\u5230\u5de6\u4fa7\u7a97\u53e3"]
let g:which_key_map_z.j = ['<C-w>j', "\u5207\u5230\u4e0b\u65b9\u7a97\u53e3"]
let g:which_key_map_z.k = ['<C-w>k', "\u5207\u5230\u4e0a\u65b9\u7a97\u53e3"]
let g:which_key_map_z.l = ['<C-w>l', "\u5207\u5230\u53f3\u4fa7\u7a97\u53e3"]
let g:which_key_map_z.H = ['<C-w>H', "\u628a\u7a97\u53e3\u79fb\u5230\u6700\u5de6"]
let g:which_key_map_z.J = ['<C-w>J', "\u628a\u7a97\u53e3\u79fb\u5230\u6700\u4e0b"]
let g:which_key_map_z.K = ['<C-w>K', "\u628a\u7a97\u53e3\u79fb\u5230\u6700\u4e0a"]
let g:which_key_map_z.L = ['<C-w>L', "\u628a\u7a97\u53e3\u79fb\u5230\u6700\u53f3"]
let g:which_key_map_z.v = ['<C-w>v', "\u7eb5\u5411\u5206\u5c4f"]
let g:which_key_map_z.s = ['<C-w>s', "\u6a2a\u5411\u5206\u5c4f"]
let g:which_key_map_z['='] = ['<C-w>=', "\u5747\u5206\u7a97\u53e3"]
let g:which_key_map_z['-'] = ['<C-w>-', "\u51cf\u5c0f\u7a97\u53e3\u9ad8\u5ea6"]
let g:which_key_map_z['+'] = ['<C-w>+', "\u589e\u5927\u7a97\u53e3\u9ad8\u5ea6"]
let g:which_key_map_z.x = ['<C-w>x', "\u4ea4\u6362\u7a97\u53e3"]
let g:which_key_map_z.o = [':only<CR>', "\u53ea\u4fdd\u7559\u5f53\u524d\u7a97\u53e3"]
let g:which_key_map_z.q = [':bd!<CR>', "\u5173\u95ed\u5f53\u524d\u7f13\u51b2\u533a"]
let g:which_key_map_z.t = [':call <SID>ToggleProjectView()<CR>', "\u5207\u6362\u9879\u76ee\u6587\u4ef6\u6811"]
let g:which_key_map_z.p = [':call <SID>ToggleQuickfix()<CR>', "\u5207\u6362 quickfix \u7a97\u53e3"]

let g:which_key_map_overview = {}
let g:which_key_map_overview.name = "\u002b\u5e38\u7528\u5feb\u6377\u952e"

let g:which_key_map_overview.f = {}
let g:which_key_map_overview.f.name = "\u002b\u529f\u80fd\u952e"
let g:which_key_map_overview.f.a = ['<Nop>', "F1 \u4fdd\u5b58\u5e76\u5207\u56de\u4e0a\u4e00\u4e2a\u7f13\u51b2\u533a"]
let g:which_key_map_overview.f.b = ['<Nop>', "F2 \u4fdd\u5b58\u5e76\u5207\u5230\u524d\u4e00\u4e2a\u7f13\u51b2\u533a"]
let g:which_key_map_overview.f.c = ['<Nop>', "F3 \u4fdd\u5b58\u5e76\u5207\u5230\u4e0b\u4e00\u4e2a\u7f13\u51b2\u533a"]
let g:which_key_map_overview.f.d = ['<Nop>', "F4 \u4fdd\u5b58\u6240\u6709\u6587\u4ef6"]
let g:which_key_map_overview.f.e = ['<Nop>', "F5 \u6784\u5efa\u5e76\u8fd0\u884c\u9879\u76ee"]
let g:which_key_map_overview.f.f = ['<Nop>', "F6 \u53ea\u6784\u5efa\u9879\u76ee"]
let g:which_key_map_overview.f.g = ['<Nop>', "F7 \u6784\u5efa\u5e76\u8fd0\u884c\u5f53\u524d\u6587\u4ef6"]
let g:which_key_map_overview.f.h = ['<Nop>', "Shift-F5 \u505c\u6b62\u5f02\u6b65\u4efb\u52a1"]
let g:which_key_map_overview.f.i = ['<Nop>', "Shift-F6 \u914d\u7f6e\u9879\u76ee"]

let g:which_key_map_overview.g = {}
let g:which_key_map_overview.g.name = "\u002b\u4ee3\u7801\u8df3\u8f6c / LSP"
let g:which_key_map_overview.g.d = ['<Nop>', "gd \u8df3\u5230\u5b9a\u4e49"]
let g:which_key_map_overview.g.D = ['<Nop>', "gD \u8df3\u5230\u5b9e\u73b0"]
let g:which_key_map_overview.g.y = ['<Nop>', "gy \u8df3\u5230\u7c7b\u578b\u5b9a\u4e49"]
let g:which_key_map_overview.g.Y = ['<Nop>', "gY \u8df3\u5230\u58f0\u660e"]
let g:which_key_map_overview.g.r = ['<Nop>', "gr \u67e5\u770b\u5f15\u7528"]
let g:which_key_map_overview.g.R = ['<Nop>', "gR \u91cd\u547d\u540d\u7b26\u53f7"]
let g:which_key_map_overview.g.i = ['<Nop>', "gi \u67e5\u770b\u6587\u6863"]
let g:which_key_map_overview.g.q = ['<Nop>', "gq \u683c\u5f0f\u5316"]
let g:which_key_map_overview.g.a = ['<Nop>', "ga \u4ee3\u7801\u52a8\u4f5c"]
let g:which_key_map_overview.g.c = ['<Nop>', "gac \u5f53\u524d\u7f13\u51b2\u533a\u4ee3\u7801\u52a8\u4f5c"]
let g:which_key_map_overview.g.l = ['<Nop>', "gl* \u8bca\u65ad\u4e0e\u5217\u8868\u547d\u4ee4"]

let g:which_key_map_overview.e = {}
let g:which_key_map_overview.e.name = "\u002b\u7f16\u8f91"
let g:which_key_map_overview.e.q = ['<Nop>', "\u4fdd\u5b58\u5e76\u5173\u95ed\u5f53\u524d\u7a97\u53e3"]
let g:which_key_map_overview.e.Q = ['<Nop>', "\u5f55\u5236\u5b8f"]
let g:which_key_map_overview.e.b = ['<Nop>', "Ctrl-q \u5173\u95ed\u5f53\u524d\u7f13\u51b2\u533a"]
let g:which_key_map_overview.e.H = ['<Nop>', "\u8df3\u5230\u884c\u9996"]
let g:which_key_map_overview.e.L = ['<Nop>', "\u8df3\u5230\u884c\u5c3e"]
let g:which_key_map_overview.e.J = ['<Nop>', "\u5411\u4e0b\u79fb\u52a8 5 \u884c"]
let g:which_key_map_overview.e.K = ['<Nop>', "\u5411\u4e0a\u79fb\u52a8 5 \u884c"]
let g:which_key_map_overview.e.U = ['<Nop>', "\u91cd\u505a"]
let g:which_key_map_overview.e.t = ['<Nop>', "EasyMotion \u5b57\u7b26\u8df3\u8f6c"]
let g:which_key_map_overview.e.T = ['<Nop>', "EasyMotion \u5355\u8bcd\u8df3\u8f6c"]
let g:which_key_map_overview.e.u = ['<Nop>', "PageUp \u5411\u4e0a\u7ffb\u534a\u9875"]
let g:which_key_map_overview.e.d = ['<Nop>', "PageDown \u5411\u4e0b\u7ffb\u534a\u9875"]

let g:which_key_map_overview.i = {}
let g:which_key_map_overview.i.name = "\u002b\u63d2\u5165 / \u7ec8\u7aef"
let g:which_key_map_overview.i.kj = ['<Nop>', "\u9000\u51fa\u63d2\u5165\u6a21\u5f0f"]
let g:which_key_map_overview.i.jk = ['<Nop>', "\u9000\u51fa\u63d2\u5165\u6a21\u5f0f"]
let g:which_key_map_overview.i.JK = ['<Nop>', "\u9000\u51fa\u63d2\u5165\u6a21\u5f0f"]
let g:which_key_map_overview.i.KJ = ['<Nop>', "\u9000\u51fa\u63d2\u5165\u6a21\u5f0f"]
let g:which_key_map_overview.i.t = ['<Nop>', "Tab \u786e\u8ba4\u8865\u5168\u6216\u63d2\u5165 Tab"]
let g:which_key_map_overview.i.r = ['<Nop>', "Enter \u786e\u8ba4\u8865\u5168\u6216\u56de\u8f66\u6362\u884c"]
let g:which_key_map_overview.i.e = ['<Nop>', "Esc \u7ec8\u7aef\u6a21\u5f0f\u9000\u56de\u666e\u901a\u6a21\u5f0f"]
let g:which_key_map_overview.i.p = ['<Nop>', "Ctrl-t \u6253\u5f00 PowerShell \u7ec8\u7aef"]

let g:which_key_map_overview.c = {}
let g:which_key_map_overview.c.name = "\u002b\u526a\u8d34\u677f / Windows \u98ce\u683c"
let g:which_key_map_overview.c.y = ['<Nop>', "\u590d\u5236\u5230\u7cfb\u7edf\u526a\u8d34\u677f"]
let g:which_key_map_overview.c.yy = ['<Nop>', "\u590d\u5236\u5f53\u524d\u884c\u5230\u7cfb\u7edf\u526a\u8d34\u677f"]
let g:which_key_map_overview.c.Y = ['<Nop>', "\u590d\u5236\u5230\u884c\u5c3e\u5230\u7cfb\u7edf\u526a\u8d34\u677f"]
let g:which_key_map_overview.c.a = ['<Nop>', "Ctrl-a \u5168\u9009"]
let g:which_key_map_overview.c.s = ['<Nop>', "Ctrl-s \u4fdd\u5b58\u6587\u4ef6"]
let g:which_key_map_overview.c.z = ['<Nop>', "Ctrl-z \u64a4\u9500"]
let g:which_key_map_overview.c.c = ['<Nop>', "Ctrl-c \u590d\u5236\u9009\u4e2d\u5185\u5bb9"]
let g:which_key_map_overview.c.v = ['<Nop>', "Ctrl-v \u7c98\u8d34\u6216\u66ff\u6362\u9009\u533a"]
let g:which_key_map_overview.c.x = ['<Nop>', "Ctrl-x \u526a\u5207 / \u5220\u9664"]

let g:which_key_map_overview.w = {}
let g:which_key_map_overview.w.name = "\u002b\u7a97\u53e3\u64cd\u4f5c"
let g:which_key_map_overview.w.h = ['<Nop>', "\u5207\u5230\u5de6\u4fa7\u7a97\u53e3"]
let g:which_key_map_overview.w.j = ['<Nop>', "\u5207\u5230\u4e0b\u65b9\u7a97\u53e3"]
let g:which_key_map_overview.w.k = ['<Nop>', "\u5207\u5230\u4e0a\u65b9\u7a97\u53e3"]
let g:which_key_map_overview.w.l = ['<Nop>', "\u5207\u5230\u53f3\u4fa7\u7a97\u53e3"]
let g:which_key_map_overview.w.H = ['<Nop>', "\u628a\u7a97\u53e3\u79fb\u5230\u6700\u5de6"]
let g:which_key_map_overview.w.J = ['<Nop>', "\u628a\u7a97\u53e3\u79fb\u5230\u6700\u4e0b"]
let g:which_key_map_overview.w.K = ['<Nop>', "\u628a\u7a97\u53e3\u79fb\u5230\u6700\u4e0a"]
let g:which_key_map_overview.w.L = ['<Nop>', "\u628a\u7a97\u53e3\u79fb\u5230\u6700\u53f3"]
let g:which_key_map_overview.w.v = ['<Nop>', "\u7eb5\u5411\u5206\u5c4f"]
let g:which_key_map_overview.w.s = ['<Nop>', "\u6a2a\u5411\u5206\u5c4f"]
let g:which_key_map_overview.w.e = ['<Nop>', "\u5747\u5206\u7a97\u53e3 (z=)"]
let g:which_key_map_overview.w.n = ['<Nop>', "\u51cf\u5c0f\u7a97\u53e3\u9ad8\u5ea6 (z-)"]
let g:which_key_map_overview.w.m = ['<Nop>', "\u589e\u5927\u7a97\u53e3\u9ad8\u5ea6 (z+)"]
let g:which_key_map_overview.w.x = ['<Nop>', "\u4ea4\u6362\u7a97\u53e3"]
let g:which_key_map_overview.w.o = ['<Nop>', "\u53ea\u4fdd\u7559\u5f53\u524d\u7a97\u53e3"]
let g:which_key_map_overview.w.q = ['<Nop>', "\u5173\u95ed\u5f53\u524d\u7f13\u51b2\u533a"]
let g:which_key_map_overview.w.t = ['<Nop>', "\u5207\u6362\u9879\u76ee\u6587\u4ef6\u6811 (zt)"]
let g:which_key_map_overview.w.p = ['<Nop>', "\u5207\u6362 quickfix \u7a97\u53e3 (zp)"]

let g:which_key_map_overview.n = {}
let g:which_key_map_overview.n.name = "\u002bNERDTree"
let g:which_key_map_overview.n.t = ['<Nop>', "\u6253\u5f00\u6216\u5173\u95ed\u6587\u4ef6\u6811 (zt)"]
let g:which_key_map_overview.n.a = ['<Nop>', "m \u540e a \u65b0\u5efa\u6587\u4ef6\u6216\u76ee\u5f55"]
let g:which_key_map_overview.n.d = ['<Nop>', "m \u540e d \u5220\u9664\u5f53\u524d\u6587\u4ef6\u6216\u76ee\u5f55"]
let g:which_key_map_overview.n.r = ['<Nop>', "r \u5237\u65b0\u5f53\u524d\u76ee\u5f55"]
let g:which_key_map_overview.n.R = ['<Nop>', "R \u5237\u65b0\u6574\u4e2a\u6587\u4ef6\u6811"]
let g:which_key_map_overview.n.i = ['<Nop>', "I \u5207\u6362\u9690\u85cf\u6587\u4ef6\u663e\u793a"]
let g:which_key_map_overview.n.q = ['<Nop>', "q \u5173\u95ed NERDTree"]
let g:which_key_map_overview.n.h = ['<Nop>', "? \u663e\u793a\u6216\u9690\u85cf\u5e2e\u52a9"]

if exists(':WhichKey') == 2
    call which_key#register(',', 'g:which_key_map_comma')
endif

nnoremap <silent> , :<C-u>WhichKey ','<CR>

augroup which_key_style
    autocmd!
    autocmd FileType which_key hi link WhichKey Floating
    autocmd FileType which_key hi link WhichKeySeperator Comment
    autocmd FileType which_key hi link WhichKeyGroup Keyword
    autocmd FileType which_key hi link WhichKeyDesc Identifier
    autocmd FileType which_key hi link WhichKeyFloating Pmenu
    autocmd FileType which_key hi link WhichKeyTrigger PmenuSel
    autocmd FileType which_key hi link WhichKeyName Title
augroup end

function! s:ShowKeyOverview() abort
    if exists(':WhichKey') == 2
        execute 'WhichKey! g:which_key_map_overview'
    else
        echohl WarningMsg
        echom 'WhichKey is unavailable. Run :PlugInstall first.'
        echohl None
    endif
endfunction

" my custom theme settings, you may change it:
"if has('gui_running')
    "set guicursor=n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20
    "set guifont="Source Code Pro Medium 20"
"endif
set bg=dark
set lines=30
set columns=120
set guioptions-=T
set backspace=indent,eol,start
if has('gui_running')
    set guifont=DejaVuSansM\ Nerd\ Font\ Mono:h12
endif
set clipboard=unnamedplus

nnoremap y "+y
vnoremap y "+y
nnoremap Y "+Y
vnoremap Y "+Y
nnoremap yy "+yy
vnoremap yy "+yy
nnoremap J 5j
vnoremap J 5j
nnoremap K 5k
vnoremap K 5k
nnoremap U <C-r>
vnoremap U <C-r>
nnoremap gs :%s//
nnoremap zh <C-w>h
nnoremap zj <C-w>j
nnoremap zk <C-w>k
nnoremap zl <C-w>l
nnoremap zH <C-w>H
nnoremap zJ <C-w>J
nnoremap zK <C-w>K
nnoremap zL <C-w>L
nnoremap zv <C-w>v
nnoremap zs <C-w>s
nnoremap z= <C-w>=
nnoremap z- <C-w>-
nnoremap z+ <C-w>+
nnoremap zx <C-w>x
nnoremap zo :only<CR>
nnoremap zq :bd!<CR>

" C-o go back to normal mode and do a command
inoremap <C-BS> <C-o>db
inoremap <C-CR> <C-o>o
"inoremap <S-CR> <C-o>O
inoremap JK <Esc>
inoremap KJ <Esc>

" C-z undo
inoremap <C-a> <Esc>ggVG
inoremap <C-c> <Esc>"+yya
inoremap <C-v> <Esc>lPa
inoremap <C-x> <Esc>ddi
inoremap <C-z> <Esc>ui
inoremap <C-r> <Esc><C-r>i
inoremap <C-s> <Esc>:w<CR>
vnoremap <C-c> "+y
vnoremap <C-v> "_dP
vnoremap <C-x> d
nnoremap <C-a> ggVG
nnoremap <C-z> u

" powershell
function! s:OpenPowershell(fullscreen) abort
    if has('win32') || has('win64')
        execute 'terminal ' . s:powershell_shell_cmd
    else
        execute 'terminal'
    endif
    call s:BindTerminalCloseKey()
    if a:fullscreen
        only
    else
        call feedkeys("\<C-w>L")
    endif
endfunction

function! s:ToggleProjectView() abort
    if exists(':NERDTreeToggle') != 2
        echohl WarningMsg
        echom 'NERDTree is unavailable. Run :PlugInstall first.'
        echohl None
        return
    endif

    wall
    execute 'NERDTreeToggle'
    if exists(':Vista!!') == 2
        wincmd l
        execute 'Vista!!'
        wincmd h
    endif
endfunction

function! s:ToggleQuickfix() abort
    wall
    if exists(':QFix') == 2
        execute 'QFix'
    else
        cwindow
    endif
endfunction

function! s:RunAsyncTask(name) abort
    if exists(':AsyncTask') == 2
        execute 'AsyncTask ' . a:name
    else
        echohl WarningMsg
        echom 'AsyncTask is unavailable. Run :PlugInstall first.'
        echohl None
    endif
endfunction

function! s:RunAsyncTasks(...) abort
    if exists(':AsyncTask') == 2
        execute 'AsyncTasks ' . join(a:000, ' ')
    else
        echohl WarningMsg
        echom 'AsyncTasks is unavailable. Run :PlugInstall first.'
        echohl None
    endif
endfunction

nnoremap <C-t> :call <SID>OpenPowershell(0)<CR>

" auto chage working directory
autocmd BufEnter * silent! lcd %:p:h

if has('win32') || has('win64')
    let &shell = exepath('powershell')
    let &shellcmdflag = '-NoLogo -NoProfile -ExecutionPolicy Bypass -Command'
    let &shellquote = ''
    let &shellxquote = '"'
    let &shellpipe = '2>&1 | Out-File -Encoding utf8'
    let &shellredir = '2>&1 | Out-File -Encoding utf8'
    if exists('&makeencoding')
        set makeencoding=utf-8
    endif

    set undodir=$HOME/AppData/Local/Temp
    set backupdir=$HOME/AppData/Local/Temp
    set directory=$HOME/AppData/Local/Temp
endif

silent! set termguicolors
silent! colorscheme gruvbox
"colorscheme industry
hi LineNrAbove guifg=#cc6666 ctermfg=red
hi LineNrBelow guifg=#66cc66 ctermfg=green
hi FloatermNC guifg=gray

if filereadable(".vim_localrc")
        source .vim_localrc
endif
