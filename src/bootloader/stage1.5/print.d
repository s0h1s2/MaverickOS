ubyte *p=cast(ubyte*)0xb8000;

void putc(char c){
  *p=c;
   p++;
}
void puts(string text){
    for(int i=0;i<text.length;i++){
      putc(text[i]);
    }
}
