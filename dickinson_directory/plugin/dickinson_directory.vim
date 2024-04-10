if exists('g:loaded_dickinson_directory') | finish | endif
let g:loaded_dickinson_directory = 1

command! -nargs=1 DickDirName call dickinson_directory#find_record_by_name(<q-args>)
command! -nargs=1 DickDirEmail call dickinson_directory#find_record_by_email(<q-args>)
command! -nargs=1 DickDirDept call dickinson_directory#find_record_by_department(<q-args>)
