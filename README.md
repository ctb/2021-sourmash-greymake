# parallel search of sourmash databases with snakemake using manifests of manifests

(You'll need [2021-sourmash-mom](https://github.com/ctb/2021-sourmash-mom) to run the below.)

## Quickstart

### Create manifests for the signatures you want to search, based on the query

Run:
```
mkdir search
../2021-sourmash-mom/mom-query-to-picklists.py wort-sra.query.sig \
     wort-sra.zips/index.db --output-prefix=search/
```
this will create a set of output files, `writing
search/xar.sub.zip.csv` and so on, that contain picklists with just the
signatures you want to search for each of the zip databases.

### Run the search

Then, run snakemake:
```
snakemake -j 4
```
This will search each individual database (potentially in parallel),
using the CSV files output by the previous command as picklists.

