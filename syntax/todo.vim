" File:        todo.txt.vim
" Description: Todo.txt syntax settings
" Author:      Leandro Freitas <freitass@gmail.com>
" License:     Vim license
" Website:     http://github.com/freitass/todo.txt-vim
" Version:     0.3

if exists("b:current_syntax")
  finish
endif

function! Convert_to_char_class(cur) 
    if a:cur =~ '[2-9]'
        return '[0-' . (a:cur-1) . ']'
    endif
    return '0'
endfunction

function! Match_number_before(num)
    let branches = []
    let init = ''
    for i in range(len(a:num))
        if a:num[i] =~ '[1-9]'
            call add(branches, init . Convert_to_char_class(a:num[i]) . repeat('\d', len(a:num) - i - 1))
        endif 
        let init .= a:num[i]
    endfor
    return '\%(' . join(branches, '\|') .'\)'
endfunction

function! Match_date_before(date)
    if a:date !~ '\v\d{4}-\d{2}-\d{2}'
        echo "invalid date"
        return
    endif

    let branches =[]

    let parts = split(a:date, '-')
    call add(branches, Match_number_before(parts[0]) . '-\d\{2}-\d\{2}')
    call add(branches, parts[0] . '-' . Match_number_before(parts[1]) . '-\d\{2}')
    call add(branches, parts[0] . '-' . parts[1] . '-' .Match_number_before(parts[2]))

    return '\%(' . join(branches, '\|') .'\)'
endfunction

function! Convert_to_char_class_after(cur) 
    if a:cur =~ '[0-7]'
        return '[' . (a:cur+1) . '-9]'
    endif
    return '9'
endfunction

function! Match_number_after(num)
    let branches = []
    let init = ''
    for i in range(len(a:num))
        if a:num[i] =~ '[0-8]'
            call add(branches, init . Convert_to_char_class_after(a:num[i]) . repeat('\d', len(a:num) - i - 1))
        endif 
        let init .= a:num[i]
    endfor
    return '\%(' . join(branches, '\|') .'\)'
endfunction

function! Match_date_after(date)
    if a:date !~ '\v\d{4}-\d{2}-\d{2}'
        echo "invalid date"
        return
    endif

    let branches =[]

    let parts = split(a:date, '-')
    call add(branches, Match_number_after(parts[0]) . '-\d\{2}-\d\{2}')
    call add(branches, parts[0] . '-' . Match_number_after(parts[1]) . '-\d\{2}')
    call add(branches, parts[0] . '-' . parts[1] . '-' .Match_number_after(parts[2]))

    return '\%(' . join(branches, '\|') .'\)'
endfunction

syntax match TodoDone      '^[xX]\s.\+$'
syntax match TodoPriorityA '^([aA])\s.\+'    contains=TodoDate,TodoProject,TodoContext,TodoOverDueDate,TodoDateIndicator
syntax match TodoPriorityB '^([bB])\s.\+'    contains=TodoDate,TodoProject,TodoContext,TodoOverDueDate,TodoDateIndicator
syntax match TodoPriorityC '^([cC])\s.\+'    contains=TodoDate,TodoProject,TodoContext,TodoOverDueDate,TodoDateIndicator
syntax match TodoPriorityD '^([dD])\s.\+'    contains=TodoDate,TodoProject,TodoContext,TodoOverDueDate,TodoDateIndicator
syntax match TodoPriorityE '^([eE])\s.\+'    contains=TodoDate,TodoProject,TodoContext,TodoOverDueDate,TodoDateIndicator
syntax match TodoPriorityF '^([fF])\s.\+'    contains=TodoDate,TodoProject,TodoContext,TodoOverDueDate,TodoDateIndicator
syntax match TodoPriorityG '^([gG])\s.\+'    contains=TodoDate,TodoProject,TodoContext,TodoOverDueDate,TodoDateIndicator
syntax match TodoPriorityH '^([hH])\s.\+'    contains=TodoDate,TodoProject,TodoContext,TodoOverDueDate,TodoDateIndicator
syntax match TodoPriorityI '^([iI])\s.\+'    contains=TodoDate,TodoProject,TodoContext,TodoOverDueDate,TodoDateIndicator
syntax match TodoPriorityJ '^([jJ])\s.\+'    contains=TodoDate,TodoProject,TodoContext,TodoOverDueDate,TodoDateIndicator
syntax match TodoPriorityK '^([kK])\s.\+'    contains=TodoDate,TodoProject,TodoContext,TodoOverDueDate,TodoDateIndicator
syntax match TodoPriorityL '^([lL])\s.\+'    contains=TodoDate,TodoProject,TodoContext,TodoOverDueDate,TodoDateIndicator
syntax match TodoPriorityM '^([mM])\s.\+'    contains=TodoDate,TodoProject,TodoContext,TodoOverDueDate,TodoDateIndicator
syntax match TodoPriorityN '^([nN])\s.\+'    contains=TodoDate,TodoProject,TodoContext,TodoOverDueDate,TodoDateIndicator
syntax match TodoPriorityO '^([oO])\s.\+'    contains=TodoDate,TodoProject,TodoContext,TodoOverDueDate,TodoDateIndicator
syntax match TodoPriorityP '^([pP])\s.\+'    contains=TodoDate,TodoProject,TodoContext,TodoOverDueDate,TodoDateIndicator
syntax match TodoPriorityQ '^([qQ])\s.\+'    contains=TodoDate,TodoProject,TodoContext,TodoOverDueDate,TodoDateIndicator
syntax match TodoPriorityR '^([rR])\s.\+'    contains=TodoDate,TodoProject,TodoContext,TodoOverDueDate,TodoDateIndicator
syntax match TodoPriorityS '^([sS])\s.\+'    contains=TodoDate,TodoProject,TodoContext,TodoOverDueDate,TodoDateIndicator
syntax match TodoPriorityT '^([tT])\s.\+'    contains=TodoDate,TodoProject,TodoContext,TodoOverDueDate,TodoDateIndicator
syntax match TodoPriorityU '^([uU])\s.\+'    contains=TodoDate,TodoProject,TodoContext,TodoOverDueDate,TodoDateIndicator
syntax match TodoPriorityV '^([vV])\s.\+'    contains=TodoDate,TodoProject,TodoContext,TodoOverDueDate,TodoDateIndicator
syntax match TodoPriorityW '^([wW])\s.\+'    contains=TodoDate,TodoProject,TodoContext,TodoOverDueDate,TodoDateIndicator
syntax match TodoPriorityX '^([xX])\s.\+'    contains=TodoDate,TodoProject,TodoContext,TodoOverDueDate,TodoDateIndicator
syntax match TodoPriorityY '^([yY])\s.\+'    contains=TodoDate,TodoProject,TodoContext,TodoOverDueDate,TodoDateIndicator
syntax match TodoPriorityZ '^([zZ])\s.\+'    contains=TodoDate,TodoProject,TodoContext,TodoOverDueDate,TodoDateIndicator

syntax match TodoProject       '\(^\|\W\)+[^[:blank:]]\+' contains=NONE
syntax match TodoContext       '\(^\|\W\)@[^[:blank:]]\+' contains=NONE
syntax match TodoDateIndicator 'due: '                    contains=NONE

let today=strftime("%F")
let regex_before_today='^.*' . Match_date_before(today) . '.*$'
let regex_after_today=Match_date_after(today)

execute "syntax match TodoDate /"        . regex_after_today  . "/ contains=NONE"
execute "syntax match TodoOverdueDate /" . regex_before_today . "/ contains=NONE"

" Other priority colours might be defined by the user
highlight default link TodoDone          Comment
highlight default link TodoPriorityA     Todo
highlight default link TodoPriorityB     Underlined
highlight default link TodoPriorityC     Ignore
highlight default link TodoDate          Constant
highlight default link TodoOverdueDate   Error
highlight default link TodoProject       Type
highlight default link TodoContext       Identifier
highlight default link TodoDateIndicator Normal

let b:current_syntax = "todo"
