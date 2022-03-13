# azfilemonitoring
this is for monitoring of each individual azure file share storage 
It is not official script so pleas modify to suit your need, and security priciple that you may have

I am developing this just to help with monitoring the quota against used space 
on Azure File Storage.

To use this:
- 1. Create Azure Automation Runbook
- 2. Adding the Authentication part to this script - so it can login to Azure
- 3. Running the script - this script will return based on Threshold (currently setting at 80)


To consider:
- 1. Create logic app where the script can call HTTP to raise alarm such as ServiceNow, Teams alert
- 2. Considering exporting the log from fsSummary here - into Custom Log in Log analytic and setup the alert from there


