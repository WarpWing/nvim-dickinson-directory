function! dickinson_directory#find_record_by_name(name)
    let [first_name, last_name] = split(a:name, ' ', 1)
    call s:find_record(first_name, last_name, v:null, v:null)
endfunction

function! dickinson_directory#find_record_by_email(email)
    call s:find_record(v:null, v:null, a:email, v:null)
endfunction

function! dickinson_directory#find_record_by_department(department)
    call s:find_record(v:null, v:null, v:null, a:department)
endfunction

function! s:find_record(first_name, last_name, email, department)
    let cmd = 'python3 -c "import sys; sys.path.append(''.''); from dickinson_directory import find_record, print_records; results = find_record('
    if a:first_name isnot# v:null && a:last_name isnot# v:null
        let cmd .= 'first_name=''' . a:first_name . ''', last_name=''' . a:last_name . ''', '
    else
        let cmd .= 'first_name=None, last_name=None, '
    endif
    if a:email isnot# v:null
        let cmd .= 'email=''' . a:email . ''', '
    else
        let cmd .= 'email=None, '
    endif
    if a:department isnot# v:null
        let cmd .= 'department=''' . a:department . ''''
    else
        let cmd .= 'department=None'
    endif
    let cmd .= '); print_records(results)"'
    let output = system(cmd)
    echo output
endfunction
