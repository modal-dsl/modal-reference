page 123456700 "SEM Seminar Card"
{

    Caption = 'Seminar Card';
    PageType = Card;
    PromotedActionCategories = 'New,Process,Report,New Document,Seminar,Navigate';
    RefreshOnActivate = true;
    SourceTable = "SEM Seminar";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("No."; "No.")
                {
                    ApplicationArea = All;
                    Importance = Standard;

                    trigger OnAssistEdit()
                    begin
                        if AssistEdit(xRec) then
                            CurrPage.Update;
                    end;
                }
                field(Description; Description)
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                    ShowMandatory = true;

                    trigger OnValidate()
                    begin
                        CurrPage.SaveRecord;
                    end;
                }
                field("Description 2"; "Description 2")
                {
                    ApplicationArea = All;
                    Importance = Additional;
                    Visible = false;
                }
                field("Search Description"; "Search Description")
                {
                    ApplicationArea = All;
                    Importance = Additional;
                    Visible = false;
                }
                field("Duration Days"; "Duration Days")
                {
                    ApplicationArea = All;
                }
                field("Minimum Participants"; "Minimum Participants")
                {
                    ApplicationArea = All;
                }
                field("Maximum Participants"; "Maximum Participants")
                {
                    ApplicationArea = All;
                }
                field("Language Code"; "Language Code")
                {
                    ApplicationArea = All;
                }
                field(Blocked; Blocked)
                {
                    ApplicationArea = All;
                }
                field(LastDateModified; "Last Date Modified")
                {
                    ApplicationArea = All;
                    Importance = Additional;
                }
            }
            group(PostingDetails)
            {
                Caption = 'Posting Details';

                field("Gen. Prod. Posting Group"; "Gen. Prod. Posting Group")
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                    ShowMandatory = true;
                }
                field("Seminar Price"; "Seminar Price")
                {
                    ApplicationArea = All;
                }
            }
        }
        area(factboxes)
        {
            part(Control1905532107; "Dimensions FactBox")
            {
                ApplicationArea = All;
                SubPageLink = "Table ID" = const(123456700),
                              "No." = field("No.");
            }
            systempart(Control1900383207; Links)
            {
                ApplicationArea = RecordLinks;
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
            group("&Seminar")
            {
                Caption = '&Seminar';
                action(Dimensions)
                {
                    ApplicationArea = Dimensions;
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedIsBig = true;
                    RunObject = Page "Default Dimensions";
                    RunPageLink = "Table ID" = CONST(123456700),
                                  "No." = FIELD("No.");
                    ShortCutKey = 'Alt+D';
                    ToolTip = 'View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.';
                }
                action("Co&mments")
                {
                    ApplicationArea = Comments;
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    Promoted = true;
                    PromotedCategory = Category6;
                    RunObject = Page "Comment Sheet";
                    RunPageLink = "Table Name" = const(Seminar),
                                  "No." = field("No.");
                    ToolTip = 'View or add comments for the record.';
                }
            }
        }
        area(creation)
        {
            action(NewSeminarRegistration)
            {
                AccessByPermission = tabledata "SEM Seminar Reg. Header" = RIM;
                ApplicationArea = All;
                Caption = 'Seminar Registration';
                Image = NewDocument;
                Promoted = true;
                PromotedCategory = Category4;
                RunObject = Page "SEM Seminar Registration";
                RunPageLink = "Seminar No." = field("No.");
                RunPageMode = Create;
                Visible = NOT IsOfficeAddin;
            }
        }
    }

    var
        IsOfficeAddin: Boolean;

    local procedure ActivateFields()
    var
        OfficeManagement: Codeunit "Office Management";
    begin
        IsOfficeAddin := OfficeManagement.IsAvailable;
    end;
}

