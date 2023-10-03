codeunit 50100 "Customer Rewards Installation"
{
    // Customer Rewards Install Logic 
    Subtype = Install;

    trigger OnInstallAppPerCompany();
    var
        myAppInfo: ModuleInfo;
    begin
        NavApp.GetCurrentModuleInfo(myAppInfo); // Get info about the currently executing module

        if myAppInfo.DataVersion = Version.Create(0, 0, 0, 0) then // A 'DataVersion' of 0.0.0.0 indicates a 'fresh/new' install
            HandleFreshInstall()
        else
            HandleReinstall(); // If not a fresh install, then we are Re-installing the same version of the extension
    end;

    local procedure HandleFreshInstall();
    begin
        // Do work needed the first time this extension is ever installed for this tenant.
        // Some possible usages:
        // - Service callback/telemetry indicating that extension was installed
        // - Initial data setup for use
        SetDefaultCustomerRewardsExtMgtCodeunit();
        InsertDefaultRewardLevels();
        InitializeRewardsForExistingCustomers();
    end;

    local procedure HandleReinstall();
    begin
        // Do work needed when reinstalling the same version of this extension back on this tenant.
        // Some possible usages:
        // - Service callback/telemetry indicating that extension was reinstalled
        // - Data 'patchup' work, for example, detecting if new 'base' records have been changed while you have been working 'offline'.
        // - Set up 'welcome back' messaging for next user access.
    end;

    procedure SetDefaultCustomerRewardsExtMgtCodeunit();
    var
        CustomerRewardsMgtSetup: Record "Customer Rewards Mgt. Setup";
    begin
        CustomerRewardsMgtSetup.DeleteAll();
        CustomerRewardsMgtSetup.Init();
        // Default Customer Rewards Ext. Mgt codeunit to use for handling events  
        CustomerRewardsMgtSetup."Cust. Rew. Ext. Mgt. Cod. ID" := Codeunit::"Customer Rewards Ext Mgt";
        CustomerRewardsMgtSetup.Insert();
    end;

    procedure InsertDefaultRewardLevels()
    var
        RewardLevels: Record "Reward Level";
    begin
        Clear(RewardLevels);
        if not RewardLevels.IsEmpty then
            exit;
        InsertRewardLevel('Bronze', 10);
        InsertRewardLevel('Silver', 20);
        InsertRewardLevel('Gold', 30);
        InsertRewardLevel('Platinum', 40);

    end;

    local procedure InsertRewardLevel(Level: Text[20]; Points: integer)
    var
        RewardLevel: Record "Reward Level";
    begin
        Clear(RewardLevel);
        RewardLevel.Level := Level;
        RewardLevel."Minimum Reward Points" := Points;
        RewardLevel.Insert();
    end;

    local procedure InitializeRewardsForExistingCustomers()
    var
        Customer: Record Customer;
        SalesHeader: Record "Sales Header";
    begin
        Clear(SalesHeader);
        SalesHeader.SetCurrentKey("Sell-to Customer No.");
        SalesHeader.SetRange(Status, SalesHeader.Status::Released);
        if SalesHeader.FindSet() then
            repeat
                if not Customer.Get(SalesHeader."Sell-to Customer No.") then
                    exit;
                Customer.RewardPoints += 1; // Add a point for each new sales order 
                Customer.Modify();
            until SalesHeader.Next() = 0;
    end;
}