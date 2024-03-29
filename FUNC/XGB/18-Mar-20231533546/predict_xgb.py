import xgboost as xgb
import numpy as np
import os

def load_predict(modelName,x):
	# 对测试集进行预测
	model = xgb.Booster()
	model.load_model(modelName)
	y = model.predict(x)
	return y

if __name__ == "__main__":
	pathXGB = os.path.dirname(__file__)+ '/'
	modelSave = pathXGB + 'xgb_model.json'
	data_test = pathXGB + 'test.txt'
	data_result = pathXGB + 'result.txt'
	with open(data_test, 'r',encoding='utf-8') as f:
		sam = np.loadtxt(f, delimiter="\t")
	if len(sam.shape)==1:
		sam = sam.reshape(1,-1)
	x = xgb.DMatrix(sam)
	result = np.hstack((sam,load_predict(modelSave, x).reshape((-1,1))))
	# print(result)
	np.savetxt(data_result, result ,fmt='%1.10e', delimiter='\t')