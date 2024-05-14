import arcade
from arcade.experimental import Shadertoy

# Derive an application window from Arcade's parent Window class
class MyGame(arcade.Window):

    def __init__(self):
        # Call the parent constructor
        super().__init__(width=800, height=600)

        self.time = 0.0
        # Load a file and create a shader from it
        shader_file_path = "mandelbrot.glsl"
        window_size = self.get_size()
        self.shadertoy = Shadertoy.create_from_file(window_size, shader_file_path)
        print(self.get_location())
    def on_draw(self):
        # Set uniform data to send to the GLSL shader
        # Run the GLSL code
        self.shadertoy.render(time = self.time)
        self.get_location() #top right of frame
        
    def on_update(self, delta_time: float):
        # Track run time
        self.time += delta_time

if __name__ == "__main__":
    MyGame()
    arcade.run()