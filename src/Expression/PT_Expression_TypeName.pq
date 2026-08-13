(typeValue as type) as text =>
let
    Result =
        if typeValue = type any then
            "any"
        else if typeValue = type null then
            "null"
        else if typeValue = type logical then
            "logical"
        else if typeValue = type number then
            "number"
        else if typeValue = type text then
            "text"
        else if typeValue = type date then
            "date"
        else if typeValue = type datetime then
            "datetime"
        else if typeValue = type datetimezone then
            "datetimezone"
        else if typeValue = type time then
            "time"
        else if typeValue = type duration then
            "duration"
        else if typeValue = type binary then
            "binary"
        else if typeValue = type list then
            "list"
        else if typeValue = type record then
            "record"
        else if typeValue = type table then
            "table"
        else if typeValue = type function then
            "function"
        else
            "unknown"
in
    Result
