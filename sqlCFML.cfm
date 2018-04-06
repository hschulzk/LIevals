<!---

    This is a test of your Googling skills! 
    You are not expected to understand the syntax of the 
    language used here, you're expected to Google your way 
    to a solution.

    To run this code, you'll need a CFML engine. The easiest way to get one is to go to 
    https://trycf.com

    Once you're there, click on the little gear on the bottom right, and SELECT Adobe Coldfusion 2016 as the engine you're using. 
    Then, copy and paste the contents of this file into the code window. I wrote this on tryCF.com, so I know it works there.

    Ignore everything between the end of this comment and the 
    START HERE comment. That's where you'll find the instructions.
    The code in between is  is just nonsense data we're using to create the environment. 

    Suggested time: 45 minutes.
--->
<cfscript>
    allTraining = queryNew(
    "trainingName, trainingType, trainingDate", 
    "varchar, varchar, date",
    [
        {
         "trainingName": "Understanding Responsive Design", 
         "trainingType": "CSS", 
         "trainingDate": "04/12/2018"
        }, 
        {
         "trainingName": "Var No More: New Standards in ECMAScript 6", 
         "trainingType": "JS", 
         "trainingDate": "04/13/2018"
        }, 
        {
         "trainingName": "CFScript: faster, cleaner Coldfusion", 
         "trainingType": "CFML", 
         "trainingDate": "04/12/2018"
        },
        {
         "trainingName": "Logical Query Processing: SQL Under the Hood", 
         "trainingType": "SQL", 
         "trainingDate": "04/14/2018"
        },
        {
         "trainingName": "MVC: Design Patterns for Clean, Stable Code", 
         "trainingType": "Software", 
         "trainingDate": "04/12/2018"
        },
        {
         "trainingName": "Sargable Queries: Why it matters", 
         "trainingType": "SQL", 
         "trainingDate": "04/13/2018"
        },
        {
         "trainingName": "Mastering Async Functions", 
         "trainingType": "JS", 
         "trainingDate": "04/13/2018"
        },
        {
         "trainingName": "Scoping in Coldfusion", 
         "trainingType": "CFML", 
         "trainingDate": "04/12/2018"
        },
        {
         "trainingName": "https://cfdocs.org/tags", 
         "trainingType": "Online", 
         "trainingDate": "#dateformat(now(), 'mm/dd/yyyy')#"
        },
        {
         "trainingName": "https://www.w3schools.com/", 
         "trainingType": "Online", 
         "trainingDate": "#dateformat(now(), 'mm/dd/yyyy')#"
        },
        {
         "trainingName": "https://stackoverflow.com/", 
         "trainingType": "Online", 
         "trainingDate": "#dateformat(now(), 'mm/dd/yyyy')#"
        }
        
    ]);
    typeArray = ["CSS", "JS", "SQL", "Software", "CFML", "Online"]; 
    thisType = typeArray[randRange(1,6)];
    cfparam(name="form.trainingType", default="#thisType#");
</cfscript>
<!---------------------------------------------------------->
<!---------------------------------------------------------->
<!---------------------------------------------------------->
<!---------------------- START HERE------------------------->
<!---------------------------------------------------------->
<!---------------------------------------------------------->
<!----------------------------------------------------------
            
            You have three tasks: 
            
            1. Write a simple SQL SELECT query to return trainingName, trainingType, trainingDate from the 
               allTraining table. Write it withing the <cfquery> tags below. Don't change the <cfquery> tags, 
               just write your SQL inside them. 
            
            2. Put a <h1> at the top of the page that displays the training type found in form.trainingType.
            
            3. Loop over the query results to display them on the page. Try not to write too much CSS, but if you do, put it 
               inside a style tag inside the head tag.  
            
            NOTES:
            form.trainingType is the variable you will use for filtering in your SQL statement. You need to use evaluation hashes
            for the SQL to read it, so your SQL should include.
            
            <YOUR SQL>
            ... like '#form.trainingType#'
            
            Figure out where this like clause goes in your query.
            
------------------------------------------------------------>

<!--- TASK 1--->
<cfquery name="getTrainings" dbtype="query">
    <!--- WRITE YOUR SQL HERE --->

    
    <!---END OF YOUR SQL--->
</cfquery>

<!DOCTYPE hmtl>
<html lang="en">
    <head>

    </head>
    <body>
        <!--- TASK 2 --->
        
        <!--- TASK 3 --->

    </body>
    
</html>