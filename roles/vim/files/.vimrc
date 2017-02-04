" contents of minimal .vimrc
execute pathogen#infect()
syntax on
filetype plugin indent on
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
set listchars=tab:→\ ,trail:·
set modeline

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
map <silent> <F3> :NERDTreeToggle<CR>
map <silent> <F4> :set invnumber<CR>
map <silent> <F6> :SyntasticToggleMode<CR>
map <silent> <F8> :set list!<CR>
if has("gui_running")
  if has("gui_gtk2")
    set guifont=Inconsolata\ Medium\ 16
  elseif has("gui_gtk3")
    set guifont=Inconsolata\ Medium\ 16
  elseif has("gui_photon")
    set guifont=Inconsolate\ Medium:s16
  elseif has("gui_kde")
    set guifont=Courier\ New/11/-1/5/50/0/0/0/1/0
  elseif has("x11")
    set guifont=-*-courier-medium-r-normal-*-*-180-*-*-m-*-*
  else
    set guifont=Inconsolata_Medium:h16:cDEFAULT
  endif
endif

" Indent Python in the Google way.
setlocal indentexpr=GetGooglePythonIndent(v:lnum)
let s:maxoff = 50 " maximum number of lines to look backwards.
function GetGooglePythonIndent(lnum)
  " Indent inside parens.
  " Align with the open paren unless it is at the end of the line.
  " E.g.
  "   open_paren_not_at_EOL(100,
  "                         (200,
  "                          300),
  "                         400)
  "   open_paren_at_EOL(
  "       100, 200, 300, 400)
  call cursor(a:lnum, 1)
  let [par_line, par_col] = searchpairpos('(\|{\|\[', '', ')\|}\|\]', 'bW',
        \ "line('.') < " . (a:lnum - s:maxoff) . " ? dummy :"
        \ . " synIDattr(synID(line('.'), col('.'), 1), 'name')"
        \ . " =~ '\\(Comment\\|String\\)$'")
  if par_line > 0
    call cursor(par_line, 1)
    if par_col != col("$") - 1
      return par_col
    endif
  endif
  " Delegate the rest to the original function.
  return GetPythonIndent(a:lnum)
endfunction

let pyindent_nested_paren="&sw*2"
let pyindent_open_paren="&sw*2"

let g:syntastic_python_pylint_rcfile='~/pylintrc' 

let &t_SI .= "\<Esc>[?2004h"
let &t_EI .= "\<Esc>[?2004l"
inoremap <special> <expr> <Esc>[200~ XTermPasteBegin()

function! XTermPasteBegin()
  set pastetoggle=<Esc>[201~
    set paste
      return ""
  endfunction

set tabstop=4 shiftwidth=4 expandtab
