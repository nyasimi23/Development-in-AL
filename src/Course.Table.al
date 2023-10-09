table 50103 "CRONUS Course"
{
    DataClassification = CustomerContent;
    Caption = 'Course';
    LookupPageId = "CRONUS Course List";
    DrillDownPageId = "CRONUS Course List";
    
    fields
    {
       field(10; Code; Code[10])
       {
        DataClassification =  CustomerContent;
        Caption = 'Code';
           
       }

       field(20; Name; Text[30])
       {
        DataClassification =  CustomerContent;
        Caption =  'Name';    
       }

       field(30; Description; Text[50])
       {
        DataClassification =  CustomerContent;
        Caption = 'Description';
       }

       field(40; Type ; Option)
       {
        DataClassification =  CustomerContent;
        OptionMembers =  "Instructor Led", "e-Learning", "Remote Training" ;
        OptionCaption =  'Instructor Led, e-Learning, Remote Training';
        Caption = 'Type';
       }

       field(50; Duration ; Decimal)
       {
        DataClassification =  CustomerContent;
        Caption = 'Duration';
       }

       field(60; Price; Decimal)
       {
        DataClassification =  CustomerContent;
        Caption = 'Price';
       }

       field(70; Active; Boolean)
       {
        DataClassification = ToBeClassified;
        Caption = 'Active';
       }

       field(80; Difficulty; Integer)
       {
        DataClassification =  CustomerContent;
        Caption = 'Difficulty';

       }

       field(90; PassingRate; Integer)
       {
        DataClassification =  CustomerContent;
        Caption = 'PassingRate';
       }

       field(100; InstructorCode; Code[20])
       {
        DataClassification =  CustomerContent;
        Caption = 'InstructorCode';
        TableRelation = Resource  where(Type = const(Person));
       }

       field(120; InstructorName; Text[100])
       {
        Editable = false;
        FieldClass = FlowField;
        CalcFormula = lookup(Resource.Name where("No." = field("InstructorCode")));


       }
    }
    
    keys
    {
        key(PK; Code)
        {
            Clustered = true;
        }

        key(Key1; InstructorCode)
        {
            
        }

        key(Key2; Type)
        {
            
        }
    }
    
    
}