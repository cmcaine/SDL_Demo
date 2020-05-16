# Julia SDL Demos

Porting the exercises in [Will Usher's SDL2 Tutorials][Usher tutorials] to Julia.

It hasn't been too bad, though the C API is a bit awkward to use from Julia because:

1. Referencing and dereferencing are a bit unergonomic
2. Coercing a bunch of stuff to `Cint` or whatever is ugly
3. SDL seems to get confused if you send instructions to it really slowly (like manually from a REPL)


## Future

I'd like to provide an interface which lets you draw an array of some [Colors.jl][Colors.jl] type to a window easily and quick enough for simple games (perhaps with reduced resolution).

The idea is that you can just pretend you have direct memory access to the screen buffer and not bother with special line drawing functions and so on. Probably this is folly, but I think it might work pretty well for old-style arcade games.

I think I can implement this okay with `SDL_CreateTexture` and then either just UpdateTexture or in streaming mode with Lock and Unlock. One pain point might be conversion from Colors types to something that SDL can understand. Probably I'll have to write a custom array type, but that's fine.


[Usher tutorials]: https://www.willusher.io/pages/sdl2/
[Colors.jl]: https://github.com/JuliaGraphics/Colors.jl
