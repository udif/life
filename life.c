#define X 8
#define Y 8
#define ONE(x,y) (1LL << (X*(y)+x))

void main(int argc, char *argv[])
{
  unsigned long long data;
  int x = 0;
  int y = 0;
  int gen;
  int cell, new, sum, l , r, u, d, lu, ld, ru, rd, pipe, pipe_out;

  data = ONE(1,2) | ONE(2,2) | ONE(3,2) | ONE(3,3) | ONE(2,4);

  for (gen = 1; gen < 100; gen++) {
    system("clear");
    printf("Gen: %d\n", gen);
    printf("---------------\n");
    for (y = 0; y < Y; y++) {
      for (x = 0; x < X; x++) {
        cell = data & 1;
        printf ("%01d ", cell);
        l = (x < (X-1)) ? ((data >> 1) & 1)  : 0;
        r = (x >= 1)    ? ((data >> (X*Y-1)) & 1) : 0;
        u = (y < (Y-1)) ? ((data >> X) & 1)  : 0;
        d = (y >= 1)    ? ((data >> ((Y-1)*X)) & 1) : 0;
        lu = ((x < (X-1)) && (y < (Y-1))) ? ((data >> (X+1))  & 1)  : 0;
        ru = ((x >= 1)    && (y < (Y-1))) ? ((data >> (X-1))  & 1)  : 0;
        ld = ((x < (X-1)) && (y >= 1))    ? ((data >> ((Y-1)*X+1)) & 1)  : 0;
        rd = ((x >= 1)    && (y >= 1))    ? ((data >> ((Y-1)*X-1)) & 1)  : 0;
        sum = l + r + u + d + lu + ru + ld + rd;
        new = (sum == 3) ? 1 : (sum == 2) ? cell : 0;
        // printf ("x:%d y:%d new:%d sum:%d\n", x, y, new, sum);
        pipe = (pipe << 1) | new;
        pipe_out = ((pipe >> (X+2)) & 1);
        data = (data >> 1) | ((data & 1) << (X*Y-1));
        data = data & ~(1LL << ((Y-1)*X-3)) | (pipe_out  ? (1LL << ((Y-1)*X-3)) : 0);
      }
      printf("\n");
    }
    getch();
  }
}

