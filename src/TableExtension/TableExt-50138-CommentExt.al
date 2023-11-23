tableextension 50138 CommentExt extends "Comment Line"
{
    fields
    {
        field(50001; "Comment New"; Text[1048])
        {
            DataClassification = ToBeClassified;
        }
    }

    var
        myInt: Integer;
}