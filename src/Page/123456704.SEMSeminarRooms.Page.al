page 123456704 "SEM Seminar Rooms"
{
    ApplicationArea = All;
    Caption = 'Seminar Rooms';
    PageType = List;
    SourceTable = "SEM Seminar Room";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("Code"; Code)
                {
                    ApplicationArea = All;
                }
                field(InternalExternal; "Internal/External")
                {
                    ApplicationArea = All;
                }
                field(Name; Name)
                {
                    ApplicationArea = All;
                }
                field("Name 2"; "Name 2")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field(ResourceNo; "Resource No.")
                {
                    ApplicationArea = All;
                }
                field(MaxParticipants; "Maximum Participants")
                {
                    ApplicationArea = All;
                }
                field(Address; Address)
                {
                    ApplicationArea = All;
                    QuickEntry = false;
                }
                field(Address2; "Address 2")
                {
                    ApplicationArea = All;
                    QuickEntry = false;
                }
                field(City; City)
                {
                    ApplicationArea = All;
                    QuickEntry = false;
                }
                field(County; County)
                {
                    ApplicationArea = All;
                    QuickEntry = false;
                }
                field(PostCode; "Post Code")
                {
                    ApplicationArea = All;
                    QuickEntry = false;
                }
                field(CountryRegionCode; "Country/Region Code")
                {
                    ApplicationArea = All;
                    QuickEntry = false;
                }
                field(ContactPerson; "Contact Person")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field(PhoneNo; "Phone No.")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field(TelexNo; "Telex No.")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field(FaxNo; "Fax No.")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field(TelexAnswerBack; "Telex Answer Back")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field(EMail; "E-Mail")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field(HomePage; "Home Page")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field(SalespersonCode; "Salesperson Code")
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
}
