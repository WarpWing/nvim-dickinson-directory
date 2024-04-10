function! dickinson_directory#search_by_name(name)
    let [first_name, last_name] = split(a:name, ' ', 1)
    lua require('dickinson_directory').search_by_name(vim.fn.shellescape(first_name), vim.fn.shellescape(last_name))
endfunction

function! dickinson_directory#search_by_email(email)
    lua require('dickinson_directory').search_by_email(vim.fn.shellescape(a:email))
endfunction

function! dickinson_directory#search_by_department(department)
    lua require('dickinson_directory').search_by_department(vim.fn.shellescape(a:department))
endfunction