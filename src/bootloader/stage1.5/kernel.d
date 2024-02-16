import print;

extern (C) void boot_main()
{
  putc('D');
loop:
  goto loop;
}
