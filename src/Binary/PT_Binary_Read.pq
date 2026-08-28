(data as binary, offset as number, binaryFormat_type as function, byteorder_type as number) as number =>
let
    size =
        if binaryFormat_type = BinaryFormat.Byte then 1
        else if binaryFormat_type = BinaryFormat.UnsignedInteger16 then 2
        else if binaryFormat_type = BinaryFormat.UnsignedInteger32 then 4
        else if binaryFormat_type = BinaryFormat.UnsignedInteger64 then 8
        else if binaryFormat_type = BinaryFormat.SignedInteger16 then 2
        else if binaryFormat_type = BinaryFormat.SignedInteger32 then 4
        else if binaryFormat_type = BinaryFormat.SignedInteger64 then 8
        else if binaryFormat_type = BinaryFormat.Single then 4
        else if binaryFormat_type = BinaryFormat.Double then 8
        else error 1
in
    BinaryFormat.ByteOrder(binaryFormat_type, byteorder_type)(Binary.Range(data, offset, size))
