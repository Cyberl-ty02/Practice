#include "iostream"
using namespace std;

int main() {
    int sum=0;
    const size_t count = 10; // Define count

    for (size_t i = 0; i <= count; i++)
    {
        sum += i; //Gauss sum
    }

    cout << "1 to 10 Gauss sum is " << sum << endl;
    return 0;
}