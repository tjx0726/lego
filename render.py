import bpy
import sys
import mathutils
import xml.etree.cElementTree as ET

config = {}
config['sockets'] = False
config['target_res'] = 128
config['res'] = 128
config['input'] = 'IMAGE100.LXFML'
config['output'] = "out/output.png"

argv = sys.argv[sys.argv.index("--") + 1:] 
# print(argv)
if len(argv) > 1:
	config['sockets'] = int(argv[0]) == 1
if len(argv) > 2:
	config['res'] = int(argv[1])
if len(argv) > 3:
	config['input'] = argv[2]
	config['output'] = argv[3]
# print(config)

# CUDA backend
# bpy.context.scene.cycles.device = 'GPU'
# bpy.ops.render.render(True)
# bpy.context.user_preferences.system.compute_device_type = 'CUDA'
# bpy.context.user_preferences.system.compute_device = 'CUDA_0'

# Resoltuion
bpy.context.scene.render.resolution_x = config['res']
bpy.context.scene.render.resolution_y = config['res']
bpy.context.scene.render.resolution_percentage = 100 # .*config['res']/config['target_res']
bpy.context.scene.render.use_border = False

# Create Materials
bpy_materials = {}
bpy_materials[1] = ((0.9568627450980393, 0.9568627450980393, 0.9568627450980393), None, 1.0)
bpy_materials[2] = ((0.5411764705882353, 0.5725490196078431, 0.5529411764705883), None, 1.0)
bpy_materials[3] = ((1.0, 0.8392156862745098, 0.4980392156862745), None, 1.0)
bpy_materials[4] = ((0.9490196078431372, 0.4392156862745098, 0.3686274509803922), None, 1.0)
bpy_materials[5] = ((0.6901960784313725, 0.6274509803921569, 0.43529411764705883), None, 1.0)
bpy_materials[6] = ((0.6784313725490196, 0.8509803921568627, 0.6588235294117647), None, 1.0)
bpy_materials[7] = ((1.0, 0.5215686274509804, 0.0), None, 1.0)
bpy_materials[8] = ((0.5490196078431373, 0.0, 1.0), None, 1.0)
bpy_materials[9] = ((0.9647058823529412, 0.6627450980392157, 0.7333333333333333), None, 1.0)
bpy_materials[10] = ((1.0, 1.0, 0.7411764705882353), None, 0.5882352941176471)
bpy_materials[11] = ((0.6705882352941176, 0.8509803921568627, 1.0), None, 1.0)
bpy_materials[12] = ((0.8470588235294118, 0.42745098039215684, 0.17254901960784313), None, 1.0)
bpy_materials[268] = ((0.26666666666666666, 0.10196078431372549, 0.5686274509803921), None, 1.0)
bpy_materials[13] = ((1.0, 0.5019607843137255, 0.0784313725490196), None, 1.0)
bpy_materials[269] = ((0.24313725490196078, 0.5843137254901961, 0.7137254901960784), None, 1.0)
bpy_materials[14] = ((0.47058823529411764, 0.9882352941176471, 0.47058823529411764), None, 1.0)
bpy_materials[15] = ((1.0, 0.9490196078431372, 0.18823529411764706), None, 1.0)
bpy_materials[16] = ((1.0, 0.5294117647058824, 0.611764705882353), None, 1.0)
bpy_materials[17] = ((1.0, 0.5803921568627451, 0.5803921568627451), None, 1.0)
bpy_materials[18] = ((0.7333333333333333, 0.5019607843137255, 0.35294117647058826), None, 1.0)
bpy_materials[19] = ((0.8117647058823529, 0.5411764705882353, 0.2784313725490196), None, 1.0)
bpy_materials[20] = ((0.9137254901960784, 0.9137254901960784, 0.9137254901960784), None, 0.5882352941176471)
bpy_materials[21] = ((0.7058823529411765, 0.0, 0.0), None, 1.0)
bpy_materials[22] = ((0.8156862745098039, 0.3137254901960784, 0.596078431372549), None, 1.0)
bpy_materials[23] = ((0.11764705882352941, 0.35294117647058826, 0.6588235294117647), None, 1.0)
bpy_materials[24] = ((0.9803921568627451, 0.7843137254901961, 0.0392156862745098), None, 1.0)
bpy_materials[25] = ((0.32941176470588235, 0.2, 0.1411764705882353), None, 1.0)
bpy_materials[26] = ((0.10588235294117647, 0.16470588235294117, 0.20392156862745098), None, 1.0)
bpy_materials[27] = ((0.32941176470588235, 0.34901960784313724, 0.3333333333333333), None, 1.0)
bpy_materials[283] = ((1.0, 0.788235294117647, 0.5843137254901961), None, 1.0)
bpy_materials[28] = ((0.0, 0.5215686274509804, 0.16862745098039217), None, 1.0)
bpy_materials[284] = ((0.8784313725490196, 0.8156862745098039, 0.8980392156862745), None, 0.5882352941176471)
bpy_materials[29] = ((0.4980392156862745, 0.7686274509803922, 0.4588235294117647), None, 1.0)
bpy_materials[285] = ((0.8941176470588236, 0.8392156862745098, 0.8549019607843137), None, 0.5882352941176471)
bpy_materials[36] = ((0.9921568627450981, 0.7647058823529411, 0.5137254901960784), None, 1.0)
bpy_materials[37] = ((0.34509803921568627, 0.6705882352941176, 0.2549019607843137), None, 1.0)
bpy_materials[38] = ((0.5686274509803921, 0.3137254901960784, 0.10980392156862745), None, 1.0)
bpy_materials[294] = ((0.8352941176470589, 0.8627450980392157, 0.5411764705882353), None, 0.5882352941176471)
bpy_materials[39] = ((0.6862745098039216, 0.7450980392156863, 0.8392156862745098), None, 1.0)
bpy_materials[40] = ((0.9333333333333333, 0.9333333333333333, 0.9333333333333333), None, 0.5882352941176471)
bpy_materials[296] = ((0.6784313725490196, 0.6784313725490196, 0.6784313725490196), None, 1.0)
bpy_materials[41] = ((0.7215686274509804, 0.15294117647058825, 0.0), None, 0.5882352941176471)
bpy_materials[297] = ((0.6666666666666666, 0.4980392156862745, 0.1803921568627451), None, 1.0)
bpy_materials[42] = ((0.6784313725490196, 0.8666666666666667, 0.9294117647058824), None, 0.5882352941176471)
bpy_materials[298] = ((0.4627450980392157, 0.4627450980392157, 0.4627450980392157), None, 1.0)
bpy_materials[43] = ((0.4666666666666667, 0.7176470588235294, 0.8), None, 0.5882352941176471)
bpy_materials[44] = ((0.9803921568627451, 0.9450980392156862, 0.36470588235294116), None, 0.5882352941176471)
bpy_materials[45] = ((0.592156862745098, 0.796078431372549, 0.8509803921568627), None, 1.0)
bpy_materials[47] = ((0.8156862745098039, 0.42745098039215684, 0.30980392156862746), None, 0.5882352941176471)
bpy_materials[48] = ((0.45098039215686275, 0.7058823529411765, 0.39215686274509803), None, 0.5882352941176471)
bpy_materials[49] = ((0.9803921568627451, 0.9450980392156862, 0.3568627450980392), None, 0.5882352941176471)
bpy_materials[50] = ((0.8980392156862745, 0.8745098039215686, 0.8274509803921568), None, 1.0)
bpy_materials[308] = ((0.21568627450980393, 0.12941176470588237, 0.0), None, 1.0)
bpy_materials[309] = ((0.807843137254902, 0.807843137254902, 0.807843137254902), None, 1.0)
bpy_materials[310] = ((0.8745098039215686, 0.7568627450980392, 0.4627450980392157), None, 1.0)
bpy_materials[311] = ((0.6862745098039216, 0.8235294117647058, 0.27450980392156865), None, 0.5882352941176471)
bpy_materials[312] = ((0.6666666666666666, 0.49019607843137253, 0.3333333333333333), None, 1.0)
bpy_materials[315] = ((0.5490196078431373, 0.5490196078431373, 0.5490196078431373), None, 1.0)
bpy_materials[316] = ((0.24313725490196078, 0.23529411764705882, 0.2235294117647059), None, 1.0)
bpy_materials[321] = ((0.27450980392156865, 0.6078431372549019, 0.7647058823529411), None, 1.0)
bpy_materials[322] = ((0.40784313725490196, 0.7647058823529411, 0.8862745098039215), None, 1.0)
bpy_materials[323] = ((0.8274509803921568, 0.9490196078431372, 0.9176470588235294), None, 1.0)
bpy_materials[324] = ((0.6274509803921569, 0.43137254901960786, 0.7254901960784313), None, 1.0)
bpy_materials[325] = ((0.803921568627451, 0.6431372549019608, 0.8705882352941177), None, 1.0)
bpy_materials[326] = ((0.8862745098039215, 0.9764705882352941, 0.6039215686274509), None, 1.0)
bpy_materials[329] = ((0.9607843137254902, 0.9529411764705882, 0.8431372549019608), None, 1.0)
bpy_materials[330] = ((0.4666666666666667, 0.4666666666666667, 0.3058823529411765), None, 1.0)
bpy_materials[100] = ((0.9764705882352941, 0.7176470588235294, 0.6470588235294118), None, 1.0)
bpy_materials[101] = ((0.9411764705882353, 0.42745098039215684, 0.3803921568627451), None, 1.0)
bpy_materials[102] = ((0.45098039215686275, 0.5882352941176471, 0.7843137254901961), None, 1.0)
bpy_materials[103] = ((0.7372549019607844, 0.7058823529411765, 0.6470588235294118), None, 1.0)
bpy_materials[104] = ((0.403921568627451, 0.12156862745098039, 0.5058823529411764), None, 1.0)
bpy_materials[105] = ((0.9607843137254902, 0.5254901960784314, 0.1411764705882353), None, 1.0)
bpy_materials[106] = ((0.8392156862745098, 0.4745098039215686, 0.13725490196078433), None, 1.0)
bpy_materials[107] = ((0.023529411764705882, 0.615686274509804, 0.6235294117647059), None, 1.0)
bpy_materials[108] = ((0.33725490196078434, 0.2784313725490196, 0.1843137254901961), None, 1.0)
bpy_materials[109] = ((0.0, 0.0784313725490196, 0.0784313725490196), None, 1.0)
bpy_materials[110] = ((0.14901960784313725, 0.27450980392156865, 0.6039215686274509), None, 1.0)
bpy_materials[111] = ((0.7333333333333333, 0.6980392156862745, 0.6196078431372549), None, 0.5882352941176471)
bpy_materials[112] = ((0.2823529411764706, 0.3803921568627451, 0.6745098039215687), None, 1.0)
bpy_materials[113] = ((0.9921568627450981, 0.5568627450980392, 0.8117647058823529), None, 0.5882352941176471)
bpy_materials[114] = ((0.996078431372549, 0.0, 0.996078431372549), None, 0.5882352941176471)
bpy_materials[115] = ((0.7176470588235294, 0.8313725490196079, 0.1450980392156863), None, 1.0)
bpy_materials[116] = ((0.0, 0.6666666666666666, 0.6431372549019608), None, 1.0)
bpy_materials[117] = ((0.9686274509803922, 0.9686274509803922, 0.9686274509803922), None, 0.5882352941176471)
bpy_materials[118] = ((0.611764705882353, 0.8392156862745098, 0.8), None, 1.0)
bpy_materials[119] = ((0.6470588235294118, 0.792156862745098, 0.09411764705882353), None, 1.0)
bpy_materials[120] = ((0.8705882352941177, 0.9176470588235294, 0.5725490196078431), None, 1.0)
bpy_materials[121] = ((0.9725490196078431, 0.6039215686274509, 0.2235294117647059), None, 1.0)
bpy_materials[122] = ((0.996078431372549, 0.796078431372549, 0.596078431372549), None, 1.0)
bpy_materials[123] = ((0.9333333333333333, 0.32941176470588235, 0.20392156862745098), None, 1.0)
bpy_materials[124] = ((0.5647058823529412, 0.12156862745098039, 0.4627450980392157), None, 1.0)
bpy_materials[125] = ((0.9764705882352941, 0.6549019607843137, 0.4666666666666667), None, 1.0)
bpy_materials[126] = ((0.611764705882353, 0.5843137254901961, 0.7803921568627451), None, 0.5882352941176471)
bpy_materials[127] = ((0.8705882352941177, 0.6745098039215687, 0.4), None, 1.0)
bpy_materials[128] = ((0.6784313725490196, 0.3803921568627451, 0.25098039215686274), None, 1.0)
bpy_materials[129] = ((0.2627450980392157, 0.32941176470588235, 0.5764705882352941), None, 1.0)
bpy_materials[131] = ((0.6274509803921569, 0.6274509803921569, 0.6274509803921569), None, 1.0)
bpy_materials[133] = ((0.9372549019607843, 0.34509803921568627, 0.1568627450980392), None, 1.0)
bpy_materials[134] = ((0.803921568627451, 0.8666666666666667, 0.20392156862745098), None, 1.0)
bpy_materials[135] = ((0.4392156862745098, 0.5058823529411764, 0.6039215686274509), None, 1.0)
bpy_materials[136] = ((0.4588235294117647, 0.396078431372549, 0.49019607843137253), None, 1.0)
bpy_materials[137] = ((0.9568627450980393, 0.5058823529411764, 0.2784313725490196), None, 1.0)
bpy_materials[138] = ((0.5372549019607843, 0.49019607843137253, 0.3843137254901961), None, 1.0)
bpy_materials[139] = ((0.4627450980392157, 0.30196078431372547, 0.23137254901960785), None, 1.0)
bpy_materials[140] = ((0.09803921568627451, 0.19607843137254902, 0.35294117647058826), None, 1.0)
bpy_materials[141] = ((0.0, 0.27058823529411763, 0.10196078431372549), None, 1.0)
bpy_materials[143] = ((0.8156862745098039, 0.8980392156862745, 1.0), None, 0.5882352941176471)
bpy_materials[145] = ((0.3568627450980392, 0.4588235294117647, 0.5647058823529412), None, 1.0)
bpy_materials[146] = ((0.5058823529411764, 0.4588235294117647, 0.5647058823529412), None, 1.0)
bpy_materials[147] = ((0.5137254901960784, 0.4470588235294118, 0.30980392156862746), None, 1.0)
bpy_materials[148] = ((0.2823529411764706, 0.30196078431372547, 0.2823529411764706), None, 1.0)
bpy_materials[149] = ((0.0392156862745098, 0.07450980392156863, 0.15294117647058825), None, 1.0)
bpy_materials[150] = ((0.596078431372549, 0.6078431372549019, 0.6), None, 1.0)
bpy_materials[151] = ((0.4392156862745098, 0.5568627450980392, 0.48627450980392156), None, 1.0)
bpy_materials[153] = ((0.5333333333333333, 0.3764705882352941, 0.3686274509803922), None, 1.0)
bpy_materials[154] = ((0.4470588235294118, 0.0, 0.07058823529411765), None, 1.0)
bpy_materials[157] = ((1.0, 0.9647058823529412, 0.3607843137254902), None, 0.5882352941176471)
bpy_materials[158] = ((0.9450980392156862, 0.5568627450980392, 0.7333333333333333), None, 0.5882352941176471)
bpy_materials[168] = ((0.3764705882352941, 0.33725490196078434, 0.2980392156862745), None, 1.0)
bpy_materials[176] = ((0.5803921568627451, 0.3176470588235294, 0.2823529411764706), None, 1.0)
bpy_materials[178] = ((0.6705882352941176, 0.403921568627451, 0.22745098039215686), None, 1.0)
bpy_materials[179] = ((0.45098039215686275, 0.4470588235294118, 0.44313725490196076), None, 1.0)
bpy_materials[180] = ((0.8666666666666667, 0.596078431372549, 0.1803921568627451), None, 1.0)
bpy_materials[182] = ((0.8823529411764706, 0.5529411764705883, 0.0392156862745098), None, 0.5882352941176471)
bpy_materials[183] = ((0.9647058823529412, 0.9490196078431372, 0.8745098039215686), None, 1.0)
bpy_materials[184] = ((0.8392156862745098, 0.0, 0.14901960784313725), None, 1.0)
bpy_materials[185] = ((0.0, 0.34901960784313724, 0.6392156862745098), None, 1.0)
bpy_materials[186] = ((0.0, 0.5568627450980392, 0.23529411764705882), None, 1.0)
bpy_materials[187] = ((0.3411764705882353, 0.2235294117647059, 0.17254901960784313), None, 1.0)
bpy_materials[188] = ((0.0, 0.6196078431372549, 0.807843137254902), None, 1.0)
bpy_materials[189] = ((0.6745098039215687, 0.5098039215686274, 0.2784313725490196), None, 1.0)
bpy_materials[190] = ((1.0, 0.8117647058823529, 0.043137254901960784), None, 1.0)
bpy_materials[191] = ((0.9882352941176471, 0.6745098039215687, 0.0), None, 1.0)
bpy_materials[192] = ((0.37254901960784315, 0.19215686274509805, 0.03529411764705882), None, 1.0)
bpy_materials[193] = ((0.9254901960784314, 0.26666666666666666, 0.11372549019607843), None, 1.0)
bpy_materials[194] = ((0.5882352941176471, 0.5882352941176471, 0.5882352941176471), None, 1.0)
bpy_materials[195] = ((0.10980392156862745, 0.34509803921568627, 0.6549019607843137), None, 1.0)
bpy_materials[196] = ((0.054901960784313725, 0.24313725490196078, 0.6039215686274509), None, 1.0)
bpy_materials[197] = ((0.19215686274509805, 0.16862745098039217, 0.5294117647058824), None, 1.0)
bpy_materials[198] = ((0.5411764705882353, 0.07058823529411765, 0.6588235294117647), None, 1.0)
bpy_materials[199] = ((0.39215686274509803, 0.39215686274509803, 0.39215686274509803), None, 1.0)
bpy_materials[200] = ((0.41568627450980394, 0.4745098039215686, 0.26666666666666666), None, 1.0)
bpy_materials[208] = ((0.7843137254901961, 0.7843137254901961, 0.7843137254901961), None, 1.0)
bpy_materials[209] = ((0.6431372549019608, 0.4627450980392157, 0.1411764705882353), None, 1.0)
bpy_materials[210] = ((0.27450980392156865, 0.5411764705882353, 0.37254901960784315), None, 1.0)
bpy_materials[211] = ((0.24705882352941178, 0.7137254901960784, 0.6627450980392157), None, 1.0)
bpy_materials[212] = ((0.615686274509804, 0.7647058823529411, 0.9686274509803922), None, 1.0)
bpy_materials[213] = ((0.2784313725490196, 0.43529411764705883, 0.7137254901960784), None, 1.0)
bpy_materials[216] = ((0.5294117647058824, 0.16862745098039217, 0.09019607843137255), None, 1.0)
bpy_materials[217] = ((0.4823529411764706, 0.36470588235294116, 0.2549019607843137), None, 1.0)
bpy_materials[218] = ((0.5568627450980392, 0.3333333333333333, 0.592156862745098), None, 1.0)
bpy_materials[219] = ((0.33725490196078434, 0.3058823529411765, 0.615686274509804), None, 1.0)
bpy_materials[220] = ((0.5686274509803921, 0.5843137254901961, 0.792156862745098), None, 1.0)
bpy_materials[221] = ((0.8274509803921568, 0.20784313725490197, 0.615686274509804), None, 1.0)
bpy_materials[222] = ((1.0, 0.6196078431372549, 0.803921568627451), None, 1.0)
bpy_materials[223] = ((0.9450980392156862, 0.47058823529411764, 0.5019607843137255), None, 1.0)
bpy_materials[224] = ((0.9529411764705882, 0.788235294117647, 0.5333333333333333), None, 1.0)
bpy_materials[225] = ((0.9803921568627451, 0.6627450980392157, 0.39215686274509803), None, 1.0)
bpy_materials[226] = ((1.0, 0.9254901960784314, 0.4235294117647059), None, 1.0)
bpy_materials[227] = ((0.788235294117647, 0.9058823529411765, 0.5333333333333333), None, 0.5882352941176471)
bpy_materials[228] = ((0.3333333333333333, 0.6470588235294118, 0.6862745098039216), None, 0.5882352941176471)
bpy_materials[229] = ((0.6745098039215687, 0.8313725490196079, 0.8705882352941177), None, 0.5882352941176471)
bpy_materials[230] = ((0.9254901960784314, 0.6392156862745098, 0.788235294117647), None, 0.5882352941176471)
bpy_materials[231] = ((0.9882352941176471, 0.7176470588235294, 0.42745098039215684), None, 0.5882352941176471)
bpy_materials[232] = ((0.4666666666666667, 0.788235294117647, 0.8470588235294118), None, 1.0)
bpy_materials[233] = ((0.3764705882352941, 0.7294117647058823, 0.4627450980392157), None, 1.0)
bpy_materials[234] = ((0.984313725490196, 0.9098039215686274, 0.5647058823529412), None, 0.5882352941176471)
bpy_materials[236] = ((0.5529411764705883, 0.45098039215686275, 0.7019607843137254), None, 0.5882352941176471)

def makeMaterial(name, diffuse, specular, alpha):
	mat = bpy.data.materials.new(str(name))
	mat.diffuse_color = diffuse
	mat.diffuse_shader = 'LAMBERT' 
	mat.diffuse_intensity = 1.0

	if specular is not None:
		mat.specular_color = specular
		mat.specular_shader = 'COOKTORR'
		mat.specular_intensity = 0.5
	if alpha is not None:
		mat.alpha = alpha
	mat.ambient = 1
	return mat


# Set camera rotation in euler angles
# bpy.context.scene.camera.rotation_mode = 'XYZ'
# print(bpy.context.scene.camera.rotation_euler)
# x=1.1093, y=0.0108, z=0.8149
# bpy.context.scene.camera.rotation_euler[0] = rx*(pi/180.0)
# bpy.context.scene.camera.rotation_euler[1] = ry*(pi/180.0)
# bpy.context.scene.camera.rotation_euler[2] = rz*(pi/180.0)

# Set camera translation
# print(bpy.context.scene.camera.location)
# 25.1010, -23.5365, 21.3147
# bpy.context.scene.camera.location.x = 20
# bpy.context.scene.camera.location.y = 15
# bpy.context.scene.camera.location.z = 25

# designIDs = [3005, 3005, 3005]
# locations = [(-0.8*16,0,0), (0,0.8*16,0), (0.8*16,0,0.96)]
# matIds = [23, 24, 25]

if config['sockets']:
	import socket

	s = socket.socket()
	host = "127.0.0.1" #socket.gethostname()
	port = 5346
	# s.setblocking(0)
	s.bind((host, port))
	s.listen(1)

	c, addr = s.accept()
	while True:
		# print("Connection accepted from " + repr(addr[1]))

		# Receive 1024 bytes
		print('[blender] Sockets receive')
		buf = c.recv(1024).decode().strip()
		print('[blender] Sockets received: ' + buf)

		if buf != 'exit' and len(buf) > 0:
			msg = buf.split(',')
			config['input'] = msg[0]
			config['output'] = msg[1]

			# print(str(buf).split(',')) 
			# print('[blender] Sockets ' + repr(addr[1]) + ": " + str(buf))

			# Read file
			designIDs = []
			refIDs = []
			locations = []
			orientations = []
			matIds = []

			# Load LXFML
			tree = ET.parse(config['input'])
			root = tree.getroot()

			for brick in root.iter('Brick'):
				designIDs.append(int(brick.get('designID')))

				refIDs.append(int(brick.get('refID')))

				matId = int(brick.find('Part').get('materials').replace(',0',''))
				matIds.append(matId)

				# Load material
				if str(matId) not in bpy.data.materials:
					makeMaterial(matId, bpy_materials[matId][0], bpy_materials[matId][1], bpy_materials[matId][2])

				# Transformation
				transformation = [float(x) for x in brick.find('Part').find('Bone').get('transformation').split(',')]
				locations.append((transformation[-1], transformation[-3], transformation[-2]))

				# Orientation must be a matrix
				# orientation = mathutils.Matrix(((transformation[0], transformation[1], transformation[2]), (transformation[3], transformation[4], transformation[5]), (transformation[6], transformation[7], transformation[8])))
				# orientations.append(orientation)

			# xz unit
			brick_w = 0.8
			brick_h = 0.96

			# Iterate bricks
			for i in range(len(designIDs)):

				# Load brick
				designID = designIDs[i]
				location = locations[i]
				matId = matIds[i]

				# Load brick
				brick = "bricks/" + str(designID) + ".obj"
				bpy.ops.import_scene.obj(filepath=brick)

				# Set material
				obj = bpy.context.selected_objects[0]
				mat = bpy.data.materials[str(matId)]
				obj.data.materials.append(mat)

				# Dimensions
				# x, y, z = obj.dimensions 

				# Set location
				obj.location = location

			# Render
			print('[blender] Rendering')
			bpy.ops.render.render(animation=False, write_still=True)
			bpy.data.images["Render Result"].save_render(filepath=config['output'])


			# Stop edit mode
			# if bpy.ops.object.mode_set.poll():
			# 	bpy.ops.object.mode_set(mode='OBJECT')

			# Delete all mesh objects from a scene
			print('[blender] Cleaning scene')
			bpy.ops.object.select_by_type(type='MESH')
			bpy.ops.object.delete()

			# Delete meshes
			# for ob in bpy.context.scene.objects:
			#     ob.select = ob.type == 'MESH'
			# bpy.ops.object.delete()


			# Received tag
			sent = c.send("OK\n".encode())
			if sent == 0:
				raise RuntimeError("socket connection broken")
			print('[blender] OK Sent')
			# c.close()
			# elif buf == 'exit':
		else:
			c.close()
			break


else:

	# Read file
	designIDs = []
	refIDs = []
	locations = []
	orientations = []
	matIds = []

	# Load LXFML
	tree = ET.parse(config['input'])
	root = tree.getroot()

	for brick in root.iter('Brick'):
		designIDs.append(int(brick.get('designID')))

		refIDs.append(int(brick.get('refID')))

		matId = int(brick.find('Part').get('materials').replace(',0',''))
		matIds.append(matId)

		# Load material
		if str(matId) not in bpy.data.materials:
			makeMaterial(matId, bpy_materials[matId][0], bpy_materials[matId][1], bpy_materials[matId][2])

		# Transformation
		transformation = [float(x) for x in brick.find('Part').find('Bone').get('transformation').split(',')]
		locations.append((transformation[-1], transformation[-3], transformation[-2]))

		# Orientation must be a matrix
		# orientation = mathutils.Matrix(((transformation[0], transformation[1], transformation[2]), (transformation[3], transformation[4], transformation[5]), (transformation[6], transformation[7], transformation[8])))
		# orientations.append(orientation)

	# xz unit
	brick_w = 0.8
	brick_h = 0.96

	# Iterate bricks
	for i in range(len(designIDs)):

		# Load brick
		designID = designIDs[i]
		location = locations[i]
		matId = matIds[i]

		# Load brick
		brick = "bricks/" + str(designID) + ".obj"
		bpy.ops.import_scene.obj(filepath=brick)

		# Set material
		obj = bpy.context.selected_objects[0]
		mat = bpy.data.materials[str(matId)]
		obj.data.materials.append(mat)

		# Dimensions
		# x, y, z = obj.dimensions 

		# Set location
		obj.location = location

	# Render
	bpy.ops.render.render(animation=False, write_still=True)
	# bpy.ops.render.opengl(write_still=True)
	bpy.data.images["Render Result"].save_render(filepath=config['output'])