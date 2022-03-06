#!/bin/bash

# Script to download evidence, target and disease data in parquet format.



ot_data_version=21.11
out_path=datadownload1

printf "\n >>>> Creating Directory at $out_path\n"
mkdir -p ./$out_path/{evidence,targets,diseases}
printf "\n >>>> Data directories created Successfully\n"

evidence_path="ftp://ftp.ebi.ac.uk/pub/databases/opentargets/platform/$ot_data_version/output/etl/parquet/evidence/sourceId=eva/"
targets_path="ftp://ftp.ebi.ac.uk/pub/databases/opentargets/platform/$ot_data_version/output/etl/parquet/targets/"
disease_path="ftp://ftp.ebi.ac.uk/pub/databases/opentargets/platform/$ot_data_version/output/etl/parquet/diseases/"

printf "$evidence_path\n" 
printf "$targets_path\n"
printf "$disease_path\n"

printf "\n <<<< Downloading Evidence Data\n"
printf "\t Running : wget --no-parent --level=1 --no-directories --directory-prefix=$out_path/evidence --accept=*.parquet -r $evidence_path"
wget --no-parent --level=1 --no-directories --directory-prefix=$out_path/evidence --accept=*.parquet -r $evidence_path
printf "\n @@@@ Evidence datafiles downloaded Successfully\n"

printf "\n <<<< Downloading Targets Data\n"
printf "\t Running : wget --no-parent --level=1 --no-directories --directory-prefix=$out_path/targets --accept=*.parquet -r $targets_path"
wget --no-parent --level=1 --no-directories --directory-prefix=$out_path/targets --accept=*.parquet -r $targets_path
printf "\n @@@@ Targets datafiles downloaded Successfully\n"

printf "\n <<<< Downloading Diseases Data\n"
printf "\t Running : wget --no-parent --level=1 --no-directories --directory-prefix=$out_path/diseases --accept=*.parquet -r $disease_path"
wget --no-parent --level=1 --no-directories --directory-prefix=$out_path/diseases --accept=*.parquet -r $disease_path
printf "\n @@@@ Diseases datafiles downloaded Successfully\n"
