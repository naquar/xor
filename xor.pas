program xor_;

(*
    This program performs XOR operation on input data from standard input and
    sends to standard output.
*)

uses
  SysUtils;

const
  stdin  = 0;
  stdout = 1;
  stderr = 2;

const
  sl = #10;
  dl = sl+sl;

var
  fd0        : file of byte;
  buf0       : ^byte;
  count_read : sizeint;
  count_read2: sizeint;
  secret_key : ^byte;
  key_len    : sizeuint;
  key_pos    : sizeuint;
  lp0        : sizeuint;

var
  exe_name: string;

procedure show_help();
begin
  Write({$I %LOCAL_DATE%},sl);
  Write('xor is a program to perform xor operation on files.',dl);

  Write('Usage:',sl);
  Write('To xor a file:',sl);
  Write('  cat /path/to/file.data | ',exe_name,' /path/to/key.data',dl);

  Write('Note:',sl);
  Write('  Key file must be of same length as input data.',sl);

  halt(0);
end;

begin
  exe_name := ExtractFileName(ParamStr(0));

  count_read := 0;

  if (ParamCount <> 1) or not (FileExists(ParamStr(1))) then show_help();

  // read key data from file
  Assign(fd0, ParamStr(1));
  Reset(fd0);

  secret_key := GetMem(1024*1024);
  buf0       := GetMem(1024*1024);

  BlockRead(fd0, secret_key^, 1024*1024, count_read);

  key_len := count_read;
  key_pos := 0;

  repeat
    count_read2 := FileRead(stdin, buf0^, 1024*1024);

    if count_read2 = 0 then break;

    for lp0 := 0 to count_read2-1 do
    begin
      buf0[lp0] := buf0[lp0] xor secret_key[key_pos];

      inc(key_pos);

      if key_pos = key_len then
      begin
        BlockRead(fd0, secret_key^, 1024*1024, count_read);

        key_len := count_read;
        key_pos := 0;
      end;
    end;

    FileWrite(stdout, buf0^, count_read2);
  until 0<>0;

  FreeMem(buf0);
  FreeMem(secret_key);
end.