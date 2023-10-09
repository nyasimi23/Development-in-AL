page 50114 "CRONUS Course Card"
{
    PageType = Card;
    UsageCategory = None;
    SourceTable = "CRONUS Course";
    
    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';
            field(Code; Rec.Code)
            {
                ApplicationArea = All;
            }

            field(Name; Rec.Name)
            {
                ApplicationArea = All;
            }

            field(Description; Rec.Description)
            {
                ApplicationArea = All;
            }
            }

            group(Details)
            {
                Caption = 'Details';

                field(Duration; Rec.Duration)
                {
                    ApplicationArea = All;
                }

                field(Price; Rec.Price)
                {
                    ApplicationArea = All;
                }

                field(Type; Rec.Type)
                {
                    ApplicationArea = All;
                }

                field(Active; Rec.Active)
                {
                    ApplicationArea = All;
                }

                field(InstructorCode; Rec.InstructorCode)
                {
                    ApplicationArea = All;
                }

                field(InstructorName; Rec.InstructorName)
                {
                    ApplicationArea = All;
                }
            }
        }
    }
    
    actions
    {
        area(Processing)
        {
            action(ResourceCard)
            {
                ApplicationArea = All;
                Caption = 'Resource';
                ToolTip = 'Open the Resource Card';
                RunObject = Page "Resource Card";
                RunPageLink = "No." = field(InstructorName);
                Image = Relationship;
                Promoted = true;
                PromotedCategory = Process;
                
              
            }
        }
    }
    
    var
        
}