<cfcomponent>
    <cfscript>
        rec_model = createObject('Recruiter.models.rec_model');

        function addCompanyButton() {
            writeOutput('<a href="/Recruiter/addcompany.cfm" style="float:right;"><button id="DashboardButton">Post a New Job</button></a>');
        }

        function outputAddCompanyForm(companyList) {
            return(
            "
            <h3>Add me to an existing company:</h3>
            <h4>This Company Already has a Conservative Jobs Profile</h4>
            <form action='addcompany.cfm' method='post'>
             #companyselect(arguments.companyList)#
             <input type='submit' name='submit' value='Add Me to This Company'>
             </form>
            ");
        }

        function companyselect(companyList) {
            optionsSelect = '';
            for (company in arguments.companyList) {
                optionsSelect = optionsSelect & '<option value="#company.CompanyID#">' & company.companyname & '</option>';
            }
            return "<select name='existingCompany' id='existingCompany'>" & optionsSelect &"</select>";
        }

        function addNewCompanyForm() {
            returnHTML = "
            <h3>Create a new company:</h3>
            <form action='' method='POST'>
                <input type='hidden' name='addNewCompany' id='addNewCompany'>
                <label>Company Name*
                    <input type='text' name='companyName' id='companyName' value='' required>
                </label>
                <label>Company Description*
                    <textarea name='companyDescription'  required></textarea>
                </label>
                <label>Your Position with the Company*
                    <input type='text' name='recPosition' id='recPosition' value=''  required>
                </label>
                <label>Company Zip Code*
                    <input type='number' name='companyZip' id='companyZip' value=''  required>
                </label>
                <label>Company Website
                    <input type='text' name='companyWebsite' id='companyWebsite' value='https://'>
                </label>
                <label>Company Phone
                    <input type='text' name='companyPhone' id='companyPhone' value=''>
                </label>
                <input type='submit' name='submit' value='Create Company'>                                            
            </form>";
            return returnHTML;
        }
    </cfscript>


</cfcomponent>