if exists('g:loaded_dickinson_directory') | finish | endif
let g:loaded_dickinson_directory = 1

command! -nargs=1 DickinsonDirectorySearchName call dickinson_directory#search_by_name(<q-args>)
command! -nargs=1 DickinsonDirectorySearchEmail call dickinson_directory#search_by_email(<q-args>)
command! -nargs=1 DickinsonDirectorySearchDepartment call dickinson_directory#search_by_department(<q-args>)