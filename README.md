# Render360
Render360 is a tool we created for rendering 360-degree images and videos based on the user's head orientation. It can take input videos encoded using not only a variety of non-adaptive projections, but also the adaptive AdaP-360 projections. It allow researchers to encode the rendered views into "view videos" using lossless encoding, and compare the true visual qualities using the popular objective measurements. 

Details can be found in our paper: **AdaP-360: User-Adaptive Area-of-Focus Projections for Bandwidth-Efficient 360-Degree Video Streaming** [[paper](https://dl.acm.org/doi/10.1145/3394171.3413521)].

# How to compile
## Mac instructions
```
brew install glfw glew pkg-config yasm
./configure --enable-opengl --enable-libx264 --enable-gpl --extra-libs='-framework OpenGL -lglfw -lGLEW -lpng -lm -lz'
make ffmpeg
```
## Ubuntu instructions
```
./configure --enable-opengl --extra-libs='-lGL -lGLU -lGLEW -lglfw -lpng -lm -lz'
make ffmpeg
```

# How to use
## Equirectangular layout

The layout describing the equirectangular layout is defined in ```equirectangular.lt```
The render shader is defined in ```equi-render.glsl```

```
./ffmpeg -loglevel "info" -y -i test.jpg -filter:v "project=512:512:90:90:0:0:0:simpleVertex.glsl:equi-render.glsl::equirectangular.lt" view.jpg
```

## EAC layout

The layout describing baseball cube layout is defined in ```eac_32.lt```
The render shader is defined in ```eac-render.glsl```

## AdaEAC layout

The layout describing standard cube layout is defined in ```eac_21.lt```
The render shader is defined in ```eac-render.glsl```

## RSP layout

The layout describing standard cube layout is defined in ```equirectangular.lt```
The render shader is defined in ```rsp-render-1-1.glsl```

## AdaRSP layout

The layout describing standard cube layout is defined in ```equirectangular.lt```
The render shader is defined in ```rsp-render-2-1.glsl```

## Barrel layout

The layout describing standard cube layout is defined in ```equirectangular.lt```
The render shader is defined in ```barrel-render.glsl```

## AdaBarrel layout

The layout describing standard cube layout is defined in ```equirectangular.lt```
The render shader is defined in ```barrel-render.glsl```

## Offset Cube layout

The layout describing standard cube layout is defined in ```equirectangular.lt```
The render shader is defined in ```offset-cube-render.glsl```

# Filter parameters

Parameters to the projection filter are passed as follows:

```
projection={output width}:{output height}:{x-fov}:{y-fov}:{x-rotation}:{y-rotation}:{z-rotation}:{vertex shader}:{fragment shader}:{orientation file}:{layout file}:{start time}:{expand coefficient}
```

Here, ```output width``` and ```output height``` are represented in pixels
 
```x-fov```, ```y-fov```, ```x-rotation```, ```y-rotation``` and ```z-rotation``` are represented in degrees. 
The legal ranges of ```x/y/z-rotation``` are set to {-360, 360}.

```vertex shader```, ```fragment shader```, ```orientation file``` and ```layout file``` are file paths

```start time``` indicates where to start loading orinetation time

For example, a sample command can look like the follows:

```
$ ./ffmpeg -loglevel 'info' -y -i test-barrel.mp4 -filter:v "project=800:800:90:90:0:180:0:simpleVertex.glsl:barrel-render.glsl::equirectangular.lt:0.0:1.0" barrel-back.mp4
```

# Citation
```
@inproceedings{zhou2020adap,
  title={Adap-360: User-adaptive area-of-focus projections for bandwidth-efficient 360-degree video streaming},
  author={Zhou, Chao and Wang, Shuoqian and Xiao, Mengbai and Wei, Sheng and Liu, Yao},
  booktitle={Proceedings of the 28th ACM International Conference on Multimedia},
  pages={3715--3723},
  year={2020}
}
```
