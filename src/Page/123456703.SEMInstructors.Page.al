page 123456703 "SEM Instructors"
{
    ApplicationArea = All;
    Caption = 'Instructors';
    PageType = List;
    SourceTable = "SEM Instructor";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Code"; Code)
                {
                    ApplicationArea = All;
                }
                field("Internal/External"; "Internal/External")
                {
                    ApplicationArea = All;
                }
                field(Name; Name)
                {
                    ApplicationArea = All;
                }
                field("E-Mail"; "E-Mail")
                {
                    ApplicationArea = All;
                }
                field("Phone No."; "Phone No.")
                {
                    ApplicationArea = All;
                }
                field("Contact No."; "Contact No.")
                {
                    ApplicationArea = All;
                }
                field("Resource No."; "Resource No.")
                {
                    ApplicationArea = All;
                }
                field("Language Code"; "Language Code")
                {
                    ApplicationArea = All;
                }
                field("Salesperson Code"; "Salesperson Code")
                {
                    ApplicationArea = All;
                }
                field(Blocked; Blocked)
                {
                    ApplicationArea = All;
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1900383207; Links)
            {
                ApplicationArea = RecordLinks;
                Visible = false;
            }
            systempart(Control1905767507; Notes)
            {
                ApplicationArea = Notes;
                Visible = true;
            }
        }
    }

    actions
    {
        area(creation)
        {
            action("New Seminar Registration")
            {
                ApplicationArea = All;
                Caption = 'New Seminar Registration';
                Image = NewResourceGroup;
                Promoted = true;
                PromotedCategory = New;
                RunObject = Page "SEM Seminar Registration";
                RunPageLink = "Instructor Code" = field(Code);
                RunPageMode = Create;
            }
        }
    }
}
