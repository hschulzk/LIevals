<cfcomponent>
    <cfscript>
        function updateRecruiterCompanyInfo(recruiterCID, companyID, recPosition) {
            recUpdate = new Query();
            recUpdate.setDatasource('users');
            sqlString = "
                UPDATE recruiters
                SET companyid = :companyid,
                    rProfessionalTitle = :recPosition
                WHERE contactid = :recruiterCID
            ";
            recUpdate.setSQL(sqlString);
            recUpdate.addParam(name="companyid", value="#arguments.companyid#", CFSQLTYPE="cf_sql_integer");
            recUpdate.addParam(name="recPosition", value="#arguments.recPosition#", CFSQLTYPE="cf_sql_varchar");
            recUpdate.addParam(name="recruiterCID", value="#arguments.recruiterCID#", CFSQLTYPE="cf_sql_integer");
            qryRes = recUpdate.execute();
        }


    </cfscript>
</cfcomponent>