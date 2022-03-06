#!/bin/bash

# Script to download evidence, target and disease data in parquet format.


default_out_pah=data
default_data_version=21.11


ot_data_version=21.11
out_path=data


PARAMS=""
DRY_RUN=0
while (( "$#" )); do
  case "$1" in
    -d|--dry)
      DRY_RUN=1
      shift
      ;;
    -o|--out-dir)
      if [ -n "$2" ] && [ ${2:0:1} != "-" ]; then
        out_path=$2
        shift 2
      else
        echo "Error: Argument for $1 is missing" >&2
        exit 1
      fi
      ;;
    -v|--data-version)
      if [ -n "$2" ] && [ ${2:0:1} != "-" ]; then
        ot_data_version=$2
        shift 2
      else
        echo "Error: Argument for $1 is missing" >&2
        exit 1
      fi
      ;;
    -h|--help)
      printf "Usage: ./ot_data_download.sh [OPTION]...\n" >&2
      printf "Options :" >&2
      printf "\n\t -d, --dry		 Dry run. Shows commands which will be executed." >&2
      printf "\n\t -o, --out-dir 	 	Save files at out-dir/.." >&2
      printf "\n\t -v, --data-version 	Opentarget Data version to download." >&2
      printf "\n\nExample: ./ot_data_download.sh -d -o ./data --data-version 21.11\n" >&2
      printf "\nOT DATA VERSION : 21.11 \nOUTPUT PATH : data\n"
      printf "\nwget --no-parent --level=1 --no-directories --directory-prefix=data/evidence --accept=*.parquet -r ftp://ftp.ebi.ac.uk/pub/databases/opentargets/platform/21.11/output/etl/parquet/evidence/sourceId=eva/"
	  printf "\nwget --no-parent --level=1 --no-directories --directory-prefix=data/targets --accept=*.parquet -r ftp://ftp.ebi.ac.uk/pub/databases/opentargets/platform/21.11/output/etl/parquet/targets/"
	  printf "\nwget --no-parent --level=1 --no-directories --directory-prefix=data/diseases --accept=*.parquet -r ftp://ftp.ebi.ac.uk/pub/databases/opentargets/platform/21.11/output/etl/parquet/diseases/"
      printf "\n"
      exit 1
      ;;
    -*|--*=) # unsupported flags
      echo "Error: Unsupported flag $1" >&2
      exit 1
      ;;
    *) # preserve positional arguments
      PARAMS="$PARAMS $1"
      shift
      ;;
  esac
done

evidence_path="ftp://ftp.ebi.ac.uk/pub/databases/opentargets/platform/$ot_data_version/output/etl/parquet/evidence/sourceId=eva/"
targets_path="ftp://ftp.ebi.ac.uk/pub/databases/opentargets/platform/$ot_data_version/output/etl/parquet/targets/"
disease_path="ftp://ftp.ebi.ac.uk/pub/databases/opentargets/platform/$ot_data_version/output/etl/parquet/diseases/"

if [ $DRY_RUN == 1 ]; then
	printf "\nOT DATA VERSION : $ot_data_version"
	printf "\nOUTPUT PATH : $out_path\n"

	printf "\nwget --no-parent --level=1 --no-directories --directory-prefix=$out_path/evidence --accept=*.parquet -r $evidence_path"
	printf "\nwget --no-parent --level=1 --no-directories --directory-prefix=$out_path/targets --accept=*.parquet -r $targets_path"
	printf "\nwget --no-parent --level=1 --no-directories --directory-prefix=$out_path/diseases --accept=*.parquet -r $disease_path\n"
else
	printf "Actual run"
	printf "\n >>>> Creating Directory at $out_path\n"
	mkdir -p ./$out_path/{evidence,targets,diseases}
	printf "\n >>>> Data directories created Successfully\n"

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
fi
