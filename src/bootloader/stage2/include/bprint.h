typedef enum Color {
  BLACK = 0,
  BLUE,
  GREEN,
  CYAN,
  RED,
  PURPLE,
  BROWN,
  GRAY,
  DARKGRAY,
  LIGHTBLUE,
  LIGHTGREEN,
  WHITE = 15,
} Color;

void bputc(char c, Color color);
void bprints(char *src);
