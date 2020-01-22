#!/bin/bash
#  Install the Intel® Distribution for Python, skip this if you have already installed the Intel® Distribution for Python,
#  otherwise do the following steps:
#  conda update conda
#  conda config --add channels intel
#  conda create -n idp intelpython3_full python=3
#  source activate idp 
#  cd nicpython36  <-----root
#  pip install -r requirements.txt

# if you have already got idp then
#  source activate idp 
#  cd nicpython36  <-----root
#  change the config folder to appropriated values, and replace the trained model in  .../nicpython36-master/nets

conda env create -f environment.yml

conda activate idp3x

python  preprocess_inference_script.py


#   - singularity pull docker://kbronik/ms_cnn_ucl:latest  
# After running the above, a singularity image using docker hub (docker://kbronik/ms_cnn_ucl:latest) will be generated:

#  - path to singularity//..///ms_cnn_ucl_latest.sif  
#  singularity exec  ms_cnn_ucl_latest.sif  python path to nicpython36/inference_scripts.py
python inference_script.py


echo "All calculation completed"

