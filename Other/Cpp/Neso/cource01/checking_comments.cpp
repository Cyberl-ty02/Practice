#include <iostream>

// P.S. Comments are not allowed to be nested in C++.
int main() {
    std::cout << "/*";
    std::cout << "*/";
    std::cout << "/* \"*/\" */";
    std::cout << "/* \"*/\" /* \"/*\" */";
    return 0;
}