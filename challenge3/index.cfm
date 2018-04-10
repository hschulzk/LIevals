<cfsilent>
    <cfscript>
        
        if(not (isdefined("contact.RecruiterID") and contact.RecruiterID gt 1)) {
            cflocation(addtoken="false", url="https://www.conservativejobs.com");
        }
        if(isDefined('companyQuery.companyid') and companyQuery.companyid gt 0) {
            cflocation(addtoken="false", url="/Recruiter/editcompanyprofile.cfm");
        }

        //These are calls to components-- the components are included as a part of the Github repo
        rec_views = createObject('views.rec_view');
        rec_model = createObject('models.rec_model');
        com_model = createObject('models.com_model');

        //This is a component that interacts with the CJ application. You can ignore it when you see it. 
        cj_utils  = createObject('models.cj_utilities');
        
        displayMessage = "";
        showForms = true;
        
        if(not structIsEmpty(form)) {
            if(structKeyExists(form, "existingCompany") and form.existingCompany gt 0) {
                newCompany = com_model.getCompanyList(form.existingCompany);
                otherRecEmails = com_model.getCompanyRecruiters(newCompany.companyid);
                com_model.emailCompanyRecruiters(newCompany.companyid, contact.contactid);
                com_model.emailCJaboutNewCompany(newCompany.companyid, contact.contactid);                
                displayMessage = "<p>We have received your request to be added as a recruiter to #newCompany.companyName#. A member of the CJ staff will look at your request shortly.</p>";
                showForms = false;
            } else if (structKeyExists(form, "addNewCompany")) {
                companyExists = com_model.searchForCompanyByName(form.companyName);
                if (companyExists.recordcount gt 0) {
                    //What do we do if the company already exists?
                    displayMessage = "
                        <h3>The company name you submitted, <a href='/jobseeker/companyprofile.cfm?CompanyID=#urlencodedformat(tobase64(encrypt(companyExists.CompanyID,theurlKey,'AES', 'HEX')))#&'>
                        #form.companyName#</a>, already has a Conservative Jobs profile. 
                        If you'd like to be added as a recruiter for this company, please select it from the list below.</h3>";
                } else {
                    newCompanyId = com_model.createNewCompany(form);
                    rec_model.updateRecruiterCompanyInfo(contact.contactid, newCompanyId.companyId, form.recPosition);
                    //Ignore this
                    cj_utils.clearCache();
                    com_model.emailCJNewCompanyCreated(newCompanyId.companyid, contact.contactid);
                    displayMessage = "<p>You've successfully created your company profile. Please visit <a href='/recruiter/editcompanyprofile.cfm'>the profile page</a> to edit the profile and fill in the rest of the information.</p>";
                    showForms = false;
                }
                
            }
        }
        
        if (showForms is true) {
            companyList = com_model.getCompanyList();
            companyForm = rec_views.outputAddCompanyForm(variables.companyList);
            newCompanyForm = rec_views.addNewCompanyForm();
        }

    </cfscript>
</cfsilent>

<!DOCTYPE html>
<html lang="en">
    <head>
        <style>
            #cj-main {
                width: 50%;
                margin: auto;
                padding: 1em;
                background-color: white;
                margin-top: 1em;
            }
        </style>
    </head>
    <body>
        <cfinclude  template="/includes/header.cfm">
        <div id="cj-main">
            <cfoutput>
                <cfif len(displayMessage) gt 0>
                    #displayMessage#
                    <hr>
                </cfif>
                <cfif structKeyExists(variables, 'companyForm')>
                    #companyForm#
                    <hr>
                </cfif>
                <cfif structKeyExists(variables, 'newCompanyForm')>
                    #newCompanyForm#
                </cfif>
            </cfoutput>
        </div>
    </body>
</html>