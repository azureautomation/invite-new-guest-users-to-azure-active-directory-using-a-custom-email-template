<#
    .SYNOPSIS
        Invite a new external guest user to your Azure Active Directory using a custom email template
    .DESCRIPTION
        Invite a new external guest user to your directory. Instead of using the default email template that Microsoft providers, this script
        allows you to brand the email invitations to your Azure Active Directory.
    .PARAMETER Credential
        Specifies the user account that has permission to sent an email using the Send-MailMessage cmdlet.
    .PARAMETER InvitedUserDisplayName
        The display name of the user as it will appear in your directory
    .PARAMETER InvitedUserEmailAddress
        The Email address to which the invitation is sent
    .PARAMETER InviteRedirectUrl
        The URL to which the invited user is forwarded after accepting the invitation
    .PARAMETER InviteMessage
        Add an optional message to the invitation, which is displayed in the email.
    .EXAMPLE
        New-CustomAzureADMSInvitation.ps1 -InvitedUserDisplayName "John Doe" `
         -InvitedUserEmailAddress "john.doe@outlook.com" `
         -InviteRedirectUrl "http://myapps.onmicrosoft.com"
    .NOTES
        Requires the AzureAD module (Install-Module AzureAD)
        Modify the configuration section and email template to your needs.
#>
[CmdletBinding()]
param (
    [Parameter(Mandatory = $true)]
    [pscredential]$Credential,

    [Parameter(Mandatory = $false)]
    [string]$InvitedUserDisplayName,

    [Parameter(Mandatory = $true)]
    [string]$InvitedUserEmailAddress,

    [Parameter(Mandatory = $true)]
    [string]$InviteRedirectUrl,

    [Parameter(Mandatory = $false)]
    [string]$InviteMessage
)

# Test if connected to AzureAD and get the Tenant Details
try {
    $AzureADTenantDetail = Get-AzureADTenantDetail
}
catch {
    if($_.CategoryInfo.Reason -eq "AadNeedAuthenticationException") {
        Write-Output 'You must call the Connect-AzureAD cmdlet first.'
        break
    }
    Write-Error $_
}

# Configuration
$MailMessageProperties = @{
    To         = $InvitedUserEmailAddress
    From       = "Jane Doe <noreply@domain.com>"
    Subject    = "You're invited to the $($AzureADTenantDetail.DisplayName) organization"
    SmtpServer = 'smtp.office365.com'
    Credential = $Credential
    Port       = 587
}

# Create the external guest user and gather the invitation details
$AzureADMSInvitation = @{
    InvitedUserDisplayName  = $InvitedUserDisplayName
    InvitedUserEmailAddress = $InvitedUserEmailAddress
    InviteRedirectUrl       = $InviteRedirectUrl
}

try {
    $AzureADMSInvitation = New-AzureADMSInvitation @AzureADMSInvitation -SendInvitationMessage $false -ErrorAction Stop
    Write-Output "The user $InvitedUserEmailAddress has been added as external guest user to the $($AzureADTenantDetail.DisplayName) organization."
}
catch {
    Write-Error $_
}

# Email template
$MailBody = @"
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>$($MailMessageProperties.Subject)</title>
    </head>
    <body style="height: 100%; margin: 0; padding: 0; width: 100%; background-color: #FAFAFA; -ms-text-size-adjust: 100%; -webkit-text-size-adjust: 100%;">
        <table align="center" style="width:600px;">
            <div align="center" style="padding: 20px; width: 560px; background-color: #fff; color: #606060; font-family: Helvetica; font-size: 14px; line-height: 150%;">
                <img alt="" src="https://www.srdn.io/wp-content/uploads/2018/08/header.png" width="560" style="border:0; outline:none; text-decoration:none; max-width: 600px; padding-bottom: 0; display: inline; vertical-align: bottom; align-self: center; -ms-interpolation-mode: bicubic;">
                <p>
                    You've been invited to access applications in the organization of <h1>$($AzureADTenantDetail.DisplayName)</h1>

                    $InviteMessage

                    <hr>
                        <a href="$($AzureADMSInvitation.InviteRedeemUrl)">Click here to accept the invitation</a>.
                    <hr>

                    Once you have accepted the invitation, you can access the organization's applications.
                </p>
            </div>
        </table>
    </body>
</html>
"@

# Send the email to the external guest user including the invitation details
try {
    Send-MailMessage @MailMessageProperties -Body $MailBody -BodyAsHtml -UseSsl -ErrorAction Stop
    Write-Output "The email invitation has been sent to $InvitedUserEmailAddress."
}
catch {
    Write-Output "Sending the invitation by email failed. Verify the MailMessageProperties and try again."
    Write-Error $_
}
