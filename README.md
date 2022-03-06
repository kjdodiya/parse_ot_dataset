
## Content
- Data Downloading Script : _ot_data_download.sh_ 
- Data Parsing Scrit : _ot_parse_data.py_
- Output File : _output.json_ 

There are two ways to run the script:
1. Run inside docker container
2. Run it on the system

## Runnning with Docker


Create the directory for the data


```bash
$ mkdir data

$ DATA_DIR=$PWD/data

# Pull docker image
$ docker pull kjdodiya/parse_ot_dataset:0.0.3

# Run
$ docker run --name ot-tech-test -it -v $DATA_DIR:/usr/src/ot-ebi01989-code/data  parse_ot_dataset:0.0.3 /bin/bash

root@243ac79622fc:/usr/src/ot-ebi01989-code# 

# Download data
root@243ac79622fc:/usr/src/ot-ebi01989-code# ./ot_data_download.sh -o data --data-version 21.11

# Run the data parser script
root@243ac79622fc:/usr/src/ot-ebi01989-code# python ot_data_parser.py --datadir ./data/ --outfile  ebi01989_output.json


```

## Running on System

## Clone the code
```bash
$ git clone https://github.com/kjdodiya/parse_ot_dataset.git
$ cd parse_ot_dataset
```

## Data Preparation
- ### Install wget
    wget is a utility to download data. Here are some articles on installing wget on Linux/Mac.
    
    Linux : https://www.tecmint.com/install-wget-in-linux/ <br>
    Mac   : https://www.maketecheasier.com/install-wget-mac/

- ### Downloading Data
    The dataset required for this excersice are evidence, targets, diseases. 

    - #### Run script
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


## Setting up Environment
The code is written in python. It requires Python version 3.7 or higher. 

### Create virtual environment
```bash
# Create virtual environment
$ python3 -m venv /path/to/virtual/environment/ot_ebi01989

# Activate Virtual environment
$ source /path/to/virtual/environment/ot_ebi01989/bin/activate
(ot_ebi01989)$ 
```

### Prepare code
```bash
# Install python depndencies
$ pip3 install -r requirement.txt
```

## Running Script
```bash
# Run Script
$ python code/ot_data_parser.py --datadir ./data/ --outfile  ebi01989_output.json
```


## Outputfile

The output file ebi01989_output.json.

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