/**
* The SOQL class serves as a primer into the Salesforce Object Query Language in Apex.
* It covers fundamental aspects such as SELECT statements, WHERE clauses, Relationship queries, and LIMIT keyword.
*
* This class introduces developers to the concept of retrieving data from Salesforce using SOQL. It provides
* a step-by-step guide on how to construct SOQL queries, filter results using WHERE clause, retrieve related
* records, and manage data volume using the LIMIT keyword.
* 
* Topics covered in this class include:
* - Understanding the structure of a SOQL query.
* - Crafting basic SELECT statements in SOQL.
* - Applying filters using the WHERE clause in SOQL.
* - Fetching related records using Relationship queries.
* - Controlling the amount of data retrieved using the LIMIT keyword.
* 
* Users of this class can expect to gain a solid understanding of SOQL in Apex and
* be prepared to handle data retrieval tasks in Salesforce development.
* 
* @author Brandon Edoria
*/

public with sharing class SOQL {
    
    /**
     * Question 1
     * Update/Uncomment the template code to create a method
     * Returns all leads from Salesforce Org
     * @return List of all leads with Id, LastName, Company, Phone, Email
     * Update the corresponding test class and testGetAllLeads method to cover this method
     */
    public static List<Lead> getAllLeads() {
        return [SELECT Id, LastName, Company, Phone, Email FROM Lead];
    }

    /**
     * Question 2
     * Update/Uncomment the template code to create a method
     * Returns all contacts with first name of John.
     * @return A list of Contact records.
     * Update the corresponding test class and testGetContactsByFirstName method to cover this method
     */
    public static List<Contact> getContactsByFirstName() {
        return [SELECT Id, FirstName, Name FROM Contact WHERE FirstName = 'John'];
    }

    /**
     * Question 3
     * Update/Uncomment the template code to create a method
     * Returns the Contact Id for all contacts with last name of Smith or Jones
     * @return A list of Contact Ids.
     * Update the corresponding test class and testGetContactIdsByLastName method to cover this method
     */
    public static List<Id> getContactIdsByLastName() {
        List<Id> idList = new List<Id>();

        for (Contact con : [SELECT Id, LastName, Name FROM Contact WHERE LastName IN ('Smith', 'Jones')]) {
            idList.add(con.Id);
        }
        return idList;
    }

    /**
     * Question 4
     * Update/Uncomment the template code to create a method
     * Returns List of closed won opportunities for a specific Account.
     * Example: yourMethodName('001XXXXXXXXXXXX') should return the list of closed won opportunities for the Account with the Id
     * @param accountId The ID of the Account.
     * @return A list of Opportunities with important opportunities fields
     * Update the corresponding test class and testGetClosedWonOpportunityCountByAccount method to cover this method
     */
    public static List<Opportunity> getClosedWonOpportunityCountByAccount(Id accountId) {
        return [SELECT Id, Name, Account.Id, StageName, CloseDate, Amount FROM Opportunity WHERE Account.Id = :accountId AND StageName = 'Closed Won'];
    }

    /**
     * Question 5
     * Update/Uncomment the template code to create a method
     * Returns the total count of Account records.
     * @return The Integer count of Account records.
     * Update the corresponding test class and testGetAccountCount method to cover this method
     */
    public static Integer getAccountCount() {
        return [SELECT COUNT() FROM Account];
    }

    /**
     * Question 6
     * Update/Uncomment the template code to create a method
     * Return Key Value pair of Task Id and Task records for any tasks due date within the next 7 days.
     * @return A map of Task Ids to Task records.
     * Update the corresponding test class and testGetTasksDueNextWeek method to cover this method
     */
    public static Map<Id, Task> getTasksDueNextWeek() {
        Map<Id,Task> idToTask = new Map<Id, Task>(); // Map Task Id to Task

        // https://developer.salesforce.com/docs/atlas.en-us.soql_sosl.meta/soql_sosl/sforce_api_calls_soql_select_dateformats.htm
        for (Task tsk : [SELECT Id, ActivityDate FROM Task WHERE ActivityDate = NEXT_N_DAYS: 7]) { // Date literals are helpful to filter WHERE clauses in queries
            idToTask.put(tsk.Id, tsk);
        }
        return idToTask;
    }

    /**
     * Question 7
     * Update/Uncomment the template code to create a method
     * Retrieves all Contacts that have a example.com domain in their Email.
     * @return A list of Contact records.
     * Update the corresponding test class and testGetContactsByEmailDomain method to cover this method
     */
    public static List<Contact> getContactsByEmailDomain() {
        return [SELECT Id, Name, Email FROM Contact WHERE Email LIKE '%example.com%']; // Double %% look for the word throughout the whole string
    }

    /**
     * Question 8
     * Retrieves all Opportunities that have a specific keyword in their Name.
     * Example: getOpportunitiesByNameKeyword('keyword') should return all Opportunities that have 'keyword' in their Name.
     * @param keyword The keyword to search for in the Opportunity Name.
     * @return A list of Opportunity records.
     */
    public static List<Opportunity> getOpportunitiesByNameKeyword(String keyword) {
        return [SELECT Id, Name FROM Opportunity WHERE Name LIKE : '%' + keyword + '%'];
    }

    /**
     * Question 9
     * Retrieves all Cases that Case Origin is not Web or Email or Blank
     * @return A list of Case records.
     */
    public static List<Case> getFilterCaseOrigins() {
        List<String> caseOrigin = new List<String> {'Web', 'Email', ''};

        return [SELECT Id, Origin FROM Case WHERE Origin NOT IN :caseOrigin];
    }

    /**
     * Question 10
     * Update/Uncomment the template code to create a method
     * Retrieves all Leads that have a specific Lead Source or contain a specific keyword in their Title.
     * Example: yourMethodName('Web', 'Engineer') should return all Leads that have 'Web' in their Lead Source or 'Engineer' in their Title.
     * @param leadSource The Lead Source to search for.
     * @param keyword The keyword to search for in the Lead Title.
     * @return A list of Lead records.
     * Update the corresponding test class and testGetLeadsBySourceOrTitle method to cover this method
     */
    public static List<Lead> getLeadsBySourceOrTitle(String leadSource, String keyword) {
        return [SELECT Id, LeadSource, Title, LastName, Company, Phone, Email FROM Lead WHERE (LeadSource = :leadSource OR Title LIKE : '%' + keyword + '%')];
    } 

    /**
     * Question 11
     * Returns the names of all Contacts associated with an Account.
     * Example: getContactNamesByAccount('001XXXXXXXXXXXX') should return the list of Contact LastNames for the Account with the Id
     * @param accountId The ID of the Account.
     * @return A list of Contact LastName.
     */
    public static List<String> getContactNamesByAccount(Id accountId) {
        List<String> contactLastName = new List<String>();

        for (Contact con : [SELECT Id, LastName FROM Contact WHERE accountId = :accountId]) {
            contactLastName.add(con.LastName);
        }
        return contactLastName;
    }

    /**
     * Question 12
     * Returns the total revenue for all Opportunities in a specific Stage or if the amount is greater than 10000.
     * Example: getTotalRevenueByStage('Closed Won') should return the total revenue for the found opportunities
     * @param stage The Stage value to filter Opportunities.
     * @return The total revenue.
     */
    public static Decimal getTotalRevenueByStage(String stage) {
        List<AggregateResult> groupedResults = [SELECT SUM(Amount)totalRevenue FROM Opportunity WHERE (StageName = :stage OR Amount > 10000)];

        return (Decimal) groupedResults[0].get('totalRevenue'); // Need (Decimal) or else it will return an sObject
    }

    /**
     * Question 13
     * Retrieves the first 10 Accounts ordered by Name.
     * @return A list of the first 10 Accounts ordered by Name.
     */
    public static List<Account> getFirstTenAccounts() {
        return [SELECT Id, Name FROM Account ORDER BY Name LIMIT 10];
    }
    
    /**
     * Question 14
     * Retrieves the Opportunities with an Amount greater than 100,000, ordered by CloseDate, and limited to 5 records.
     * @return A list of Opportunities with an Amount greater than 100,000, ordered by CloseDate, and limited to 5 records.
     */
    public static List<Opportunity> getHighValueOpportunities() {
        return [SELECT Id, Amount, CloseDate FROM Opportunity WHERE Amount > 100000 ORDER BY CloseDate LIMIT 5];
    }
    
    /**
     * Question 15
     * Retrieves the Contacts with the most recent Birthdate, ordered by Birthdate, and limited to 3 records.
     * @return A list of Contacts
     */
    public static List<Contact> getBirthdateContacts() {
        return [SELECT Id, Birthdate FROM Contact ORDER BY Birthdate DESC LIMIT 3];
    }
    
    /**
     * Question 16
     * Retrieves the Cases in the Open Status, ordered by CreatedDate, and limited to 10 records with an offset of 5.
     * @return A list of Cases
     */
    public static List<Case> getCasesWithStatus() {
        return [SELECT Id, Status, CreatedDate FROM Case WHERE Status = 'Open' ORDER BY CreatedDate LIMIT 10 OFFSET 5];
    }

    /**
     * Question 17
     * Returns Set of Case Ids for a specific Account.
     * Example: getCaseIdsByAccount('001XXXXXXXXXXXX') should return the set of Case Ids for the Account with the Id
     * @param accountId The ID of the Account.
     * @return A set of Case Ids.
     */
    public static Set<Id> getCaseIdsByAccount(Id accountId) {
        Set<Id> caseIdSet = new Set<Id>();

        for (Case cas : [SELECT Id, AccountId FROM Case WHERE AccountId = :accountId]) {
            caseIdSet.add(cas.Id);
        }
        return caseIdSet;
    }

    /**
     * Question 18
     * Return Map of Account Ids to Account Names Not in a specific Country.
     * Example: getAccountIdsToNamesNotInCountry('United States') should return the map of Account Ids to Account Names for Accounts that are not in the United States.
     * @param country The country to filter Accounts.
     * @return A map of Account Ids to Account Names.
     */
    public static Map<Id, String> getAccountIdsToNamesNotInCountry(String country) {
        Map<Id, String> accountIdsToNames = new Map<Id, String>();

        for (Account acct : [SELECT Id, Name, BillingCountry FROM Account WHERE BillingCountry != :country]) {
            accountIdsToNames.put(acct.Id, acct.Name);
        }
        return accountIdsToNames;
    }

    /**
     * Question 19
     * Retrieves the Account Name for a given Contact.
     * Example: getAccountNameForContact('003XXXXXXXXXXXX') should return the Account Name for the Contact with the Id
     * @param contactId The Id of the Contact.
     * @return The Account Name of the Contact.
     */
    public static String getAccountNameForContact(String contactId) {
        return [SELECT Id, Account.Name FROM Contact WHERE Id = :contactId][0].Account.Name; // gets the first elemenet in the query and grabs the Account.Name , dot operator if going from child to parent
    }    

    /**
     * Question 20
     * Returns single Account that has related opportunities in the same query
     * Example: getAccountAndOpportunitiesFromAccountId('001XXXXXXXXXXXX') should return the Account Name for the Account with the Id and all related Opportunities
     * @param accountId The ID of the Account.
     * @return An Account record with related Opportunities.
     */
    public static Account getAccountAndOpportunitiesFromAccountId(Id accountId) {
        return [SELECT Id, Name, (SELECT Id, Name FROM Opportunities) FROM Account WHERE Id = :accountId]; // parens if going from parent to child, also plural child object
    }

    /**
     * Question 21
     * Retrieves all contacts that have the Mailing State similar to the Account Billing State.
     * Example: getAccountsWithContactsByState('001XXXXXXXXXXXX') should return a list of Contacts that have the same Mailing State as the Account with the Id
     * @param Account Id
     * @return List of contacts with the same Mailing State as the Account Billing State
     */
    public static List<Contact> getAccountsWithContactsByState(Id accountId) {
        Account getBillingState = [SELECT BillingState FROM Account WHERE Id = :accountId];
        List<Contact> matchBillingState = [SELECT Id, MailingState FROM Contact WHERE MailingState = :getBillingState.BillingState];

        return matchBillingState;
    }

    /**
     * Question 22
     * Extracts email domains from the leads, then finds Accounts with matching website domains
     * If Lead Email = test@test.com return account with website = www.test.com
     * Example: findAccountsByLeadEmailDomains([set of lead ids]) should return a list of Accounts with matching email domains
     * @param leadIds set of Lead Ids.
     * @return A list of Accounts with matching email domains.
     */
    public static List<Account> findAccountsByLeadEmailDomains(Set<Id> leadIds) {
        List<Lead> leadList = [SELECT Id, Email FROM Lead WHERE Id IN :leadIds];

        Set<String> emailDomains = new Set<String>();

        for (Lead lead : leadList) {
            if (lead.Email != null) {
                emailDomains.add('%' + lead.Email.substringAfter('@')); // get the string after the @ sign in the email, add % for the LIKE operator used later
            }
        }
        return [SELECT Id, Name, Website FROM Account WHERE Website LIKE :emailDomains];
    }

    /**
     * Question 23
     * Clones and Inserts Opportunity Line Items from an original Opportunity to a list of cloned Opportunities.
     * Adds a randomized number between 1 to 3 to the quantity of each line item.
     * Example: cloneLineItems('001XXXXXXXXXXXX', [list of opportunity ids]) should clone the line items from the Opportunity with the Id to each Opportunity in the list
     * @param Original Opportunity Id
     * @param List of cloned Opportunity Ids
     */
    public static void cloneLineItems(Id origOppId, List<Id> cloneOppIds) {
        // Query the original Opportunity Line Items
        List<OpportunityLineItem> originalOppList = [SELECT Id, OpportunityId, Quantity, PricebookEntryId, UnitPrice FROM OpportunityLineItem WHERE OpportunityId = :origOppId];

        // Create a list to hold the new line items
        List<OpportunityLineItem> newOppList = new List<OpportunityLineItem>();

        // Generate a random number between 1 and 3
        Integer randomNumber = Integer.valueOf((Math.random() * 3) + 1);

        // Loop through each cloned Opportunity Id
            // Loop through each original line item
                // Clone the original line item and add the random number to the quantity
        for (Id id : cloneOppIds) {
            for (OpportunityLineItem oli : originalOppList) {
                OpportunityLineItem cloneOLI = oli.clone();
                cloneOLI.quantity = randomNumber;
                cloneOLI.OpportunityId = id;
                newOppList.add(cloneOLI);
            }
        }
        // Insert the new line items
        insert newOppList;
    }
    
    /**
     * Question 24
     * Retrieves the Opportunity Name, Account Name, and Owner Name for Opportunities that have a Stage of 'Closed Won'.
     * Example: getOpportunityDetailsForClosedWon()
     * @return A list of filtered Opportunity
     */
    public static List<Opportunity> getOpportunityDetailsForClosedWon() {
        List<Opportunity> oppDetails = [SELECT Id, Name, Account.Id, OwnerId FROM Opportunity WHERE StageName = 'Closed Won'];

        return oppDetails;
    }

    /**
     * Question 25
     * Sets the 'Primary_Contact__c' field for all Closed Won Opportunities to first Contact on the Account.
     * Example: setPrimaryContact() should set the 'Primary_Contact__c' field for every Opportunity in the org
     */
    public static void setPrimaryContact() {
        // Use the getOpportunityDetailsForClosedWon() method to get the Opportunities
        List<Opportunity> closedWonOpps = getOpportunityDetailsForClosedWon();

        // Create a set of Account Ids from the Opportunities
        Set<Id> accountIdSet = new Set<Id>();
        for (Opportunity opp : closedWonOpps) {
            accountIdSet.add(opp.Account.Id);
        }
        // Query the Contacts
        List<Contact> contactList = [SELECT Id, Name, Account.Id FROM Contact WHERE Account.Id IN :accountIdSet];

        // Loop through each Contact and add the Account Id and Contact to the map
        Map<Id,Id> accountIdToContact = new Map<Id,Id>();
        for (Contact con : contactList) {
                accountIdToContact.put(con.Account.Id, con.Id);
        }
        // Loop through each Opportunity
                // Update the Opportunity primary contact from accountToContactMap
        for (Opportunity opp : closedWonOpps) {
            opp.Primary_Contact__c = accountIdToContact.get(opp.Account.Id);
        }
        // Update the Opportunities
        update closedWonOpps;
    }
}