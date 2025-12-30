#include <vector>

using namespace std;

typedef class board {
    public:
        int x;
        int y;
    private:
        int capacity;
        int count;
        vector<vector<int>> board;
}board_t;

board_t board_t::newBoard(int x, int y);