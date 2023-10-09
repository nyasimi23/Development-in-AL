page  50115 "CRONUS Course List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    Caption = 'Course List';
    SourceTable = "CRONUS Course";
    Editable = false;
    CardPageId = "CRONUS Course Card";
    
    layout
    {
        area(Content)
        {
           
        repeater(General){
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

            field(Price; Rec.Price)
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
            action(ActionName)
            {
                ApplicationArea = All;
                
                trigger OnAction()
                begin
                    
                end;
            }
        }
    }
    
    var
        myInt: Integer;
}