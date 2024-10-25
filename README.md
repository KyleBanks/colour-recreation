# Colour Effect

This repository contains a demonstration of how you can create the colour restoration effect from [Farewell North](https://farewell-north.com/links) using simple shader logic.

The main components to understand how the effect is implemented are:

1. [colour_source.gd](./Scripts/colour_source.gd) - represents a single colour source
2. [colour_source_manager.gd](./Scripts/colour_source_manager.gd) - manager which supplies the colour source details to the shader
3. [colour_effect.gdshader](./Shaders/colour_effect.gdshader) - the shader implementing our colour restoration effect

For more information, [check out this YouTube video where I implement and explain the effect.](https://youtu.be/Wr_N6yM4cQE)

## Credits

[KayKit - Dungeon Remastered Pack](https://kaylousberg.itch.io/kaykit-dungeon-remastered) licensed under CC0.

[KayKit - Character Pack : Adventurers](https://kaylousberg.itch.io/kaykit-adventurers) licensed under CC0.
