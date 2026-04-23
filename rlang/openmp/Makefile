CC = clang
NAME = hw

CFLAGS = -Xpreprocessor -fopenmp -I/opt/homebrew/opt/libomp/include
LIBS = -lomp
LDFLAGS = -L/opt/homebrew/opt/libomp/lib

OBJS = $(NAME).o

%.o : %.c
	$(CC) $(CFLAGS) -c $< -o $@

$(NAME): $(OBJS)
	$(CC) $(CFLAGS) -o $@ $(OBJS) $(LIBS) $(LDFLAGS)

clean:
	rm -f *.o
	rm -f $(NAME)
