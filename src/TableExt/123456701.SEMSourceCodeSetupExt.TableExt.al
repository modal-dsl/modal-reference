tableextension 123456701 "SEM Source Code Setup Ext" extends "Source Code Setup"
{
    fields
    {
        field(123456700; "SEM Seminar Registration"; Code[10])
        {
            Caption = 'Seminar Registration';
            TableRelation = "Source Code";
        }
    }
}