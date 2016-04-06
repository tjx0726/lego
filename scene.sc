#-----------------------------
# DEFAULT SCENE FILE
#-----------------------------


image {
  # resolution %WIDTH% %HEIGHT%
  resolution 256 256
  aa 0 1
  filter mitchell
}

# Background of the image, default is full white
background {
  color { "sRGB nonlinear" %BACKGROUND_COLOR% }
}
 
# this is the camera setting. The FieldOfView is narrow to match the camera in LDD
camera {
  type pinhole
  transform row %LDDCAMERA%
  # fov 30
  fov 22
  aspect %ASPECTRATIO%
}


# Alternatively, you can define your own camera, by givin the eye and target coordinates
#camera {
#  type pinhole
#  eye    20 15 25
#  target 0 4 0
#  up     0 1 0
#  fov 22
#  aspect 1.333333
#}

# A mirror material, you can use it with the Plane to have a shiny plane
shader {
  name Mirror
  type mirror
  refl 1 0.5 1.5
}

# The default material for the plane, a nice blue shade
shader {
  name PlaneMaterial
  type diffuse
  diff { "sRGB nonlinear" %PLANE_COLOR% }
}

# Here we define our plane.
object {
  shader PlaneMaterial
  type plane
  p 0 %LOWESTPOINT% 0
  n 0 1 0
}

# ---------------------------------
# LIGHTS
# ---------------------------------


# This is the default light, a kind that simulates the natural sun light.
# you can change turbidity to move between soft-blue and hard-red lights

light {
  type sunsky
  up 0 1 0
  east 1 0 0
  sundir 1 1 1
  turbidity 7
  samples 64
}



# Example of directional light
#light {
#	type directional
#	source 0 20 0
#	target 0 0 0
#	radius 10000
#	emit 1 1 1
#	intensity 1
#}


# Example of spherical light
#light {
#  type spherical
#  color 1 1 1
#  radiance 20
#  center 20 20 0
#  radius 5
#  samples 32
#}


# ---------------------------------
# MATERIALS
# ---------------------------------

# LDD COLORS MATERIALS

shader {
name mat1
type shiny
diff { "sRGB nonlinear" 0.95686275 0.95686275 0.95686275 }
refl 0.05
}
shader {
name mat2
type shiny
diff { "sRGB nonlinear" 0.5411765 0.57254905 0.5529412 }
refl 0.05
}

# BASEPLATE - Light Gray
shader
{
	name mat3
	type shiny
	diff 0.5411765 0.57254905 0.5529412
	refl 0.0505
}


shader {
name mat4
type shiny
diff { "sRGB nonlinear" 0.9490196 0.4392157 0.36862746 }
refl 0.05
}
shader {
name mat5
type shiny
diff { "sRGB nonlinear" 0.6901961 0.627451 0.43529412 }
refl 0.05
}
shader {
name mat6
type shiny
diff { "sRGB nonlinear" 0.6784314 0.8509804 0.65882355 }
refl 0.05
}
shader {
name mat7
type shiny
diff { "sRGB nonlinear" 1.0 0.52156866 0.0 }
refl 0.05
}
shader {
name mat8
type shiny
diff { "sRGB nonlinear" 0.54901963 0.0 1.0 }
refl 0.05
}
shader {
name mat9
type shiny
diff { "sRGB nonlinear" 0.9647059 0.6627451 0.73333335 }
refl 0.05
}
shader {
name mat10
type glass
eta 1.6
color  { "sRGB nonlinear" 1.0 1.0 0.87058824 }
}
shader {
name mat11
type shiny
diff { "sRGB nonlinear" 0.67058825 0.8509804 1.0 }
refl 0.05
}
shader {
name mat12
type shiny
diff { "sRGB nonlinear" 0.84705883 0.42745098 0.17254902 }
refl 0.05
}
shader {
name mat268
type shiny
diff { "sRGB nonlinear" 0.26666668 0.101960786 0.5686275 }
refl 0.05
}
shader {
name mat13
type shiny
diff { "sRGB nonlinear" 1.0 0.5019608 0.078431375 }
refl 0.05
}
shader {
name mat269
type shiny
diff { "sRGB nonlinear" 0.24313726 0.58431375 0.7137255 }
refl 0.05
}
shader {
name mat14
type shiny
diff { "sRGB nonlinear" 0.47058824 0.9882353 0.47058824 }
refl 0.05
}
shader {
name mat15
type shiny
diff { "sRGB nonlinear" 1.0 0.9490196 0.1882353 }
refl 0.05
}
shader {
name mat16
type shiny
diff { "sRGB nonlinear" 1.0 0.5294118 0.6117647 }
refl 0.05
}
shader {
name mat17
type shiny
diff { "sRGB nonlinear" 1.0 0.5803922 0.5803922 }
refl 0.05
}
shader {
name mat18
type shiny
diff { "sRGB nonlinear" 0.73333335 0.5019608 0.3529412 }
refl 0.05
}
shader {
name mat19
type shiny
diff { "sRGB nonlinear" 0.8117647 0.5411765 0.2784314 }
refl 0.05
}
shader {
name mat20
type glass
eta 1.6
color  { "sRGB nonlinear" 0.95686275 0.95686275 0.95686275 }
}
shader {
name mat21
type shiny
diff { "sRGB nonlinear" 0.7058824 0.0 0.0 }
refl 0.05
}
shader {
name mat22
type shiny
diff { "sRGB nonlinear" 0.8156863 0.3137255 0.59607846 }
refl 0.05
}
shader {
name mat23
type shiny
diff { "sRGB nonlinear" 0.11764706 0.3529412 0.65882355 }
refl 0.05
}
shader {
name mat24
type shiny
diff { "sRGB nonlinear" 0.98039216 0.78431374 0.039215688 }
refl 0.05
}
shader {
name mat25
type shiny
diff { "sRGB nonlinear" 0.32941177 0.2 0.14117648 }
refl 0.05
}
shader {
name mat26
type shiny
diff { "sRGB nonlinear" 0.07 0.07 0.07 }
refl 0.05
}
shader {
name mat27
type shiny
diff { "sRGB nonlinear" 0.32941177 0.34901962 0.33333334 }
refl 0.05
}
shader {
name mat283
type shiny
diff { "sRGB nonlinear" 1.0 0.7882353 0.58431375 }
refl 0.05
}
shader {
name mat28
type shiny
diff { "sRGB nonlinear" 0.0 0.52156866 0.16862746 }
refl 0.05
}
shader {
name mat284
type glass
eta 1.6
color  { "sRGB nonlinear" 0.93921566 0.9078431 0.9490196 }
}
shader {
name mat29
type shiny
diff { "sRGB nonlinear" 0.49803922 0.76862746 0.45882353 }
refl 0.05
}
shader {
name mat285
type glass
eta 1.6
color  { "sRGB nonlinear" 0.9470588 0.9196078 0.92745095 }
}
shader {
name mat36
type shiny
diff { "sRGB nonlinear" 0.99215686 0.7647059 0.5137255 }
refl 0.05
}
shader {
name mat37
type shiny
diff { "sRGB nonlinear" 0.34509805 0.67058825 0.25490198 }
refl 0.05
}
shader {
name mat38
type shiny
diff { "sRGB nonlinear" 0.5686275 0.3137255 0.10980392 }
refl 0.05
}
shader {
name mat294
type glass
eta 1.6
color  { "sRGB nonlinear" 0.91764706 0.9313725 0.7705882 }
}
shader {
name mat39
type shiny
diff { "sRGB nonlinear" 0.6862745 0.74509805 0.8392157 }
refl 0.05
}
shader {
name mat40
type glass
eta 1.6
color  { "sRGB nonlinear" 0.96666664 0.96666664 0.96666664 }
}
shader {
name mat296
type shiny
diff { "sRGB nonlinear" 0.6784314 0.6784314 0.6784314 }
refl 0.05
}
shader {
name mat41
type glass
eta 1.6
color  { "sRGB nonlinear" 0.8607843 0.5764706 0.5 }
}

# WARM GOLD
shader
{
	name mat297
	type uber
	diff { "sRGB nonlinear" 0.6666667 0.49803922 0.18039216 }
	diff.blend 0
	spec { "sRGB nonlinear" 1.0 0.8 0.5 }
	spec.blend 0
	glossy 1
	samples 1
}

shader {
name mat42
type glass
eta 1.6
color  { "sRGB nonlinear" 0.8392157 0.93333334 0.9647059 }
}
shader {
name mat298
type custom
class bluerender.customshaders.ColorSilverDrumLaquered
}
shader {
name mat43
type glass
eta 1.6
color  { "sRGB nonlinear" 0.73333335 0.85882354 0.9 }
}
shader {
name mat44
type glass
eta 1.6
color  { "sRGB nonlinear" 0.99019605 0.972549 0.68235296 }
}
shader {
name mat45
type shiny
diff { "sRGB nonlinear" 0.5921569 0.79607844 0.8509804 }
refl 0.05
}
shader {
name mat47
type glass
eta 1.6
color  { "sRGB nonlinear" 0.9078431 0.7137255 0.654902 }
}
shader {
name mat48
type glass
eta 1.6
color  { "sRGB nonlinear" 0.7254902 0.85294116 0.6960784 }
}
shader {
name mat49
type glass
eta 1.6
color  { "sRGB nonlinear" 0.99019605 0.972549 0.6784314 }
}

# PHOSPHORESCENT WHITE
shader
{
	name mat50
	type phong
	diff 2 2 2
	spec 1.5 1.5 1.5 0
	samples 64
}

shader {
name mat308
type shiny
diff { "sRGB nonlinear" 0.21568628 0.12941177 0.0 }
refl 0.05
}


# METALIZED SILVER
shader
{
	name mat309
	type custom
	class bluerender.customshaders.MetalizedSilver
}

# METALIZED GOLD
shader
{
	name mat310
	type custom
	class bluerender.customshaders.MetalizedGold
}



shader {
name mat311
type glass
eta 1.6
color  { "sRGB nonlinear" 0.84313726 0.9117647 0.6372549 }
}
shader {
name mat312
type shiny
diff { "sRGB nonlinear" 0.6666667 0.49019608 0.33333334 }
refl 0.05
}


# SILVER METALLIC
shader
{
	name mat315
	type uber
	diff { "sRGB nonlinear" 0.34901963 0.34901963 0.34901963 }
	diff.blend 0
	spec { "sRGB nonlinear" 0.8 0.8 0.8 }
	spec.blend 0
	glossy 100
	samples 1
}


# TITANIUM METALLIC
shader
{
	name mat316
	type phong
	diff { "sRGB nonlinear" 0.24313726 0.23529412 0.22352941 }
	spec { "sRGB nonlinear" 0.3 0.3 0.3 } 200
	samples 1
}
shader {
name mat321
type shiny
diff { "sRGB nonlinear" 0.27450982 0.60784316 0.7647059 }
refl 0.05
}
shader {
name mat322
type shiny
diff { "sRGB nonlinear" 0.40784314 0.7647059 0.8862745 }
refl 0.05
}

# BASEPLATE - Black
shader
{
	name mat323
	type uber
	diff { "sRGB nonlinear" 0.07 0.07 0.07 }
	diff.blend 0
	spec .1 .1 .1
	spec.blend 0
	glossy 1
	samples 4
}


shader {
name mat324
type shiny
diff { "sRGB nonlinear" 0.627451 0.43137255 0.7254902 }
refl 0.05
}
shader {
name mat325
type shiny
diff { "sRGB nonlinear" 0.8039216 0.6431373 0.87058824 }
refl 0.05
}
shader {
name mat326
type shiny
diff { "sRGB nonlinear" 0.8862745 0.9764706 0.6039216 }
refl 0.05
}
shader {
name mat329
type custom
class bluerender.customshaders.WhiteGlow
}
shader {
name mat330
type shiny
diff { "sRGB nonlinear" 0.46666667 0.46666667 0.30588236 }
refl 0.05
}
shader {
name mat100
type shiny
diff { "sRGB nonlinear" 0.9764706 0.7176471 0.64705884 }
refl 0.05
}
shader {
name mat101
type shiny
diff { "sRGB nonlinear" 0.9411765 0.42745098 0.38039216 }
refl 0.05
}
shader {
name mat102
type shiny
diff { "sRGB nonlinear" 0.4509804 0.5882353 0.78431374 }
refl 0.05
}
shader {
name mat103
type shiny
diff { "sRGB nonlinear" 0.7372549 0.7058824 0.64705884 }
refl 0.05
}
shader {
name mat104
type shiny
diff { "sRGB nonlinear" 0.40392157 0.12156863 0.5058824 }
refl 0.05
}
shader {
name mat105
type shiny
diff { "sRGB nonlinear" 0.9607843 0.5254902 0.14117648 }
refl 0.05
}
shader {
name mat106
type shiny
diff { "sRGB nonlinear" 0.8392157 0.4745098 0.13725491 }
refl 0.05
}
shader {
name mat107
type shiny
diff { "sRGB nonlinear" 0.023529412 0.6156863 0.62352943 }
refl 0.05
}
shader {
name mat108
type shiny
diff { "sRGB nonlinear" 0.3372549 0.2784314 0.18431373 }
refl 0.05
}
shader {
name mat109
type shiny
diff { "sRGB nonlinear" 0.0 0.078431375 0.078431375 }
refl 0.05
}
shader {
name mat110
type shiny
diff { "sRGB nonlinear" 0.14901961 0.27450982 0.6039216 }
refl 0.05
}
shader {
name mat111
type glass
eta 2
color  { "sRGB nonlinear" 0.8666667 0.8490196 0.8098039 }
}
shader {
name mat112
type shiny
diff { "sRGB nonlinear" 0.28235295 0.38039216 0.6745098 }
refl 0.05
}
shader {
name mat113
type glass
eta 1.6
color  { "sRGB nonlinear" 0.99607843 0.77843136 0.90588236 }
}
shader {
name mat114
type glass
eta 1.6
color  { "sRGB nonlinear" 0.9980392 0.5 0.9980392 }
}
shader {
name mat115
type shiny
diff { "sRGB nonlinear" 0.7176471 0.83137256 0.14509805 }
refl 0.05
}
shader {
name mat116
type shiny
diff { "sRGB nonlinear" 0.0 0.6666667 0.6431373 }
refl 0.05
}
shader {
name mat117
type glass
eta 1.6
color  { "sRGB nonlinear" 0.9843137 0.9843137 0.9843137 }
}
shader {
name mat118
type shiny
diff { "sRGB nonlinear" 0.6117647 0.8392157 0.8 }
refl 0.05
}
shader {
name mat119
type shiny
diff { "sRGB nonlinear" 0.64705884 0.7921569 0.09411765 }
refl 0.05
}
shader {
name mat120
type shiny
diff { "sRGB nonlinear" 0.87058824 0.91764706 0.57254905 }
refl 0.05
}
shader {
name mat121
type shiny
diff { "sRGB nonlinear" 0.972549 0.6039216 0.22352941 }
refl 0.05
}
shader {
name mat122
type shiny
diff { "sRGB nonlinear" 0.99607843 0.79607844 0.59607846 }
refl 0.05
}
shader {
name mat123
type shiny
diff { "sRGB nonlinear" 0.93333334 0.32941177 0.20392157 }
refl 0.05
}
shader {
name mat124
type shiny
diff { "sRGB nonlinear" 0.5647059 0.12156863 0.4627451 }
refl 0.05
}
shader {
name mat125
type shiny
diff { "sRGB nonlinear" 0.9764706 0.654902 0.46666667 }
refl 0.05
}
shader {
name mat126
type glass
eta 1.6
color  { "sRGB nonlinear" 0.80588233 0.7921569 0.8901961 }
}
shader {
name mat127
type shiny
diff { "sRGB nonlinear" 0.87058824 0.6745098 0.4 }
refl 0.05
}
shader {
name mat128
type shiny
diff { "sRGB nonlinear" 0.6784314 0.38039216 0.2509804 }
refl 0.05
}
shader {
name mat129
type shiny
diff { "sRGB nonlinear" 0.2627451 0.32941177 0.5764706 }
refl 0.05
}
shader {
name mat131
type shiny
diff { "sRGB nonlinear" 0.627451 0.627451 0.627451 }
refl 0.05
}
shader {
name mat133
type shiny
diff { "sRGB nonlinear" 0.9372549 0.34509805 0.15686275 }
refl 0.05
}
shader {
name mat134
type shiny
diff { "sRGB nonlinear" 0.8039216 0.8666667 0.20392157 }
refl 0.05
}
shader {
name mat135
type shiny
diff { "sRGB nonlinear" 0.4392157 0.5058824 0.6039216 }
refl 0.05
}
shader {
name mat136
type shiny
diff { "sRGB nonlinear" 0.45882353 0.39607844 0.49019608 }
refl 0.05
}
shader {
name mat137
type shiny
diff { "sRGB nonlinear" 0.95686275 0.5058824 0.2784314 }
refl 0.05
}
shader {
name mat138
type shiny
diff { "sRGB nonlinear" 0.5372549 0.49019608 0.38431373 }
refl 0.05
}

# COPPER
shader
{
	name mat139
	type uber
	diff { "sRGB nonlinear" 0.4627451 0.3019608 0.23137255 }
	diff.blend 0
	spec { "sRGB nonlinear" 1.0 0.9 0.8 }
	spec.blend 0
	glossy 100
	samples 1
}


shader {
name mat140
type shiny
diff { "sRGB nonlinear" 0.09803922 0.19607843 0.3529412 }
refl 0.05
}
shader {
name mat141
type shiny
diff { "sRGB nonlinear" 0.0 0.27058825 0.101960786 }
refl 0.05
}
shader {
name mat143
type glass
eta 1.6
color  { "sRGB nonlinear" 0.9078431 0.9490196 1.0 }
}

# METALLIC SAND BLUE
shader
{
	name mat145
	type uber
	diff { "sRGB nonlinear" 0.35686275 0.45882353 0.5647059 }
	diff.blend 0
	spec { "sRGB nonlinear" .6 .7 0.8 }
	spec.blend 0
	glossy 20
	samples 1
}


shader {
name mat146
type shiny
diff { "sRGB nonlinear" 0.5058824 0.45882353 0.5647059 }
refl 0.05
}

# METALLIC SAND YELLOW
shader
{
	name mat147
	type uber
	diff { "sRGB nonlinear" 0.5137255 0.44705883 0.30980393 }
	diff.blend 0
	spec { "sRGB nonlinear" .7 .6 .5 }
	spec.blend 0
	glossy 20
	samples 1
}


shader {
name mat148
type shiny
diff { "sRGB nonlinear" 0.28235295 0.3019608 0.28235295 }
refl 0.05
}
shader {
name mat149
type shiny
diff { "sRGB nonlinear" 0.039215688 0.07450981 0.15294118 }
refl 0.05
}
shader {
name mat150
type shiny
diff { "sRGB nonlinear" 0.59607846 0.60784316 0.6 }
refl 0.05
}
shader {
name mat151
type shiny
diff { "sRGB nonlinear" 0.4392157 0.5568628 0.4862745 }
refl 0.05
}
shader {
name mat153
type shiny
diff { "sRGB nonlinear" 0.53333336 0.3764706 0.36862746 }
refl 0.05
}
shader {
name mat154
type shiny
diff { "sRGB nonlinear" 0.44705883 0.0 0.07058824 }
refl 0.05
}
shader {
name mat157
type glass
eta 1.6
color  { "sRGB nonlinear" 1.0 0.9823529 0.68039215 }
}
shader {
name mat158
type glass
eta 1.6
color  { "sRGB nonlinear" 0.972549 0.77843136 0.8666667 }
}
shader {
name mat168
type shiny
diff { "sRGB nonlinear" 0.3764706 0.3372549 0.29803923 }
refl 0.05
}
shader {
name mat176
type shiny
diff { "sRGB nonlinear" 0.5803922 0.31764707 0.28235295 }
refl 0.05
}
shader {
name mat178
type shiny
diff { "sRGB nonlinear" 0.67058825 0.40392157 0.22745098 }
refl 0.05
}
shader {
name mat179
type custom
class bluerender.customshaders.SilverFlipFlop
}
shader {
name mat180
type shiny
diff { "sRGB nonlinear" 0.8666667 0.59607846 0.18039216 }
refl 0.05
}
shader {
name mat182
type glass
eta 1.6
color  { "sRGB nonlinear" 0.9411765 0.7764706 0.51960784 }
}
shader {
name mat183
type shiny
diff { "sRGB nonlinear" 0.9647059 0.9490196 0.8745098 }
refl 0.05
}
shader {
name mat184
type shiny
diff { "sRGB nonlinear" 0.8392157 0.0 0.14901961 }
refl 0.05
}
shader {
name mat185
type shiny
diff { "sRGB nonlinear" 0.0 0.34901962 0.6392157 }
refl 0.05
}
shader {
name mat186
type shiny
diff { "sRGB nonlinear" 0.0 0.5568628 0.23529412 }
refl 0.05
}
shader {
name mat187
type shiny
diff { "sRGB nonlinear" 0.34117648 0.22352941 0.17254902 }
refl 0.05
}
shader {
name mat188
type shiny
diff { "sRGB nonlinear" 0.0 0.61960787 0.80784315 }
refl 0.05
}
shader {
name mat189
type shiny
diff { "sRGB nonlinear" 0.6745098 0.50980395 0.2784314 }
refl 0.05
}
shader {
name mat190
type shiny
diff { "sRGB nonlinear" 1.0 0.8117647 0.043137256 }
refl 0.05
}
shader {
name mat191
type shiny
diff { "sRGB nonlinear" 0.9882353 0.6745098 0.0 }
refl 0.05
}
shader {
name mat192
type shiny
diff { "sRGB nonlinear" 0.37254903 0.19215687 0.03529412 }
refl 0.05
}
shader {
name mat193
type shiny
diff { "sRGB nonlinear" 0.9254902 0.26666668 0.11372549 }
refl 0.05
}
shader {
name mat194
type shiny
diff { "sRGB nonlinear" 0.5882353 0.5882353 0.5882353 }
refl 0.05
}
shader {
name mat195
type shiny
diff { "sRGB nonlinear" 0.10980392 0.34509805 0.654902 }
refl 0.05
}
shader {
name mat196
type shiny
diff { "sRGB nonlinear" 0.05490196 0.24313726 0.6039216 }
refl 0.05
}
shader {
name mat197
type shiny
diff { "sRGB nonlinear" 0.19215687 0.16862746 0.5294118 }
refl 0.05
}
shader {
name mat198
type shiny
diff { "sRGB nonlinear" 0.5411765 0.07058824 0.65882355 }
refl 0.05
}
shader {
name mat199
type shiny
diff { "sRGB nonlinear" 0.39215687 0.39215687 0.39215687 }
refl 0.05
}
shader {
name mat200
type shiny
diff { "sRGB nonlinear" 0.41568628 0.4745098 0.26666668 }
refl 0.05
}
shader {
name mat208
type shiny
diff { "sRGB nonlinear" 0.78431374 0.78431374 0.78431374 }
refl 0.05
}
shader {
name mat209
type shiny
diff { "sRGB nonlinear" 0.6431373 0.4627451 0.14117648 }
refl 0.05
}
shader {
name mat210
type shiny
diff { "sRGB nonlinear" 0.27450982 0.5411765 0.37254903 }
refl 0.05
}
shader {
name mat211
type shiny
diff { "sRGB nonlinear" 0.24705882 0.7137255 0.6627451 }
refl 0.05
}
shader {
name mat212
type shiny
diff { "sRGB nonlinear" 0.6156863 0.7647059 0.96862745 }
refl 0.05
}
shader {
name mat213
type shiny
diff { "sRGB nonlinear" 0.2784314 0.43529412 0.7137255 }
refl 0.05
}
shader {
name mat216
type shiny
diff { "sRGB nonlinear" 0.5294118 0.16862746 0.09019608 }
refl 0.05
}
shader {
name mat217
type shiny
diff { "sRGB nonlinear" 0.48235294 0.3647059 0.25490198 }
refl 0.05
}
shader {
name mat218
type shiny
diff { "sRGB nonlinear" 0.5568628 0.33333334 0.5921569 }
refl 0.05
}
shader {
name mat219
type shiny
diff { "sRGB nonlinear" 0.3372549 0.30588236 0.6156863 }
refl 0.05
}
shader {
name mat220
type shiny
diff { "sRGB nonlinear" 0.5686275 0.58431375 0.7921569 }
refl 0.05
}
shader {
name mat221
type shiny
diff { "sRGB nonlinear" 0.827451 0.20784314 0.6156863 }
refl 0.05
}
shader {
name mat222
type shiny
diff { "sRGB nonlinear" 1.0 0.61960787 0.8039216 }
refl 0.05
}
shader {
name mat223
type shiny
diff { "sRGB nonlinear" 0.94509804 0.47058824 0.5019608 }
refl 0.05
}
shader {
name mat224
type shiny
diff { "sRGB nonlinear" 0.9529412 0.7882353 0.53333336 }
refl 0.05
}
shader {
name mat225
type shiny
diff { "sRGB nonlinear" 0.98039216 0.6627451 0.39215687 }
refl 0.05
}
shader {
name mat226
type shiny
diff { "sRGB nonlinear" 1.0 0.9254902 0.42352942 }
refl 0.05
}
shader {
name mat227
type glass
eta 1.6
color  { "sRGB nonlinear" 0.89411765 0.9529412 0.76666665 }
}
shader {
name mat228
type glass
eta 1.6
color  { "sRGB nonlinear" 0.6666667 0.8235294 0.84313726 }
}
shader {
name mat229
type glass
eta 1.6
color  { "sRGB nonlinear" 0.8372549 0.91568625 0.9352941 }
}
shader {
name mat230
type glass
eta 1.6
color  { "sRGB nonlinear" 0.9627451 0.81960785 0.89411765 }
}
shader {
name mat231
type glass
eta 1.6
color  { "sRGB nonlinear" 0.9941176 0.85882354 0.7137255 }
}
shader {
name mat232
type shiny
diff { "sRGB nonlinear" 0.46666667 0.7882353 0.84705883 }
refl 0.05
}
shader {
name mat233
type shiny
diff { "sRGB nonlinear" 0.3764706 0.7294118 0.4627451 }
refl 0.05
}
shader {
name mat234
type glass
eta 1.6
color  { "sRGB nonlinear" 0.99215686 0.95490193 0.7823529 }
}
shader {
name mat236
type glass
eta 1.6
color  { "sRGB nonlinear" 0.7764706 0.7254902 0.8509804 }
}
