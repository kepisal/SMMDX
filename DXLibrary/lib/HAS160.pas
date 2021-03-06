unit HAS160;

interface

const
  HAS160_DIGEST_BLOCKLEN = 64; //	in bytes
  HAS160_DIGEST_VALUELEN = 20; //	in bytes

  CTR_SUCCESS = 0;

type
  DWORD = Longword;
  BOOL = Integer;
  RET_VAL = DWORD; //	return values

  PHAS160_ALG_INFO = ^HAS160_ALG_INFO;
  HAS160_ALG_INFO = packed record
    ChainVar: array[0..4] of DWORD;
    Count: array[0..3] of DWORD;
    Buffer: array[0..HAS160_DIGEST_BLOCKLEN - 1] of BYTE;
  end;

function HAS160Hash(AMessage: string): string;

implementation

{$L has160.obj}
procedure HAS160_Init(PAlgInfo: PHAS160_ALG_INFO); external;
procedure HAS160_Update(PAlgInfo: PHAS160_ALG_INFO; Message: PChar; MessageLen: DWORD); external;
procedure HAS160_Final(PAlgInfo: PHAS160_ALG_INFO; Digest: PChar); external;

{
// nullvana 2004-07-26
// 사용하지않음. 메모용.
function __lrotl(val: DWORD; count: BYTE): DWORD; cdecl;
asm
  mov eax, val
  mov cl, count
  rol eax, cl
  mov dword ptr [Result], eax
end;
}

procedure _memset(P: Pointer; B: Byte; count: Integer); cdecl;
begin
  FillChar(P^, count, B);
end;

procedure _memcpy(dest, source: Pointer; count: Integer); cdecl;
begin
  Move(source^, dest^, count);
end;

function HAS160Hash(AMessage: string): string;
var
  AlgInfo: HAS160_ALG_INFO;
begin
  HAS160_Init(@AlgInfo);
  HAS160_Update(@AlgInfo, PChar(AMessage), Length(AMessage));
  SetLength(Result, HAS160_DIGEST_VALUELEN);
  HAS160_Final(@AlgInfo, PChar(Result));
end;

end.



















