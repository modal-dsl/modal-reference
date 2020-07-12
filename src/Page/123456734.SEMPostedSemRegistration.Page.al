page 123456734 "SEM Posted Sem. Registration"
{

    Caption = 'Seminar Registration';
    InsertAllowed = false;
    Editable = false;
    PageType = Document;
    PromotedActionCategories = 'New,Process,Report,Seminar Registration,Correct,Print/Send,Navigate';
    RefreshOnActivate = true;
    SourceTable = "SEM Posted Seminar Reg. Header";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field(No; "No.")
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                    ToolTip = 'Specifies the number of the involved entry or record, according to the specified number series.';
                }
                field(StartingDate; "Starting Date")
                {
                    ApplicationArea = All;
                }
                field(SeminarNo; "Seminar No.")
                {
                    ApplicationArea = All;
                }
                field(SeminarDescription; "Seminar Description")
                {
                    ApplicationArea = All;
                }
                field(InstructorCode; "Instructor Code")
                {
                    ApplicationArea = All;
                }
                field(InstructorName; "Instructor Name")
                {
                    ApplicationArea = All;
                }
                field(PostingDate; "Posting Date")
                {
                    ApplicationArea = All;
                }
                field(DocumentDate; "Document Date")
                {
                    ApplicationArea = All;
                }
                field(Status; Status)
                {
                    ApplicationArea = All;
                }
                field(DurationDays; "Duration Days")
                {
                    ApplicationArea = All;
                }
                field(MinimumParticipants; "Minimum Participants")
                {
                    ApplicationArea = All;
                }
                field(MaximumParticipants; "Maximum Participants")
                {
                    ApplicationArea = All;
                }
                field(LanguageCode; "Language Code")
                {
                    ApplicationArea = All;
                }
                field(SalespersonCode; "Salesperson Code")
                {
                    ApplicationArea = All;
                }
                field(ExternalDocumentNo; "External Document No.")
                {
                    ApplicationArea = All;
                }
            }
            part(PostedSemiRegLines; "SEM Posted Sem. Reg. Subform")
            {
                ApplicationArea = All;
                SubPageLink = "Document No." = field("No.");
            }
            group("Seminar Room")
            {
                Caption = 'Seminar Room';
                field("Room Code"; "Room Code")
                {
                    ApplicationArea = All;
                }
                field("Room Name"; "Room Name")
                {
                    ApplicationArea = All;
                }
                field("Room Name 2"; "Room Name 2")
                {
                    ApplicationArea = All;
                }
                field("Room Contact Person"; "Room Contact Person")
                {
                    ApplicationArea = All;
                }
                field("Room Address"; "Room Address")
                {
                    ApplicationArea = All;
                }
                field("Room Address 2"; "Room Address 2")
                {
                    ApplicationArea = All;
                }
                field("Room City"; "Room City")
                {
                    ApplicationArea = All;
                }
                group(Control48)
                {
                    ShowCaption = false;
                    Visible = IsRoomCountyVisible;
                    field("Room County"; "Room County")
                    {
                        ApplicationArea = All;
                    }
                }
                field("Room Post Code"; "Room Post Code")
                {
                    ApplicationArea = All;
                }
                field("Room Country/Region Code"; "Room Country/Region Code")
                {
                    ApplicationArea = All;
                }
            }
            group(Invoicing)
            {
                Caption = 'Invoicing';
                field(GenProdPostingGroup; "Gen. Prod. Posting Group")
                {
                    ApplicationArea = All;
                }
                field(ShortcutDimension1Code; "Shortcut Dimension 1 Code")
                {
                    ApplicationArea = All;
                }
                field(ShortcutDimension2Code; "Shortcut Dimension 2 Code")
                {
                    ApplicationArea = All;
                }
                field(SeminarPrice; "Seminar Price")
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
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("Seminar &Registration")
            {
                Caption = 'Seminar &Registration';
                action(Comments)
                {
                    ApplicationArea = Comments;
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    Promoted = true;
                    PromotedCategory = Category4;
                    RunObject = Page "SEM Seminar Comment Sheet";
                    RunPageLink = "Document Type" = CONST("Posted Seminar Registration"),
                                  "No." = FIELD("No."),
                                  "Document Line No." = CONST(0);
                    ToolTip = 'View or add comments for the record.';
                }
            }
        }
        area(processing)
        {
            action(Navigate)
            {

                ApplicationArea = All;
                Caption = '&Navigate';
                Image = Navigate;
                Promoted = true;
                PromotedCategory = Category4;
                ToolTip = 'Find all entries and documents that exist for the document number and posting date on the selected entry or document.';

                trigger OnAction()
                begin
                    Navigate;
                end;
            }
        }
    }

    var
        FormatAddress: Codeunit "Format Address";
        IsRoomCountyVisible: Boolean;

    trigger OnOpenPage()
    begin
        ActivateFields;
    end;

    local procedure ActivateFields()
    begin
        IsRoomCountyVisible := FormatAddress.UseCounty("Room Country/Region Code");
    end;
}
