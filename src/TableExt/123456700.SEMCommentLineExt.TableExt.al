tableextension 123456700 "SEM Comment Line Ext" extends "Comment Line"
{
    fields
    {
        modify("No.")
        {
            TableRelation = if ("Table Name" = const(Seminar)) "SEM Seminar";
        }
    }
}