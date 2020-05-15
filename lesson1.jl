"""
Lesson 1 - Hello world

I haven't bothered with porting the error handling.

The free and destroy functions don't modify the pointers,
so be careful not to reuse a stale pointer.

I had variable success running this manually at the REPL. Seems
like if you run the commands too slowly, the image doesn't
get shown for some reason.

"""

using SimpleDirectMediaLayer
const SDL = SimpleDirectMediaLayer

sdlerror() = unsafe_string(SDL.GetError())
function checkptr(ptr)
    if ptr == C_NULL
        error(sdlerror())
    end
end
checkptr(ptrs...) = foreach(checkptr, ptrs)

SDL.Init(SDL.INIT_VIDEO)

window = SDL.CreateWindow("Hello!", Cint.((100, 100, 640, 480))..., SDL.WINDOW_SHOWN)
checkptr(window)

# Flags don't seem important, so I've omitted them
renderer = SDL.CreateRenderer(window, Cint(-1), Cuint(0))
checkptr(renderer)

surface = SDL.LoadBMP("res/Lesson1/hello.bmp")
texture = SDL.CreateTextureFromSurface(renderer, surface)
checkptr(surface, texture)

SDL.FreeSurface(surface)
surface = C_NULL

for _ in 1:3
    SDL.RenderClear(renderer)
    SDL.RenderCopy(renderer, texture, C_NULL, C_NULL)
    SDL.RenderPresent(renderer)
    SDL.Delay(Cuint(1000))
end

SDL.DestroyTexture(texture)
SDL.DestroyRenderer(renderer)
SDL.DestroyWindow(window)
SDL.Quit()
