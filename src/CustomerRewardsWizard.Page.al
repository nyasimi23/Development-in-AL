page 50100 "Customer Rewards Wizard"
{
    // Specifies that this page will be a navigate page. 
    PageType = NavigatePage;
    Caption = 'Customer Rewards assisted setup guide';

    layout{

        area(Content){

            group(MediaStandard)
            {
                Caption = '';
                Editable = false;
                Visible = TopBannerVisible;

                field("Media Reference"; MediaResourcesStandard."Media Reference")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ShowCaption = false;
                }
            }

            group(FirstPage){
                Caption = '';
                Visible = FirstPageVisible;

                group("Welcome")
                {
                    group(Introduction){

                    }

                    group("Terms")
                    {

                    }

                    group(Terms2)
                    {

                    }
                }

            }

          group(SecondPage)
            {
                Caption = '';
                Visible = SecondPageVisible;

                group("Activation")
                {
                    Caption = 'Activation';
                    Visible = SecondPageVisible;

                    field(Spacer2; '')
                    {
                        ApplicationArea = All;
                        ShowCaption = false;
                        Editable = false;
                        MultiLine = true;
                    }

                    group(ActivationMessage)
                    {
                        Caption = '';
                        InstructionalText = 'Enter your 14 digit activation code to continue';
                        Visible = SecondPageVisible;

                        field(Activationcode; ActivationCode)
                        {
                            ApplicationArea = All;
                            ShowCaption = false;
                            Editable = true;
                        }
                    }
                }
            }

            group(FinalPage)
            {
                Caption = '';
                Visible = FinalPageVisible;

                group("ActivationDone")
                {
                    Caption = 'You are done!';
                    Visible = FinalPageVisible;

                    group(DoneMessage)
                    {
                        Caption = '';
                        InstructionalText = 'Click Finish to set up your rewards level and start using Customer Rewards.';
                        Visible = FinalPageVisible;
                    }
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionBack)
            {
                ApplicationArea = All;
                Caption = 'Back';
                Enabled = BackEnabled;
                Visible = BackEnabled;
                Image = PreviousRecord;
                InFooterBar = true;

                trigger OnAction();
                begin
                    NextStep(true);
                end;
            }

            action(ActionNext)
            {
                ApplicationArea = All;
                Caption = 'Next';
                Enabled = NextEnabled;
                Visible = NextEnabled;
                Image = NextRecord;
                InFooterBar = true;

                trigger OnAction();
                begin
                    NextStep(false);
                end;
            }

            action(ActionActivate)
            {
                ApplicationArea = All;
                Caption = 'Activate';
                Enabled = ActivateEnabled;
                Visible = ActivateEnabled;
                Image = NextRecord;
                InFooterBar = true;

                trigger OnAction();
                var
                    CustomerRewardsExtMgt: Codeunit "Customer Rewards Ext Mgt";
                begin
                    if ActivationCode = '' then
                        Error('Activation code cannot be blank.');

                    if Text.StrLen(ActivationCode) <> 14 then
                        Error('Activation code must have 14 digits.');

                    if CustomerRewardsExtMgt.ActivateCustomerRewards(ActivationCode) then
                        NextStep(false)
                    else
                        Error('Activation failed. Please check the activation code you entered.');
                end;
            }

            action(ActionFinish)
            {
                ApplicationArea = All;
                Caption = 'Finish';
                Enabled = FinalPageVisible;
                Image = Approve;
                InFooterBar = true;

                trigger OnAction();
                begin
                    FinishAndEnableCustomerRewards();
                end;
            }
        }
    }

    local procedure NextStep(Backwards: Boolean);
    begin
        if Backwards then
            Step := Step - 1
        ELSE
            Step := Step + 1;
        EnableControls();
    end; 

    local procedure FinishAndEnableCustomerRewards();
    var
        CustomerRewardsExtMgt: Codeunit "Customer Rewards Ext Mgt";
        GuidedExperience: Codeunit "Guided Experience";
        Info: ModuleInfo;
    begin
        NavApp.GetCurrentModuleInfo(Info);
        GuidedExperience.CompleteAssistedSetup(ObjectType::Page,PAGE::"Customer Rewards Wizard");
        CurrPage.Close();
        CustomerRewardsExtMgt.OpenRewardsLevelPage();
    end;
    local procedure EnableControls();
    begin
        ResetControls();

        case Step of
            Step::First:
                ShowFirstPage();

            Step::Second:
                ShowSecondPage();

            Step::Finish:
                ShowFinalPage();
        end;
    end;

    trigger OnInit();
    begin
        LoadTopBanners();
    end;

    trigger OnOpenPage();
    begin
        Step := Step::First;
        EnableControls();
    end;

    local procedure ShowFirstPage();
    begin
        FirstPageVisible := true;
        SecondPageVisible := false;
        FinishEnabled := false;
        BackEnabled := false;
        ActivateEnabled := false;
        NextEnabled := EnableCustomerRewards;
    end;

    local procedure ShowSecondPage();
    begin
        FirstPageVisible := false;
        SecondPageVisible := true;
        FinishEnabled := false;
        BackEnabled := true;
        NextEnabled := false;
        ActivateEnabled := true;
    end;

    local procedure ShowFinalPage();
    begin
        FinalPageVisible := true;
        BackEnabled := true;
        NextEnabled := false;
        ActivateEnabled := false;
    end;

    local procedure ResetControls();
    begin
        FinishEnabled := true;
        BackEnabled := true;
        NextEnabled := true;
        ActivateEnabled := true;
        FirstPageVisible := false;
        SecondPageVisible := false;
        FinalPageVisible := false;
    end;

    var
        MediaRepositoryStandard: Record "Media Repository";
        MediaResourcesStandard: Record "Media Resources";
        Step: Option First,Second,Finish;
        ActivationCode: Text;
        TopBannerVisible: Boolean;
        FirstPageVisible: Boolean;
        SecondPageVisible: Boolean;
        FinalPageVisible: Boolean;
        FinishEnabled: Boolean;
        BackEnabled: Boolean;
        NextEnabled: Boolean;
        ActivateEnabled: Boolean;
        EnableCustomerRewards: Boolean;


        local procedure LoadTopBanners();
    begin
        if MediaRepositoryStandard.GET('AssistedSetup-NoText-400px.png', FORMAT(CURRENTCLIENTTYPE))
      then
            if MediaResourcesStandard.GET(MediaRepositoryStandard."Media Resources Ref")
        then
                TopBannerVisible := MediaResourcesStandard."Media Reference".HASVALUE;
    end;

}


// codeunit 50102 "Cust Rewards Assisted Setup"
// {
//     trigger OnRun()
//     begin

//     end;

//     [EventSubscriber(ObjectType::Codeunit, Codeunit::"Guided Experience", 'OnRegisterAssistedSetup', '', false, false)]
//     local procedure AddExtensionAssistedSetup_OnRegisterAssistedSetup();
//     var
//         GuidedExperience: Codeunit "Guided Experience";
//         CurrentGlobalLanguage: Integer;
//         myAppInfo: ModuleInfo;
//         WizardTxt: Label 'Customer Rewards assisted setup guide';
//         GuidedExperienceType : Enum "Guided Experience Type";
//         VideoCategory : Enum "Video Category";
//     begin
//         NavApp.GetCurrentModuleInfo(myAppInfo);
//         CurrentGlobalLanguage := GlobalLanguage();
//         GuidedExperience.InsertAssistedSetup(WizardTxt, WizardTxt, WizardTxt,5,ObjectType::Page,page::"Customer Rewards Wizard","Assisted Setup Group"::Extensions,'',VideoCategory::Uncategorized,'');
//         GLOBALLANGUAGE(1033);
//         GuidedExperience.AddTranslationForSetupObjectTitle(GuidedExperienceType::"Assisted Setup", ObjectType::Page,Page::"Customer Rewards Wizard", CurrentGlobalLanguage, WizardTxt);
//     end;
// }