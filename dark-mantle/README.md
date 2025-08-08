# CSG Terrain
<p align="center" width="100%">
  <img width="501px" src="https://github.com/user-attachments/assets/dca0127c-8349-41f5-9dcc-a66836708446"
</p>

> ### Prototype your terrain faster with the power of curves and [CSG nodes](https://docs.godotengine.org/en/stable/tutorials/3d/csg_tools.html).

**Video Tutorial:** https://www.youtube.com/watch?v=WvpFUpjmPUc


## What is it?
CSG Terrain is a plugin for [Godot Engine](https://godotengine.org/) 4.4 (or later) to prototype terrains on a simple and non-destructive way. It's made with CSG (Constructive Solid Geometry), so you are supposed to combine with geometric shapes and even other terrains to achieve the desired form. [Read more about CSG](https://docs.godotengine.org/en/stable/tutorials/3d/csg_tools.html).

Unlike other systems **the terrain is molded purely with paths, not brushes or other 3D tools**. This forced simplicity allows to focus on what is important before finalizing in 3D software.

CSG Terrain is based on 3D meshes that can be baked to make compatible with Godot's Baked Global Illumination [(LightmapGI)](https://docs.godotengine.org/en/stable/tutorials/3d/global_illumination/using_lightmap_gi.html) and can be exported to 3D software such as [Blender](https://www.blender.org/).


## How does it work?
When placing a CSG Terrain node, it will also place a Path3D in the middle and the terrain will follow it.

This is the basic idea: You place paths, and the terrain follows.

You can place several Path3D nodes as needed.


## How to install
1) Download the file `CSG_Terrain_v1.0.2.zip` from the [Download Page.](https://github.com/SpockBauru/CSG_Terrain/releases)
2) Extract the `addons` folder on the root of your project (`res://`). Other files/folders are optional.
3) Go to Godot's "Project" menu -> "Project Settings" -> "Plugins" tab -> enable "CSG Terrain".
4) Place the CSGTerrain node in your scene. \o/


## The CSG Terrain node
<p align="center" width="100%">
  <img width="600px" src="https://github.com/user-attachments/assets/2bd96e3e-2f21-4f41-a8ce-556c311f94e7"
</p>


Place the CSG Terrain node in "Add Node" -> "Search" -> type CSGTerrain. The node comes with several parameters:

**Size:** The size of each side of the terrain. Terrains will always be squared. Smaller terrains will have higher vertex density and vice versa.

**Divs:** The number of faces on each side of the terrain. Higher values will cause slowdown and are not recommended. Place several smaller terrains instead.

**Path Mask Resolution:** The resolution of the mask applied to the path texture. Only change if the [Path Texture](#the-path-workflow) is not merging accordingly.

**Bake Terrain Mesh:** Create a MeshInstance3D without the bottom cube. It will be placed below the CSG Terrain node. This step is necessary in order to be compatible with Godot's Baked Global Illumination [(LightmapGI)](https://docs.godotengine.org/en/stable/tutorials/3d/global_illumination/using_lightmap_gi.html).

**Export Terrain File:** Save the mesh without the bottom cube to a glTF file so it can be edited in 3D software.


## The Path workflow
<p align="center" width="100%">
  <img width="500px" src="https://github.com/user-attachments/assets/513440c5-b64b-40d8-a647-67a825e0e661"
</p>

The terrain follows the line between the points of the path. Because of that each path needs at least 2 points to work.

When creating a new Path3D as child of the CSG Terrain node, the path node will contain various extra parameters:

**Width:** The number of terrain vertices affected on each side of the curve. The value 2 will affect 2 vertices on each side, the number 0 will not affect the terrain.

**Smoothness:** Amount of curvature around the path. Value 1.0 will smoothly lower the curve. Zero will create a flat slope with the height of the curve.

**Paint Width:** How many pixels around the path that will be painted below the curve. You can choose the texture in the [Terrain Material](#terrain-material).

**Paint Smoothness:** How much the path texture will blend with the terrain. Zero will cause blockness and high values will make the texture thinner.


### Order matters
<p align="center" width="100%">
  <img width="500px" src="https://github.com/user-attachments/assets/c0f5d464-d8d3-495f-9a9c-fa88b59ecf83"
</p>

Similar to canvas items, paths that are children of the CSG Terrain node will be applied one on top of each other following the order in the scene tree.

The first child will be drown on bottom and the last will be drown on top.

You can change the order at will.


### Synchronizing neighboring terrains
<p align="center" width="100%">
  <img width="500px" src="https://github.com/user-attachments/assets/e9744d68-bfa2-496f-a974-e26cb28bbad0"
</p>

If you duplicate an Path3D with Control+D and move to a new CSG Terrain node, both curves will be synchronized.

**Note:** To avoid conflicts, make sure that both terrains have the same Size and Divs.


## The Terrain material
<p align="center" width="100%">
  <img width="456px" src="https://github.com/user-attachments/assets/b17a4cc5-c43e-4479-993f-4f32bda7d232"
</p>

The terrain material is located on the CSG node, in CSGMesh section.

It's composed of 3 materials: Ground, Walls and Path.

For each one you can change the material properties and the textures for Albedo, Normal Map and Roughness Map (Rough Map) similar to [Godot's StandardMaterial3D](https://docs.godotengine.org/en/stable/tutorials/3d/standard_material_3d.html) counterparts.

The Shader Parameter **Wall Underlay** set how the wall will be merged with the ground. Zero means no wall will be applied. High values will make the transition sharper.

The terrain material aims to be simple and serves as a base for users to make their own terrain material. In the final product it's recommended to polish this shader and make optimizations such as [channel packing](http://wiki.polycount.com/wiki/ChannelPacking).


## Limitations
CSG Terrain only works in the editor. It's too heavy for the player's machine.

CSG Terrain is not designed to work with a high number of [Divs](#the-csg-terrain-node). Instead, consider placing several smaller terrains.

Too many or too large paths can decrease performance in the editor. Simple optimization ideas are welcomed as explained in the next section.


## Compatibility
CSG Terrain is compatible with Godot 4.4 and there are plans to continue supporting onward.


## Future features and how to contribute
CSG Terrain is designed to be as simple as possible. Because of that **no new features are planned** in order to avoid [feature creep](https://en.wikipedia.org/wiki/Feature_creep).

The code aims to be readable and beginner friendly. Users are encouraged to change and expand the code in their end, but this repository must be kept neat and tidy.

Contributions to make the code simpler, more readable and bugfixes are welcomed. Optimizations must be easy to understand even for beginner/intermediate users, example: Advanced features like compute shaders would greatly benefit the plugin speed, but will be kept out of the code in order to keep it accessible.


## Acknowledgements
A big thank you to [@fire](https://github.com/fire) for overhauling Godot's CSG System. Without it, this plugin would not be possible.


## Ending notes
This tool was entirely made in my free time. If you want to support me, please make an awesome asset and publish for free to the community!


## Changelog
v1.0.2
- Fix bug when editor tab change focus

v1.0.1
- Fixed errors on exported projects
- Fixed the terrain shader

v1.0:
- Bugfixes

v0.9-rc:
- Bugfixes

v0.5-beta:
- First release.
