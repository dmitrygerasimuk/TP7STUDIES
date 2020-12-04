#include <string>
#include <iostream>
#include <cstdlib>
#include "src/image.h"

int main(int argc, char** argv)
{
  if(argc < 3 || argc > 6)
  {
    std::cerr << "Usage: ./bmptoascii <filename> <byteperpixel> [i]" << std::endl;
    std::cerr << "   or: ./bmptoascii <filename> <byteperpixel> <width> <height> [i]" << std::endl;
    return 1;
  }
  Image img(argv[1],atoi(argv[2]));
  if(argc == 4 || argc == 6)
  {
    img.invert();   
  }
  if(argc == 5 || argc == 6)
  {
    img.resize(atoi(argv[3]),atoi(argv[4]));  
  }
  
  img.displayASCII();
  return 0;
}
