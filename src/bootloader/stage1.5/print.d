void putc(char c){
  ubyte *p=cast(ubyte*)0xb8000;
  *p=c;
}
