<cfcomponent>
    <cfscript>
        contact_model = createObject('models.contacts');

        function searchForCompanyByName(companyName) {
            comQ = new Query();
            comQ.setDatasource('users');
            sqlString = "SELECT companyName, companyId FROM companies WHERE companyName like :companyName ;";
            comQ.setSQL(sqlString);
            comQ.addParam(name="companyName", value="#trim(arguments.companyName)#", CFSQLTYPE="cf_sql_varchar");
            companyResults = comQ.execute().getResult();
            return companyResults;
        }

        function getCompanyRecruiters(companyid) {
            recQuery = new Query();    
            recQuery.setDatasource("users");   
            sqlString = "with lastLogin as (
                        select distinct contactid 
                        from yoda.logs.dbo.cjpagehits
                        where hitDateTime > DATEADD(m, -6, getdate())
                        )
                        select distinct RFirstName, RLastName, email 
                        from RFRecruiterProfile  cross apply
                        (
                            select top(1) email, case when email = RFRecruiterProfile.remail then 1 else 0 end as primaryFlag 
                            from ContactEmailAddress 
                            where contactid = RFRecruiterProfile.contactid 
                            order by primaryFlag, primaryemail
                        ) as contactEmail
                        
                        where (companyid = :companyid
                        and exists (
                        select contactid 
                        from lastlogin
                        where contactid = RFRecruiterProfile.contactid
                        ) and deleted = 0)";
            recQuery.setSQL(sqlString);
            recQuery.addParam(name="companyid", value="#arguments.companyid#", CFSQLTYPE="CF_SQL_INTEGER");
            qryRes = recQuery.execute().getResult();
            return qryRes;            
        }
        
        function getCompanyList(companyID) {
            recQuery = new Query();    
            recQuery.setDatasource("users");
            sqlString = "SELECT companyname, companyid FROM companies WHERE deleted <> 1 and len(companyname) > 0";
            if(structKeyExists(arguments, "companyID") and arguments.companyid gt 0) {
                sqlString = sqlString & " and companyid = :companyid";
            }
            sqlString = sqlString & " ORDER BY companyname;";
            recQuery.setSQL(sqlString);
            if(structKeyExists(arguments, "companyID") and arguments.companyid gt 0) {
                recQuery.addParam(name="companyid", value="#arguments.companyid#", CFSQLTYPE="CF_SQL_INTEGER");
            }
            qryRes = recQuery.execute().getResult();
            return qryRes;
        }

        function createNewCompany(formData) {
            cfparam(name="formData.companyName", default="");
            cfparam(name="formData.companyDescription", default="");
            cfparam(name="formData.recPosition", default="");
            cfparam(name="formData.companyZip", default="");
            cfparam(name="formData.companyWebsite", default="");
            cfparam(name="formData.companyPhone", default="");                                     
            newCom = new Query();
            newCom.setDatasource('users');
            sqlString = "
                INSERT INTO companies(CompanyName, CompanyDescription, companyZip, companyDomain, companyPhone)
                VALUES (:companyName, :companyDescription, :companyZip, :companyWebsite, :companyPhone);
                SELECT scope_identity() as companyID
            ";
            newCom.setSQL(sqlString);
            newCom.addParam(name="companyName", value="#formData.companyName#", CFSQLTYPE="cf_sql_varchar");
            newCom.addParam(name="companyDescription", value="#formData.companyDescription#", CFSQLTYPE="cf_sql_varchar");
            newCom.addParam(name="companyZip", value="#formData.companyZip#", CFSQLTYPE="cf_sql_integer");
            newCom.addParam(name="companyWebsite", value="#formData.companyWebsite#", CFSQLTYPE="cf_sql_varchar", null="#(not len(formData.companyWebsite))#");
            newCom.addParam(name="companyPhone", value="#formData.companyPhone#", CFSQLTYPE="cf_sql_varchar", null="#(not len(formData.companyPhone))#");
            qryRes = newCom.execute().getResult();
            return qryRes;
        }


        function emailCompanyRecruiters(companyID, userId) {
            companyInfo = getCompanyList(arguments.companyID);
            userName = contact_model.getContactName(arguments.userId);
            userFullName = userName.firstname & ' ' & userName.lastname;
            for (otherRecEmail in getCompanyRecruiters(arguments.companyID)) {
                cfmail(
                    to = "#otherRecEmail.email#", 
                    from = "support@conservativejobs.com", 
                    subject = "#variables.userFullName# has asked to be added as a recruiter for #companyInfo.companyname#", 
                    type="html",
                    failto="lid@limail.us"
                ) { 
                    WriteOutput("
                        Dear #otherRecEmail.RFirstName# #otherRecEmail.RLastName#, <br>

                        #variables.userFullName# has asked to be added to #companyInfo.companyname# as a recruiter. If they should not be added, please contact Patricia Simpson at PSimpson@conservativejobs.org to let her know.

                        Best regards, <br>

                        Conservative Jobs Staff
                        <br>
                    "); 
                }
            }
            
        }


        function emailCJaboutNewCompany(companyID, userId) {
                companyInfo = getCompanyList(arguments.companyID);
                userName = contact_model.getContactName(arguments.userId);
                userFullName = userName.firstname & ' ' & userName.lastname;
                cfmail(
                    to = "psimpson@limail.us, bwoodward@limail.us", 
                    from = "support@conservativejobs.com", 
                    subject = "#variables.userFullName# has asked to be added as a recruiter for #companyInfo.companyname#", 
                    type="html",
                    failto="lid@limail.us"
                ) { 
                    WriteOutput("
                        Dear CJ Team, <br>

                        #variables.userFullName# has asked to be added to #companyInfo.companyname# as a recruiter.<br>
                        
                        An email has been sent any other recruiters at the company so they can contact Patti with any objections.<br>
                        
                        Best regards, <br>

                        Conservative Jobs
                        <br>
                    "); 
                }            
        }

        function emailCJNewCompanyCreated(companyID, userId) {
                companyInfo = getCompanyList(arguments.companyID);
                userName = contact_model.getContactName(arguments.userId);
                userFullName = userName.firstname & ' ' & userName.lastname;
                cfmail(
                    to = "psimpson@limail.us, bwoodward@limail.us", 
                    from = "support@conservativejobs.com", 
                    subject = "#variables.userFullName# has asked to be added as a recruiter for #companyInfo.companyname#", 
                    type="html",
                    failto="lid@limail.us"
                ) { 
                    WriteOutput("
                        Dear CJ Team, <br>

                        #variables.userFullName# has created a new company on CJ called #companyInfo.companyname#.<br>
                        
                        If this should not have been done, please address the issue or let tech know if you need help.<br>
                        
                        Best regards, <br>

                        Conservative Jobs
                        <br>
                    "); 
                }            
        }


    </cfscript>
</cfcomponent>