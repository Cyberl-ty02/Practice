#include"iostream"
using namespace std;

int main() {
    int number;

    std::cout << "Enter a number: ";
    cin >> number;

    if (number > 10)
    {
        std::cout << "Number is greater than 10." << std::endl;
    }
    else if (number < 10)
    {
        std::cout << "Number is less than 10." << std::endl;
    }
    else
    {
        std::cout << "Number is equal to 10." << std::endl;
    }


    return 0;
}