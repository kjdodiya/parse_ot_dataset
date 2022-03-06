
## Content
- Data Downloading Script : _ot_data_download.sh_ 
- Data Parsing Scrit : _ot_parse_data.py_
- Output File : _output.json_ 

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
        $ ./code/ot_data_download.sh
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
$ python code/ot_data_parser.py --datadir ./data/ --outfile  output.json
```
