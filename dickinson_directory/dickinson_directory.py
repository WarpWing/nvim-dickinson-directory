import os
import requests
import sys
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.firefox.options import Options
from selenium.common.exceptions import NoSuchElementException
from selenium.webdriver.firefox.service import Service
from webdriver_manager.firefox import GeckoDriverManager
from typing_extensions import *


# Configure Firefox options
options = Options()
options.add_argument("-headless")  
options.add_argument("-disable-gpu") 
options.add_argument("-no-sandbox")  # Bypass OS security model
options.add_argument("-disable-dev-shm-usage")  # Overcome limited resource problems
options.log.level = "fatal"  # Suppress logging messages

# Use webdriver_manager to automatically manage Firefox (disabled logging to suppress warnings by piping to devnull)
service = Service(GeckoDriverManager().install(),log_path=os.devnull)
driver = webdriver.Firefox(service=service, options=options)

def find_record(first_name=None, last_name=None, email=None, department=None):
    f = requests.get('https://www2.dickinson.edu/lis/angularJS_services/directory_open/data.cfc?method=f_getAllPeople').json()
    matching_records = []
    for record in f:
        if email:
            email_domain = email.split('@')[-1] if '@' in email else ''
            if record['EMAIL'] == email.split('@')[0] and email_domain == 'dickinson.edu':
                matching_records.append(record)
        elif first_name and last_name:
            if record['FIRSTNAME'].lower() == first_name.lower() and record['LASTNAME'].lower() == last_name.lower():
                matching_records.append(record)
        elif department:
            department_lower = department.lower()
            if department_lower in record['DEPT1'].lower() or department_lower in record['DEPT2'].lower():
                matching_records.append(record)
    return matching_records


def return_classes(email):
    driver.get(f"https://www.dickinson.edu/site/custom_scripts/dc_faculty_profile_index.php?fac={email}")

    # Extract Education Details
    education_details = []
    try:
        education_section = driver.find_element(By.XPATH, "//h3[contains(text(), 'Education')]/following-sibling::ul")
        for item in education_section.find_elements(By.TAG_NAME, "li"):
            education_details.append(item.text)
    except NoSuchElementException:
        print("No Education section found.")

    # Click on the 'Course Info' tab
    try:
        course_info_tab = driver.find_element(By.XPATH, "//a[@href='#courses']")
        course_info_tab.click()
    except NoSuchElementException:
        print("Course Info tab not found.")

    # Function to extract course names
    def extract_courses(xpath):
        course_elements = driver.find_elements(By.XPATH, xpath)
        unique_courses = set()
        for course in course_elements:
            course_name = course.text.split('\n')[0]
            unique_courses.add(course_name)
        return sorted(list(unique_courses), key=lambda x: int(x.split(' ')[1]))

    # Extract Course Names for Fall and Spring
    fall_courses = extract_courses('//h3[contains(text(), "Fall")]/following-sibling::p')
    spring_courses = extract_courses('//h3[contains(text(), "Spring")]/following-sibling::p')
    driver.quit()

    return education_details, fall_courses, spring_courses

def print_records(records):
    for result in records:
        print("Name:", f"{result['FIRSTNAME']} {result['LASTNAME']}")
        
        if result['STATUS'] == 'STU' and result['TITLE']:
            print("Role:", result['TITLE'])
        else:
            # Convert STATUS codes to full words
            status_full = {"STU": "Student", "FAC": "Faculty", "STA": "Staff"}
            status_word = status_full.get(result['STATUS'], "Unknown")
            print("Status:", status_word)

        if result['STATUS'] == 'STU':
            print("Graduating Class:", result['CLASS'])
            print("ID:", result['ID'])
        
        if result['STATUS'] == 'FAC':
            if result['TITLE']:
                print("Title:", result['TITLE'])
            if result['DEPT1']:
                print("Department:", result['DEPT1'])
            if result['BUILDING']:
                print("Building:", result['BUILDING'])
            if result['ROOM']:
                print("Room:", result['ROOM'])
            education, fall_courses, spring_courses = return_classes(result['EMAIL'])
            print("Education:")
            for item in education:
                print("- " + item)
            print("Fall Courses:")
            for course in fall_courses:
                print("- " + course)
            print("Spring Courses:")
            for course in spring_courses:
                print("- " + course)
            driver.quit()
        
        elif result['STATUS'] == 'STA':
            if result['TITLE']:
                print("Title:", result['TITLE'])
            if result['DEPT1']:
                print("Department:", result['DEPT1'])
            if result['BUILDING']:
                print("Building:", result['BUILDING'])
        
        if result['PHONE']:
            print("Phone Number:", result['PHONE'])
        print("Email:", f"{result['EMAIL']}@dickinson.edu")
        print("---")


