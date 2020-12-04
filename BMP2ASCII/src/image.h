#ifndef IMAGE_H
#define IMAGE_H

#include <string>

class Image
{
public:
  
  // CONSTRUCTOR
  Image(std::string filename, int numberOfBytesPerPixel = 3);

  // DESTRUCTOR
  ~Image();

  // GETTERS
  int getWidth() const;
  int getHeight() const;
  
  // FUNCTIONS
  void resize(int w2, int h2);
  void displayASCII() const;
  void invert();

private:
  // FIELDS
  int width;
  int height;
  int *pixels;
  std::string filename;
  int numberOfBytesPerPixel;
  bool inverted;
  
  // CONST FIELDS
  const int HEADER_SIZE = 54;
  const int WIDTH_LOCATION = 18;
  const int HEIGHT_LOCATION = 22;

  static const int SIZE_CHAR = 13;
  const char CHAR_TO_DISPLAY[SIZE_CHAR] = {
      #include "charToDisplay.txt"
    };
  const int CHAR_PADDING = 255 / (SIZE_CHAR - 1); 

  // FUNCTIONS
  void ReadBMP();
};

#endif
