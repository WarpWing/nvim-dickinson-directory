function! dickinson_directory#search_by_name(name)
    let command = "dickdir -name '" . a:name . "'"
    let output = system(command)
    echo output
endfunction

function! dickinson_directory#search_by_email(email)
    let command = "dickdir -email '" . a:email . "'"
    let output = system(command)
    echo output
endfunction

function! dickinson_directory#search_by_department(department)
    let command = "dickdir -dep '" . a:department . "'"
    let output = system(command)
    echo output
endfunction