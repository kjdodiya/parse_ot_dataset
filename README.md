
## Content

- [Introduction](#introduction)
- [Running with Docker](#run_code_docker)
    - [Pull Docker image](#pull_docker_image)
    - [Create Container](#run_docker_image)
- [Running on System](#run_code_system)
    - [Clone Codebase](#clone_codebase)
    - [Data Preparation](#data_preparation)
        - [Install wget](#install_wget)
        - [Downloading Data](#data_downloading)
    - [Setting up environment](#setup_env)
    - [Run Parser Script](#data_parser_script)
- [Results](#results)
    - [Output JSON](#result_json)
    - [Target-target pairs](#target_target_pair)

<a name="introduction"></a>
## Introduction
The script is written in python and primaryliy uses two libraries PyArrow, Pandas.<br>
<b>PyArrow</b> : To read parquet files in to a dataset [pyarrow](https://arrow.apache.org/docs/python/index.html)<br>
<b>Pandas</b>  : Data Analysis and Manipulation library. [pandas](https://pandas.pydata.org)<br>
The easiest way to run the script is to run the script with docker. Instrunctions are [here](#run_code_docker)
 
## Running code <a name="run_code"></a>

There are two ways to run the script:
1. Run inside docker container
2. Run it on the system

<a name="run_code_docker"></a>
## Runnning with Docker

<a name="data_dir"></a>
### Create the directory for the data 

```bash
$ DATA_DIR=$PWD/data

$ mkdir $DATA_DIR
```

<a name="pull_docker_image"></a>
### Pull docker image 
```bash
$ docker pull kjdodiya/parse_ot_dataset:0.0.3
```

<a name="run_docker_image"></a>
### Create Container  

```bash
# Run
$ docker run --name ot-tech-test -it -v $DATA_DIR:/usr/src/ot-ebi01989-code/data  parse_ot_dataset:0.0.3 /bin/bash

root@243ac79622fc:/usr/src/ot-ebi01989-code# 

# Download data
root@243ac79622fc:/usr/src/ot-ebi01989-code# ./ot_data_download.sh -o data --data-version 21.11

# Run the data parser script
root@243ac79622fc:/usr/src/ot-ebi01989-code# python ot_data_parser.py --datadir ./data/ --outfile  ebi01989_output.json

```

<a name="run_code_system"></a>
## Running on System 

<a name="clone_codebase"></a>
### Clone codebase 
```bash
$ git clone https://github.com/kjdodiya/parse_ot_dataset.git
$ cd parse_ot_dataset
```

<a name="data_preparation"></a>
### Data Preparation

<a name="install_wget"></a>
- ### Install wget 
    wget is a utility to download data. Here are some articles on installing wget on Linux/Mac.
    
    Linux : https://www.tecmint.com/install-wget-in-linux/ <br>
    Mac   : https://www.maketecheasier.com/install-wget-mac/

<a name="data_downloading"></a>
- ### Downloading Data 
    The dataset required for this excersice are evidence, targets, diseases. 

    - #### Run Data Downloading script
        To download the data run ./code/data_download.sh script. 
        The script will
        - Create _evidence targets diseases_ directories in the _data_ directory
        - Downloads the data in the parquet format.
        ```bash
        $ ./code/ot_data_download.sh -o data --data-version 21.11
            Usage: ./ot_data_download.sh [OPTION]...
            Options :
                 -d, --dry       Dry run. Shows commands which will be executed.
                 -o, --out-dir      Save files at out-dir/..
                 -v, --data-version     Opentarget Data version to download.

            Example: ./ot_data_download.sh -d -o ./data --data-version 21.11
        ```

    - #### Run Commands Manually
        Alternatively, run following commands from terminal.
    
        ```bash
        # Create directories
        data_dir=data
        mkdir -p $data_dir/{evidence,targets,diseases}
        
        # Evidence Data
        $ wget --no-parent --level=1 --no-directories --directory-prefix=$data_dir/evidence --accept=*.parquet -r ftp://ftp.ebi.ac.uk/pub/databases/opentargets/platform/21.11/output/etl/parquet/evidence/sourceId=eva/
        
        # Targets Data
        $ wget --no-parent --level=1 ---no-directories --directory-prefix=$data_dir/targets --accept=*.parquet -r ftp://ftp.ebi.ac.uk/pub/databases/opentargets/platform/21.11/output/etl/parquet/targets/
        
        # Diseases Data
        $ wget --no-parent --level=1 --no-directories --directory-prefix=$data_dir/diseases --accept=*.parquet -r ftp://ftp.ebi.ac.uk/pub/databases/opentargets/platform/21.11/output/etl/parquet/diseases/
        ```


<a name="setup_env"></a>
### Setting up Environment 
The code is written in python. It requires Python version 3.7 or higher. 

#### Create virtual environment
```bash
# Create virtual environment
$ python3 -m venv /path/to/virtual/environment/ot_ebi01989

# Activate Virtual environment
$ source /path/to/virtual/environment/ot_ebi01989/bin/activate
(ot_ebi01989)$ 
```

#### Install dependencies
```bash
# Install python depndencies
$ pip3 install -r requirement.txt
```

<a name="data_parser_script"></a>
#### Running Script 
```bash
# Run Script
$ python code/ot_data_parser.py --datadir ./data/ --outfile  ebi01989_output.json
```

<a name="results"></a>
## Result

<a name="result_json"></a>
### Output JSON 

The output file is at [ebi01989_output.json](#https://github.com/kjdodiya/parse_ot_dataset/blob/main/ebi01989_output.json). 
The snipped of the json file is shown below.

```json
[
    {
        "approvedSymbol": "DPM1",
        "diseaseId": "EFO_0003847",
        "median_score": 0.0,
        "name": "mental retardation",
        "score": [
            0.0
        ],
        "targetId": "ENSG00000000419"
    },
    ...
    ...
    {
        "approvedSymbol": "POLD1",
        "diseaseId": "EFO_0004230",
        "median_score": 0.0,
        "name": "endometrial neoplasm",
        "score": [
            0.3,
            0.0,
            0.0
        ],
        "targetId": "ENSG00000062822"
    }
]
```

<a name="result_ttpair"></a>
### Target Target Pair sharing connection with atleast two diseases 

There are 142318 target target pair which shares connection with atleast two diseases. 

