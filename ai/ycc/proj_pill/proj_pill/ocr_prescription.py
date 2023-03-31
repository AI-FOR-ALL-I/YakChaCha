import easyocr
import re

def run_ocr_model(image):
    reader = easyocr.Reader(['ko'])
    result = reader.readtext(image)

    edi_code = []
    for data in result:
        string = data[1]
        numbers = re.findall(r'\d+', string)
        if numbers:
            for j in numbers:
                if len(j) == 9 and j[0] == '6':
                    edi_code.append(j)
    
    result = {
        'edi_code': edi_code
    }

    print('job done')
    return result