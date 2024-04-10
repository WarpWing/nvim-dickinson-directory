local crawler = require('dickinson_directory.crawler')

local M = {}

function M.search_by_name(first_name, last_name)
    local records = crawler.find_record(first_name, last_name, nil, nil)
    crawler.print_records(records)
end

function M.search_by_email(email)
    local records = crawler.find_record(nil, nil, email, nil)
    crawler.print_records(records)
end

function M.search_by_department(department)
    local records = crawler.find_record(nil, nil, nil, department)
    crawler.print_records(records)
end

return M