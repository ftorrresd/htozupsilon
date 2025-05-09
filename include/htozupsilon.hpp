#include "TH1.h"

inline auto add(int i, int j) -> int {
  auto h = TH1F();
  h.Print("all");

  return i + j;
}
