mov eax,offset @@StartCode    // Move(@@StartCode, Code^, @@EndCode-@@StartCode)
mov edx,dword ptr [Code]
mov edx,dword ptr [edx]
mov ecx,offset @@EndCode
sub ecx,offset @@StartCode
call Move
mov ecx,dword ptr [Code]      // ecx := Code;
mov ecx,dword ptr [ecx]
mov eax,offset @@EndCode      // Inc(PByte(Code), (@@EndCode-@@StartCode));
sub eax,offset @@StartCode
mov edx,dword ptr [Code]
add dword ptr [edx],eax
