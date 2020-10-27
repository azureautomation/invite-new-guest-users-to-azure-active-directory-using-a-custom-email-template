Invite new guest users to Azure Active Directory using a custom email template
==============================================================================

            

This script allows you to invite a new external guest user to your Azure Active Directory. Instead of using the default email template that Microsoft providers, you can define a company
branded email template in the script which will be used to send the email invitations to your Azure Active Directory.


Check out my blog post for more details and instructions on how to use at [https://www.srdn.io/2018/08/invite-guest-users-with-powershell-using-a-custom-email-template/](https://www.srdn.io/2018/08/invite-guest-users-with-powershell-using-a-custom-email-template/)


  *  Modify the configuration section
 

  *  
Modify the HTML template in the $MailBody variable
 



**.SYNOPSIS**
    Invite a new external guest user to your Azure Active Directory using a custom email template



**.DESCRIPTION**
    Invite a new external guest user to your directory. Instead of using the default email template that Microsoft providers, this script
    allows you to brand the email invitations to your Azure Active Directory.



**.PARAMETER Credential**
    Specifies the user account that has permission to sent an email using the Send-MailMessage cmdlet.



**.PARAMETER InvitedUserDisplayName**
    The display name of the user as it will appear in your directory



**.PARAMETER InvitedUserEmailAddress**
    The Email address to which the invitation is sent



**.PARAMETER InviteRedirectUrl**
    The URL to which the invited user is forwarded after accepting the invitation



**.PARAMETER InviteMessage**
    Add an optional message to the invitation, which is displayed in the email.



**.EXAMPLE**


 

**.NOTES**

 


    Requires the AzureAD module (Install-Module AzureAD)
    Modify the configuration section and email template to your needs.


 


 



** *** *


        
    
TechNet gallery is retiring! This script was migrated from TechNet script center to GitHub by Microsoft Azure Automation product group. All the Script Center fields like Rating, RatingCount and DownloadCount have been carried over to Github as-is for the migrated scripts only. Note : The Script Center fields will not be applicable for the new repositories created in Github & hence those fields will not show up for new Github repositories.
