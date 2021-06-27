# tcp\_com

make a tcp server using libdill library as suggested in the Book Modern Fortran of Milan Curcic


## dependencies

For now, you need to install libdill (I plan to add a external project to manage that dependency)

## compiling with cmake

- first export the variable `DILL_LIB_DIR`
```bash
export DILL_LIB_DIR=/path/to/the/directory/containing/libdill.a
```
- configure with cmake
```bash
cmake -B build 
```
- compile
```bash
make -C build
```
- run 
```bash
cd build && ./tcp_server 
tmux new netcat 127.0.0.1 5555
```
