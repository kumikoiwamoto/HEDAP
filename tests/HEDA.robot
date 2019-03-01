*** Settings ***

Resource       cumulusci/robotframework/Salesforce.robot
Library        tests/HEDA.py




*** Variables ***
${task1}  Send Email1
${sub_task}    Welcome Email1
${task2}     Make a Phone Call1



*** Keywords ***


API Create And Return Term
    [Arguments]       ${account_id}  &{fields}
    ${term_name} =    Generate Random String
    ${term_id} =      Salesforce Insert  Term__c
    ...                   Name=${term_name}
    ...                   Account__c=${account_id}
    ...                   &{fields}
    &{term} =         Salesforce Get  Term__c  ${term_id}
    [return]          &{term}

API Create And Return Course
    [Arguments]       ${account_id}
    ${course_name} =  Generate Random String
    ${course_id} =    Salesforce Insert  Course__c
    ...                   Name=${course_name}
    ...                   Account__c=${account_id}
    &{course} =       Salesforce Get  Course__c  ${course_id}
    [return]          &{course}

API Create And Return Course Offering
    [Arguments]       ${course_id}  ${term_id}
    ${offering_id} =  Salesforce Insert  Course_Offering__c
    ...                   Course__c=${course_id}
    ...                   Term__c=${term_id}
    &{offering} =     Salesforce Get  Course_Offering__c  ${offering_id}
    [return]          &{offering}

API Create And Return Course Enrollment
    [Arguments]       ${contact_id}  ${offering_id}
    ${rt_id} =        Get Record Type Id  Course_Enrollment__c  Student
    ${enrollment_id} =  Salesforce Insert  Course_Enrollment__c
    ...                   Contact__c=${contact_id}
    ...                   Course_Offering__c=${offering_id}
    ...                   RecordTypeId=${rt_id}
    &{enrollment} =   Salesforce Get  Course_Enrollment__c  ${enrollment_id}
    [return]          &{enrollment}

API Create And Return Department
    [Arguments]       ${record_type}=University_Department
    ${dept_name} =    Generate Random String
    ${rt_id} =        Get Record Type Id  Account  University_Department
    ${dept_id} =      Salesforce Insert  Account
    ...                   Name=${dept_name}
    ...                   RecordTypeId=${rt_id}
    &{department} =   Salesforce Get  Account  ${dept_id}
    [return]          &{department}

API Create And Return Program
    [Arguments]       ${record_type}=Academic_Program
    ${prog_name} =    Generate Random String
    ${rt_id} =        Get Record Type Id  Account  Academic_Program
    ${prog_id} =      Salesforce Insert  Account
    ...                   Name=${prog_name}
    ...                   RecordTypeId=${rt_id}
    &{program} =      Salesforce Get  Account  ${prog_id}
    [return]          &{program}


Create And Return Course Enrollment
    [Arguments]                ${contact_id}  ${offering_name}
    Go To Record Home          ${contact_id}
    Click Related List Button  Course Connections  New
    Select Record Type         Student
    Populate Lookup Field      Course Offering ID  ${offering_name}
    Click Modal Button         Save
    Wait Until Modal Is Closed
    @{records} =               Salesforce Query  Course_Enrollment__c
    ...                            Contact__c=${contact_id}
    ...                            Course_Offering__r.Name=${offering_name}
    &{enrollment} =            Get From List  ${records}  0
    Store Session Record       Course_Enrollment__c  &{enrollment}[Id]
    [return]          &{enrollment}

Create And Return Department
    ${department_name} =  Generate Random String
    Go To Object Home     Account
    Click Object Button   New
    Select Record Type    University Department
    Populate Form         Account Name=${department_name}
    Click Modal Button    Save
    Wait Until Modal Is Closed
    ${department_id} =    Get Current Record Id
    Store Session Record  Account  ${department_id}
    [return]              ${department_id}

Create Program
    ${program_name} =     Generate Random String
    Go To Object Home     Account
    Click Object Button   New
    Select Record Type    Academic Program
    Populate Form         Account Name=${program_name}
    Click Modal Button    Save
    Wait Until Modal is Closed
    ${program_id} =       Get Current Record Id
    Store Session Record  Account  ${program_id}

API Create And Return Contact
    [Arguments]      &{fields}
    ${first_name} =  Generate Random String
    ${last_name} =   Generate Random String
    ${contact_id} =  Salesforce Insert  Contact
    ...                  FirstName=${first_name}
    ...                  LastName=${last_name}
    ...                  &{fields}  
    &{contact} =     Salesforce Get  Contact  ${contact_id}
    [return]         &{contact}
 
API Create And Return Opportunity
    [Arguments]      ${account_id}      &{fields}    
    ${opp_id} =  Salesforce Insert    Opportunity
    ...               AccountId=${account_id}
    ...               StageName=ClosedWon
    ...               CloseDate=2018-09-10
    ...               Amount=100
    ...               Name=Test Donation
    ...               npe01__Do_Not_Automatically_Create_Payment__c=true 
    ...               &{fields}
    &{opportunity} =     Salesforce Get  Opportunity  ${opp_id} 
    [return]         &{opportunity}  
 
API Create Organization Account
    [Arguments]      &{fields}
    ${name} =        Generate Random String
    ${rt_id} =       Get Record Type Id  Account  Organization
    ${account_id} =  Salesforce Insert  Account
    ...                  Name=${name}
    ...                  RecordTypeId=${rt_id}
    ...                  &{fields}
    &{account} =     Salesforce Get  Account  ${account_id}
    [return]         &{account}

API Create Primary Affiliation
    [Arguments]      ${account_id}      ${contact_id}    &{fields}    
    ${opp_id} =  Salesforce Insert    npe5__Affiliation__c
    ...               npe5__Organization__c=${account_id}
    ...               npe5__Contact__c=${contact_id}
    ...               npe5__Primary__c=true 
    ...               &{fields}

API Create Secondary Affiliation
    [Arguments]      ${account_id}      ${contact_id}    &{fields}    
    ${opp_id} =  Salesforce Insert    npe5__Affiliation__c
    ...               npe5__Organization__c=${account_id}
    ...               npe5__Contact__c=${contact_id}
    ...               npe5__Primary__c=false 
    ...               &{fields}
 
# API Create Engagement Plan
    # [Arguments]      ${plan_name}     &{fields}    
    # ${opp_id} =  Salesforce Insert    npsp__Engagement_Plan_Template__c
    # ...               Name=${plan_name}
    # ...               npsp__Description__c=This plan is created via Automation 
    # ...               &{fields}
   
API Create And Return GAU
    ${name} =   Generate Random String
    ${gau_id} =  Salesforce Insert  npsp__General_Accounting_Unit__c
    ...               Name=${name}
    &{gau} =     Salesforce Get  npsp__General_Accounting_Unit__c  ${gau_id}
    [return]         &{gau}  
   
Create And Return Contact
    ${first_name} =           Generate Random String
    ${last_name} =            Generate Random String
    Go To Object Home         Contact
    Click Object Button       New
    Populate Form
    ...                       First Name=${first_name}
    ...                       Last Name=${last_name}
    Click Modal Button        Save    
    Wait Until Modal Is Closed
    ${contact_id} =           Get Current Record Id
    Store Session Record      Contact  ${contact_id}
    [return]                  ${contact_id}
    
Create And Return Contact with Email
    ${first_name} =           Generate Random String
    ${last_name} =            Generate Random String
    Go To Object Home         Contact
    Click Object Button       New
    Populate Form
    ...                       First Name=${first_name}
    ...                       Last Name=${last_name}
    ...                       Work Email= dshattuck@salesforce.com
    Click Modal Button        Save    
    Wait Until Modal Is Closed
    ${contact_id} =           Get Current Record Id
    Store Session Record      Contact  ${contact_id}
    [return]                  ${contact_id}    
    
    
Create And Return Contact with Address
    ${first_name} =           Generate Random String
    ${last_name} =            Generate Random String
    Go To Object Home         Contact
    Click Object Button       New
    Populate Form
    ...                       First Name=${first_name}
    ...                       Last Name=${last_name}
    Click Dropdown            Primary Address Type
    Click Link                link=Work
    Populate Address          Mailing Street            5544 Highland Avenue  
    Populate Address          Mailing City              Pobre Ciudad
    Populate Address          Mailing Zip/Postal Code   84123
    Populate Address          Mailing State/Province    AL
    Populate Address          Mailing Country           USA  
    Click Modal Button        Save    
    Wait Until Modal Is Closed
    
    ${contact_id} =           Get Current Record Id
    Store Session Record      Contact  ${contact_id}
    [return]                  ${contact_id}     


API Populate Create And Return Contact with Address
    [Arguments]      ${first_name}      ${last_name}      ${mailing_street}      ${mailing_city}      ${mailing_zip}      ${mailing_state}      ${mailing_country}
    Go To Object Home         Contact
    Click Object Button       New
    Populate Form
    ...                       First Name=${first_name}
    ...                       Last Name=${last_name}
    Click Dropdown            Primary Address Type
    Click Link                link=Work
    Populate Address          Mailing Street            ${mailing_street}  
    Populate Address          Mailing City              ${mailing_city}
    Populate Address          Mailing Zip/Postal Code   ${mailing_zip}
    Populate Address          Mailing State/Province    ${mailing_state}
    Populate Address          Mailing Country           ${mailing_country}
    Click Modal Button        Save    
    Wait Until Modal Is Closed
    
    ${contact_id} =           Get Current Record Id
    Store Session Record      Contact  ${contact_id}
    [return]                  ${contact_id}  


New And Return Contact for HouseHold
    Click Related List Button  Contacts    New 
    Wait Until Modal Is Open
    ${first_name} =           Generate Random String
    ${last_name} =            Generate Random String
    Populate Form
    ...                       First Name=${first_name}
    ...                       Last Name=${last_name}
    Click Modal Button        Save    
    Wait Until Modal Is Closed
    Go To Object Home         Contact
    Click Link                link= ${first_name} ${last_name}
    ${contact_id} =           Get Current Record Id
    Store Session Record      Account  ${contact_id}
    [return]                  ${contact_id} 
        
Create And Return Organization Foundation   
    ${account_name} =          Generate Random String
    Go To Object Home          Account
    Click Object Button        New
    Select Record Type         Organization
    Populate Form
    ...                        Account Name=${account_name}
    Click Modal Button         Save    
    Wait Until Modal Is Closed
    ${account_id} =            Get Current Record Id
    Store Session Record       Account  ${account_id}
    [return]                   ${account_id}
    
Create And Return HouseHold    
    ${account_name} =         Generate Random String
    Go To Object Home         Account
    Click Object Button       New
    Select Record Type        Household Account
    Populate Form
    ...                       Account Name=${account_name}
    Click Modal Button        Save    
    Wait Until Modal Is Closed
    ${account_id} =           Get Current Record Id
    Store Session Record      Account  ${account_id}
    [return]                  ${account_id}

Create Primary Affiliation
    [Arguments]      ${acc_name}      ${con_id}
    Go To Record Home  ${con_id}
    Select Tab    Details
    #Scroll Page To Location    0    300
    Click Edit Button    Edit Primary Affiliation
    Populate Lookup Field    Primary Affiliation    ${acc_name}
    Click Record Button    Save 
    
Create Secondary Affiliation
    [Arguments]      ${acc_name}      ${con_id}
    Go To Record Home  ${con_id}
    Wait For Locator    record.related.title    Volunteer Hours 
    Scroll Page To Location    50    400
    Click Related List Button   Organization Affiliations    New
    Populate Lookup Field    Organization    ${acc_name}
    Click Modal Button    Save
    
Create Opportunities
    [Arguments]    ${opp_name}    ${hh_name}  
    Select Window
    Sleep    2   
    Populate Form
    ...                       Opportunity Name= ${opp_name}
    ...                       Amount=100 
    Click Dropdown    Stage
    Click Link    link=Closed Won
    Populate Lookup Field    Account Name    ${hh_name}
    Click Dropdown    Close Date
    Pick Date    10
    Select Lightning Checkbox    Do Not Automatically Create Payment
    Click Modal Button        Save

Create And Return Engagement Plan
    ${plan_name} =     Generate Random String
    Select App Launcher Tab  Engagement Plan Templates
    Click Special Object Button       New
    #Sleep    2
    Select Frame With Title    Manage Engagement Plan Template
    Enter Eng Plan Values
    ...             Engagement Plan Template Name=${plan_name}
    ...             Description=This plan is created via Automation  
    Click Task Button    Add Task
    Enter Task Id and Subject    5    ${task1}
    Click Task Button    Add Dependent Task
    Enter Task Id and Subject    32    ${sub_task}
    Click Task Button    Add Task
    Enter Task Id and Subject    59    ${task2}
    Page Scroll To Locator    id    saveBTN
    Click Task Button    Save
    #Sleep    2
    [Return]    ${plan_name}    ${task1}    ${sub_task}     ${task2}
    
Create And Return Level
    ${level_name}=    Generate Random String
    Select App Launcher Tab  Levels
    Click Special Object Button       New
    Select Frame With Title    Levels
    Enter Level Values
    ...            Level Name=${level_name}
    ...            Minimum Amount=0.1
    ...            Maximum Amount=0.9
    Enter Level Dd Values    Target    Contact
    Enter Level Dd Values    Source Field    Total Gifts
    Enter Level Dd Values    Level Field    Level
    Enter Level Dd Values    Previous Level Field    Previous Level
    Set Focus To Element   xpath: //input[@value='Save']
    Click Button  Save
    Unselect Frame
    Wait For Locator  breadcrumb  Level
    ${level_id} =            Get Current Record Id
    Store Session Record  Level__c  ${level_id}
    [Return]    ${level_id}  ${level_name}

Verify Engagement Plan
    [Arguments]       ${plan_name}     @{others}
    Select App Launcher Tab  Engagement Plan Templates
    Click Link    link=${plan_name}
    Check Field Value    Engagement Plan Template Name    ${plan_name}
    Select Tab    Related
    Check Related List Values    Engagement Plan Tasks      @{others}

Create And Return GAU
    ${gau_name} =         Generate Random String
    Sleep    5
    Open App Launcher
    Populate Address    Search apps or items...    General Accounting Units
    Select App Launcher Link    General Accounting Units
    Click Object Button       New
    Populate Form
    ...                    General Accounting Unit Name=${gau_name}
    ...                    Largest Allocation=5
    Click Modal Button        Save
    #Sleep    2
    [Return]           ${gau_name}    

Create And Return Program
    ${program_name} =     Generate Random String
    Go To Object Home     Account
    Click Object Button   New
    Select Record Type    Academic Program
    Populate Form         Account Name=${program_name}
    Click Modal Button    Save
    Wait Until Modal is Closed
    ${program_id} =       Get Current Record Id
    Store Session Record  Account  ${program_id}
    [return]              ${program_id}

API And Return Create Contact
    ${first_name} =  Generate Random String
    ${last_name} =   Generate Random String
    ${contact_id} =  Salesforce Insert  Contact
    ...                  FirstName=${first_name}
    ...                  LastName=${last_name}
    &{contact} =     Salesforce Get  Contact  ${contact_id}
    [return]         &{contact}
      
Create and Return Primary Affiliation
    # Create Organization Account
    ${account_id} =  Create Organization Foundation
    &{account} =  Salesforce Get  Account  ${account_id}
    
    # Create Contact
    ${contact_id} =  Create Contact with Email
    &{contact} =  Salesforce Get  Contact  ${contact_id}   
    Select Tab    Details
    Scroll Page To Location    100    300
    Click Edit Button    Edit Primary Affiliation
    Populate Lookup Field    Primary Affiliation    &{account}[Name]
    Click Record Button    Save 
    [Return]         ${account_id}    ${contact_id}   

Create And Return Secondary Affiliation
    # Create Organization Account
    ${account_id} =  Create Organization Foundation
    &{account} =  Salesforce Get  Account  ${account_id}
    
    # Create Contact
    ${contact_id} =  Create Contact with Email
    &{contact} =  Salesforce Get  Contact  ${contact_id}   
    Scroll Page To Location    50    400
    Click Related List Button   Organization Affiliations    New
    Populate Lookup Field    Organization    &{account}[Name]
    Click Modal Button    Save
    [Return]         ${account_id}    ${contact_id}
    









Choose Frame
    [Arguments]    ${frame}
    Select Frame    //iframe[contains(@title,'${frame}')]
    
Select Frame with ID
    [Arguments]    ${id}
    Select Frame    //iframe[contains(@id, '${id}')]    
    
Select Frame With Title
    [Arguments]    ${name}
    Select Frame    //iframe[@title= '${name}']    
    
Scroll Page To Location
    [Arguments]    ${x_location}    ${y_location}
    Execute JavaScript    window.scrollTo(${x_location},${y_location}) 



Go To Heda Settings
   Open App Launcher
   Click Link   //a[@title= 'HEDA Settings']
   Select Frame			//iframe[contains(@name, "vfFrameId")]