-- I think I got the hang of lua, if I make all of my variables local I should be fineeeeee. Still need to deal with web scraping though... at least it can just do basic names.

local M = {}

local function find_record(first_name, last_name, email, department)
    local response = vim.fn.system(string.format('curl -s "https://www2.dickinson.edu/lis/angularJS_services/directory_open/data.cfc?method=f_getAllPeople"'))
    local data = vim.fn.json_decode(response)
    local matching_records = {}

    for _, record in ipairs(data) do
        if email then
            local email_domain = string.match(email, "@(.+)") or "" --No one in the world likes regex.
            if record.EMAIL == string.match(email, "(.+)@") and email_domain == "dickinson.edu" then
                table.insert(matching_records, record)
            end
        elseif first_name and last_name then
            if string.lower(record.FIRSTNAME) == string.lower(first_name) and string.lower(record.LASTNAME) == string.lower(last_name) then
                table.insert(matching_records, record)
            end
        elseif department then
            local department_lower = string.lower(department)
            if string.find(string.lower(record.DEPT1), department_lower) or string.find(string.lower(record.DEPT2), department_lower) then
                table.insert(matching_records, record)
            end
        end
    end

    return matching_records
end

local function print_records(records)
    for _, result in ipairs(records) do
        print("Name: " .. result.FIRSTNAME .. " " .. result.LASTNAME)

        if result.STATUS == "STU" and result.TITLE then
            print("Role: " .. result.TITLE)
        else
            local status_full = {STU = "Student", FAC = "Faculty", STA = "Staff"}
            local status_word = status_full[result.STATUS] or "Unknown"
            print("Status: " .. status_word)
        end

        if result.STATUS == "STU" then
            print("Graduating Class: " .. result.CLASS)
            print("ID: " .. result.ID)
        end

        if result.STATUS == "FAC" then
            if result.TITLE then
                print("Title: " .. result.TITLE)
            end
            if result.DEPT1 then
                print("Department: " .. result.DEPT1)
            end
            if result.BUILDING then
                print("Building: " .. result.BUILDING)
            end
            if result.ROOM then
                print("Room: " .. result.ROOM)
            end
        elseif result.STATUS == "STA" then
            if result.TITLE then
                print("Title: " .. result.TITLE)
            end
            if result.DEPT1 then
                print("Department: " .. result.DEPT1)
            end
            if result.BUILDING then
                print("Building: " .. result.BUILDING)
            end
        end

        if result.PHONE then
            print("Phone Number: " .. result.PHONE)
        end

        print("Email: " .. result.EMAIL .. "@dickinson.edu")
        print("---")
    end
end

function M.find_record_by_name(name)
    local first_name, last_name = unpack(vim.split(name, " ", {plain = true}))
    local results = find_record(first_name, last_name, nil, nil)
    print_records(results)
end

function M.find_record_by_email(email)
    local results = find_record(nil, nil, email, nil)
    print_records(results)
end

function M.find_record_by_department(department)
    local results = find_record(nil, nil, nil, department)
    print_records(results)
end

return M
