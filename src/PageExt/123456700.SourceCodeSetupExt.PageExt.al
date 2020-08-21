pageextension 123456700 "Source Code Setup Ext" extends "Source Code Setup"
{
    layout
    {
        addafter("Cost Accounting")
        {
            group("Seminar Management")
            {
                Caption = 'Seminar Management';

                field(SEMSeminarRegistration; "SEM Seminar Registration")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}
