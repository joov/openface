require 'torch'
require 'paths'
require 'nn'
require 'dpnn'

net = torch.load(arg[1], 'ascii')
torch.save(arg[2], net)
