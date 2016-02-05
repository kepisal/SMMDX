{*******************************************************}
{                                                       }
{       SEED Unit v 1.1                                 }
{                                                       }
{       Translator: �̿���, �����                      }
{                                                       }
{*******************************************************}

{*******************************************************}
{ Change History                                        }
{ 2005-02-01 : 1040 ���� ����                           }
{*******************************************************}

{***************************************************************************
* Copyright (c) 2000-2004, Future Systems, Inc. / Seoul, Republic of Korea *
* All Rights Reserved.                                                     *
*                                                                          *
* This document contains proprietary and confidential information.  No     *
* parts of this document or the computer program it embodies may be in     *
* any way copied, duplicated, reproduced, translated into a different      *
* programming language, or distributed to any person, company, or          *
* corporation without the prior written consent of Future Systems, Inc.    *
*                              Hyo Sun Hwang                               *
*                372-2 YangJae B/D 6th Floor, Seoul, Korea                 *
*                           +82-2-578-0581 (552)                           *
***************************************************************************}
{*--------------------- [ Version/Command in detais] ---------------------*\
Description : seed.h
   (head file) head file for seed.c : Block Cipher SEED
C0000 : Created by Hyo Sun Hwang (hyosun@future.co.kr) 2000/12/31

C0001 : Modified by Hyo Sun Hwang (hyosun@future.co.kr) 2000/00/00
\*------------------------------------------------------------------------*}

unit SEED;

interface

const
  ////	���� �Ʒ��� 4�� ����� �����Ѵ�.
  AI_ECB = 1;
  AI_CBC = 2;
  AI_OFB = 3;
  AI_CFB = 4;
  ////	���� �Ʒ��� �� padding�� �����Ѵ�.
  AI_NO_PADDING = 1; //	Padding ����(�Է��� 16����Ʈ�� ���)
  AI_PKCS_PADDING = 2; //	padding�Ǵ� ����Ʈ ���� padding
  ////	SEED�� ���õ� �����
  SEED_BLOCK_LEN = 16; //	in BYTEs
  SEED_USER_KEY_LEN = 16; //	in BYTEs
  SEED_NO_ROUNDS = 16;
  SEED_NO_ROUNDKEY = (2 * SEED_NO_ROUNDS); //	in DWORDs

  ////	Error Code - �����ϰ�, ������ ����ؾ� ��.
  CTR_SUCCESS = 0;
  CTR_FATAL_ERROR = $1001;
  CTR_INVALID_USERKEYLEN = $1002; //	���Ű�� ���̰� ��������.
  CTR_PAD_CHECK_ERROR = $1003; //
  CTR_DATA_LEN_ERROR = $1004; //	���� ���̰� ��������.
  CTR_CIPHER_LEN_ERROR = $1005; //	��ȣ���� ����� ����� �ƴ�.

type
  PDWORD = ^DWORD;
  DWORD = Longword;
  BOOL = Integer;

  RET_VAL = DWORD; //	return values

  PByte = ^Byte;
  ////	SEED..
  PSEED_ALG_INFO = ^SEED_ALG_INFO;
  SEED_ALG_INFO = packed record
    ModeID: DWORD; //	ECB or CBC
    PadType: DWORD; //	��Ͼ�ȣ�� Padding type
    IV: array[0..SEED_BLOCK_LEN - 1] of BYTE; //	Initial Vector
    ChainVar: array[0..SEED_BLOCK_LEN - 1] of BYTE; //	Chaining Variable
    Buffer: array[0..SEED_BLOCK_LEN - 1] of BYTE; //	Buffer for unfilled block
    BufLen: DWORD; //	Buffer�� ��ȿ ����Ʈ ��
    RoundKey: array[0..SEED_NO_ROUNDKEY - 1] of DWORD; //	���� Ű�� DWORD ��
  end;

function SeedEnc(AKey, APlainText: string): string;
function SeedDec(AKey, AEncText: string): string;
function SeedDecFromBase64(AKey, ADecText: string): string;
function SeedEncToBase64(AKey, AEncText: string): string;

implementation

uses
  SysUtils
  , Classes // for TStringStream
  , HAS160
{$IFDEF BASE64}
  , IdCoderMIME
{$ENDIF BASE64}
  //, Base64
  , DCPbase64
;

const
  OBJSEED = 'seed.obj';
  OBJSEEDENC = 'seedenc.obj';
var
  TestUserKey: array[0..SEED_USER_KEY_LEN - 1] of BYTE = ($01, $23, $45, $67, $89, $AB, $CD, $EF, $12, $34, $56, $78, $9A, $BC,
    $DE, $F0);
  IVs: array[0..SEED_USER_KEY_LEN - 1] of BYTE = ($FE, $DC, $BA, $98, $76, $54, $32, $10, $FE, $DC, $BA, $98, $76, $54, $32, $10);

  {$L seedenc.obj}
  {$L seed.obj}
  ////	����Ÿ Ÿ�� SEED_ALG_INFO�� mode, padding ���� �� IV ���� �ʱ�ȭ�Ѵ�.
procedure SEED_SetAlgInfo(
  ModeID: Cardinal;
  PadType: Cardinal;
  PIV: PByte;
  PAlgInfo: PSEED_ALG_INFO); external; // OBJSEEDENC;
////	�Էµ� SEED_USER_KEY_LEN����Ʈ�� ���Ű�� ���� Ű ����
function SEED_KeySchedule(
  UserKey: PByte; //	����� ���Ű�� �Է���.
  UserKeyLen: Cardinal;
  PAlgInfo: PSEED_ALG_INFO): RET_VAL; external; // OBJSEED; //	�Ϻ�ȣ�� Round Key�� �����.

////	Init/Update/Final ������ ��ȣȭ.
function SEED_EncInit(
  PAlgInfo: PSEED_ALG_INFO): RET_VAL; external; // OBJSEEDENC;

function SEED_EncUpdate(
  PAlgInfo: PSEED_ALG_INFO;
  PPlainTxt: PByte; //	���� �Էµ�.
  PlainTxtLen: DWORD;
  PCipherTxt: PByte; //	��ȣ���� ��µ�.
  PCipherTxtLen: PDWORD): RET_VAL; external; // OBJSEEDENC;

function SEED_EncFinal(
  PAlgInfo: PSEED_ALG_INFO;
  CipherTxt: PBYTE; //	��ȣ���� ��µ�.
  CipherTxtLen: PDWORD): RET_VAL; external; // OBJSEEDENC;

////	Init/Update/Final ������ ��ȣȭ.
function SEED_DecInit(
  PAlgInfo: PSEED_ALG_INFO): RET_VAL; external; // OBJSEEDENC;

function SEED_DecUpdate(
  PAlgInfo: PSEED_ALG_INFO;
  CipherTxt: PBYTE; //	��ȣ���� �Էµ�.
  CipherTxtLen: LongInt;
  PlainTxt: PBYTE; //	��ȣ���� ��µ�.
  PlainTxtLen: PDWORD): RET_VAL; external; // OBJSEEDENC;

function SEED_DecFinal(
  PAlgInfo: PSEED_ALG_INFO;
  PlainTxt: PBYTE; //	��ȣ���� ��µ�.
  PlainTxtLen: PDWORD): RET_VAL; external; // OBJSEEDENC;

procedure SEED_Encrypt(
  CipherKey: Pointer; //	��/��ȣ�� Round Key
  Data: PBYTE); external; // OBJSEED;

procedure SEED_Decrypt(
  CipherKey: Pointer; //	��/��ȣ�� Round Key
  Data: PBYTE); external; // OBJSEED; //	������� ���� ����� ����Ű�� pointer

procedure _memset(P: Pointer; B: Byte; count: Integer); cdecl;
begin
  FillChar(P^, count, B);
end;

procedure _memcpy(dest, source: Pointer; count: Integer); cdecl;
begin
  Move(source^, dest^, count);
end;

function SeedCommon(AEncType, AModeType, APadType: Cardinal; AKey, AText: string): string;
const
  BufferSize = 1024;
var
  AlgInfo: SEED_ALG_INFO;
  Ret: Integer;
  SrcLen, DstLen: Cardinal;
  SrcStrm, DstStrm: TStringStream;
  SrcData: array[0..1024+32-1] of Byte;
  DstData: array[0..1024+32-1] of Byte;
  ExceptCaseBufferSize : Integer;
begin
  SEED_SetAlgInfo(AModeType, APadType, @IVs[0], @AlgInfo);
//  Ret := SEED_KeySchedule(@TestUserKey[0], 16, @AlgInfo);
  Ret := SEED_KeySchedule(@AKey[1], 16, @AlgInfo);
  if Ret <> CTR_SUCCESS then
    raise Exception.Create(Format('SEED_KeySchedule return %d.', [Ret]))
  else
  begin
    if AEncType = 0 then // Encode
    begin
      Ret := SEED_EncInit(@AlgInfo);
      if Ret <> CTR_SUCCESS then
        raise Exception.Create(Format('SEED_EncInit return %d.', [Ret]))
      else
      begin
        try
          SrcStrm := TStringStream.Create(AText);
          DstStrm := TStringStream.Create('');

          while True do
          begin
            SrcLen := SrcStrm.Read(SrcData, BufferSize);
            if SrcLen = 0 then Break;

            DstLen := 1024;
            Ret := SEED_EncUpdate(@AlgInfo, @SrcData[0], SrcLen, @DstData[0], @DstLen);
            if ret <> CTR_SUCCESS then
              raise Exception.Create(Format('SEED_EncUpdate return %d.', [Ret]));

            DstStrm.Write(DstData, DstLen);
          end;

          DstLen := 1024;
          Ret := SEED_EncFinal(@AlgInfo, @DstData[0], @DstLen);
          if Ret <> CTR_SUCCESS then
            raise Exception.Create(Format('SEED_EncUpdate return %d.', [Ret]));
          DstStrm.Write(DstData, DstLen);
        finally
          Result := DstStrm.DataString;
          if Assigned(SrcStrm) then FreeAndNil(SrcStrm);
          if Assigned(DstStrm) then FreeAndNil(DstStrm);
        end;
      end;
    end
    else
    begin // Decode
      Ret := SEED_DecInit(@AlgInfo);
      if Ret <> CTR_SUCCESS then
        raise Exception.Create(Format('SEED_DecInit return %d.', [Ret]))
      else
      begin
        try
          // nullvana ���ܰ�찡 �ִ�. ������ ���̰� (1024*n)~((1024*n)+15)�̰� ��ȣ���� ���̰� (1024*n)+16�϶�, 16����Ʈ�� �� �о����.  
          if ((Length(AText) - 16) mod BufferSize) = 0 then
            ExceptCaseBufferSize := BufferSize + 16
          else
            ExceptCaseBufferSize := BufferSize;
            
          SrcStrm := TStringStream.Create(AText);
          DstStrm := TStringStream.Create('');

          while True do
          begin
            SrcLen := SrcStrm.Read(SrcData, ExceptCaseBufferSize);
            ExceptCaseBufferSize := BufferSize;
            if SrcLen = 0 then Break;

            DstLen := 1024;
            Ret := SEED_DecUpdate(@AlgInfo, @SrcData[0], SrcLen, @DstData[0], @DstLen);
            if ret <> CTR_SUCCESS then
              raise Exception.Create(Format('SEED_DecUpdate return %d.', [Ret]));

            DstStrm.Write(DstData, DstLen);
          end;

          DstLen := 1024;
          Ret := SEED_DecFinal(@AlgInfo, @DstData[0], @DstLen);
          if Ret <> CTR_SUCCESS then
            raise Exception.Create(Format('SEED_DecFinal return %d.', [Ret]));
          DstStrm.Write(DstData, DstLen);
        finally
          Result := DstStrm.DataString;
          if Assigned(SrcStrm) then FreeAndNil(SrcStrm);
          if Assigned(DstStrm) then FreeAndNil(DstStrm);
        end;
      end;
    end;
  end;
end;

function SeedEnc(AKey, APlainText: string): string;
{$IFDEF BASE64}
var
  Base64Enc: TIdEncoderMIME;
{$ENDIF BASE64}
begin
  AKey := HAS160Hash(AKey);
  Result := SeedCommon(0, AI_CBC, AI_PKCS_PADDING, Copy(AKey,1,16), APlainText);
{$IFDEF BASE64}
  try
    Base64Enc := TIdEncoderMIME.Create(nil);
    Result := Base64Enc.Encode(Result);
  finally
    if Assigned(Base64Enc) then FreeAndNil(Base64Enc);
  end;
{$ENDIF BASE64}
end;

function SeedDec(AKey, AEncText: string): string;
{$IFDEF BASE64}
var
  Base64Dec: TIdDecoderMIME;
{$ENDIF BASE64}
begin
  AKey := HAS160Hash(AKey);
{$IFDEF BASE64}
  try
    Base64Dec := TIdDecoderMIME.Create(nil);
    AEncText := Base64Dec.DecodeString(AEncText);
  finally
    if Assigned(Base64Dec) then FreeAndNil(Base64Dec);
  end;
{$ENDIF BASE64}
  Result := SeedCommon(1, AI_CBC, AI_PKCS_PADDING, Copy(AKey,1,16), AEncText);
end;

function SeedEncToBase64(AKey, AEncText: string): string;
begin
  AKey := HAS160Hash(AKey);

  Result := Base64EncodeStr(SeedCommon(0, AI_CBC, AI_PKCS_PADDING, Copy(AKey,1,16), AEncText));
end;

function SeedDecFromBase64(AKey, ADecText: string): string;
begin
  AKey := HAS160Hash(AKey);
  Result := SeedCommon(1, AI_CBC, AI_PKCS_PADDING, Copy(AKey,1,16), Base64DecodeStr(ADecText));
end;


end.

