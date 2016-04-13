--
-- Created by IntelliJ IDEA.
-- User: mat
-- Date: 12/04/16
-- Time: 4:23 PM
-- To change this template use File | Settings | File Templates.
--

require("scripts.lua.common")
matio = require 'matio'

-- directories setup
feats_output_dir= '../data/output/'
input_dir='../data/validation_spatial_alex/'
img_name = '001.jpg'
output_mat = feats_output_dir..img_name..'.mat'
dis_resize = 2
sq=0

-- load net
print ("extract feats to : "..output_mat)
net_conv = torch.load(th_model_full_conv_fc7)
--net_conv = torch.load(th_model_full_conv_vgg16_fc7)
print (net_conv)
-- disable flips, dropouts and batch normalization
net_conv:evaluate()

-- img = image.load(img_name)

img = load_image(input_dir..img_name, dis_resize,sq)
print ("Image size :\n"..tostring(img:size()))

y_conv = net_conv:forward(img:cuda())
print ("output size :\n"..tostring(y_conv:size()))
print ("save file")
matio.save(output_mat,y_conv:float())

