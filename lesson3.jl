"""
Lesson 3 - Transparency initiative

Show a smiley face with a transparent background over a tiled background of red and yellow text.

The original tutorial writes a method for tiling the images, but I haven't bothered.

"""

using SimpleDirectMediaLayer
const SDL = SimpleDirectMediaLayer

sdlerror() = error(unsafe_string(SDL.GetError()))

function checkptr(ptr)
    if ptr == C_NULL
        # The tutorial has us freeing and quitting and all sorts.
        # My philosophy: exit(1) is the simplest way of freeing
        # resources.
        sdlerror()
    else
        ptr
    end
end

function load_texture!(renderer, filename)
    return checkptr(SDL.IMG_LoadTexture(renderer, filename))
end

"""
    draw!(ren, tex::Ptr{SDL.Texture}, x, y)

Draw texture to renderer at position x, y, preserving texture's width and height

"""
function draw!(ren, tex::Ptr{SDL.Texture}, x, y)
    w, h = texture_wh(tex)
    dst = SDL.Rect(Cint.((x, y, w, h))...)
    # Don't know if I should be using Ref or pointer.
    # dst is a regular Julia struct, so it's lifetime is controlled by Julia,
    # so I'm going with Ref.
    SDL.RenderCopy(ren, tex, C_NULL, Ref(dst))
    return nothing
end

function query_texture(tex)
    # Is there a better way to do this?
    # I tried Ref{Cint}(0), but that didn't work.
    format = UInt32[0]
    access = Cint[0]
    w = Cint[0]
    h = Cint[0]
    checkptr(SDL.QueryTexture(tex, format, access, w, h))
    return format[], access[], w[], h[]
end

"Return the width and height of `tex`"
function texture_wh(tex)
    return query_texture(tex)[3:4]
end

### Main

function main()
    screen_width = 640
    screen_height = 480

    checkptr(SDL.Init(SDL.INIT_VIDEO))

    window = checkptr(SDL.CreateWindow(
        "Lesson 2",
        Cint.((100, 100, screen_width, screen_height))...,
        SDL.WINDOW_SHOWN))

    # Flags don't seem important, so I've omitted them
    renderer = checkptr(SDL.CreateRenderer(window, Cint(-1), Cuint(0)))

    background = load_texture!(renderer, "res/Lesson3/background.png" )
    image = load_texture!(renderer, "res/Lesson3/image.png")

    for _ in 1:3
        SDL.RenderClear(renderer)
        bW, bH = texture_wh(background)
        draw!(renderer, background, 0, 0)
        draw!(renderer, background, bW, 0)
        draw!(renderer, background, 0, bH)
        draw!(renderer, background, bW, bH)
        iW, iH = texture_wh(image)
        draw!(renderer, image, screen_width ÷ 2 - iW ÷ 2, screen_height ÷ 2 - iH ÷ 2)
        SDL.RenderPresent(renderer)
        SDL.Delay(Cuint(1000))
    end

    SDL.DestroyTexture(background)
    SDL.DestroyTexture(image)
    SDL.DestroyRenderer(renderer)
    SDL.DestroyWindow(window)
    SDL.IMG_Quit()
    SDL.Quit()
end

main()
