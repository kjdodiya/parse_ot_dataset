#Baseimage
FROM python

# Copy code, requirements.txt
COPY ./code /usr/src/ot-ebi01989-code
COPY ./requirement.txt /usr/src/ot-ebi01989-code/requirement.txt

# Install dependencies
WORKDIR /usr/src/ot-ebi01989-code/
RUN pip install -r requirement.txt

