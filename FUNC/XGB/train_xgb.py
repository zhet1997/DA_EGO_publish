import xgboost as xgb
import numpy as np
import os

def train_model(X,y,modelName):
	# XGBoost训练过程
	model = xgb.XGBRegressor(max_depth=5, learning_rate=0.1, n_estimators=160,
	objective='reg:gamma')
	model.fit(X, y)
	model.save_model(modelName)

	return modelName

if __name__ == "__main__":
	pathXGB = os.path.dirname(__file__)+ '/'
	modelSave = pathXGB + 'xgb_model.json'
	dataX = pathXGB + 'samples.txt'
	datay = pathXGB + 'values.txt'

	with open(dataX, 'r',encoding='utf-8') as f:
		X = np.loadtxt(f, delimiter="\t")
	with open(datay, 'r',encoding='utf-8') as f:
		y = np.loadtxt(f, delimiter="\t")
	# X = xgb.DMatrix(dataX)
	# y = xgb.DMatrix(datay)
	modelSave = train_model(X, y, modelSave)
	print(modelSave)