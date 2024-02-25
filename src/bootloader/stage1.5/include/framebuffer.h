#include "types.h"
typedef enum Color {
  BLACK = 0,
  BLUE,
  GREEN,
  CYAN,
  RED,
  MAGENTA,
  BROWN,
  LGRAY,
  DGRAY,
  LBLUE,
  LGREEN,
  LCYAN,
  LRED,
  LMAGENTA,
  YELLOW,
  WHITE,
} Color;
extern void clear_screen();
void write_char(i8 ch, Color fore, Color back);
void write_str(i8 *s, Color fore, Color back);
void set_cursor(int x, int y);
int get_X();
int get_Y();
