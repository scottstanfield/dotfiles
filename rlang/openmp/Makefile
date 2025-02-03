CC = clang
NAME = hw

#CFLAGS = -I/opt/homebrew/opt/llvm/include
CFLAGS = -fopenmp
LIBS = -fopenmp
LDFLAGS = -L/opt/homebrew/opt/llvm/lib

OBJS = $(NAME).o

%.o : %.c
	$(CC) $(CFLAGS) -c $< -o $@

$(NAME): $(OBJS)
	$(CC) $(CFLAGS) -o $@ $(OBJS) $(LIBS) $(LDFLAGS)

clean:
	rm -f *.o
	rm -f $(NAME)
