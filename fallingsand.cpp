#include <iostream>
#include <vector>
#include <cassert>
#include <algorithm>
int main() { using namespace std;
    auto getblock = [&]() { char c; do{ assert(cin.get(c)); }while(c=='\n');
        assert(c == ' ' || c == '.' || c == '#'); return c; };
    unsigned int N; cin >> N; vector<vector<char>> grid(N, vector<char>(N)); 
    for(auto& row : grid) generate(begin(row), end(row), getblock);
    for(bool steady = false; steady = !steady, steady;)
    for(unsigned int y = N-1; y != 0; y--)
    for(unsigned int x =   0; x <  N; x++)
    if(grid[y][x] == ' ' && grid[y-1][x] == '.' && !(steady = false))
       swap( grid[y][x], grid[y-1][x] );
    for(auto& row : grid) {
        for(auto& elem : row) cout << elem; 
        cout << '\n';     }
}
