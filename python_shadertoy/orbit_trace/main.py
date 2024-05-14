import arcade
from arcade.experimental import Shadertoy

# Derive an application window from Arcade's parent Window class
class MyGame(arcade.Window):

    def __init__(self):
        # Call the parent constructor
        super().__init__(width=1000, height=800)

        self.time = 0.0
        # Load a file and create a shader from it
        shader_file_path = "trace.glsl"
        window_size = self.get_size()
        self.shadertoy = Shadertoy.create_from_file(window_size, shader_file_path)

    def on_draw(self):
        # Set uniform data to send to the GLSL shader
        # Run the GLSL code
        self.shadertoy.render(time = self.time)

    def on_update(self, delta_time: float):
        # Track run time
        self.time += delta_time

if __name__ == "__main__":
    MyGame()
    arcade.run()