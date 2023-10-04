page 50111 "Expressions Card"
{
    // Properties
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Documents;
    Caption = 'Expressions Card';
    
    layout
    {
        area(Content)
        {
            #region -- Displays the Input forms
            group(Input)
            {
                Caption = 'Input';
               
                field(Value1; Value1)
                {
                    ApplicationArea = All;
                    ToolTip = 'Enter a value for Value1.';
                    Caption = 'Value1';
                }
                field(Value2; Value2)
                {
                    ApplicationArea = All;
                    ToolTip = 'Enter a value for Value2.';
                    Caption = 'Value2';
                }
            }
            #endregion


            #region -- Displays the Output
            group(output)
            {
                 Caption = 'Output';
                 field(Ans; Ans)
                 {
                    ApplicationArea = All;
                    ToolTip = 'The result of the operation.';
	                Caption = 'Ans';
                    Editable = false;

                 }
            }
            #endregion
        }
    }
    
    actions
    {
        area(Processing)
        {
            action(Execute)
            {
                ApplicationArea = All;
                Caption = 'Execute';
	            ToolTip = 'Click to calculate the result.';
	            Image = ExecuteBatch;
                ShortCutKey = 'Shift+Ctrl+D';
                
                trigger OnAction()
                begin
                if Value1 > Value2 then 
                     Ans := Value1 - Value2
                else
                    Ans := Value1 + Value2;
                Message('%1', Ans);
                end;
            }
        }
    }
    
    var
        myInt , Value1 , Value2 , Ans: Integer;
}