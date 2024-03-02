let g:translateprg=$HOME."/.vim/plugged/vim-translate/translate/translate"

function! Translate(is_selection, ...) range
    if a:0 == 0
        echohl ErrorMsg | echomsg "No target language specified" | echohl None
        return
    endif

    let l:cmd = g:translateprg." -t ".a:1

    if a:0 == 2
        let l:cmd = l:cmd." -s ".a:2
    endif

    let l:content = a:is_selection
        \? join(getline(a:firstline, a:lastline), "\n")
        \: join(getline(1, "$"), "\n")

    let l:cmd = l:cmd." ".shellescape(l:content)
    echo "Processing please wait ..."
    let l:output = system(l:cmd)
    redraw | echo ""

    if v:shell_error
        echohl ErrorMsg | echomsg l:output | echohl None
        return
    endif

    if a:is_selection
        call setline(a:firstline, split(l:output, "\n"))
    else
        call setline(1, split(l:output, "\n"))
    endif
endfunction

command! -range -nargs=* Translate <line1>,<line2>call Translate(<range>, <f-args>)
