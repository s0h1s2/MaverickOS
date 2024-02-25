#pragma once
#include "types.h"
typedef struct E820Entry {
  u64 base_addr;
  u64 length;
  u32 type;
  u32 acpi_null;
} E820Entry;
void detect_memory();
