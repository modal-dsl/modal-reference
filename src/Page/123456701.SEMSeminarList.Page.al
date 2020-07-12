page 123456701 "SEM Seminar List"
{
    ApplicationArea = All;
    Caption = 'Seminars';
    CardPageID = "SEM Seminar Card";
    Editable = false;
    PageType = List;
    PromotedActionCategories = 'New,Process,Report,Seminar,Navigate';
    SourceTable = "SEM Seminar";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("No."; "No.")
                {
                    ApplicationArea = All;
                }
                field(Description; Description)
                {
                    ApplicationArea = All;
                }
                field("Search Description"; "Search Description")
                {
                    ApplicationArea = All;
                }
                field("Description 2"; "Description 2")
                {
                    ApplicationArea = All;
                    Visible = false;
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
        area(navigation)
        {
            group("&Seminar")
            {
                Caption = '&Seminar';
                action("Co&mments")
                {
                    ApplicationArea = Comments;
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    Promoted = true;
                    PromotedCategory = Category4;
                    RunObject = Page "Comment Sheet";
                    RunPageLink = "Table Name" = const(Seminar),
                                  "No." = field("No.");
                    ToolTip = 'View or add comments for the record.';
                }
            }
        }
    }
}
