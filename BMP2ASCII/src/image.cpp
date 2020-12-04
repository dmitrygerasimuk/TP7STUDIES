#include "image.h"
#include <iostream>

// CONSTRUCTOR
Image::Image(std::string filename, int numberOfBytesPerPixel)
{
  this->filename = filename;
  this->numberOfBytesPerPixel = numberOfBytesPerPixel;
  ReadBMP();
}

// DESTRUCTOR
Image::~Image()
{
  delete [] pixels;
}

// GETTERS
int Image::getWidth() const
{
  return width;
}
int Image::getHeight() const
{
  return height;
}

// PUBLIC FUNCTIONS
void Image::resize(int w2, int h2)
{
  int *temp = new int[w2*h2];
  int x_ratio = (int)((width<<16)/w2) + 1;
  int y_ratio = (int)((height<<16)/h2) + 1;
  int x2, y2;
  for(int i = 0; i < h2; ++i)
  {
    for(int j = 0; j < w2; ++j)
    {
      x2 = ((j*x_ratio)>>16) ;
      y2 = ((i*y_ratio)>>16) ;
      temp[(i*w2)+j] = pixels[(y2*width)+x2];
    }
  }
  delete [] pixels;
  width = w2;
  height = h2;
  pixels = temp;
}

void Image::displayASCII() const
{
  for(int i = height - 1; i >= 0; --i)
  {
    for(int j = 0; j < width; ++j)
    {
      if(inverted)
        std::cout << CHAR_TO_DISPLAY[(255 - pixels[j + i * width])/CHAR_PADDING];
      else
        std::cout << CHAR_TO_DISPLAY[(pixels[j + i * width])/CHAR_PADDING];
    }
    std::cout << std::endl;
  }
}

void Image::invert()
{
  this->inverted = !this->inverted;
}



// PRIVATE FUNCTIONS
void Image::ReadBMP()
{
  int i;
  FILE* file = fopen(filename.c_str(), "rb");

  if(!file)
    throw "Argument Exception";

  unsigned char info[HEADER_SIZE];
  fread(info, sizeof(unsigned char), HEADER_SIZE, file);
    
  width = *(int*)&info[WIDTH_LOCATION];
  height = *(int*)&info[HEIGHT_LOCATION];

  pixels = new int[width * height];

  int row_padded = (width*numberOfBytesPerPixel + numberOfBytesPerPixel) & (~numberOfBytesPerPixel);
    
  unsigned char* data = new unsigned char[row_padded];
  unsigned char tmp;
  int index = 0;
  for(int i = 0; i < height; i++)
  {
    fread(data, sizeof(unsigned char), row_padded, file);
    for(int j = 0; j < width*numberOfBytesPerPixel; j += numberOfBytesPerPixel)
    {
      pixels[index] = 0;
      for(int h = 0; h < numberOfBytesPerPixel; ++h)
      {
        pixels[index] += data[j+h];
      }
      pixels[index] /= numberOfBytesPerPixel;
      ++index;
    }
  }
  fclose(file);
  delete [] data;
}
