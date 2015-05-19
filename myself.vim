function! s:PreviewMarkdown()
    if !executable('pandoc')
        echohl ErrorMsg | echo 'Please install pandoc first.' | echohl None
        return
    endif
    if s:isWin
        let BROWSER_COMMAND = 'cmd.exe /c start ""'
    elseif s:isLinux
        let BROWSER_COMMAND = 'xdg-open'
    elseif s:isMac
        let BROWSER_COMMAND = 'open'
    endif
    let output_file = tempname() . '.html'
    let input_file = tempname() . '.md'
    let css_file = 'file://' . expand($HOME . '/.vimdb/pandoc/github.css', 1)
    " Convert buffer to UTF-8 before running pandoc
    let original_encoding = &fileencoding
    let original_bomb = &bomb
    silent! execute 'set fileencoding=utf-8 nobomb'
    " Generate html file for preview
    let content = getline(1, '$')
    let newContent = []
    for line in content
        let str = matchstr(line, '\(!\[.*\](\)\@<=.\+\.\%(png\|jpe\=g\|gif\)')
        if str != "" && match(str, '^https\=:\/\/') == -1
            let newLine = substitute(line, '\(!\[.*\]\)(' . str . ')',
                        \'\1(file://' . escape(expand("%:p:h", 1), '\') .
                        \(s:isWin ? '\\\\' : '/') .
                        \escape(expand(str, 1), '\') . ')', 'g')
        else
            let newLine = line
        endif
        call add(newContent, newLine)
    endfor
    call writefile(newContent, input_file)
    silent! execute '!pandoc -f markdown -t html5 -s -S -c "' . css_file . '" -o "' . output_file .'" "' . input_file . '"'
    call delete(input_file)
    " Change encoding back
    silent! execute 'set fileencoding=' . original_encoding . ' ' . original_bomb
    " Preview
    silent! execute '!' . BROWSER_COMMAND . ' "' . output_file . '"'
    execute input('Press ENTER to continue...')
    echo
    call delete(output_file)
endfunction

nnoremap <silent> <LocalLeader>p :call <SID>PreviewMarkdown()<CR>
