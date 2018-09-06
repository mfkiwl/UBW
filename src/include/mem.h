#ifndef UBW_MEM_H_
#define UBW_MEM_H_

#include "type.h"

void *malloc(size_t length);
void free(void *ptr);
void *memset(void *dest, uint8_t byte, size_t length);
void *memcpy(void *dest, void *src, size_t length);

#endif // UBW_MEM_H_
