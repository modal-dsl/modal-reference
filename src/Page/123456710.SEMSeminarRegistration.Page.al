page 123456710 "SEM Seminar Registration"
{

    Caption = 'Seminar Registration';
    PageType = Document;
    PromotedActionCategories = 'New,Process,Report,Print/Send,Release,Posting,Seminar Registration,Navigate';
    RefreshOnActivate = true;
    SourceTable = "SEM Seminar Reg. Header";

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

                    trigger OnAssistEdit()
                    begin
                        if AssistEdit(xRec) then
                            CurrPage.Update;
                    end;
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
            part("Seminar Reg. Lines"; "SEM Seminar Reg. Subform")
            {
                ApplicationArea = All;
                SubPageLink = "Document No." = field("No.");
                UpdatePropagation = Both;
            }
            group("Seminar Room")
            {
                Caption = 'Seminar Room';
                field("Room Code"; "Room Code")
                {
                    ApplicationArea = All;
                }
                field("Room Contact Person"; "Room Contact Person")
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
                field("Room Address"; "Room Address")
                {
                    ApplicationArea = All;
                    QuickEntry = false;
                }
                field("Room Address 2"; "Room Address 2")
                {
                    ApplicationArea = All;
                    QuickEntry = false;
                }
                field("Room City"; "Room City")
                {
                    ApplicationArea = All;
                    QuickEntry = false;
                }
                group(Control48)
                {
                    ShowCaption = false;
                    Visible = IsRoomCountyVisible;
                    field("Room County"; "Room County")
                    {
                        ApplicationArea = All;
                        QuickEntry = false;
                    }
                }
                field("Room Post Code"; "Room Post Code")
                {
                    ApplicationArea = All;
                    QuickEntry = false;
                }
                field("Room Country/Region Code"; "Room Country/Region Code")
                {
                    ApplicationArea = All;
                    QuickEntry = false;

                    trigger OnValidate()
                    begin
                        IsRoomCountyVisible := FormatAddress.UseCounty("Room Country/Region Code");
                    end;
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
                Visible = true;
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
                Image = "Order";
                action("Co&mments")
                {
                    ApplicationArea = Comments;
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    Promoted = true;
                    PromotedCategory = Category8;
                    RunObject = Page "SEM Seminar Comment Sheet";
                    RunPageLink = "No." = field("No."),
                                  "Document Line No." = const(0);
                    ToolTip = 'View or add comments for the record.';
                }
            }
            group("P&osting")
            {
                Caption = 'P&osting';
                Image = Post;
                action(Post)
                {
                    ApplicationArea = All;
                    Caption = 'P&ost';
                    Ellipsis = true;
                    Image = PostOrder;
                    Promoted = true;
                    PromotedCategory = Category7;
                    PromotedIsBig = true;
                    ShortCutKey = 'F9';
                    ToolTip = 'Finalize the document or journal by posting the amounts and quantities to the related accounts in your company books.';

                    trigger OnAction()
                    var
                        SeminarPostYesNo: Codeunit "SEM Seminar-Post (Yes/No)";
                    begin
                        SeminarPostYesNo.Run(Rec);
                        CurrPage.Update(false);
                    end;
                }
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

