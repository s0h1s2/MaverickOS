import print;
extern (C) void boot_main()
{
  //string hello="Hello,world!";
  putc('B');
  //puts(hello);
loop:
  goto loop;
}
