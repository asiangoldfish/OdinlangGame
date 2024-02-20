package main

import "core:fmt"
import SDL "vendor:sdl2"

WINDOW_FLAGS :: SDL.WINDOW_SHOWN
RENDER_FLAGS :: SDL.RENDERER_ACCELERATED
TARGET_DT :: 1000/60

Game :: struct {
	perf_frequency: f64,
	renderer: ^SDL.Renderer
}

game := Game{}

main :: proc() {
	fmt.println("hei")
	// Initlialize SDL
	assert(SDL.Init(SDL.INIT_VIDEO) == 0, SDL.GetErrorString())
	defer SDL.Quit()

	window := SDL.CreateWindow(
		"Odin Space Shooter",
		SDL.WINDOWPOS_CENTERED,
		SDL.WINDOWPOS_CENTERED,
		640,
		480,
		WINDOW_FLAGS
	)
	assert(window != nil, SDL.GetErrorString())
	defer SDL.DestroyWindow(window)

	// Must not do VSync because we runn the tick loop on the same thread
	game.renderer = SDL.CreateRenderer(window, -1, RENDER_FLAGS)
	assert(game.renderer != nil, SDL.GetErrorString())
	defer SDL.DestroyRenderer(game.renderer)

	game.perf_frequency = f64(SDL.GetPerformanceFrequency())
	start : f64
	end : f64

	event : SDL.Event
	state := SDL.GetKeyboardState(nil)

	game_loop : for {
		start = get_time()

		if SDL.PollEvent(&event) {
			if event.type == SDL.EventType.QUIT {
				break game_loop
			}
			if event.type == SDL.EventType.KEYDOWN {
				#partial switch event.key.keysym.scancode {
					case .ESCAPE:
						break game_loop
				}
			}
		}

		SDL.RenderPresent(game.renderer)
		SDL.SetRenderDrawColor(game.renderer, 0,0,0,100)
		SDL.RenderClear(game.renderer)
	}
}

get_time :: proc() -> f64 {
	return f64(SDL.GetPerformanceCounter()) * 1000 / game.perf_frequency
}