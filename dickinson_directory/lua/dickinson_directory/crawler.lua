local requests = require("requests")

local function find_record(first_name, last_name, email, department)
    local response = requests.get("https://www2.dickinson.edu/lis/angularJS_services/directory_open/data.cfc?method=f_getAllPeople")
    local data = response.json()
    local matching_records = {}

    for _, record in ipairs(data) do
        if email then
            local email_domain = string.match(email, "@(.+)") or ""
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

local function return_classes(email)
    local url = string.format("https://www.dickinson.edu/site/custom_scripts/dc_faculty_profile_index.php?fac=%s", email)
    local response = requests.get(url)
    local html = response.text

    local education_details = {}
    local education_pattern = '<h3>Education</h3>.-<ul>(.-)</ul>'
    local education_match = string.match(html, education_pattern)
    if education_match then
        for item in string.gmatch(education_match, '<li>(.-)</li>') do
            table.insert(education_details, item)
        end
    else
        print("No Education section found.")
    end

    local fall_courses = {}
    local spring_courses = {}
    local courses_pattern = '<a name="courses"></a>.-<h3>Fall</h3>(.-)<h3>Spring</h3>(.-)</div>'
    local courses_match = string.match(html, courses_pattern)
    if courses_match then
        local fall_match, spring_match = string.match(courses_match, '(.-)<h3>Spring</h3>(.*)')
        for course in string.gmatch(fall_match, '<p>(.-)</p>') do
            table.insert(fall_courses, course)
        end
        for course in string.gmatch(spring_match, '<p>(.-)</p>') do
            table.insert(spring_courses, course)
        end
    else
        print("No Course Info found.")
    end

    return education_details, fall_courses, spring_courses
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
            local education, fall_courses, spring_courses = return_classes(result.EMAIL)
            print("Education:")
            for _, item in ipairs(education) do
                print("- " .. item)
            end
            print("Fall Courses:")
            for _, course in ipairs(fall_courses) do
                print("- " .. course)
            end
            print("Spring Courses:")
            for _, course in ipairs(spring_courses) do
                print("- " .. course)
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

return {
    find_record = find_record,
    return_classes = return_classes,
    print_records = print_records
}

