page 123456735 "SEM Posted Sem. Reg. Subform"
{

    AutoSplitKey = true;
    Caption = 'Lines';
    Editable = false;
    LinksAllowed = false;
    PageType = ListPart;
    SourceTable = "SEM Posted Seminar Reg. Line";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("Bill-to Customer No."; "Bill-to Customer No.")
                {
                    ApplicationArea = All;
                }
                field("Participant Contact No."; "Participant Contact No.")
                {
                    ApplicationArea = All;
                }
                field("Participan tName"; "Participant Name")
                {
                    ApplicationArea = All;
                }
                field("Registration Date"; "Registration Date")
                {
                    ApplicationArea = All;
                }
                field(Registered; Registered)
                {
                    ApplicationArea = All;
                }
                field(Participated; Participated)
                {
                    ApplicationArea = All;
                }
                field("To Invoice"; "To Invoice")
                {
                    ApplicationArea = All;
                }
                field("Confirmation Date"; "Confirmation Date")
                {
                    ApplicationArea = All;
                }
                field("Seminar Price"; "Seminar Price")
                {
                    ApplicationArea = All;
                }
                field("Line Discount %"; "Line Discount %")
                {
                    ApplicationArea = All;
                }
                field("Line Discount Amount (LCY)"; "Line Discount Amount (LCY)")
                {
                    ApplicationArea = All;
                }
                field("Line Amount (LCY)"; "Line Amount (LCY)")
                {
                    ApplicationArea = All;
                }
                field("External Document No."; "External Document No.")
                {
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 1 Code"; "Shortcut Dimension 1 Code")
                {
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 2 Code"; "Shortcut Dimension 2 Code")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("&Line")
            {
                Caption = '&Line';
                Image = Line;
                group("Related Information")
                {
                    Caption = 'Related Information';
                    action("Co&mments")
                    {
                        ApplicationArea = Comments;
                        Caption = 'Co&mments';
                        Image = ViewComments;
                        ToolTip = 'View or add comments for the record.';

                        trigger OnAction()
                        begin
                            ShowLineComments;
                        end;
                    }
                }
            }
        }
    }
}

