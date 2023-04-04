import os
import cv2
import numpy as np
import json
from pathlib import Path
from torchvision.transforms import transforms
from torchvision.models import resnet152, ResNet152_Weights
import torch
from PIL import Image
from .make_pill_itemseq_dict import search_itemseq_by_pillid as search
from .utils import read_dict_from_json

# Define function to preprocess the image file and recognize objects
def recognize_pills(model, img, device):
    # Define transforms
    img_transforms = transforms.Compose([
        transforms.Resize(256),
        transforms.CenterCrop(224),
        transforms.ToTensor(),
        transforms.Normalize([0.485, 0.456, 0.406], [0.229, 0.224, 0.225])
    ])

    img_tensor = img_transforms(img)
    img_tensor = img_tensor.unsqueeze(0).to(device)
    with torch.no_grad():
        outputs = model(img_tensor)
        results = outputs.data.sort(dim=1, descending=True)
    return results

def run_predict_model(img):
    # Set device and other parameters
    device = torch.device("cuda" if torch.cuda.is_available() else "cpu")

    json_pill_itemseq_dict = r'./proj_pill/proj_pill/pill_itemseq_dict.json'
    json_dir_dict = r'./proj_pill/proj_pill/idx_pillid_dict.json'
    dict_temp = read_dict_from_json(json_dir_dict)
    dict_idx_pillid = dict_temp['dict_idx_pillid']

    print(dict_idx_pillid)

    # Load the trained model
    model_path = r'./proj_pill/proj_pill/new_resnet152_model.pt'
    model = resnet152(weights=ResNet152_Weights.DEFAULT)
    num_ftrs = model.fc.in_features
    model.fc = torch.nn.Linear(num_ftrs, 19)
    model = torch.nn.Sequential(model, torch.nn.BatchNorm1d(19))
    model = model.to(device)
    checkpoint = torch.load(model_path, map_location=device)
    model.load_state_dict(checkpoint['state_dict'])
    model.eval()

    results = recognize_pills(model, img, device)
    results_idx = results[1].view(-1).tolist()[:5]
    

    result = {
        'item_seq': [str(search(dict_idx_pillid[str(results_idx[rk])], json_pill_itemseq_dict)[0]) for rk in range(5)]
    }
    return result