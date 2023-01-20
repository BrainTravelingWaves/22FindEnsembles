# 22FindEnsembles
Search for ensembles based on MEG data/
Before run, upload test data (see link) to the workspace/
https://drive.google.com/drive/folders/1u1cb-05ztPgY8J6T3ZxPvHFjLCAn43HZ?usp=share_link

Ver 2 Add ChMEG_ChN_ChGr.mat file var ->SigF{}

Example:

ChMEG_ChN_ChGr.mat -> SigF - channel matching list

dostupn1.mat -> clsG - list of channel clusters

dostupn1Ch004.mat - 4 channel gradiometers from 204

look at 4 in clsG column 2

The 4 is part of a cluster with 24 gradiometer channel

look SigF 24 gradientometr is 35 general channel or 'MEG0342'
Ver 2.1 add create .fig It is necessary to set the path for the clusters and Fig
