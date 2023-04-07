from torchvision.transforms import transforms
from efficientnet_pytorch import EfficientNet
import torch
import torch.nn as nn
import json
import cv2
import numpy as np
from PIL import Image

# Define function to preprocess the image file and recognize objects
def recognize_pills(model, img, device):
    # Define transforms
    img_transforms = transforms.Compose([
        transforms.Resize(256),
        transforms.CenterCrop(224),
        transforms.ToTensor(),
        transforms.Normalize([0.485, 0.456, 0.406], [0.229, 0.224, 0.225])
    ])
    
    img_array = np.frombuffer(img, np.uint8)
    img = cv2.imdecode(img_array, cv2.IMREAD_COLOR)
    img = cv2.cvtColor(img, cv2.COLOR_BGR2RGB)
    img_pil = Image.fromarray(img)
    img_tensor = img_transforms(img_pil)
    img_tensor = img_tensor.unsqueeze(0).to(device)
    with torch.no_grad():
        outputs = model(img_tensor)
        results = outputs.data.sort(dim=1, descending=True)
    return results

def run_efficient_model(img):
    # Load json files
    with open('./proj_pill/proj_pill/dir_dict.json', 'r', encoding='utf-8') as f:
        dir_dict = json.load(f)

    with open('./proj_pill/proj_pill/pill_itemseq_dict.json', 'r', encoding='utf-8') as f:
        dict_temp = json.load(f)
        dict_pillid_itemseq = dict_temp['dict_pillid_itemseq']
    
    # Set device and other parameters
    device = torch.device("cuda" if torch.cuda.is_available() else "cpu")
    num_classes = len(dir_dict)
    num_results = 5
    model_name = 'SGD_freeze_250_efficientnet_b4_model.pt'

    # Load the trained model
    model_path = f'./proj_pill/proj_pill/{model_name}'
    
    model = EfficientNet.from_pretrained('efficientnet-b4', num_classes=num_classes)
    model = nn.Sequential(model, nn.BatchNorm1d(num_classes))
    model = model.to(device)
    checkpoint = torch.load(model_path, map_location=device)
    model.load_state_dict(checkpoint['state_dict'])
    model.eval()

    results = recognize_pills(model, img, device)
    results_idx = results[1].view(-1).tolist()[:num_results]
    
    temp = [(dir_dict[str(results_idx[rk])], dict_pillid_itemseq[dir_dict[str(results_idx[rk])]]) for rk in range(num_results)]
    for i in temp:
        print(i)

    result = {
        'item_seq': [str(dict_pillid_itemseq[dir_dict[str(results_idx[rk])]][0]) for rk in range(num_results)]
    }
    return result