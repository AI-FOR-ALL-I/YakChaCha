
from torchvision.transforms import transforms
from torchvision.models import resnet152, ResNet152_Weights
import torch
import json

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

    with open('./proj_pill/proj_pill/dir_dict.json', 'r', encoding='utf-8') as f:
        dir_dict = json.load(f)

    with open('./proj_pill/proj_pill/pill_itemseq_dict.json', 'r', encoding='utf-8') as f:
        dict_temp = json.load(f)
        dict_pillid_itemseq = dict_temp['dict_pillid_itemseq']

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
    
    temp = [(dir_dict[str(results_idx[rk])], dict_pillid_itemseq[dir_dict[str(results_idx[rk])]]) for rk in range(5)]
    for i in temp:
        print(i)

    result = {
        'item_seq': [dir_dict[str(results_idx[rk])] for rk in range(5)]
    }
    return result